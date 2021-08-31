#include "build-msx/MSX/BIOS/msxbios.h"
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "host.h"
#include "workarea.h"
#include "hooks_msx.h"

#include "workarea_msx.h"
#include "keyboard_msx.h"
#include "filesystem_msx.h"
#include "screen_msx.h"
#include "device.h"

#pragma disable_warning 85

#ifndef ROOKIEDRIVE
    #define CMD_PORT 0x11
    #define DATA_PORT 0x10
#else
    #define CMD_PORT 0x21
    #define DATA_PORT 0x20
#endif

WORKAREA bootup_workarea;
const char MSG_MSXUSB[] = "MSXUSB Terminal version 0.5\r\n";
const char MSG_LICENSE[] = "GNU General Public License\r\n(c) Sourceror\r\n\r\n";

///////////////////////////////////////////////////
// MSXUSB

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

// MSXUSB
///////////////////////////////////////////////////

///////////////////////////////////////////////////
// HOST requests send to serial device

void host_reset () __naked
{
    __asm
        jp 0
    __endasm;
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

void host_putchar (uint8_t character) __z88dk_fastcall __naked
{
    __asm
    ld a, l
    cp #0x14    ; CTRL-T is CTRL-STOP
    jr z, CTRLSTOP
    cp #0x0F    ; CTRL-O is STOP
    jr z, STOP
    jr C0F55
STOP:
    ld a, #4
    ld (#BIOS_INTFLG),a
    ret
CTRLSTOP:
    ld a, #3
    ld (#BIOS_INTFLG),a
    ret

;	Subroutine	put keycode in keyboardbuffer
;	Inputs		A = keycode
;	Outputs		________________________
;	Remark		entrypoint compatible among keyboard layout versions
C0F55:
	LD	HL,(#BIOS_PUTPNT)
	LD	(HL),A			; put in keyboardbuffer
	CALL	C10C2		; next postition in keyboardbuffer with roundtrip
	LD	A,(#BIOS_GETPNT)
	CP	L			    ; keyboard buffer full ?
	RET	Z			    ; yep, quit
	LD	(#BIOS_PUTPNT),HL		; update put pointer
    RET

;	Subroutine	increase keyboardbuffer pointer
;	Inputs		________________________
;	Outputs		________________________
C10C2:
	INC	HL			    ; increase pointer
	LD	A,L
	CP	#BIOS_KEYBUF+40
	RET	NZ			    ; not the end of buffer, quit
	LD	HL,#BIOS_KEYBUF		; wrap around to start of buffer
	RET

    __endasm;
}

void host_save (uint16_t address, uint16_t size, char* in_filename)
{
    memsave (address, size, in_filename);
}
void host_load (uint16_t address, char* in_filename)
{
    memload (address,in_filename);
}

void host_delay (int milliseconds)
{
    msx_wait (milliseconds/20);
}

uint32_t host_millis_elapsed () 
{
    __at BIOS_JIFFY static uint16_t FRAME_COUNTER;
    return FRAME_COUNTER*20;
}

// HOST requests send to serial device
///////////////////////////////////////////////////


///////////////////////////////////////////////////
// new hooks

uint8_t getRegA () __z88dk_fastcall __naked
{
    __asm
    ld l,a
    ret
    __endasm;
}

void new_chput () __z88dk_fastcall 
{
    uint8_t regA = getRegA ();
    WORKAREA* chput = get_workarea ();
    if (chput->pos_in_char_buffer<(chput->char_buffer+sizeof(((WORKAREA*)0)->char_buffer)))
        *(chput->pos_in_char_buffer++)=regA;
}

void new_chget ()
{
    __asm
        ; we can destroy HL, DE, BC, AF
        
        ; check or wait for something in the buffer
        ; ---------------------------------------------------
        CALL    BIOS_CHSNS      ; CHSNS - Tests the status of the keyboard buffer
        JR      NZ, SKIP_WAIT

        ; DANGEROUS, dont want to directly call into BIOS but it works, checked on MSX1,2,2+,TR. Alternative is to copy these functions
        LD      HL, #0x002d     ; check MSX version (1=0, 2,2+,TR > 0)
        LD      A, (HL)
        AND     A
        CALL    NZ,0x0A37       ; MSX 2 - Display cursor when disabled, store contents under cursor
        CALL    Z,0x09DA        ; MSX 1
CHECK_AGAIN:
        CALL    BIOS_CHSNS      ; CHSNS - Tests the status of the keyboard buffer
        JR      Z, CHECK_AGAIN  ; Nothing? Check again

        ; DANGEROUS
        LD      HL, #0x002d     ; check MSX version (1=0, 2,2+,TR > 0)
        LD      A, (HL)
        AND     A
        CALL    NZ,0x0A84       ; Remove cursor when disabled, restore previous contents back to screen
        CALL    Z,0x0A27        ; MSX 1
SKIP_WAIT:
        ; read the value, leave it in the buffer for CHGET upon return
        ; ---------------------------------------------------
        LD      HL,(#BIOS_GETPNT)
        LD      A,(HL)
        ; is it of interest?
        CP      #0x08             ; backspace
        JR      Z, HANDLE_BACKSPACE
        CP      #0x7F             ; handle delete
        JR      Z, HANDLE_DELETE
        ; return
        RET
HANDLE_BACKSPACE:
        JP    _new_chput        ; add it to the send buffer
HANDLE_DELETE:
        JP    _new_chput        ; add it to the send buffer
    __endasm;
}

void jump_address (void* address) __z88dk_fastcall __naked
{
    __asm
    jp (hl)
    __endasm;
}

void new_timi ()
{
    WORKAREA* wrk = get_workarea ();
    if (wrk->pos_in_char_buffer!=wrk->char_buffer)
    {
        device_send (wrk,wrk->char_buffer,wrk->pos_in_char_buffer-wrk->char_buffer);
        wrk->pos_in_char_buffer = wrk->char_buffer;
    }
    if((readStatus() & 0x80) == 0) 
        device_interrupt(wrk,TERMINAL_MODE); 

    jump_address (&(wrk->HTIMI_original));
}

// new hooks
///////////////////////////////////////////////////

bool init_serial_device (WORKAREA* wrk)
{
    device_reset (wrk);
    // initialize USB device
    if (device_init ())
    {
        print ("+CH376s recognised\r\n");
        print ("+Connect MSX to PC via USB\r\n");
        return true;
    }
    else
    {
        print ("-CH376s not inserted\r\n");
        return false;
    }
}

void hook_terminal (WORKAREA* wrk)
{
    // slower processing via HTIMI hook
    // plus start terminal function via HCHPU
    hook((HOOK*) HTIMI,&(wrk->HTIMI_original),(uint16_t*) &new_timi);
    hook((HOOK*) HCHPU,&(wrk->HCHPU_original),(uint16_t*) &new_chput);
    hook((HOOK*) HCHGE,&(wrk->HCHGE_original),(uint16_t*) &new_chget);
}

void unhook_terminal (WORKAREA* wrk)
{
    unhook ((HOOK*) HTIMI,&(get_workarea ()->HTIMI_original));
    unhook ((HOOK*) HCHPU,&(get_workarea ()->HCHPU_original));
    unhook ((HOOK*) HCHGE,&(get_workarea ()->HCHGE_original));
}

void run_serial_terminal()
{
    WORKAREA* wrk = get_workarea ();
    
    // fast processing until serial is connected
    while (true)
    {
        if((readStatus() & 0x80) == 0) 
        {
            INTERRUPT_RESULT intres = device_interrupt(wrk,TERMINAL_MODE);
            if (intres==DEVICE_CONFIGURATION_SET)
                print ("+Start Terminal program\r\n"); 
            if (intres==DEVICE_SERIAL_CONNECTED)
                break;
        }
    }
    // do further processing via HTIMI
    hook_terminal (wrk);
}

void run_serial_monitor()
{
    WORKAREA* wrk = get_workarea ();
    unhook_terminal (wrk);

    print ("+Use Monitor from host PC\r\n");
    print ("+H for Help\r\n");
    print ("+B to go back to BASIC\r\n");

    // reset monitor device
    device_monitor_reset ();
    device_send_welcome (wrk);

    // fast processing until serial is connected
    while (true)
    {
        if((readStatus() & 0x80) == 0) 
        {
            if (device_interrupt(wrk,MONITOR_MODE)==MONITOR_EXIT_BASIC)
                break; 
        }
    }



    // do further interrupt handling via HTIMI
    hook_terminal (wrk);
}

// executed at start of BASIC at H.CLEA(r)
void basic_start ()
{
    __asm
    push ix
    push iy
    push hl             ; save BASIC pointer
    push de
    push bc
    push af
    __endasm;

    // reset CLEAR hook to original value
    unhook ((HOOK*) HCLEA,&(bootup_workarea.HCLEA_original));
    // start the terminal
    print (MSG_MSXUSB);
    // allocate TSR memory
    allocate_workarea (sizeof (WORKAREA));
    // initialize
    init_workarea();
    
    if (init_serial_device (get_workarea()))
        run_serial_terminal();

    __asm
    pop af
    pop bc
    pop de
    pop hl ; restore BASIC pointer
    pop iy
    pop ix
    __endasm;
}

// only run with very old diskrom's, newer diskroms do this themselves and replace this
__at BIOS_H_PHYD uint8_t h_phyd;
__at BIOS_HIMEM uint16_t himem;
__at BDOS_HIMSAV uint16_t himsav;
void initialize_himsav ()
{
    __asm
    push hl             ; save BASIC pointer
    push de
    push bc
    __endasm;

    unhook ((HOOK*) HLOPD,&(bootup_workarea.HLOPD_original));
    if (h_phyd!=0xc9)
    {
        print ("hello");
        himsav = himem;
    }

    __asm
    pop bc
    pop de
    pop hl
    __endasm;
}


void main (void)
{
    print (MSG_MSXUSB);
    print (MSG_LICENSE);
    
    // hook initialisation interrupts to be able to allocate our workarea
    hook((HOOK*) HCLEA,&(bootup_workarea.HCLEA_original),(uint16_t*) &basic_start);
    hook((HOOK*) HLOPD,&(bootup_workarea.HLOPD_original),(uint16_t*) &initialize_himsav);

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
    // seek end of command (0x00/EoL or 0x3a/":")
	while ((*param != 0) && (*param != 0x3a)) 
		param++;

    run_serial_monitor ();

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