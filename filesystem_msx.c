#include "build-msx/MSX/BIOS/msxbios.h"
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "filesystem_msx.h"
#pragma disable_warning 85	// because parameters not used in C context

const char file_load_error[] = "File NOT loaded\r\n";
const char file_load_success[] = "File loaded\r\n";
const char file_save_error[] = "File NOT saved\r\n";
const char file_save_success[] = "File saved\r\n";

FCB_structure FCB;

void clear_fcb ()
{
    memset ((void*) FCB,0,sizeof (FCB));
}

void reset_fcb ()
{
    FCB.record_size = 1;
    FCB.current_record = 0;
}

uint16_t filesize_fcb ()
{
    return (uint16_t) FCB.file_size;
}

void prepare_fcb (char* in_filename)
{
    clear_fcb ();
    memset (FCB.filename,' ',sizeof(FCB.filename));
    char* dot = strchr ((char*) in_filename,'.');
    char* end = strchr ((char*) in_filename,'\0');
    if (dot)
    {
        memcpy (FCB.filename,(void*)in_filename,dot-in_filename);
        memcpy (FCB.filename+8,dot+1,end-dot);
    }
    else
    {
        memcpy (FCB.filename,(void*)in_filename,end-in_filename);
    }
}

void memload (uint16_t address, char* in_filename)
{
    prepare_fcb (in_filename);
    __asm
    BDOS    .equ 0xf37d
    SETDMA  .equ 0x1a
    OPEN    .equ 0x0f
    BLREAD  .equ 0x27
        ld      iy, #2
		add     iy, sp

        ; preserve IX
        push    ix
        ; preserve IX

        ; set location in memory to receive the data
        ld      e,(iy)  ; retrieve [address] from stack
        ld      d,1(iy)
        ld      c,#SETDMA
        call    BDOS
        ; open file
        ld      de, #_FCB
        ld      c, #OPEN
        call    BDOS
        and     a ; check for error
        jr      nz,__load_error ; disk error
        call    _reset_fcb
        ; read file in memory
        call    _filesize_fcb
        ld      de, #_FCB
        ld      c, #BLREAD
        call    BDOS
        and     a ; check for error
        jr      nz,__load_error ; disk error
        ; celebrate success
        ld      hl,#_file_load_success
        push    hl
        call    _print
        pop     hl
        jr      __load_end
    __load_error:
        ; disappointed
        ld      hl,#_file_load_error
        push    hl
        call    _print
        pop     hl
    __load_end:
        ; restore IX
        pop     ix
    __endasm;
}

void memsave (uint16_t address, uint16_t size, char* in_filename)
{
    prepare_fcb (in_filename);

  __asm
    BLSAVE  .equ 0x26
    BLCLOSE .equ 0x10
    CREATE  .equ 0x16
        ld      iy, #2
		add     iy, sp

        ; preserve IX
        push    ix
        ; preserve IX

        ; set location in memory where is the data
        ld      e,0(iy)  ; retrieve [address] from stack
        ld      d,1(iy)
        ld      c,#SETDMA
        push    iy
        call    BDOS
        pop     iy
        ; create file
        ld      de, #_FCB
        ld      c, #CREATE
        push    iy
        call    BDOS
        pop     iy
        and     a ; check for error
        jr nz,  __save_error ; disk error
        call    _reset_fcb
        ; write file from memory
        ld      l,2(iy) ; retrieve [size] from stack
        ld      h,3(iy)
        ld      de, #_FCB
        ld      c, #BLSAVE
        call    BDOS
        and     a ; check for error
        jr nz,  __save_error ; disk error
        ; close file to flush buffers
        ld      c, #BLCLOSE
        ld      de, #_FCB
        call    BDOS
        and     a ; check for error
        jr      nz,__save_error ; disk error
        ; celebrate success
        ld      hl,#_file_save_success
        push    hl
        call    _print
        pop     hl        
        jr      __save_end

    __save_error:
        ; disappointed
        ld      hl,#_file_save_error
        push    hl
        call    _print
        pop     hl
    __save_end:
        ; restore IX
        pop     ix

    __endasm;
}