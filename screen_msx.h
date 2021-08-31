#ifndef __SCREEN_MSX_H
#define __SCREEN_MSX_H

#define JIFFY 50
#define SECOND JIFFY
#define MINUTE SECOND*60

void _print(const char* msg);
void set_screen0();
void writeCharV (uint8_t character) __z88dk_fastcall;
void sendBufferV (char* buffer,uint16_t length);
void msx_wait (uint16_t times_jiffy)  __z88dk_fastcall __naked;
void msx_enable_interrupt () __naked;
void msx_disable_interrupt () __naked;
void print(const char* msg);

#endif //__SCREEN_MSX_H