#include <wiring.h>
#include <SPI.h>

#include "host.h"
#include "workarea.h"
#include "device.h"
#include "ch376s.h"

WORKAREA workarea;

int ledPin = 11;
int intPin = 5;
int misoPin = 3;
bool bDeviceOk = false;
#define LEDLOW LOW
#define LEDHIGH HIGH

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
  digitalWrite (ledPin, LEDHIGH);
}
void checkEndCmd (byte value)
{
  if (zero_ended_command && value==0)
  {
    bytes_following=0;
    digitalWrite(SS, HIGH);
    digitalWrite (ledPin, LEDLOW);
    return; 
  }
  if (wait_for_operation_status && (value==CH_ST_RET_SUCCESS || value==CH_ST_RET_ABORT))
  {
    bytes_following=0;
    digitalWrite(SS, HIGH);
    digitalWrite (ledPin, LEDLOW);
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
      digitalWrite (ledPin, LEDLOW);
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

void host_reset ()
{
  printf ("resetting host\n");
}
void host_basic_interpreter ()
{
  printf ("starting BASIC\n");
}
void host_go (uint16_t address)
{
  printf ("jumping to 0x%04X\n",address);
}
void host_writeByte (uint16_t address, uint8_t value)
{
  printf ("address: 0x%04X, value: 0x%02X",address,value);
}
uint8_t host_readByte (uint16_t address)
{
  return address&0xff;
}
void host_putchar (uint8_t character)
{
  
}
struct 
{
  char filename[11];
} FCB;
void host_load (uint16_t address, uint16_t in_filename)
{
  memset (FCB.filename,' ',sizeof(FCB.filename));
  char* dot = strchr ((char*) in_filename,'.');
  char* end = strchr ((char*) in_filename,'\0');
  if (dot)
  {
      memcpy (FCB.filename,(void*)in_filename,dot-(char*)in_filename);
      memcpy (FCB.filename+8,dot+1,end-dot);
  }
  else
  {
      memcpy (FCB.filename,(void*)in_filename,end-(char*)in_filename);
  }
  printf ("reading [%s] into address: 0x%04X\n",(char*)FCB.filename,address);
}
void host_save (uint16_t address, uint16_t size, uint16_t in_filename)
{
  memset (FCB.filename,' ',sizeof(FCB.filename));
  char* dot = strchr ((char*) in_filename,'.');
  char* end = strchr ((char*) in_filename,'\0');
  if (dot)
  {
      memcpy (FCB.filename,(void*)in_filename,dot-(char*)in_filename);
      memcpy (FCB.filename+8,dot+1,end-dot);
  }
  else
  {
      memcpy (FCB.filename,(void*)in_filename,end-(char*)in_filename);
  }
  printf ("saving 0x%04X bytes to [%s] from address: 0x%04X\n",size,(char*)FCB.filename,address);
}
void host_delay (int milliseconds)
{
    delay (milliseconds);
}
uint32_t host_millis_elapsed () 
{
    return millis();
}

void loop() 
{
  if((readStatus() & 0x80) == 0)
  {
    if (device_interrupt(&workarea,MONITOR_MODE)==MONITOR_EXIT_BASIC)
      host_basic_interpreter ();
  }
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
  digitalWrite (ledPin, LEDLOW);

  // reset global variables
  device_reset (&workarea);

  // initialize USB device
  bDeviceOk = device_init ();
  if (bDeviceOk)
  {
      printf ("CH376s recognised\r\n");
  }
  else
  {
      printf ("CH376s not inserted\r\n");
      while (true);
  }
}

