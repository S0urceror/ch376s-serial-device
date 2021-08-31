#ifndef __KEYBOARD_MSX_H
#define __KEYBOARD_MSX_H

uint8_t read_keyboard_matrix (uint8_t row) __z88dk_fastcall __naked;
uint8_t pressed_ESC();

#endif // __KEYBOARD_MSX_H