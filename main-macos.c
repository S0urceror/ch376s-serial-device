// USB-DEVICE - application that discovers attached USB devices to CH376s
// Copyright 2019 - Sourceror (Mario Smit)

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

#include <stdlib.h>
#include <stdbool.h>
#include <stdio.h>
#include <termios.h>
#include <fcntl.h>
#include <sys/time.h>
#include <strings.h>
#include <unistd.h>
#include <assert.h>

#include "host.h"
#include "workarea.h"
#include "device.h"
#include "ch376s.h"

WORKAREA workarea;

//#define   B115200 0010002
//#define   B230400 0010003
#define   B460800 0010004
#define   B500000 0010005
#define   B576000 0010006
#define   B921600 0010007
#define  B1000000 0010010
#define  B1152000 0010011
#define  B1500000 0010012
#define  B2000000 0010013
#define  B2500000 0010014
#define  B3000000 0010015
#define  B3500000 0010016
#define  B4000000 0010017
#define BAUDRATE B115200
int serial=-1;

bool VERBOSE=1;
void print_buffer (uint8_t* data, uint16_t length)
{
    if (VERBOSE==0)
        return;

    for (int i=0;i<length;i++)
    {
        if ((i%16)==0)
            printf ("\n");
        if ((i%4)==0)
            printf (" ");
        printf ("%02x ",*(data+i));
    }
    printf ("\n");
}

void error (char const * msg)
{
    printf ("ERROR: %s\n",msg);
    exit(0);
}

void init_serial ()
{
    const char device[] = "/dev/tty.usbmodem123451";
    serial = open(device, O_RDWR | O_NOCTTY | O_NONBLOCK);
    if(serial == -1)
      error( "failed to open port" );
    if(!isatty(serial))
      error( "not serial" );
    fcntl(serial, F_SETFL, 0);
    
    struct termios  config;
    bzero(&config, sizeof(config));
    config.c_cflag |= CS8 | CLOCAL | CREAD;
    config.c_iflag |= IGNPAR;
    cfsetispeed (&config, B230400);
    cfsetospeed (&config, B230400);
     
    config.c_cc[VTIME]    = 1;   /* wait 0.1 * VTIME on new characters to arrive when blocking */
    config.c_cc[VMIN]     = 1;   /* blocking read until 1 chars received */
    
    tcflush(serial, TCIFLUSH);
    tcsetattr(serial, TCSANOW, &config); 
}

// LOW_LEVEL serial communication to CH376
///////////////////////////////////////////////////////////////////////////
const uint8_t WR_COMMAND = 1;
const uint8_t RD_STATUS = 2;
const uint8_t WR_DATA = 3;
const uint8_t RD_DATA = 4;
const uint8_t RD_INT = 5;
const uint8_t RD_DATA_MULTIPLE = 6;
const uint8_t WR_DATA_MULTIPLE = 7;
const uint8_t DATA_DUMP = 10;
const uint8_t ROUNDTRIP = 11;
const uint8_t WAITSTATUS = 12;

struct timeval pvtime, crtime,wsprevtime, wscurtime;
void roundtrip ()
{
    uint8_t cmd[] = {ROUNDTRIP,0x41};
    uint8_t new_value;

    gettimeofday(&crtime, NULL);
    write (serial,cmd,sizeof(cmd));
    read (serial,&new_value,1);

    unsigned long nsecs = (crtime.tv_sec - pvtime.tv_sec) * 1000000 + (crtime.tv_usec - pvtime.tv_usec);
    pvtime = crtime;
    printf("Roundtrip: %ld nsecs\r\n", nsecs);
}

void writeCommand (uint8_t command)
{
    uint8_t cmd[] = {WR_COMMAND,command};
    write (serial,cmd,sizeof(cmd));
}
void writeData (uint8_t data)
{
    uint8_t cmd[] = {WR_DATA,data};
    write (serial,cmd,sizeof(cmd));
}
uint8_t readData ()
{
    uint8_t new_value;
    uint8_t cmd[] = {RD_DATA};
    write (serial,cmd,sizeof(cmd));
    read (serial,&new_value,1);
    return new_value;
}
uint8_t readStatus ()
{
    uint8_t new_value;
    uint8_t cmd[] = {RD_STATUS};

    //gettimeofday(&pvtime, NULL);
    write (serial,cmd,sizeof(cmd));
    read (serial,&new_value,1);

    //gettimeofday(&crtime, NULL);
    //unsigned long nsecs = (crtime.tv_sec - pvtime.tv_sec) * 1000000 + (crtime.tv_usec - pvtime.tv_usec);
    //printf("readStatus: %ld nsecs\r\n", nsecs);

    return new_value;
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
   printf ("jumping to 0x%0X\n",address);
}
void host_writeByte (uint16_t address, uint8_t value)
{
  printf ("address: 0x%04X, value: 0x%02X\n",address,value);
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
void host_load (uint16_t address, char* in_filename)
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
void host_save (uint16_t address, uint16_t size, char* in_filename)
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
    usleep (milliseconds*1000);
}
uint32_t host_millis_elapsed () 
{
    struct timeval tv;
    gettimeofday(&tv, NULL);

    unsigned long long millisecondsSinceEpoch =
        (unsigned long long)(tv.tv_sec) * 1000 +
        (unsigned long long)(tv.tv_usec) / 1000;

    return millisecondsSinceEpoch;
}

int main(int argc, const char * argv[]) 
{
    bool bDeviceOk = false;

    init_serial();
    for (int i=0;i<10;i++) roundtrip ();

    // initialize USB device
    bDeviceOk = device_init ();
    if (bDeviceOk)
    {
        writeCommand (CH_CMD_SET_REGISTER);
        writeData (0x16);
        writeData (0x90);
    }
    
    // reset global variables
    device_reset (&workarea);
    while (bDeviceOk)
    {
        if((readStatus() & 0x80) == 0) 
            device_interrupt(&workarea,MONITOR_MODE); 
    }

    return 0;
}