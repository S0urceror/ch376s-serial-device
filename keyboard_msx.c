#include "build-msx/MSX/BIOS/msxbios.h"
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>

#include "keyboard_msx.h"
#pragma disable_warning 85	// because parameters not used in C context

uint8_t read_keyboard_matrix (uint8_t row) __z88dk_fastcall __naked
{
    __asm
    ld c,l
    in a,(#0xAA)
    and #0xF0
    or c
    out (#0xAA),a
    in a,(#0xA9)
    ld l,a
    ret
    __endasm;
}

uint8_t pressed_ESC()
{
    return (read_keyboard_matrix(7)&0b00000100)==0;
}