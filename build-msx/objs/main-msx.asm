;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.0.3 #11868 (Mac OS X x86_64)
;--------------------------------------------------------
	.module main_msx
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _onDeviceMON_IO
	.globl _onDeviceMON_getId
	.globl _onCallMONITOR
	.globl _main
	.globl _print
	.globl _msx_disable_interrupt
	.globl _msx_enable_interrupt
	.globl __print
	.globl _handleInterrupt
	.globl _initDevice
	.globl _bDeviceOk
	.globl _writeCommand
	.globl _writeData
	.globl _readData
	.globl _readStatus
	.globl _host_reset
	.globl _host_basic_interpreter
	.globl _host_go
	.globl _host_writeByte
	.globl _host_readByte
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
_bDeviceOk::
	.ds 1
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area _DABS (ABS)
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area _HOME
	.area _GSINIT
	.area _GSFINAL
	.area _GSINIT
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE
;main-msx.c:13: void _print(const char* msg) {
;	---------------------------------
; Function _print
; ---------------------------------
__print::
;main-msx.c:35: __endasm;
	ld	hl, #2; retrieve address from stack
	add	hl, sp
	ld	b, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, b
	  _printMSG_loop	:
	ld	a, (hl); print
	or	a
	ret	z
	push	hl
	push	ix
	ld	iy, (#0xfcc0)
	ld	ix, #0x00a2
	call	#0x001c
	pop	ix
	pop	hl
	inc	hl
	jr	_printMSG_loop
;main-msx.c:37: return;
;main-msx.c:38: }
	ret
;main-msx.c:40: void writeCommand (uint8_t data) __z88dk_fastcall __naked
;	---------------------------------
; Function writeCommand
; ---------------------------------
_writeCommand::
;main-msx.c:46: __endasm;
	ld	a, l
	out	(#0x11),a
	ret
;main-msx.c:47: }
;main-msx.c:48: void writeData (uint8_t data) __z88dk_fastcall __naked
;	---------------------------------
; Function writeData
; ---------------------------------
_writeData::
;main-msx.c:54: __endasm;
	ld	a, l
	out	(#0x10),a
	ret
;main-msx.c:55: }
;main-msx.c:56: uint8_t readData () __naked
;	---------------------------------
; Function readData
; ---------------------------------
_readData::
;main-msx.c:62: __endasm;
	in	a, (#0x10)
	ld	l, a
	ret
;main-msx.c:63: }
;main-msx.c:64: uint8_t readStatus () __naked
;	---------------------------------
; Function readStatus
; ---------------------------------
_readStatus::
;main-msx.c:70: __endasm;
	in	a, (#0x11)
	ld	l, a
	ret
;main-msx.c:71: }
;main-msx.c:77: void msx_enable_interrupt () __naked
;	---------------------------------
; Function msx_enable_interrupt
; ---------------------------------
_msx_enable_interrupt::
;main-msx.c:82: __endasm;
	ei
	ret
;main-msx.c:83: }
;main-msx.c:84: void msx_disable_interrupt () __naked
;	---------------------------------
; Function msx_disable_interrupt
; ---------------------------------
_msx_disable_interrupt::
;main-msx.c:89: __endasm;
	di
	ret
;main-msx.c:90: }
;main-msx.c:96: void print(const char* msg) {
;	---------------------------------
; Function print
; ---------------------------------
_print::
;main-msx.c:97: _print(msg);
	pop	bc
	pop	hl
	push	hl
	push	bc
	push	hl
	call	__print
	pop	af
;main-msx.c:98: msx_enable_interrupt ();
;main-msx.c:99: return;
;main-msx.c:100: }
	jp	_msx_enable_interrupt
;main-msx.c:103: void host_reset () __naked
;	---------------------------------
; Function host_reset
; ---------------------------------
_host_reset::
;main-msx.c:107: __endasm;
	jp	0
;main-msx.c:108: }
;main-msx.c:109: void host_basic_interpreter ()
;	---------------------------------
; Function host_basic_interpreter
; ---------------------------------
_host_basic_interpreter::
;main-msx.c:112: bDeviceOk = false;
	ld	hl, #_bDeviceOk
	ld	(hl), #0x00
;main-msx.c:113: }
	ret
;main-msx.c:114: void host_go (uint16_t address) __z88dk_fastcall __naked
;	---------------------------------
; Function host_go
; ---------------------------------
_host_go::
;main-msx.c:119: __endasm;
	push	hl
	ret
;main-msx.c:120: }
;main-msx.c:121: void host_writeByte (uint16_t address, uint8_t value) __naked
;	---------------------------------
; Function host_writeByte
; ---------------------------------
_host_writeByte::
;main-msx.c:134: __endasm;
	ld	iy, #2
	add	iy, sp
	ld	l,(iy) ; retrieve [address] from stack
	ld	h,1(iy)
	ld	a,2(iy) ; retrieve [value] from stack
	ld	(hl),a ; write to memory
	ret
;main-msx.c:135: }
;main-msx.c:136: uint8_t host_readByte (uint16_t address) __z88dk_fastcall __naked
;	---------------------------------
; Function host_readByte
; ---------------------------------
_host_readByte::
;main-msx.c:142: __endasm;
	ld	a, (hl)
	ld	l, a
	ret
;main-msx.c:143: }
;main-msx.c:145: void main (void)
;	---------------------------------
; Function main
; ---------------------------------
_main::
;main-msx.c:148: print ("MSXUSB v0.1 serial monitor\r\n");
	ld	hl, #___str_0
	push	hl
	call	_print
;main-msx.c:149: print ("GNU General Public License\r\n");
	ld	hl, #___str_1
	ex	(sp),hl
	call	_print
;main-msx.c:150: print ("(c) Sourceror\r\n");
	ld	hl, #___str_2
	ex	(sp),hl
	call	_print
;main-msx.c:151: print ("-----------------------------\r\n");
	ld	hl, #___str_3
	ex	(sp),hl
	call	_print
	pop	af
;main-msx.c:154: bDeviceOk = initDevice ();
	call	_initDevice
	ld	a, l
	ld	(_bDeviceOk+0), a
;main-msx.c:155: if (bDeviceOk)
	ld	hl, #_bDeviceOk
	bit	0, (hl)
	jr	Z, 00102$
;main-msx.c:157: print ("+CH376s recognised\r\n");
	ld	hl, #___str_4
	push	hl
	call	_print
;main-msx.c:158: print ("+Connect to your serial port\r\n");
	ld	hl, #___str_5
	ex	(sp),hl
	call	_print
;main-msx.c:159: print (" and type H for help\r\n\r\n");
	ld	hl, #___str_6
	ex	(sp),hl
	call	_print
	pop	af
	jr	00106$
00102$:
;main-msx.c:163: print ("-CH376s not inserted\r\n");
	ld	hl, #___str_7
	push	hl
	call	_print
	pop	af
;main-msx.c:164: return;
	ret
;main-msx.c:167: while (bDeviceOk)
00106$:
	ld	hl, #_bDeviceOk
	bit	0, (hl)
	ret	Z
;main-msx.c:169: if((readStatus() & 0x80) == 0) 
	call	_readStatus
	ld	a, l
	rlca
	jr	C, 00106$
;main-msx.c:170: handleInterrupt(); 
	call	_handleInterrupt
;main-msx.c:173: return;
;main-msx.c:174: }
	jr	00106$
___str_0:
	.ascii "MSXUSB v0.1 serial monitor"
	.db 0x0d
	.db 0x0a
	.db 0x00
___str_1:
	.ascii "GNU General Public License"
	.db 0x0d
	.db 0x0a
	.db 0x00
___str_2:
	.ascii "(c) Sourceror"
	.db 0x0d
	.db 0x0a
	.db 0x00
___str_3:
	.ascii "-----------------------------"
	.db 0x0d
	.db 0x0a
	.db 0x00
___str_4:
	.ascii "+CH376s recognised"
	.db 0x0d
	.db 0x0a
	.db 0x00
___str_5:
	.ascii "+Connect to your serial port"
	.db 0x0d
	.db 0x0a
	.db 0x00
___str_6:
	.ascii " and type H for help"
	.db 0x0d
	.db 0x0a
	.db 0x0d
	.db 0x0a
	.db 0x00
___str_7:
	.ascii "-CH376s not inserted"
	.db 0x0d
	.db 0x0a
	.db 0x00
;main-msx.c:187: char* onCallMONITOR(char* param) {
;	---------------------------------
; Function onCallMONITOR
; ---------------------------------
_onCallMONITOR::
;main-msx.c:188: print("CALL MONITOR\r\n\0");
	ld	hl, #___str_8
	push	hl
	call	_print
	pop	af
;main-msx.c:190: while ((*param != 0) && (*param != 0x3a)) {
	pop	bc
	pop	hl
	push	hl
	push	bc
00102$:
	ld	a, (hl)
	or	a, a
	ret	Z
	sub	a, #0x3a
	ret	Z
;main-msx.c:191: param++;
	inc	hl
;main-msx.c:194: return param;
;main-msx.c:195: }
	jr	00102$
___str_8:
	.ascii "CALL MONITOR"
	.db 0x0d
	.db 0x0a
	.db 0x00
	.db 0x00
;main-msx.c:208: char onDeviceMON_getId() {
;	---------------------------------
; Function onDeviceMON_getId
; ---------------------------------
_onDeviceMON_getId::
;main-msx.c:209: print("The C handler for MON_getId says hi!\r\n\0");
	ld	hl, #___str_9
	push	hl
	call	_print
	pop	af
;main-msx.c:210: return 0; // we're the first device so we return 0
	ld	l, #0x00
;main-msx.c:211: }
	ret
___str_9:
	.ascii "The C handler for MON_getId says hi!"
	.db 0x0d
	.db 0x0a
	.db 0x00
	.db 0x00
;main-msx.c:224: void onDeviceMON_IO(char cmd,char* param) {
;	---------------------------------
; Function onDeviceMON_IO
; ---------------------------------
_onDeviceMON_IO::
	push	ix
	ld	ix,#0
	add	ix,sp
;main-msx.c:225: switch (cmd)
	ld	a, 4 (ix)
	or	a, a
	jr	Z, 00101$
	ld	a, 4 (ix)
	sub	a, #0x02
	jr	Z, 00102$
	ld	a, 4 (ix)
	sub	a, #0x04
	jr	Z, 00103$
	ld	a, 4 (ix)
	sub	a, #0x06
	jr	Z, 00104$
	ld	a, 4 (ix)
	sub	a, #0x08
	jr	Z, 00105$
	ld	a, 4 (ix)
	sub	a, #0x0a
	jr	Z, 00106$
	ld	a, 4 (ix)
	sub	a, #0x0c
	jr	Z, 00107$
	ld	a, 4 (ix)
	sub	a, #0x0e
	jr	Z, 00108$
	ld	a, 4 (ix)
	sub	a, #0x10
	jr	Z, 00109$
	ld	a, 4 (ix)
	sub	a, #0x12
	jr	Z, 00110$
	ld	a, 4 (ix)
	inc	a
	jr	Z, 00111$
	jr	00112$
;main-msx.c:227: case 0: print ("OPEN\r\n");break;
00101$:
	ld	hl, #___str_10
	push	hl
	call	_print
	pop	af
	jr	00113$
;main-msx.c:228: case 2: print ("CLOSE\r\n");break;
00102$:
	ld	hl, #___str_11
	push	hl
	call	_print
	pop	af
	jr	00113$
;main-msx.c:229: case 4: print ("RANDOM ACCESS\r\n");break;
00103$:
	ld	hl, #___str_12
	push	hl
	call	_print
	pop	af
	jr	00113$
;main-msx.c:230: case 6: print ("SEQ OUTPUT\r\n");break;
00104$:
	ld	hl, #___str_13
	push	hl
	call	_print
	pop	af
	jr	00113$
;main-msx.c:231: case 8: print ("SEQ INPUT\r\n");break;
00105$:
	ld	hl, #___str_14
	push	hl
	call	_print
	pop	af
	jr	00113$
;main-msx.c:232: case 10: print ("LOC\r\n");break;
00106$:
	ld	hl, #___str_15
	push	hl
	call	_print
	pop	af
	jr	00113$
;main-msx.c:233: case 12: print ("LOF\r\n");break;
00107$:
	ld	hl, #___str_16
	push	hl
	call	_print
	pop	af
	jr	00113$
;main-msx.c:234: case 14: print ("EOF\r\n");break;
00108$:
	ld	hl, #___str_17
	push	hl
	call	_print
	pop	af
	jr	00113$
;main-msx.c:235: case 16: print ("FPOS\r\n");break;
00109$:
	ld	hl, #___str_18
	push	hl
	call	_print
	pop	af
	jr	00113$
;main-msx.c:236: case 18: print ("BACKUP\r\n");break;
00110$:
	ld	hl, #___str_19
	push	hl
	call	_print
	pop	af
	jr	00113$
;main-msx.c:237: case 255: print ("INQUIRE\r\n");break;
00111$:
	ld	hl, #___str_20
	push	hl
	call	_print
	pop	af
	jr	00113$
;main-msx.c:238: default: print ("UNKNOWN\r\n");break;
00112$:
	ld	hl, #___str_21
	push	hl
	call	_print
	pop	af
;main-msx.c:239: }
00113$:
;main-msx.c:240: print("The C handler for MON_IO says hi!\r\n\0");
	ld	hl, #___str_22
	push	hl
	call	_print
	pop	af
;main-msx.c:241: }
	pop	ix
	ret
___str_10:
	.ascii "OPEN"
	.db 0x0d
	.db 0x0a
	.db 0x00
___str_11:
	.ascii "CLOSE"
	.db 0x0d
	.db 0x0a
	.db 0x00
___str_12:
	.ascii "RANDOM ACCESS"
	.db 0x0d
	.db 0x0a
	.db 0x00
___str_13:
	.ascii "SEQ OUTPUT"
	.db 0x0d
	.db 0x0a
	.db 0x00
___str_14:
	.ascii "SEQ INPUT"
	.db 0x0d
	.db 0x0a
	.db 0x00
___str_15:
	.ascii "LOC"
	.db 0x0d
	.db 0x0a
	.db 0x00
___str_16:
	.ascii "LOF"
	.db 0x0d
	.db 0x0a
	.db 0x00
___str_17:
	.ascii "EOF"
	.db 0x0d
	.db 0x0a
	.db 0x00
___str_18:
	.ascii "FPOS"
	.db 0x0d
	.db 0x0a
	.db 0x00
___str_19:
	.ascii "BACKUP"
	.db 0x0d
	.db 0x0a
	.db 0x00
___str_20:
	.ascii "INQUIRE"
	.db 0x0d
	.db 0x0a
	.db 0x00
___str_21:
	.ascii "UNKNOWN"
	.db 0x0d
	.db 0x0a
	.db 0x00
___str_22:
	.ascii "The C handler for MON_IO says hi!"
	.db 0x0d
	.db 0x0a
	.db 0x00
	.db 0x00
	.area _CODE
	.area _INITIALIZER
__xinit__bDeviceOk:
	.db #0x00	;  0
	.area _CABS (ABS)
