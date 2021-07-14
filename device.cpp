#include "wiring.h"
#include "ch376s.h"
#include "device.h"
#include <stdio.h>
#include <string.h>
#include "descriptors.h"

uint8_t oneOneByte[1] = {1};
uint8_t oneZeroByte[1] = {0};
uint8_t twoZeroBytes[2] = {0,0};

typedef	union __attribute__((packed)) _REQUEST_PACK{
	unsigned char  buffer[64];
	struct{
		uint8_t	    bmRequestType;  
		uint8_t	    bRequest;	
		uint16_t    wValue;		
		uint16_t    wIndx;		
		uint16_t    wLength;	
	}r;
} REQUEST_PACKET;

typedef union __attribute__((packed)) _UART_PARA
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

   if(name == NULL) 
   {
        printf("Unknown interrupt received: 0x%02X\r\n", interruptCode);
   }
   else 
   {
        printf("Int: %s\r\n", name);
   }
 }

uint8_t* dataToTransfer;
int     dataLength;
uint8_t usb_device_address;
uint8_t usb_configuration_id;

void reset ()
{
    dataLength = 0;
    dataToTransfer = NULL;
    usb_device_address = 0;
    usb_configuration_id = 0;
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
    printf("  Writing %d bytes of %d: ", amount,dataLength);    
    writeCommand(CH_CMD_WR_EP0);
    writeData(amount);
    for(int i=0; i<amount; i++) 
    {
        printf("0x%02X ", dataToTransfer[i]);
        writeData(dataToTransfer[i]);
    }
    printf("\r\n");

    dataToTransfer += amount;
    dataLength -= amount;
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
    delay (2);
}

REQUEST_PACKET request;
int length;
char characterBuffer[255];
enum state_transaction 
{
    SETUP=0,
    DATA,
    STATUS
} transaction_state = STATUS;
    
void handleInterrupt ()
{
    // get the type of interrupt
    writeCommand(CH375_CMD_GET_STATUS);
    byte interruptType = readData ();

    if((interruptType & USB_BUS_RESET_MASK) == USB_INT_BUS_RESET)
        interruptType = USB_INT_BUS_RESET;

    //printInterruptName(interruptType);

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
            if (transaction_state!=STATUS)
                printf ("SETUP: >> previous transaction not completed <<\r\n");
            transaction_state = SETUP;
            printf ("SETUP\r\n");

            // read setup package
            int length = read_usb_data (request.buffer);
            printf("  bmRequestType: 0x%02X\r\n", request.r.bmRequestType);
            printf("  bRequest: %i\r\n", request.r.bRequest);
            printf("  wValue: 0x%04X\r\n", request.r.wValue);
            printf("  wIndex: 0x%04X\r\n", request.r.wIndx);
            printf("  wLength: %03d\r\n", request.r.wLength);

            // initialize dataLength with length of setup package
            dataLength = request.r.wLength;

            if ((request.r.bmRequestType & USB_TYPE_MASK)==USB_TYPE_VENDOR)
            {
                printf("SETUP VENDOR request\r\n");
            }
            if ((request.r.bmRequestType & USB_TYPE_MASK)==USB_TYPE_CLASS)
            {
                printf("SETUP CLASS request\r\n");
                switch (request.r.bRequest)              // Analyze the class request code and process it
                {
                    case SET_LINE_CODING: 
                        // SET_LINE_CODING
                        // new encoding send in EP0_IN message
                        printf ("  SET_LINE_CODING\r\n");
                        break;
                    case GET_LINE_CODING: // GET_LINE_CODING
                        printf ("  GET_LINE_CODING\r\n");
                        dataToTransfer = (uint8_t*) &uart_parameters;
                        dataLength = min ((uint16_t) sizeof(UART_PARA),request.r.wLength);;
                        break;
                    case SET_CONTROL_LINE_STATE: // SET_CONTROL_LINE_STATE
                        printf ("  SET_CONTROL_LINE_STATE\r\n");
                        sendEP0ACK ();
                        break;
                    default:
                        error ("  Unsupported class command code");
                        //sendEP0STALL ();
                        break;
                }                    
            }
            if ((request.r.bmRequestType & USB_TYPE_MASK)==USB_TYPE_STANDARD)
            {
                printf("SETUP STANDARD request");
                if ((request.r.bmRequestType & USB_DIR_MASK) == USB_DIR_IN) // IN
                {
                    printf(" IN\r\n");
                    switch(request.r.bRequest)
                    {
                        case USB_REQ_GET_DESCRIPTOR:
                        {
                            printf("USB_REQ_GET_DESCRIPTOR: ");
                            switch (request.r.wValue>>8)
                            {
                                case USB_DESC_DEVICE: 
                                {
                                    printf("DEVICE\r\n");
                                    dataToTransfer = DevDes;
                                    dataLength = min ((uint16_t) sizeof(DevDes),request.r.wLength);
                                    break;
                                }
                                case USB_DESC_CONFIGURATION: 
                                {
                                    printf("CONFIGURATION\r\n");
                                    dataToTransfer = ConDes;
                                    dataLength = min ((uint16_t) sizeof(ConDes),request.r.wLength);
                                    break;
                                }
                                case USB_DESC_STRING: 
                                {
                                    printf("STRING: ");
                                    uint8_t stringIndex = request.r.wValue&0xff;  
                                    switch(stringIndex)
                                    {
                                        case 0: 
                                        {
                                            printf("Language\r\n");
                                            dataToTransfer = LangDes;
                                            dataLength = min ((uint16_t) sizeof(LangDes),request.r.wLength);
                                            break;
                                        }
                                        case STRING_DESC_PRODUCT: 
                                        {
                                            printf("Product\r\n");
                                            dataToTransfer = PRODUCER_Des;
                                            dataLength = min ((uint16_t) sizeof(PRODUCER_Des),request.r.wLength);
                                            break;
                                        }
                                        case STRING_DESC_MANUFACTURER: 
                                        {
                                            printf("Manufacturer\r\n");
                                            dataToTransfer = MANUFACTURER_Des;
                                            dataLength = min ((uint16_t) sizeof(MANUFACTURER_Des),request.r.wLength);
                                            break;
                                        }
                                        case STRING_DESC_SERIAL:
                                        {
                                            printf("Serial\r\n");
                                            dataToTransfer = PRODUCER_SN_Des;
                                            dataLength = min ((uint16_t) sizeof(PRODUCER_SN_Des),request.r.wLength);
                                            break;
                                        }
                                        default: 
                                        {
                                            printf("Unknown! (%i)\r\n", stringIndex);
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
                            printf("USB_REQ_GET_CONFIGURATION\r\n");    
                            dataToTransfer = &usb_configuration_id;
                            dataLength = 1;
                            break;
                        case USB_REQ_GET_INTERFACE:
                            printf("USB_REQ_GET_INTERFACE\r\n");    
                            break;
                        case USB_REQ_GET_STATUS:
                            printf("USB_REQ_GET_STATUS\r\n");    
                            break;
                        default:
                            printf("UNKNOWN IN REQUEST 0x%x\r\n", request.r.bRequest);    
                            break;
                    }
                }
                else // OUT
                {
                    printf(" OUT\r\n");
                    switch(request.r.bRequest)
                    {
                        case USB_REQ_SET_ADDRESS:
                        {  
                            usb_device_address = request.r.wValue;
                            printf("  SET_ADDRESS: %i\r\n", usb_device_address);
                            sendEP0ACK ();
                            break;
                        }
                        case USB_REQ_SET_CONFIGURATION:
                        {
                            printf("  USB_REQ_SET_CONFIGURATION %d\r\n",request.r.wValue);  
                            if (request.r.wValue==USB_CONFIGURATION_ID) 
                                usb_configuration_id = request.r.wValue;
                            sendEP0ACK ();
                            break; 
                        }
                        case USB_REQ_SET_INTERFACE:
                        {
                            printf("  USB_REQ_SET_INTERFACE\r\n");  
                            break; 
                        }
                        case USB_REQ_CLEAR_FEATURE:
                        {
                            printf("  USB_REQ_CLEAR_FEATURE\r\n");  
                            break; 
                        }
                        default:
                            printf("  UNKNOWN OUT REQUEST 0x%x\r\n", request.r.bRequest);    
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
            if (transaction_state!=SETUP && transaction_state!=DATA) {
                printf ("IN: >> unexpected IN after STATUS <<\r\n");
                writeCommand (CH375_CMD_UNLOCK_USB);
                break;
            }
            if (dataLength==0) {
                transaction_state = STATUS;
                printf ("IN:STATUS\r\n");
            }
            else {
                transaction_state = DATA;
                printf ("IN:DATA\r\n");
            }
            
            switch(request.r.bRequest)
            {
                case USB_REQ_SET_ADDRESS:
                {
                    printf("  Setting device address to: %d\r\n",usb_device_address);  
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
            if (transaction_state!=SETUP && transaction_state!=DATA) {
                printf ("OUT: >> unexpected OUT after status<<\r\n");
                sendEP0STALL();
                writeCommand (CH375_CMD_UNLOCK_USB);
                break;
            }
            if (dataLength==0) {
                transaction_state = STATUS;
                printf ("OUT:STATUS\r\n");
            }
            else {
                transaction_state = DATA;
                printf ("OUT:DATA\r\n");
            }

            // save previous request before it's overwritten in the next step
            uint8_t last_request = request.r.bRequest;

            // read data send to us
            length = read_usb_data (request.buffer);

            printf("  Read %i bytes: ", length);
            for(int i=0; i<length; i++) 
            {
                printf("0x%02X ", request.buffer[i]);
            }
            printf("\r\n");

            // handle data
            dataLength = 0;
            switch(last_request)
            {
                case SET_LINE_CODING:
                {
                    printf ("  Copy line encoding parameters \r\n");
                    memcpy (&uart_parameters,request.buffer,length);
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
            printf ("EP1 IN\r\n");
            writeCommand (CH375_CMD_UNLOCK_USB);
            break;
        case USB_INT_EP1_OUT:
            printf ("EP1 OUT\r\n");
            // read data send to us
            length = read_usb_data (request.buffer);
            printf("  Read %i bytes: ", length);
            for(int i=0; i<length; i++) 
            {
                printf("0x%02X ", request.buffer[i]);
            }
            printf("\r\n");
            break;
        // bulk endpoint
        case USB_INT_EP2_IN:
            // interrupt send after writing to EP2 buffer 
            // when we do nothing data does get send
            writeCommand (CH375_CMD_UNLOCK_USB);
            break;
        case USB_INT_EP2_OUT:
            length = read_usb_data ((uint8_t*)characterBuffer);

            characterBuffer[length]='\0';
            printf("  Read %i bytes: ", length);
            for(int i=0; i<length; i++) 
            {
                printf("0x%02X ", characterBuffer[i]);
            }
            printf("\r\n");

            // write back (echo)
            strupr (characterBuffer);
            // write characterbuffer to EP2
            length = strlen (characterBuffer);
            writeCommand (CH_CMD_WR_EP2);
            writeData (length);
            for (int i=0; i<length; i++)
            {
                writeData (characterBuffer[i]);
            }

            break;
        default:
            writeCommand (CH375_CMD_UNLOCK_USB);
            break;
    }
}

bool check_exists ()
{
    uint8_t value = 190;
    uint8_t new_value;
    //char cmd[] = {0x57,0xAB,CH375_CMD_CHECK_EXIST,value};
    writeCommand (CH375_CMD_CHECK_EXIST);
    writeData(value);
    new_value = readData ();
    value = value ^ 255;
    if (new_value != value)
        error ("Device does not exist");
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
        delay(1);
    }
    return false;
}

bool initDevice ()
{
    if (!check_exists())
        return false;

    writeCommand (CH375_CMD_RESET_ALL);
    delay (500);

    bool result;
    if (!set_usb_host_mode(CH375_USB_MODE_DEVICE_OUTER_FW))
    {
        error ("device mode not succeeded");
        return false;
    }
    
    printf ("USB device initialized\r\n");
    return true;
}