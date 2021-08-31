
#include "build-msx/MSX/BIOS/msxbios.h"
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "screen_msx.h"

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

void set_screen0()
{
    __asm
    INITTXT .equ #0x6c
    call INITTXT
    __endasm;
}

void writeCharV (uint8_t character) __z88dk_fastcall
{
    __asm
    ld a,l
    push af
    ; address 0x00 0x0000
    ld hl, #39 ; right top colum
    xor a
    rlc h
    rla
    rlc h
    rla
    srl h
    srl h
    di
    out (#0x99),a
    ld a,#14 + #128
    out (#0x99),a
    ld a,l
    nop
    out (#0x99),a
    ld a,h
    or #64
    ei
    out (#0x99),a
    ; write character
    pop af
    out (#0x98),a
    ret
    __endasm;
}
void sendBufferV (char* buffer,uint16_t length)
{
    while (length--)
        writeCharV (*(buffer++));
}

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
void print(const char* msg) 
{
	_print(msg);
    msx_enable_interrupt ();
	return;
}

/*
void print_address (uint16_t address)
{
    convertToStr (address>>8,szAddress);
    convertToStr (address&0xff,szAddress+2);
    print (szAddress);
    print ("\r\n");
}
*/
