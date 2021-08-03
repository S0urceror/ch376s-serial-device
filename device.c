#if defined(ARDUINO)
    #include <wiring.h>
#endif
#include <ctype.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdbool.h>
#include "ch376s.h"
#include "device.h"
#include <stdio.h>
#include <string.h>
#include "descriptors.h"

#define min(X, Y) (((X) < (Y)) ? (X) : (Y))
char * strupr (char *str) 
{
  char *ret = str;

  while (*str)
    {
      *str = toupper (*str);
      ++str;
    }

  return ret;
}

#if defined(ARDUINO)
    void msdelay (int milliseconds)
    {
        delay (milliseconds);
    }
    uint32_t millis_elapsed () 
    {
        return millis();
    }
#endif
#if defined(__APPLE__)
    #include <unistd.h>
    #include <sys/time.h>

    void msdelay (int milliseconds)
    {
        usleep (milliseconds*1000);
    }
    uint32_t millis_elapsed () 
    {
        struct timeval tv;
        gettimeofday(&tv, NULL);

        unsigned long long millisecondsSinceEpoch =
            (unsigned long long)(tv.tv_sec) * 1000 +
            (unsigned long long)(tv.tv_usec) / 1000;

        return millisecondsSinceEpoch;
    }
#endif
#if defined(__SDCC)
    #include "build-msx/MSX/BIOS/msxbios.h"
    #define JIFFY 50
    #define SECOND JIFFY
    #define MINUTE SECOND*60
    #pragma disable_warning 85	// suppress unreferenced function argument
    void msx_wait (uint16_t times_jiffy)  __z88dk_fastcall __naked
    {
        __asm
    ; Wait a determined number of interrupts
    ; Input: BC = number of 1/framerate interrupts to wait
    ; Output: (none)
    WAIT:
        halt        ; waits 1/50th or 1/60th of a second till next interrupt
        dec hl
        ld a,h
        or l
        jr nz, WAIT
        ret

        __endasm; 
    }

    void msdelay (int milliseconds)
    {
        msx_wait (milliseconds/20);
    }
    uint32_t millis_elapsed () 
    {
        __at BIOS_JIFFY static uint16_t FRAME_COUNTER;
        return FRAME_COUNTER*20;
    }
#endif

uint8_t oneOneByte[1] = {1};
uint8_t oneZeroByte[1] = {0};
uint8_t twoZeroBytes[2] = {0,0};

uint8_t *dataToTransfer,*dataToTransfer2;
int     dataLength,dataLength2;
uint8_t usb_device_address;
uint8_t usb_configuration_id;
bool usb_terminal_open = false;

enum state_transaction 
{
    SETUP=0,
    DATA,
    STATUS
} transaction_state = STATUS;

#ifdef DEBUG
    uint16_t curtime, accurtime, prevtime;
#endif 
#ifndef __SDCC
typedef	union __attribute__((packed)) _REQUEST_PACK{
#else
typedef	union _REQUEST_PACK{
#endif
	unsigned char  buffer[64];
	struct{
		uint8_t	    bmRequestType;  
		uint8_t	    bRequest;	
		uint16_t    wValue;		
		uint16_t    wIndx;		
		uint16_t    wLength;	
	}r;
} REQUEST_PACKET;

#ifndef __SDCC
typedef union __attribute__((packed)) _UART_PARA
#else
typedef	union _UART_PARA
#endif
{
    uint8_t uart_para_buf[ 7 ];
    struct
    {
        uint8_t bBaudRate1; // Serial port baud rate (lowest bit)
        uint8_t bBaudRate2; // (second low)
        uint8_t bBaudRate3; // (second highest)
        uint8_t bBaudRate4; // (highest bit)
        uint8_t bStopBit; // Stop bit
        uint8_t bParityBit; // Parity bit
        uint8_t bDataBits; // Number of data bits
    } uart;
} UART_PARA;
UART_PARA uart_parameters;

#ifdef DEBUG
void printInterruptName( uint8_t interruptCode)
{
    const char* name = NULL;

    switch(interruptCode) 
    {
        case USB_INT_BUS_RESET:
            name = "BUS_RESET";
            break;
        case USB_INT_EP0_SETUP:
            name = "EP0_SETUP";
            break;
        case USB_INT_EP0_OUT:
            name = "EP0_OUT";
            break;
        case USB_INT_EP0_IN:
            name = "EP0_IN";
            break;
        case USB_INT_EP1_OUT:
            name = "EP1_OUT";
            break;
        case USB_INT_EP1_IN:
            name = "EP1_IN";
            break;
        case USB_INT_EP2_OUT:
            name = "EP2_OUT";
            break;
        case USB_INT_EP2_IN:
            name = "EP2_IN";
            break;
        case USB_INT_USB_SUSPEND:
            name = "USB_SUSPEND";
            break;
        case USB_INT_WAKE_UP:
            name = "WAKE_UP";
            break;
   }

   curtime = millis_elapsed ();
   if(name == NULL) 
   {
        printf("Unknown interrupt received: 0x%02X\n", interruptCode);
   }
   else 
   {
        uint16_t msecs1 = curtime - prevtime;
        uint16_t msecs2 = curtime - accurtime;
        prevtime = curtime;

        printf("Int: %s (%d,%d)\n", name, msecs1, msecs2);
   }
 }
#endif // DEBUG

void reset ()
{
    dataLength = 0;
    dataToTransfer = NULL;
    usb_device_address = 0;
    usb_configuration_id = 0;
    transaction_state = STATUS;
    usb_terminal_open = false;
    #ifdef DEBUG
        curtime = prevtime = accurtime = millis_elapsed ();
    #endif
}

void sendEP0ACK ()
{
    writeCommand (SET_ENDP3__TX_EP0);
    writeData (SET_ENDP_ACK);
}
void sendEP0NAK ()
{
    writeCommand (SET_ENDP3__TX_EP0);
    writeData (SET_ENDP_NAK);
}
void sendEP0STALL ()
{
    writeCommand (SET_ENDP3__TX_EP0);
    writeData (SET_ENDP_STALL);
}

void writeDataForEndpoint0()
{
    int amount = min (EP0_PIPE_SIZE,dataLength);

    // this is a data or status stage
    #ifdef DEBUG
    printf("  EP0: writing %d bytes of %d: ", amount,dataLength);    
    #endif
    writeCommand(CH_CMD_WR_EP0);
    writeData(amount);
    for(int i=0; i<amount; i++) 
    {
        #ifdef DEBUG
        printf("0x%02X ", dataToTransfer[i]);
        #endif
        writeData(dataToTransfer[i]);
    }
    #ifdef DEBUG
    printf("\n");
    #endif
    dataToTransfer += amount;
    dataLength -= amount;
}
void writeDataForEndpoint2()
{
    int amount = min (BULK_OUT_ENDP_MAX_SIZE,dataLength2);

    if (amount!=0)
    {
        #ifdef DEBUG
        printf("  EP2: writing %d bytes of %d: ", amount,dataLength2);    
        #endif
        writeCommand(CH_CMD_WR_EP2);
        writeData(amount);
        for(int i=0; i<amount; i++) 
        {
            #ifdef DEBUG
            printf("0x%02X ", dataToTransfer2[i]);
            #endif
            writeData(dataToTransfer2[i]);
        }
        #ifdef DEBUG
        printf("\n");
        #endif
        dataToTransfer2 += amount;
        dataLength2 -= amount;
    }
}

size_t read_usb_data (uint8_t* pBuffer)
{
    uint8_t value = 0;
    writeCommand(CH375_CMD_RD_USB_DATA_UNLOCK);
    value = readData();
    if (value==0)
        return 0;
    for (uint8_t i=0;i<value;i++)
        *(pBuffer+i) = readData();
    return value;
}

void set_target_device_address (uint8_t address)
{
    writeCommand (CH375_CMD_SET_USB_ADDR);
    writeData(address);
    //msdelay (2);
}

REQUEST_PACKET request;
int length;
char resultBuffer[BULK_OUT_ENDP_MAX_SIZE+1];
char WELCOME_MSG[] = "\r\nMSXUSB Monitor\r\nMxxxx - display memory\r\nGxxxx - goto address\r\nR - Reset\r\nX - exit to BASIC\r\nH - show this help text\r\nor, paste Intel HEX lines\r\n\r\n$ ";
char UNKNOWN_MSG[] = "\r\nInvalid command\r\n$ ";
char BYTES_MSG[] = "\r0x00 bytes written to memory\r\n$ ";
char NEWLINE_MSG[] = "\r\n$ ";
uint16_t convertHex (char* start, uint8_t len)
{
    uint16_t result=0;
    char* cur;
    cur = start;
    while (len-- && *cur!='\0')
    {
        *cur = *cur;
        uint8_t dec = *cur - '0';
        if (dec>9)
            dec -= 7;
        result = (result << 4) + dec;
        cur++;
    }
    return result;
}
void convertToStr (uint8_t value, char* buffer)
{
    uint8_t lo_nibble = value & 0x0f;
    uint8_t hi_nibble = value >> 4;

    *buffer = hi_nibble>9?hi_nibble+'A'-10:hi_nibble+'0';
    *(buffer+1) = lo_nibble>9?lo_nibble+'A'-10:lo_nibble+'0';
}

uint8_t handleIHX(char* ihxline)
{
#ifdef DEBUG
    printf ("handling IHX: [%s]\n",ihxline);
#endif
    uint8_t type = convertHex (ihxline+6,2);
    if (type!=00)
        return 0;
    
    uint8_t value;
    uint8_t bytesWritten = 0;
    uint8_t byteCount = convertHex (ihxline,2);
    uint16_t addressStart = convertHex (ihxline+2,4);
#ifdef DEBUG
    uint8_t checksum=byteCount;
    checksum += addressStart>>8;
    checksum += addressStart;
#endif
    ihxline += 8;
    while (byteCount--)
    {
        value = convertHex (ihxline,2);
        host_writeByte (addressStart++,value);
        bytesWritten++;
        ihxline+=2;
#ifdef DEBUG
        checksum += value;
        printf ("=> %02x\n",checksum);
#endif
    }
#ifdef DEBUG
    uint8_t ihxchecksum = convertHex (ihxline,2);
    if ((uint8_t)(ihxchecksum+checksum) != 0)
        printf ("checksum does not match 0x%02X != 0x%02X\n",ihxchecksum,(uint8_t)(~checksum+1));
#endif
    return bytesWritten;
}

char memory_buffer[]="\r\n:10A000002110A0CD07A0C97EA7C8CDA2002318F700\r\n$ ";
void print_memory (uint16_t address)
{
    dataToTransfer2 = memory_buffer;
    dataLength2 = sizeof (memory_buffer);

    convertToStr (address>>8,memory_buffer+5);
    convertToStr (address&0xff,memory_buffer+7);
    char* membufptr = memory_buffer+11;
    for (int i=0;i<0x10;i++)
    {
        convertToStr (host_readByte(address+i),membufptr);
        membufptr+=2;
    }
}

enum 
{
    CMD_NULL = 0,
    CMD_GO  = 1,
    CMD_RESET = 2,
    CMD_BASIC = 3,
    CMD_IHX = 4,
    CMD_HELP = 5,
    CMD_MEMORY = 6
} processing_command;

char payload[BULK_OUT_ENDP_MAX_SIZE+1];
char* payloadptr;
void read_and_process_data()
{
    uint8_t length = 0;
    uint8_t value;
    writeCommand(CH375_CMD_RD_USB_DATA_UNLOCK);
    length = readData(); // read length
    if (length==0)
        return;
    #ifdef DEBUG
    printf("  Processing %i bytes \n", length);
    #endif
    char* resultptr = resultBuffer;
    dataToTransfer2 = NULL;
    dataLength2 = 0;

    for (uint8_t i=0;i<length;i++)
    {
        value = readData();
        // copy to result buffer
        if (processing_command!=CMD_IHX && value!=':')
            *resultptr++ = value;

        // what did we get?
        switch (toupper(value))
        {
            case 'G': 
                processing_command = CMD_GO; 
                payloadptr = payload;
                break;
            case 'M': 
                processing_command = CMD_MEMORY; 
                payloadptr = payload;
                break;
            case 'R': 
                processing_command = CMD_RESET; 
                payloadptr = NULL;
                break;
            case 'X': 
                processing_command = CMD_BASIC; 
                payloadptr = NULL;
                break;
            case 'H': 
                processing_command = CMD_HELP; 
                payloadptr = NULL;
                break;
            case ':': 
                processing_command = CMD_IHX; 
                payloadptr = payload;
                break;
            case '\r':
                switch (processing_command)
                {
                    case CMD_GO:
                        host_go(convertHex (payload,payloadptr-payload));
                        dataToTransfer2 = (uint8_t*) NEWLINE_MSG;
                        dataLength2 = sizeof (NEWLINE_MSG);
                        break;
                    case CMD_MEMORY:
                        print_memory(convertHex (payload,payloadptr-payload));
                        break;
                    case CMD_RESET:
                        host_reset ();
                        dataToTransfer2 = (uint8_t*) NEWLINE_MSG;
                        dataLength2 = sizeof (NEWLINE_MSG);
                        break;
                    case CMD_BASIC:
                        host_basic_interpreter();
                        dataToTransfer2 = (uint8_t*) NEWLINE_MSG;
                        dataLength2 = sizeof (NEWLINE_MSG);
                        break;
                    case CMD_HELP:
                        dataToTransfer2 = (uint8_t*) WELCOME_MSG;
                        dataLength2 = sizeof (WELCOME_MSG);
                        break;
                    case CMD_IHX:
                        *payloadptr = '\0';
                        uint8_t bytesWritten = handleIHX (payload);
                        // write confirmation message and continue
                        convertToStr (bytesWritten,BYTES_MSG+3);
                        dataToTransfer2 = (uint8_t*) BYTES_MSG;
                        dataLength2 = sizeof (BYTES_MSG);
                        break;
                    case CMD_NULL:
                        dataToTransfer2 = (uint8_t*) UNKNOWN_MSG;
                        dataLength2 = sizeof (UNKNOWN_MSG);
                        break;
                }
                processing_command = CMD_NULL;
                break;
            default:
                if (processing_command!=CMD_NULL && payloadptr != NULL)
                    *(payloadptr++) = value;
        }
    }
    
    // write resultBuffer
    if (dataToTransfer2==NULL)
    {
        // echo the incoming characters if there is no alternative output
        dataToTransfer2 = (uint8_t*) resultBuffer;
        dataLength2 = resultptr - resultBuffer;
    }
    writeDataForEndpoint2 ();  
}


void handleInterrupt ()
{
    // get the type of interrupt
    writeCommand(CH375_CMD_GET_STATUS);
    uint8_t interruptType = readData ();

    if((interruptType & USB_BUS_RESET_MASK) == USB_INT_BUS_RESET)
        interruptType = USB_INT_BUS_RESET;

    #ifdef DEBUG
    printInterruptName(interruptType);
    #endif

    switch(interruptType)
    {
        case USB_INT_USB_SUSPEND:
            writeCommand(CH_CMD_ENTER_SLEEP);
            writeCommand (CH375_CMD_UNLOCK_USB);
            break;
        case USB_INT_BUS_RESET:
            //writeCommand (CH375_CMD_RESET_ALL);
            reset ();
            writeCommand (CH375_CMD_UNLOCK_USB);
            break;
        // control endpoint setup package
        case USB_INT_EP0_SETUP:
        {
            #ifdef DEBUG
            if (transaction_state!=STATUS)
                printf ("SETUP: >> previous transaction not completed <<\n");
            #endif
            transaction_state = SETUP;
            #ifdef DEBUG
            printf ("SETUP\n");
            #endif
            // read setup package
            int length = read_usb_data (request.buffer);
            #ifdef DEBUG
            printf("  bmRequestType: 0x%02X\n", request.r.bmRequestType);
            printf("  bRequest: %i\n", request.r.bRequest);
            printf("  wValue: 0x%04X\n", request.r.wValue);
            printf("  wIndex: 0x%04X\n", request.r.wIndx);
            printf("  wLength: %03d\n", request.r.wLength);
            #endif
            // initialize dataLength with length of setup package
            dataLength = request.r.wLength;

            if ((request.r.bmRequestType & USB_TYPE_MASK)==USB_TYPE_VENDOR)
            {
                #ifdef DEBUG
                printf("SETUP VENDOR request\n");
                #endif
            }
            if ((request.r.bmRequestType & USB_TYPE_MASK)==USB_TYPE_CLASS)
            {
                #ifdef DEBUG
                printf("SETUP CLASS request\n");
                #endif
                switch (request.r.bRequest)              // Analyze the class request code and process it
                {
                    case SET_LINE_CODING: 
                        // SET_LINE_CODING
                        // new encoding send in EP0_IN message
                        #ifdef DEBUG
                        printf ("  SET_LINE_CODING\n");
                        #endif
                        break;
                    case GET_LINE_CODING: // GET_LINE_CODING
                        #ifdef DEBUG
                        printf ("  GET_LINE_CODING\n");
                        #endif
                        dataToTransfer = (uint8_t*) &uart_parameters;
                        dataLength = min ((uint16_t) sizeof(UART_PARA),request.r.wLength);;
                        break;
                    case SET_CONTROL_LINE_STATE: // SET_CONTROL_LINE_STATE
                        #ifdef DEBUG
                        printf ("  SET_CONTROL_LINE_STATE\n");
                        #endif
                        sendEP0ACK ();
                        if (request.r.wValue && 0x01)
                        {
                            usb_terminal_open = true;   
                            
                            dataToTransfer2 = (uint8_t*) WELCOME_MSG;
                            dataLength2 = strlen (WELCOME_MSG);
                            writeDataForEndpoint2 ();
                        }
                        else
                            usb_terminal_open = false;   
                        break;
                    default:
                        #ifdef DEBUG
                        printf ("  Unsupported class command code\n");
                        #endif
                        //sendEP0STALL ();
                        break;
                }                    
            }
            if ((request.r.bmRequestType & USB_TYPE_MASK)==USB_TYPE_STANDARD)
            {
                #ifdef DEBUG
                printf("SETUP STANDARD request");
                #endif
                if ((request.r.bmRequestType & USB_DIR_MASK) == USB_DIR_IN) // IN
                {
                    #ifdef DEBUG
                    printf(" IN\n");
                    #endif
                    switch(request.r.bRequest)
                    {
                        case USB_REQ_GET_DESCRIPTOR:
                        {
                            #ifdef DEBUG
                            printf("USB_REQ_GET_DESCRIPTOR: ");
                            #endif
                            switch (request.r.wValue>>8)
                            {
                                case USB_DESC_DEVICE: 
                                {
                                    #ifdef DEBUG
                                    printf("DEVICE\n");
                                    #endif
                                    dataToTransfer = DevDes;
                                    dataLength = min ((uint16_t) sizeof(DevDes),request.r.wLength);
                                    break;
                                }
                                case USB_DESC_CONFIGURATION: 
                                {
                                    #ifdef DEBUG
                                    printf("CONFIGURATION\n");
                                    #endif
                                    dataToTransfer = ConDes;
                                    dataLength = min ((uint16_t) sizeof(ConDes),request.r.wLength);
                                    break;
                                }
                                case USB_DESC_STRING: 
                                {
                                    #ifdef DEBUG
                                    printf("STRING: ");
                                    #endif
                                    uint8_t stringIndex = request.r.wValue&0xff;  
                                    switch(stringIndex)
                                    {
                                        case 0: 
                                        {
                                            #ifdef DEBUG
                                            printf("Language\n");
                                            #endif
                                            dataToTransfer = LangDes;
                                            dataLength = min ((uint16_t) sizeof(LangDes),request.r.wLength);
                                            break;
                                        }
                                        case STRING_DESC_PRODUCT: 
                                        {
                                            #ifdef DEBUG
                                            printf("Product\n");
                                            #endif
                                            dataToTransfer = PRODUCER_Des;
                                            dataLength = min ((uint16_t) sizeof(PRODUCER_Des),request.r.wLength);
                                            break;
                                        }
                                        case STRING_DESC_MANUFACTURER: 
                                        {
                                            #ifdef DEBUG
                                            printf("Manufacturer\n");
                                            #endif
                                            dataToTransfer = MANUFACTURER_Des;
                                            dataLength = min ((uint16_t) sizeof(MANUFACTURER_Des),request.r.wLength);
                                            break;
                                        }
                                        case STRING_DESC_SERIAL:
                                        {
                                            #ifdef DEBUG
                                            printf("Serial\n");
                                            #endif
                                            dataToTransfer = PRODUCER_SN_Des;
                                            dataLength = min ((uint16_t) sizeof(PRODUCER_SN_Des),request.r.wLength);
                                            break;
                                        }
                                        default: 
                                        {
                                            #ifdef DEBUG
                                            printf("Unknown! (%i)\n", stringIndex);
                                            #endif
                                            break;
                                        }
                                    }
                                    break;
                                }
                            }
                            writeDataForEndpoint0();
                            break;                   
                        } 
                        case USB_REQ_GET_CONFIGURATION:
                            #ifdef DEBUG
                            printf("USB_REQ_GET_CONFIGURATION\n");    
                            #endif
                            dataToTransfer = &usb_configuration_id;
                            dataLength = 1;
                            break;
                        case USB_REQ_GET_INTERFACE:
                            #ifdef DEBUG
                            printf("USB_REQ_GET_INTERFACE\n");    
                            #endif
                            break;
                        case USB_REQ_GET_STATUS:
                            #ifdef DEBUG
                            printf("USB_REQ_GET_STATUS\n");    
                            #endif
                            break;
                        default:
                            #ifdef DEBUG
                            printf("UNKNOWN IN REQUEST 0x%x\n", request.r.bRequest);    
                            #endif
                            break;
                    }
                }
                else // OUT
                {
                    #ifdef DEBUG
                    printf(" OUT\n");
                    #endif
                    switch(request.r.bRequest)
                    {
                        case USB_REQ_SET_ADDRESS:
                        {  
                            usb_device_address = request.r.wValue;
                            #ifdef DEBUG
                            printf("  SET_ADDRESS: %i\n", usb_device_address);
                            accurtime = millis_elapsed ();
                            #endif
                            sendEP0ACK ();
                            break;
                        }
                        case USB_REQ_SET_CONFIGURATION:
                        {
                            #ifdef DEBUG
                            printf("  USB_REQ_SET_CONFIGURATION %d\n",request.r.wValue);  
                            #endif
                            if (request.r.wValue==USB_CONFIGURATION_ID) 
                                usb_configuration_id = request.r.wValue;
                            sendEP0ACK ();
                            break; 
                        }
                        case USB_REQ_SET_INTERFACE:
                        {
                            #ifdef DEBUG
                            printf("  USB_REQ_SET_INTERFACE\n");  
                            #endif
                            break; 
                        }
                        case USB_REQ_CLEAR_FEATURE:
                        {
                            #ifdef DEBUG
                            printf("  USB_REQ_CLEAR_FEATURE\n");  
                            #endif
                            break; 
                        }
                        default:
                            #ifdef DEBUG
                            printf("  UNKNOWN OUT REQUEST 0x%x\n", request.r.bRequest);    
                            #endif
                            break;
                    }
                }
            }
            break;
        }
        // control endpoint, handles follow-up on setup packets
        // Successful upload of control endpoint from device to host
        case USB_INT_EP0_IN:
        {
            if (transaction_state!=SETUP && transaction_state!=DATA) 
            {
                #ifdef DEBUG
                printf ("IN: >> unexpected IN after STATUS <<\n");
                #endif
                writeCommand (CH375_CMD_UNLOCK_USB);
                break;
            }
            if (dataLength==0) {
                transaction_state = STATUS;
                #ifdef DEBUG
                printf ("IN:STATUS\n");
                #endif
            }
            else {
                transaction_state = DATA;
                #ifdef DEBUG
                printf ("IN:DATA\n");
                #endif
            }
            
            switch(request.r.bRequest)
            {
                case USB_REQ_SET_ADDRESS:
                {
                    #ifdef DEBUG
                    printf("  Setting device address to: %d\n",usb_device_address);  
                    #endif
                    // it's time to set the new address
                    set_target_device_address (usb_device_address);
                    break;
                }
            }
            // write remaining data, or a zero packet to indicate end of transfer
            writeDataForEndpoint0 ();
            writeCommand (CH375_CMD_UNLOCK_USB);
            break;
        }
        // Control endpoint data is successfully downloaded to device
        case USB_INT_EP0_OUT:
        {
            if (transaction_state!=SETUP && transaction_state!=DATA) 
            {
                #ifdef DEBUG
                printf ("OUT: >> unexpected OUT after status<<\n");
                #endif
                sendEP0STALL();
                writeCommand (CH375_CMD_UNLOCK_USB);
                break;
            }
            if (dataLength==0) 
            {
                transaction_state = STATUS;
                #ifdef DEBUG
                printf ("OUT:STATUS\n");
                #endif
            }
            else 
            {
                transaction_state = DATA;
                #ifdef DEBUG
                printf ("OUT:DATA\n");
                #endif
            }

            // save previous request before it's overwritten in the next step
            uint8_t current_request = request.r.bRequest;

            // read data send to us
            length = read_usb_data (request.buffer);
            length = min (length,request.r.wLength);

            #ifdef DEBUG
            printf("  Read %i bytes: ", length);
            for(int i=0; i<length; i++) 
            {
                printf("0x%02X ", request.buffer[i]);
            }
            printf("\n");
            #endif

            // handle data
            dataLength = 0;
            switch(current_request)
            {
                case SET_LINE_CODING:
                {
                    #ifdef DEBUG
                    printf ("  Copy line encoding parameters \n");
                    #endif
                    //memcpy (&uart_parameters,request.buffer,length);
                    sendEP0ACK ();
                    break;
                }
                default:
                {
                    // absorb mode
                    break;
                }
            }
            break;  
        }
        // interrupt endpoint
        case USB_INT_EP1_IN:
            #ifdef DEBUG
            printf ("EP1 IN\n");
            #endif
            writeCommand (CH375_CMD_UNLOCK_USB);
            break;
        case USB_INT_EP1_OUT:
            #ifdef DEBUG
            printf ("EP1 OUT\n");
            #endif
            // read data send to us
            length = read_usb_data (request.buffer);
            #ifdef DEBUG
            printf("  Read %i bytes: ", length);
            for(int i=0; i<length; i++) 
            {
                printf("0x%02X ", request.buffer[i]);
            }
            printf("\n");
            #endif
            break;
        // bulk endpoint
        case USB_INT_EP2_IN:
            // interrupt send after writing to EP2 buffer 
            // when we do nothing data does get send
            writeDataForEndpoint2 ();
            writeCommand (CH375_CMD_UNLOCK_USB);
            break;
        case USB_INT_EP2_OUT:
            read_and_process_data ();
            break;
        default:
            #ifdef DEBUG
            printf("Unable to handle: %d\n",interruptType);
            #endif
            writeCommand (CH375_CMD_UNLOCK_USB);
            break;
    }
}

bool check_exists ()
{
    uint8_t value = 190;
    uint8_t new_value;
    writeCommand (CH375_CMD_CHECK_EXIST);
    writeData(value);
    new_value = readData ();
    value = value ^ 255;
    #ifdef DEBUG
    if (new_value != value)
        printf ("Device does not exist\n");
    #endif
    return new_value==value;
}

bool set_usb_host_mode (uint8_t mode)
{
    writeCommand(CH375_CMD_SET_USB_MODE);
    writeData(mode);
    
    uint8_t value;
    for(int i=0; i!=200; i++ )
    {
        value = readData();
        if ( value == CH_ST_RET_SUCCESS )
            return true;
        //msdelay(1);
    }
    return false;
}

bool initDevice ()
{
    if (!check_exists())
        return false;

    writeCommand (CH375_CMD_RESET_ALL);
    msdelay (500);

    bool result;
    if (!set_usb_host_mode(CH375_USB_MODE_DEVICE_OUTER_FW))
    {
        #ifdef DEBUG
        printf ("device mode not succeeded\n");
        #endif
        return false;
    }
    #ifdef DEBUG
    printf ("USB device initialized\n");
    #endif
    return true;
}