#include <SPI.h>
#include "device.h"
#include "ch376s.h"


int ledPin = 11;
int intPin = 4;
int misoPin = 3;
bool bDeviceOk = false;

int bytes_following;
bool extended_command;
bool zero_ended_command;
bool wait_for_operation_status;

void beginCmd (byte cmd)
{
  extended_command = false;
  zero_ended_command = false;
  wait_for_operation_status = false;
  
  switch (cmd) 
  {
    case CH_CMD_ENTER_SLEEP:        bytes_following = 1;
                                    break;   
    case CH375_CMD_CHECK_EXIST:     bytes_following = 3;
                                    break;
    case CH375_CMD_SET_USB_MODE:    wait_for_operation_status = true;
                                    break;
    case CH375_CMD_SET_USB_ADDR:    bytes_following = 2;
                                    break;
    case CH375_CMD_WR_HOST_DATA:    bytes_following = 2;
                                    extended_command = true;
                                    break; 
    case CH_CMD_SET_EP0_RX:         bytes_following = 2;
                                    break;
    case CH_CMD_SET_EP0_TX:         bytes_following = 2;
                                    break;
    case CH_CMD_SET_EP1_RX:         bytes_following = 2;
                                    break;
    case CH_CMD_SET_EP1_TX:         bytes_following = 2;
                                    break;
    case CH_CMD_SET_EP2_RX:         bytes_following = 2;
                                    break;
    case CH_CMD_SET_EP2_TX:         bytes_following = 2;
                                    break;
    case CH_CMD_WR_EP0:             bytes_following = 2;
                                    extended_command = true;
                                    break;  
    case CH_CMD_WR_EP1:             bytes_following = 2;
                                    extended_command = true;
                                    break;  
    case CH_CMD_WR_EP2:             bytes_following = 2;
                                    extended_command = true;
                                    break;                                                                                            
    case CH375_CMD_GET_STATUS:      bytes_following = 2;
                                    break; 
    case CH375_CMD_ISSUE_TKN_X:     bytes_following = 3;
                                    break;           
    case CH376_CMD_GET_IC_VER:      bytes_following = 2;
                                    break;
    case CH376_CMD_CLR_STALL:       bytes_following = 2;
                                    break;
    case CH375_CMD_RD_USB_DATA:     bytes_following = 2;
                                    extended_command = true;
                                    break;
    case CH375_CMD_RD_USB_DATA_UNLOCK:     bytes_following = 2;
                                           extended_command = true;
                                           break;
    case CH_CMD_SET_REGISTER:       bytes_following = 3;
                                    break;
    case CH_CMD_GET_REGISTER:       bytes_following = 3;
                                    break;        
    case CH_CMD_DELAY_100US:        bytes_following = 2;
                                    break;
    case CH375_CMD_GET_DESCR:       bytes_following = 2;
                                    break;         
    case CH_CMD_TEST_CONNECT:       bytes_following = 2;
                                    break;   
    case CH_CMD_DISK_CONNECT:       bytes_following = 1;
                                    break;   
    case CH_CMD_DISK_MOUNT:         bytes_following = 1;
                                    break;    
    case CH_CMD_FILE_OPEN:          bytes_following = 1;  
                                    break;          
    case CH_CMD_FILE_CLOSE:         bytes_following = 2;  
                                    break;          
    case CH_CMD_FILE_ENUM_GO:       bytes_following = 1;  
                                    break;    
    case CH_CMD_FILE_ERASE:         bytes_following = 1;  
                                    break;                                                                   
    case CH_CMD_SET_FILE_NAME:      bytes_following = 15;
                                    zero_ended_command = true;
                                    break;         
    case CH_CMD_BYTE_READ:          bytes_following = 3;
                                    break;      
    case CH_CMD_BYTE_RD_GO:         bytes_following = 1;
                                    break;  
    case CH_CMD_BYTE_WRITE:         bytes_following = 3;
                                    break;
    case CH_CMD_BYTE_WR_GO:         bytes_following = 1;
                                    break;       
    case CH_CMD_DIR_CREATE:         bytes_following = 1;
                                    break;  
    case CH_CMD_FILE_CREATE:        bytes_following = 1;
                                    break;            
    case CH_CMD_WR_REQ_DATA:        bytes_following = 2;
                                    extended_command = true;
                                    break;         
    case CH_CMD_DIR_INFO_READ:      bytes_following = 2;
                                    break;         
    case CH_CMD_BYTE_LOCATE:        bytes_following = 5;
                                    break;                
    case CH375_CMD_UNLOCK_USB:      bytes_following = 1;
                                    break;                                                                                                                                                                                                                       
    default:                        bytes_following = 1;  
                                    break;
  }
  digitalWrite(SS, LOW);  
  digitalWrite (ledPin, HIGH);
}
void checkEndCmd (byte value)
{
  if (zero_ended_command && value==0)
  {
    bytes_following=0;
    digitalWrite(SS, HIGH);
    digitalWrite (ledPin, LOW);
    return; 
  }
  if (wait_for_operation_status && (value==CH_ST_RET_SUCCESS || value==CH_ST_RET_ABORT))
  {
    bytes_following=0;
    digitalWrite(SS, HIGH);
    digitalWrite (ledPin, LOW);
    return;
  }
  if (--bytes_following==0) 
  {
      if (extended_command)
      {
        extended_command = false;
        bytes_following = value;
        if (bytes_following>0)
          return;
      }
      digitalWrite(SS, HIGH);
      digitalWrite (ledPin, LOW);
      return;
  }
}

void writeCommand (byte cmd)
{
  beginCmd (cmd);
  SPI.transfer (cmd);
  checkEndCmd (-1);
}

void writeData (byte data)
{
  SPI.transfer (data);
  checkEndCmd (data);
}
byte readData ()
{
  byte data = SPI.transfer (0);
  checkEndCmd (data);
  return data;
}
byte readStatus () 
{
  byte data;
  data = digitalRead (intPin)<<7; // INT
  //data = digitalRead (misoPin)<<7; // MISO
  data += 1; // simulated READY bit
  return data;
}

/**********************************
 * Redirect printf to serial port *
 **********************************/

//https://forum.arduino.cc/t/printf-to-the-serial-port/333975/4

int serial_putc( char c, FILE * ) 
{
  Serial.write( c );
  return c;
} 

void printf_begin(void)
{
  fdevopen( &serial_putc, 0 );
}

void error (char* msg)
{
  printf ("Error: %s\r\n",msg);
}

void loop() 
{
  if(bDeviceOk && (readStatus() & 0x80) == 0)
    handleInterrupt(); 
}

void setup() {
  // initialize SPI pins
  pinMode(SS, OUTPUT);
  digitalWrite(SS, HIGH);
  SPI.begin ();

  // initialize Teensy USB serial
  Serial.begin(0); // baudrate is always maximum usb bus speed 12Mbit/sec
  printf_begin();

  // initialize LED
  pinMode (ledPin,OUTPUT);
  digitalWrite (ledPin, LOW);

  // initialize USB device
  bDeviceOk = initDevice ();
}

