#if defined(ARDUINO)
    #include <wiring.h>
#endif
#include <ctype.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>

#include "host.h"
#include "workarea.h"
#include "device.h"
#include "descriptors.h"
#include "ch376s.h"

// Monitor messages
const char WELCOME_MSG[] = "\r\nMSXUSB Monitor\r\n--------------\r\nMxxxx - display memory\r\nSxxxx,yyyy,filename - save memory\r\nLxxxx,filename - load memory\r\nGxxxx - goto address\r\nR - Reset\r\nB - BASIC\r\nH - show this help text\r\nor, paste Intel HEX lines\r\n\r\n$ ";
const char UNKNOWN_MSG[] = "\r\nInvalid command\r\n$ ";
const char BYTES_MSG_ROM[] = "\r0x00 bytes written to memory\r\n$ ";
const char NEWLINE_MSG[] = "\r\n$ ";
const char IHX_TEMPLATE[]="\r\n:10A000002110A0CD07A0C97EA7C8CDA2002318F700";

// Monitor variables
char strMonitorEcho[BULK_OUT_ENDP_MAX_SIZE+1];
char ihx_bytes_processed[sizeof (BYTES_MSG_ROM)];
char ihx_output_line[sizeof (IHX_TEMPLATE)];
char strMonitorCmdArgs[BULK_OUT_ENDP_MAX_SIZE+1];
char* pstrMonitorCmdArgs;

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

#ifdef DEBUG
    uint16_t curtime, prevtime;
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
REQUEST_PACKET request;

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

   curtime = host_millis_elapsed ();
   if(name == NULL) 
   {
        printf("Unknown interrupt received: 0x%02X\n", interruptCode);
   }
   else 
   {
        uint16_t msecs1 = curtime - prevtime;
        prevtime = curtime;

        printf("Int: %s (%d)\n", name, msecs1);
   }
 }
#endif // DEBUG

void device_reset (WORKAREA* wrk)
{
    wrk->dataTransferLengthEP0 = 0;
    wrk->dataToTransferEP0 = NULL;
    wrk->dataTransferLengthEP2 = 0;
    wrk->dataToTransferEP2 = NULL;
    wrk->usb_device_address = 0;
    wrk->usb_configuration_id = 0;
    wrk->transaction_state = STATUS;
    wrk->processing_command = CMD_NULL;
    wrk->memory_address = 0xffff;
    #ifdef DEBUG
        curtime = prevtime = host_millis_elapsed ();
    #endif
}
void device_monitor_reset ()
{
    strcpy (ihx_bytes_processed, BYTES_MSG_ROM);
    strcpy (ihx_output_line, IHX_TEMPLATE);
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

void writeDataForEndpoint0(WORKAREA* wrk)
{
    int amount = min (EP0_PIPE_SIZE,wrk->dataTransferLengthEP0);

    // this is a data or status stage
    #ifdef DEBUG
    printf("  EP0: writing %d bytes of %d: ", amount,wrk->dataTransferLengthEP0);    
    #endif
    writeCommand(CH_CMD_WR_EP0);
    writeData(amount);
    for(int i=0; i<amount; i++) 
    {
        #ifdef DEBUG
        printf("0x%02X ", wrk->dataToTransferEP0[i]);
        #endif
        writeData(wrk->dataToTransferEP0[i]);
    }
    #ifdef DEBUG
    printf("\n");
    #endif
    wrk->dataToTransferEP0 += amount;
    wrk->dataTransferLengthEP0 -= amount;
}
void writeDataForEndpoint2(WORKAREA* wrk)
{
    int amount = min (BULK_OUT_ENDP_MAX_SIZE,wrk->dataTransferLengthEP2);

    if (amount!=0)
    {
        #ifdef DEBUG
        printf("  EP2: writing %d bytes of %d: ", amount,wrk->dataTransferLengthEP2);    
        #endif
        writeCommand(CH_CMD_WR_EP2);
        writeData(amount);
        for(int i=0; i<amount; i++) 
        {
            #ifdef DEBUG
            printf("0x%02X ", wrk->dataToTransferEP2[i]);
            #endif
            writeData(wrk->dataToTransferEP2[i]);
        }
        #ifdef DEBUG
        printf("\n");
        #endif
        wrk->dataToTransferEP2 += amount;
        wrk->dataTransferLengthEP2 -= amount;
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

void print_memory (WORKAREA* wrk)
{
    #ifdef DEBUG
    uint8_t checksum;
    #endif
    uint8_t value;
    uint8_t addr_low,addr_high;

    // setup what to transfer
    wrk->dataToTransferEP2 = (uint8_t*) ihx_output_line;
    wrk->dataTransferLengthEP2 = sizeof (ihx_output_line);

    // fill buffer with memory contents
    uint16_t address = wrk->memory_address;
    addr_high = address>>8;
    addr_low = address&0xff;
    convertToStr (addr_high,ihx_output_line+5);
    convertToStr (addr_low,ihx_output_line+7);

    #ifdef DEBUG
    checksum = 0x10;
    checksum += addr_high;
    checksum += addr_low;
    #endif

    char* membufptr = ihx_output_line+11;
    for (int i=0;i<0x10;i++)
    {
        value = host_readByte(address+i);
        convertToStr (value,membufptr);
        membufptr+=2;
        #ifdef DEBUG
        checksum+=value;
        #endif
    }
    #ifdef DEBUG
    // two complement of checksum
    checksum = checksum ^ 0xff;
    checksum += 1;
    convertToStr (checksum,ihx_output_line+43);
    #endif

    // next memory_address to print
    wrk->memory_address += 0x10;
}

void device_send (WORKAREA* wrk,char* buffer,uint16_t length)
{
    wrk->dataToTransferEP2 = (uint8_t*) buffer;
    wrk->dataTransferLengthEP2 = length;
    writeDataForEndpoint2 (wrk);
}
void device_send_welcome (WORKAREA* wrk)
{
    device_send (wrk,WELCOME_MSG,sizeof (WELCOME_MSG));
}

void read_and_send_host()
{
    uint8_t length;
    writeCommand(CH375_CMD_RD_USB_DATA_UNLOCK);
    length = readData();
    if (length)
    {
        for (uint8_t i=0;i<length;i++)
            host_putchar (readData());
    }
}

INTERRUPT_RESULT read_and_process_data(WORKAREA* wrk)
{
    INTERRUPT_RESULT intres = DEVICE_INTERRUPT_OKAY;
    uint8_t length = 0;
    uint8_t value;
    writeCommand(CH375_CMD_RD_USB_DATA_UNLOCK);
    length = readData(); // read length
    if (length==0)
        return DEVICE_INTERRUPT_ERROR;
    #ifdef DEBUG
    printf("  Processing %i bytes \n", length);
    #endif
    char* pstrMonitorEcho = strMonitorEcho;
    wrk->dataToTransferEP2 = NULL;
    wrk->dataTransferLengthEP2 = 0;

    for (uint8_t i=0;i<length;i++)
    {
        value = toupper(readData());
        // copy to result buffer
        if (wrk->processing_command!=CMD_IHX && value!=':')
            *pstrMonitorEcho++ = value;

        // what did we get?
        switch (value)
        {
            case 'G': 
                if (wrk->processing_command==CMD_NULL)
                {
                    wrk->processing_command = CMD_GO; 
                    pstrMonitorCmdArgs = strMonitorCmdArgs;
                }
                break;
            case 'M': 
                if (wrk->processing_command==CMD_NULL)
                {
                    wrk->processing_command = CMD_MEMORY; 
                    pstrMonitorCmdArgs = strMonitorCmdArgs;
                }
                break;
            case 'R': 
                if (wrk->processing_command==CMD_NULL)
                {
                    wrk->processing_command = CMD_RESET; 
                    pstrMonitorCmdArgs = NULL;
                }
                break;
            case 'B': 
                if (wrk->processing_command==CMD_NULL)
                {
                    wrk->processing_command = CMD_BASIC; 
                    pstrMonitorCmdArgs = NULL;
                }
                break;
            case 'H': 
                if (wrk->processing_command==CMD_NULL)
                {
                    wrk->processing_command = CMD_HELP; 
                    pstrMonitorCmdArgs = NULL;
                }
                break;
            case ':': 
                if (wrk->processing_command==CMD_NULL)
                {
                    wrk->processing_command = CMD_IHX; 
                    pstrMonitorCmdArgs = strMonitorCmdArgs;
                }
                break;
            case 'S': 
                if (wrk->processing_command==CMD_NULL)
                {
                    wrk->processing_command = CMD_SAVE; 
                    pstrMonitorCmdArgs = strMonitorCmdArgs;
                }
                break;
            case 'L': 
                if (wrk->processing_command==CMD_NULL)
                {
                    wrk->processing_command = CMD_LOAD; 
                    pstrMonitorCmdArgs = strMonitorCmdArgs;
                }
                break;
            case 0x1b:
                wrk->dataToTransferEP2 = (uint8_t*) NEWLINE_MSG;
                wrk->dataTransferLengthEP2 = sizeof (NEWLINE_MSG);
                wrk->processing_command = CMD_NULL;
                wrk->memory_address=0xffff;
                break;
            case '\r':
            {
                switch (wrk->processing_command)
                {
                    case CMD_GO:
                        host_go(convertHex (strMonitorCmdArgs+1,4));
                        wrk->dataToTransferEP2 = (uint8_t*) NEWLINE_MSG;
                        wrk->dataTransferLengthEP2 = sizeof (NEWLINE_MSG);
                        wrk->processing_command = CMD_NULL;
                        break;
                    case CMD_MEMORY:
                        if (wrk->memory_address==0xffff)
                            wrk->memory_address = convertHex (strMonitorCmdArgs+1,4);
                        print_memory(wrk);
                        break;
                    case CMD_RESET:
                        host_reset ();
                        wrk->dataToTransferEP2 = (uint8_t*) NEWLINE_MSG;
                        wrk->dataTransferLengthEP2 = sizeof (NEWLINE_MSG);
                        wrk->processing_command = CMD_NULL;
                        break;
                    case CMD_BASIC:
                        intres = MONITOR_EXIT_BASIC;
                        wrk->dataToTransferEP2 = (uint8_t*) NEWLINE_MSG;
                        wrk->dataTransferLengthEP2 = sizeof (NEWLINE_MSG);
                        wrk->processing_command = CMD_NULL;
                        break;
                    case CMD_HELP:
                        wrk->dataToTransferEP2 = (uint8_t*) WELCOME_MSG;
                        wrk->dataTransferLengthEP2 = sizeof (WELCOME_MSG);
                        wrk->processing_command = CMD_NULL;
                        break;
                    case CMD_IHX:
                        *pstrMonitorCmdArgs = '\0';
                        uint8_t bytesWritten = handleIHX (strMonitorCmdArgs+1);
                        // write confirmation message and continue
                        convertToStr (bytesWritten,ihx_bytes_processed+3);
                        wrk->dataToTransferEP2 = (uint8_t*) ihx_bytes_processed;
                        wrk->dataTransferLengthEP2 = sizeof (ihx_bytes_processed);
                        wrk->processing_command = CMD_NULL;
                        break;
                    case CMD_LOAD:
                        *pstrMonitorCmdArgs = '\0';
                        if ((pstrMonitorCmdArgs-strMonitorCmdArgs)>5)
                            host_load(convertHex (strMonitorCmdArgs+1,4),strMonitorCmdArgs+6);
                        wrk->dataToTransferEP2 = (uint8_t*) NEWLINE_MSG;
                        wrk->dataTransferLengthEP2 = sizeof (NEWLINE_MSG);
                        wrk->processing_command = CMD_NULL;
                        break;
                    case CMD_SAVE:
                        *pstrMonitorCmdArgs = '\0';
                        if ((pstrMonitorCmdArgs-strMonitorCmdArgs)>10)
                            host_save(convertHex (strMonitorCmdArgs+1,4),convertHex (strMonitorCmdArgs+6,4),strMonitorCmdArgs+11);
                        wrk->dataToTransferEP2 = (uint8_t*) NEWLINE_MSG;
                        wrk->dataTransferLengthEP2 = sizeof (NEWLINE_MSG);
                        wrk->processing_command = CMD_NULL;
                        break;
                    case CMD_NULL:
                        wrk->dataToTransferEP2 = (uint8_t*) UNKNOWN_MSG;
                        wrk->dataTransferLengthEP2 = sizeof (UNKNOWN_MSG);
                        break;
                }
                break;
            }
        }
        if (wrk->processing_command!=CMD_NULL && pstrMonitorCmdArgs != NULL)
            *(pstrMonitorCmdArgs++) = value;
    }
    
    // write strMonitorEcho
    if (wrk->dataToTransferEP2==NULL)
    {
        // echo the incoming characters if there is no alternative output
        wrk->dataToTransferEP2 = (uint8_t*) strMonitorEcho;
        wrk->dataTransferLengthEP2 = pstrMonitorEcho - strMonitorEcho;
    }
    writeDataForEndpoint2 (wrk);  

    return intres;
}
INTERRUPT_RESULT handleEP0SetupClass (WORKAREA* wrk)
{
    INTERRUPT_RESULT intres = DEVICE_INTERRUPT_OKAY;
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
            wrk->dataToTransferEP0 = (uint8_t*) &uart_parameters;
            wrk->dataTransferLengthEP0 = min ((uint16_t) sizeof(UART_PARA),request.r.wLength);;
            break;
        case SET_CONTROL_LINE_STATE: // SET_CONTROL_LINE_STATE
            #ifdef DEBUG
            printf ("  SET_CONTROL_LINE_STATE\n");
            #endif
            sendEP0ACK ();
            if (request.r.wValue && 0x01)
                intres = DEVICE_SERIAL_CONNECTED;   
            else
                intres = DEVICE_SERIAL_DISCONNECTED;   
            break;
        default:
            #ifdef DEBUG
            printf ("  Unsupported class command code\n");
            #endif
            break;
    }            
    return intres;
}
INTERRUPT_RESULT handleEP0SetupStandard(WORKAREA* wrk)
{
    INTERRUPT_RESULT intres = DEVICE_INTERRUPT_OKAY;
    #ifdef DEBUG
    printf("SETUP STANDARD request\n");
    #endif
    switch(request.r.bRequest)
    {
        // IN requests
        //////////////////////////////////////////
        case USB_REQ_GET_DESCRIPTOR:
            #ifdef DEBUG
            printf("  USB_REQ_GET_DESCRIPTOR: ");
            #endif
            switch (request.r.wValue>>8)
            {
                case USB_DESC_DEVICE: 
                {
                    #ifdef DEBUG
                    printf("DEVICE\n");
                    #endif
                    wrk->dataToTransferEP0 = (uint8_t*) DevDes;
                    wrk->dataTransferLengthEP0 = min ((uint16_t) sizeof(DevDes),request.r.wLength);
                    break;
                }
                case USB_DESC_CONFIGURATION: 
                {
                    #ifdef DEBUG
                    printf("CONFIGURATION\n");
                    #endif
                    wrk->dataToTransferEP0 = (uint8_t*) ConDes;
                    wrk->dataTransferLengthEP0 = min ((uint16_t) sizeof(ConDes),request.r.wLength);
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
                            wrk->dataToTransferEP0 = (uint8_t*) LangDes;
                            wrk->dataTransferLengthEP0 = min ((uint16_t) sizeof(LangDes),request.r.wLength);
                            break;
                        }
                        case STRING_DESC_PRODUCT: 
                        {
                            #ifdef DEBUG
                            printf("Product\n");
                            #endif
                            wrk->dataToTransferEP0 = (uint8_t*) PRODUCER_Des;
                            wrk->dataTransferLengthEP0 = min ((uint16_t) sizeof(PRODUCER_Des),request.r.wLength);
                            break;
                        }
                        case STRING_DESC_MANUFACTURER: 
                        {
                            #ifdef DEBUG
                            printf("Manufacturer\n");
                            #endif
                            wrk->dataToTransferEP0 = (uint8_t*) MANUFACTURER_Des;
                            wrk->dataTransferLengthEP0 = min ((uint16_t) sizeof(MANUFACTURER_Des),request.r.wLength);
                            break;
                        }
                        case STRING_DESC_SERIAL:
                        {
                            #ifdef DEBUG
                            printf("Serial\n");
                            #endif
                            wrk->dataToTransferEP0 = (uint8_t*) PRODUCER_SN_Des;
                            wrk->dataTransferLengthEP0 = min ((uint16_t) sizeof(PRODUCER_SN_Des),request.r.wLength);
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
            writeDataForEndpoint0(wrk);
            break;                   
        case USB_REQ_GET_CONFIGURATION:
            #ifdef DEBUG
            printf("  USB_REQ_GET_CONFIGURATION\n");    
            #endif
            wrk->dataToTransferEP0 = &(wrk->usb_configuration_id);
            wrk->dataTransferLengthEP0 = 1;
            break;
        case USB_REQ_GET_INTERFACE:
            #ifdef DEBUG
            printf("  USB_REQ_GET_INTERFACE\n");    
            #endif
            break;
        case USB_REQ_GET_STATUS:
            #ifdef DEBUG
            printf("  USB_REQ_GET_STATUS\n");    
            #endif
            break;
        // OUT requests
        //////////////////////////////////////////
        case USB_REQ_SET_ADDRESS:
            intres = DEVICE_ADDRESS_SET;
            wrk->usb_device_address = request.r.wValue;
            #ifdef DEBUG
            printf("  SET_ADDRESS: %i\n", wrk->usb_device_address);
            #endif
            sendEP0ACK ();
            break;
        case USB_REQ_SET_CONFIGURATION:
            intres = DEVICE_CONFIGURATION_SET;
            #ifdef DEBUG
            printf("  USB_REQ_SET_CONFIGURATION %d\n",request.r.wValue);  
            #endif
            if (request.r.wValue==USB_CONFIGURATION_ID) 
                wrk->usb_configuration_id = request.r.wValue;
            sendEP0ACK ();
            break; 
        case USB_REQ_SET_INTERFACE:
            #ifdef DEBUG
            printf("  USB_REQ_SET_INTERFACE\n");  
            #endif
            break; 
        case USB_REQ_CLEAR_FEATURE:
            #ifdef DEBUG
            printf("  USB_REQ_CLEAR_FEATURE\n");  
            #endif
            break; 
        default:
            #ifdef DEBUG
            printf("  UNKNOWN IN/OUT REQUEST 0x%x\n", request.r.bRequest);    
            #endif
            break;
    }
    return intres;
}
INTERRUPT_RESULT handleEP0Setup (WORKAREA* wrk)
{
    INTERRUPT_RESULT intres = DEVICE_INTERRUPT_OKAY;
    #ifdef DEBUG
    if (wrk->transaction_state!=STATUS)
        printf ("SETUP: >> previous transaction not completed <<\n");
    #endif
    wrk->transaction_state = SETUP;
    #ifdef DEBUG
    printf ("SETUP\n");
    #endif
    // read setup package
    size_t length = read_usb_data (request.buffer);
    #ifdef DEBUG
    printf("  bmRequestType: 0x%02X\n", request.r.bmRequestType);
    printf("  bRequest: %i\n", request.r.bRequest);
    printf("  wValue: 0x%04X\n", request.r.wValue);
    printf("  wIndex: 0x%04X\n", request.r.wIndx);
    printf("  wLength: %03d\n", request.r.wLength);
    #endif
    // initialize dataTransferLengthEP0 with length of setup package
    wrk->dataTransferLengthEP0 = request.r.wLength;

    switch (request.r.bmRequestType & USB_TYPE_MASK)
    {
        case USB_TYPE_STANDARD: 
            intres = handleEP0SetupStandard (wrk); 
            break;
        case USB_TYPE_CLASS:    
            intres = handleEP0SetupClass (wrk); 
            break;
        case USB_TYPE_VENDOR:   
            #ifdef DEBUG
            printf("SETUP VENDOR request\n");
            #endif
            break;                        
    }
    return intres;
}

void handleEP0IN (WORKAREA* wrk)
{
    // EP0IN: control endpoint, handles follow-up on setup packets
    // Successful upload of control endpoint from device to host
    if (wrk->transaction_state!=SETUP && wrk->transaction_state!=DATA) 
    {
        #ifdef DEBUG
        printf ("IN: >> unexpected IN after STATUS <<\n");
        #endif
        writeCommand (CH375_CMD_UNLOCK_USB);
        return;
    }
    if (wrk->dataTransferLengthEP0==0) 
    {
        wrk->transaction_state = STATUS;
        #ifdef DEBUG
        printf ("IN:STATUS\n");
        #endif
    }
    else 
    {
        wrk->transaction_state = DATA;
        #ifdef DEBUG
        printf ("IN:DATA\n");
        #endif
    }
    
    switch(request.r.bRequest)
    {
        case USB_REQ_SET_ADDRESS:
            #ifdef DEBUG
            printf("  Setting device address to: %d\n",wrk->usb_device_address);  
            #endif
            // it's time to set the new address
            set_target_device_address (wrk->usb_device_address);
            break;
    }
    // write remaining data, or a zero packet to indicate end of transfer
    writeDataForEndpoint0 (wrk);
    writeCommand (CH375_CMD_UNLOCK_USB);
}
void handleEP0OUT(WORKAREA* wrk)
{
    // EP0OUT: Control endpoint data is successfully downloaded to device
    if (wrk->transaction_state!=SETUP && wrk->transaction_state!=DATA) 
    {
        #ifdef DEBUG
        printf ("OUT: >> unexpected OUT after status<<\n");
        #endif
        sendEP0STALL();
        writeCommand (CH375_CMD_UNLOCK_USB);
        return;
    }
    if (wrk->dataTransferLengthEP0==0) 
    {
        wrk->transaction_state = STATUS;
        #ifdef DEBUG
        printf ("OUT:STATUS\n");
        #endif
    }
    else 
    {
        wrk->transaction_state = DATA;
        #ifdef DEBUG
        printf ("OUT:DATA\n");
        #endif
    }

    // save previous request before it's overwritten in the next step
    uint8_t current_request = request.r.bRequest;

    // read data send to us
    size_t length = read_usb_data (request.buffer);
    length = min (length,request.r.wLength);

    #ifdef DEBUG
    printf("  Read %i bytes: ", (int) length);
    for(int i=0; i<length; i++) 
    {
        printf("0x%02X ", request.buffer[i]);
    }
    printf("\n");
    #endif

    // handle data
    wrk->dataTransferLengthEP0 = 0;
    switch(current_request)
    {
        case SET_LINE_CODING:
            #ifdef DEBUG
            printf ("  Copy line encoding parameters \n");
            #endif
            //memcpy (&uart_parameters,request.buffer,length);
            sendEP0ACK ();
            break;
        default:
            // absorb mode
            break;
    }
}
INTERRUPT_RESULT device_interrupt (WORKAREA* wrk, DEVICE_MODE mode)
{
    INTERRUPT_RESULT intres = DEVICE_INTERRUPT_OKAY;
    size_t length;
    // get the type of interrupt
    writeCommand(CH375_CMD_GET_STATUS);
    uint8_t interruptType = readData ();

    if((interruptType & USB_BUS_RESET_MASK) == USB_INT_BUS_RESET)
        interruptType = USB_INT_BUS_RESET;

    #ifdef DEBUG
    //printInterruptName(interruptType);
    #endif

    switch(interruptType)
    {
        case USB_INT_USB_SUSPEND:
            writeCommand(CH_CMD_ENTER_SLEEP);
            writeCommand (CH375_CMD_UNLOCK_USB);
            break;
        case USB_INT_BUS_RESET:
            device_reset (wrk);
            writeCommand (CH375_CMD_UNLOCK_USB);
            break;
        // control endpoint setup package
        case USB_INT_EP0_SETUP:
            intres = handleEP0Setup (wrk);
            break;
        // control endpoint, handles follow-up on setup packets
        // Successful upload of control endpoint from device to host
        case USB_INT_EP0_IN:
            handleEP0IN (wrk);
            break;
        // Control endpoint data is successfully downloaded to device
        case USB_INT_EP0_OUT:
            handleEP0OUT (wrk);
            break;  
        // interrupt endpoint is not being used
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
            printf("  Read %i bytes: ", (int) length);
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
            // write any additional data if there is more to send
            writeDataForEndpoint2 (wrk);
            writeCommand (CH375_CMD_UNLOCK_USB);
            break;
        case USB_INT_EP2_OUT:
            if (mode==MONITOR_MODE)
                intres = read_and_process_data (wrk);
            else
                read_and_send_host ();   
            break;
        default:
            #ifdef DEBUG
            printf("Unable to handle: %d\n",interruptType);
            #endif
            writeCommand (CH375_CMD_UNLOCK_USB);
            break;
    }
    return intres;
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

bool device_init ()
{
    if (!check_exists())
        return false;

    writeCommand (CH375_CMD_RESET_ALL);
    host_delay (500);

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