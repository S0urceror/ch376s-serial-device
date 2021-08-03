#include "build-msx/MSX/BIOS/msxbios.h"
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include "ch376s.h"
#include "device.h"
#include <string.h>

#ifndef ROOKIEDRIVE
    #define CMD_PORT 0x11
    #define DATA_PORT 0x10
#else
    #define CMD_PORT 0x21
    #define DATA_PORT 0x20
#endif

#pragma disable_warning 85	// because the var msg is not used in C context
void _print(const char* msg) {
	__asm
		ld      hl, #2; retrieve address from stack
		add     hl, sp
		ld		b, (hl)
		inc		hl
		ld		h, (hl)
		ld		l, b

		_printMSG_loop :
		ld		a, (hl); print
		or		a
		ret z
		push	hl
		push	ix
		ld		iy, (#BIOS_ROMSLT)
		ld		ix, #BIOS_CHPUT
		call	#BIOS_CALSLT
		pop		ix
		pop		hl
		inc		hl
		jr		_printMSG_loop
	__endasm;

	return;
}

void writeCommand (uint8_t data) __z88dk_fastcall __naked
{
    __asm
    ld a, l
    out (#CMD_PORT),a
    ret
    __endasm;
}
void writeData (uint8_t data) __z88dk_fastcall __naked
{
    __asm
    ld a, l
    out (#DATA_PORT),a
    ret
    __endasm;
}
uint8_t readData () __naked
{
    __asm
    in a, (#DATA_PORT)
    ld l, a
    ret
    __endasm;
}
uint8_t readStatus () __naked
{
    __asm
    in a, (#CMD_PORT)
    ld l, a
    ret
    __endasm;
}

#define JIFFY 50
#define SECOND JIFFY
#define MINUTE SECOND*60

void msx_enable_interrupt () __naked
{
    __asm
    ei
    ret
    __endasm;
}
void msx_disable_interrupt () __naked
{
    __asm
    di
    ret
    __endasm;
}

// ----------------------------------------------------------
//	This is an example of using debug code in C.
//	This is only for the demo app.
//	You can safely remove it for your application.
void print(const char* msg) {
	_print(msg);
    msx_enable_interrupt ();
	return;
}

bool bDeviceOk = false;
void host_reset () __naked
{
    __asm
        jp 0
    __endasm;
}
void host_basic_interpreter ()
{
    // break while loop to go to return ROM and go to BASIC
    bDeviceOk = false;
}
void host_go (uint16_t address) __z88dk_fastcall __naked
{
    __asm
        push hl
        ret
    __endasm;
}
void host_writeByte (uint16_t address, uint8_t value) __naked
{
    __asm
        ld      iy, #2
		add     iy, sp

        ld      l,(iy)  ; retrieve [address] from stack
        ld      h,1(iy)

        ld      a,2(iy) ; retrieve [value] from stack
		
        ld      (hl),a  ; write to memory
        ret
    __endasm;
}
uint8_t host_readByte (uint16_t address) __z88dk_fastcall __naked
{
    __asm
        ld      a, (hl)
        ld      l, a
        ret
    __endasm;
}

void main (void)
{
    
    print ("MSXUSB v0.1 serial monitor\r\n");
    print ("GNU General Public License\r\n");
    print ("(c) Sourceror\r\n");
    print ("-----------------------------\r\n");

    // initialize USB device
    bDeviceOk = initDevice ();
    if (bDeviceOk)
    {
        print ("+CH376s recognised\r\n");
        print ("+Connect to your serial port\r\n");
        print (" and type H for help\r\n\r\n");
    }
    else
    {
        print ("-CH376s not inserted\r\n");
        return;
    }

    while (bDeviceOk)
    {
        if((readStatus() & 0x80) == 0) 
            handleInterrupt(); 
    }

    return;
}

// ----------------------------------------------------------
//	This is a CALL handler example.
//	CALL CMD1
//
//	This is only for the demo app.
//	To disable the support for BASIC's CALL statement:
//	1) Set CALL_EXPANSION to _OFF in ApplicationSettings.txt
//	To completely remove the support for BASIC's CALL statement from the project:
//	1) Set CALL_EXPANSION to _OFF in ApplicationSettings.txt
//	2) Optionally, remove/comment all CALL_STATEMENT items in ApplicationSettings.txt
//	3) Remove all onCallXXXXX functions from this file
char* onCallMONITOR(char* param) {
    print("CALL MONITOR\r\n\0");
    // seek end of command (0x00/EoL ou 0x3a/":")
	while ((*param != 0) && (*param != 0x3a)) {
		param++;
	}

	return param;
}

// ----------------------------------------------------------
//	This is a DEVICE getID handler example.
//	"DEV:"
//
//	This is only for the demo app.
//	To disable the support for BASIC's devices:
//	1) Set DEVICE_EXPANSION to _OFF in ApplicationSettings.txt
//	To completely remove the support for BASIC's devices from the project:
//	1) Set DEVICE_EXPANSION to _OFF in ApplicationSettings.txt
//	2) Optionally, remove / comment all DEVICE items in ApplicationSettings.txt
//	3) Remove all onDeviceXXXXX_getIdand onDeviceXXXXX_IO routines from this file
char onDeviceMON_getId() {
	print("The C handler for MON_getId says hi!\r\n\0");
	return 0; // we're the first device so we return 0
}

// ----------------------------------------------------------
//	This is a DEVICE IO handler example.
//	"DEV:"
//
//	This is only for the demo app.
//	To disable the support for BASIC's devices:
//	1) Set DEVICE_EXPANSION to _OFF in ApplicationSettings.txt
//	To completely remove the support for BASIC's devices from the project:
//	1) Set DEVICE_EXPANSION to _OFF in ApplicationSettings.txt
//	2) Optionally, remove / comment all DEVICE items in ApplicationSettings.txt
//	3) Remove all onDeviceXXXXX_getIdand onDeviceXXXXX_IO routines from this file
void onDeviceMON_IO(char cmd,char* param) {
    switch (cmd)
    {
        case 0: print ("OPEN\r\n");break;
        case 2: print ("CLOSE\r\n");break;
        case 4: print ("RANDOM ACCESS\r\n");break;
        case 6: print ("SEQ OUTPUT\r\n");break;
        case 8: print ("SEQ INPUT\r\n");break;
        case 10: print ("LOC\r\n");break;
        case 12: print ("LOF\r\n");break;
        case 14: print ("EOF\r\n");break;
        case 16: print ("FPOS\r\n");break;
        case 18: print ("BACKUP\r\n");break;
        case 255: print ("INQUIRE\r\n");break;
        default: print ("UNKNOWN\r\n");break;
    }
	print("The C handler for MON_IO says hi!\r\n\0");
}