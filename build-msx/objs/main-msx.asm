;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.1.0 #12072 (Mac OS X x86_64)
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
	.globl _initialize_himsav
	.globl _basic_start
	.globl _run_serial_monitor
	.globl _run_serial_terminal
	.globl _unhook_terminal
	.globl _hook_terminal
	.globl _init_serial_device
	.globl _new_timi
	.globl _jump_address
	.globl _new_chget
	.globl _new_chput
	.globl _getRegA
	.globl _device_send_welcome
	.globl _device_send
	.globl _device_monitor_reset
	.globl _device_reset
	.globl _device_interrupt
	.globl _device_init
	.globl _print
	.globl _msx_wait
	.globl _memsave
	.globl _memload
	.globl _get_workarea
	.globl _init_workarea
	.globl _allocate_workarea
	.globl _unhook
	.globl _hook
	.globl _himsav
	.globl _himem
	.globl _h_phyd
	.globl _bootup_workarea
	.globl _HLOPD
	.globl _HSTKE
	.globl _HCLEA
	.globl _HTIMI
	.globl _HCHGE
	.globl _HCHPU
	.globl _MSG_LICENSE
	.globl _MSG_MSXUSB
	.globl _writeCommand
	.globl _writeData
	.globl _readData
	.globl _readStatus
	.globl _host_reset
	.globl _host_go
	.globl _host_writeByte
	.globl _host_readByte
	.globl _host_putchar
	.globl _host_save
	.globl _host_load
	.globl _host_delay
	.globl _host_millis_elapsed
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_HCHPU	=	0xfda4
_HCHGE	=	0xfdc2
_HTIMI	=	0xfd9f
_HCLEA	=	0xfed0
_HSTKE	=	0xfeda
_HLOPD	=	0xfed5
_bootup_workarea::
	.ds 81
_host_millis_elapsed_FRAME_COUNTER_65536_100	=	0xfc9e
_h_phyd	=	0xffa7
_himem	=	0xfc4a
_himsav	=	0xf349
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
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
;main-msx.c:34: void writeCommand (uint8_t data) __z88dk_fastcall __naked
;	---------------------------------
; Function writeCommand
; ---------------------------------
_writeCommand::
;main-msx.c:40: __endasm;
	ld	a, l
	out	(#0x11),a
	ret
;main-msx.c:41: }
;main-msx.c:42: void writeData (uint8_t data) __z88dk_fastcall __naked
;	---------------------------------
; Function writeData
; ---------------------------------
_writeData::
;main-msx.c:48: __endasm;
	ld	a, l
	out	(#0x10),a
	ret
;main-msx.c:49: }
;main-msx.c:50: uint8_t readData () __naked
;	---------------------------------
; Function readData
; ---------------------------------
_readData::
;main-msx.c:56: __endasm;
	in	a, (#0x10)
	ld	l, a
	ret
;main-msx.c:57: }
;main-msx.c:58: uint8_t readStatus () __naked
;	---------------------------------
; Function readStatus
; ---------------------------------
_readStatus::
;main-msx.c:64: __endasm;
	in	a, (#0x11)
	ld	l, a
	ret
;main-msx.c:65: }
;main-msx.c:73: void host_reset () __naked
;	---------------------------------
; Function host_reset
; ---------------------------------
_host_reset::
;main-msx.c:77: __endasm;
	jp	0
;main-msx.c:78: }
;main-msx.c:80: void host_go (uint16_t address) __z88dk_fastcall __naked
;	---------------------------------
; Function host_go
; ---------------------------------
_host_go::
;main-msx.c:85: __endasm;
	push	hl
	ret
;main-msx.c:86: }
;main-msx.c:88: void host_writeByte (uint16_t address, uint8_t value) __naked
;	---------------------------------
; Function host_writeByte
; ---------------------------------
_host_writeByte::
;main-msx.c:101: __endasm;
	ld	iy, #2
	add	iy, sp
	ld	l,(iy) ; retrieve [address] from stack
	ld	h,1(iy)
	ld	a,2(iy) ; retrieve [value] from stack
	ld	(hl),a ; write to memory
	ret
;main-msx.c:102: }
;main-msx.c:104: uint8_t host_readByte (uint16_t address) __z88dk_fastcall __naked
;	---------------------------------
; Function host_readByte
; ---------------------------------
_host_readByte::
;main-msx.c:110: __endasm;
	ld	a, (hl)
	ld	l, a
	ret
;main-msx.c:111: }
;main-msx.c:113: void host_putchar (uint8_t character) __z88dk_fastcall __naked
;	---------------------------------
; Function host_putchar
; ---------------------------------
_host_putchar::
;main-msx.c:156: __endasm;
	ld	a, l
	cp	#0x14 ; CTRL-T is CTRL-STOP
	jr	z, CTRLSTOP
	cp	#0x0F ; CTRL-O is STOP
	jr	z, STOP
	jr	C0F55
	STOP:
	ld	a, #4
	ld	(#0xfc9b),a
	ret
	CTRLSTOP:
	ld	a, #3
	ld	(#0xfc9b),a
	ret
;	Subroutine put keycode in keyboardbuffer
;	Inputs A = keycode
;	Outputs ________________________
;	Remark entrypoint compatible among keyboard layout versions
	C0F55:
	LD	HL,(#0xf3f8)
	LD	(HL),A ; put in keyboardbuffer
	CALL	C10C2 ; next postition in keyboardbuffer with roundtrip
	LD	A,(#0xf3fa)
	CP	L ; keyboard buffer full ?
	RET	Z ; yep, quit
	LD	(#0xf3f8),HL ; update put pointer
	RET
;	Subroutine increase keyboardbuffer pointer
;	Inputs ________________________
;	Outputs ________________________
	C10C2:
	INC	HL ; increase pointer
	LD	A,L
	CP	#0xfbf0 +40
	RET	NZ ; not the end of buffer, quit
	LD	HL,#0xfbf0 ; wrap around to start of buffer
	RET
;main-msx.c:157: }
;main-msx.c:159: void host_save (uint16_t address, uint16_t size, char* in_filename)
;	---------------------------------
; Function host_save
; ---------------------------------
_host_save::
;main-msx.c:161: memsave (address, size, in_filename);
	ld	iy, #6
	add	iy, sp
	ld	l, 0 (iy)
	ld	h, 1 (iy)
	push	hl
	ld	l, -2 (iy)
	ld	h, -1 (iy)
	dec	iy
	dec	iy
	push	hl
	ld	l, -2 (iy)
	ld	h, -1 (iy)
	push	hl
	call	_memsave
	ld	hl, #6
	add	hl, sp
	ld	sp, hl
;main-msx.c:162: }
	ret
_MSG_MSXUSB:
	.ascii "MSXUSB Terminal version 0.5"
	.db 0x0d
	.db 0x0a
	.db 0x00
_MSG_LICENSE:
	.ascii "GNU General Public License"
	.db 0x0d
	.db 0x0a
	.ascii "(c) Sourceror"
	.db 0x0d
	.db 0x0a
	.db 0x0d
	.db 0x0a
	.db 0x00
;main-msx.c:163: void host_load (uint16_t address, char* in_filename)
;	---------------------------------
; Function host_load
; ---------------------------------
_host_load::
;main-msx.c:165: memload (address,in_filename);
	ld	iy, #4
	add	iy, sp
	ld	l, 0 (iy)
	ld	h, 1 (iy)
	push	hl
	ld	l, -2 (iy)
	ld	h, -1 (iy)
	push	hl
	call	_memload
	pop	af
	pop	af
;main-msx.c:166: }
	ret
;main-msx.c:168: void host_delay (int milliseconds)
;	---------------------------------
; Function host_delay
; ---------------------------------
_host_delay::
;main-msx.c:170: msx_wait (milliseconds/20);
	ld	hl, #0x0014
	push	hl
	ld	hl, #4
	add	hl, sp
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	push	bc
	call	__divsint
	pop	af
	pop	af
;main-msx.c:171: }
	jp	_msx_wait
;main-msx.c:173: uint32_t host_millis_elapsed () 
;	---------------------------------
; Function host_millis_elapsed
; ---------------------------------
_host_millis_elapsed::
;main-msx.c:176: return FRAME_COUNTER*20;
	ld	hl, (_host_millis_elapsed_FRAME_COUNTER_65536_100)
	ld	c, l
	ld	b, h
	add	hl, hl
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	ld	de, #0x0000
;main-msx.c:177: }
	ret
;main-msx.c:186: uint8_t getRegA () __z88dk_fastcall __naked
;	---------------------------------
; Function getRegA
; ---------------------------------
_getRegA::
;main-msx.c:191: __endasm;
	ld	l,a
	ret
;main-msx.c:192: }
;main-msx.c:194: void new_chput () __z88dk_fastcall 
;	---------------------------------
; Function new_chput
; ---------------------------------
_new_chput::
	push	ix
	ld	ix,#0
	add	ix,sp
	dec	sp
;main-msx.c:196: uint8_t regA = getRegA ();
	call	_getRegA
	ld	-1 (ix), l
;main-msx.c:197: WORKAREA* chput = get_workarea ();
	call	_get_workarea
;main-msx.c:198: if (chput->pos_in_char_buffer<(chput->char_buffer+sizeof(((WORKAREA*)0)->char_buffer)))
	ld	bc, #0x0028
	add	hl, bc
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	dec	hl
	ld	a, c
	sub	a, l
	ld	a, b
	sbc	a, h
	jr	NC, 00103$
;main-msx.c:199: *(chput->pos_in_char_buffer++)=regA;
	ld	e, c
	ld	d, b
	inc	de
	ld	(hl), e
	inc	hl
	ld	(hl), d
	ld	a, -1 (ix)
	ld	(bc), a
00103$:
;main-msx.c:200: }
	inc	sp
	pop	ix
	ret
;main-msx.c:202: void new_chget ()
;	---------------------------------
; Function new_chget
; ---------------------------------
_new_chget::
;main-msx.c:244: __endasm;
;	we can destroy HL, DE, BC, AF
;	check or wait for something in the buffer
;	---------------------------------------------------
	CALL	0x009c ; CHSNS - Tests the status of the keyboard buffer
	JR	NZ, SKIP_WAIT
;	DANGEROUS, dont want to directly call into BIOS but it works, checked on MSX1,2,2+,TR. Alternative is to copy these functions
	LD	HL, #0x002d ; check MSX version (1=0, 2,2+,TR > 0)
	LD	A, (HL)
	AND	A
	CALL	NZ,0x0A37 ; MSX 2 - Display cursor when disabled, store contents under cursor
	CALL	Z,0x09DA ; MSX 1
	CHECK_AGAIN:
	CALL	0x009c ; CHSNS - Tests the status of the keyboard buffer
	JR	Z, CHECK_AGAIN ; Nothing? Check again
;	DANGEROUS
	LD	HL, #0x002d ; check MSX version (1=0, 2,2+,TR > 0)
	LD	A, (HL)
	AND	A
	CALL	NZ,0x0A84 ; Remove cursor when disabled, restore previous contents back to screen
	CALL	Z,0x0A27 ; MSX 1
	SKIP_WAIT:
;	read the value, leave it in the buffer for CHGET upon return
;	---------------------------------------------------
	LD	HL,(#0xf3fa)
	LD	A,(HL)
;	is it of interest?
	CP	#0x08 ; backspace
	JR	Z, HANDLE_BACKSPACE
	CP	#0x7F ; handle delete
	JR	Z, HANDLE_DELETE
;	return
	RET
	HANDLE_BACKSPACE:
	JP	_new_chput ; add it to the send buffer
	HANDLE_DELETE:
	JP	_new_chput ; add it to the send buffer
;main-msx.c:245: }
	ret
;main-msx.c:247: void jump_address (void* address) __z88dk_fastcall __naked
;	---------------------------------
; Function jump_address
; ---------------------------------
_jump_address::
;main-msx.c:251: __endasm;
	jp	(hl)
;main-msx.c:252: }
;main-msx.c:254: void new_timi ()
;	---------------------------------
; Function new_timi
; ---------------------------------
_new_timi::
;main-msx.c:256: WORKAREA* wrk = get_workarea ();
	call	_get_workarea
	ex	de, hl
;main-msx.c:257: if (wrk->pos_in_char_buffer!=wrk->char_buffer)
	ld	hl, #0x0028
	add	hl, de
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	dec	hl
	ld	a, c
	sub	a, e
	jr	NZ, 00117$
	ld	a, b
	sub	a, d
	jr	Z, 00102$
00117$:
;main-msx.c:259: device_send (wrk,wrk->char_buffer,wrk->pos_in_char_buffer-wrk->char_buffer);
	ld	a, c
	sub	a, e
	ld	c, a
	ld	a, b
	sbc	a, d
	ld	b, a
	push	hl
	push	de
	push	bc
	push	de
	push	de
	call	_device_send
	ld	hl, #6
	add	hl, sp
	ld	sp, hl
	pop	de
	pop	hl
;main-msx.c:260: wrk->pos_in_char_buffer = wrk->char_buffer;
	ld	(hl), e
	inc	hl
	ld	(hl), d
00102$:
;main-msx.c:262: if((readStatus() & 0x80) == 0) 
	push	de
	call	_readStatus
	ld	a, l
	pop	de
	rlca
	jr	C, 00104$
;main-msx.c:263: device_interrupt(wrk,TERMINAL_MODE); 
	push	de
	ld	a, #0x01
	push	af
	inc	sp
	push	de
	call	_device_interrupt
	pop	af
	inc	sp
	pop	de
00104$:
;main-msx.c:265: jump_address (&(wrk->HTIMI_original));
	ld	hl, #0x0034
	add	hl, de
;main-msx.c:266: }
	jp	_jump_address
;main-msx.c:271: bool init_serial_device (WORKAREA* wrk)
;	---------------------------------
; Function init_serial_device
; ---------------------------------
_init_serial_device::
;main-msx.c:273: device_reset (wrk);
	pop	bc
	pop	hl
	push	hl
	push	bc
	push	hl
	call	_device_reset
	pop	af
;main-msx.c:275: if (device_init ())
	call	_device_init
	bit	0, l
	jr	Z, 00102$
;main-msx.c:277: print ("+CH376s recognised\r\n");
	ld	hl, #___str_2
	push	hl
	call	_print
;main-msx.c:278: print ("+Connect MSX to PC via USB\r\n");
	ld	hl, #___str_3
	ex	(sp),hl
	call	_print
	pop	af
;main-msx.c:279: return true;
	ld	l, #0x01
	ret
00102$:
;main-msx.c:283: print ("-CH376s not inserted\r\n");
	ld	hl, #___str_4
	push	hl
	call	_print
	pop	af
;main-msx.c:284: return false;
	ld	l, #0x00
;main-msx.c:286: }
	ret
___str_2:
	.ascii "+CH376s recognised"
	.db 0x0d
	.db 0x0a
	.db 0x00
___str_3:
	.ascii "+Connect MSX to PC via USB"
	.db 0x0d
	.db 0x0a
	.db 0x00
___str_4:
	.ascii "-CH376s not inserted"
	.db 0x0d
	.db 0x0a
	.db 0x00
;main-msx.c:288: void hook_terminal (WORKAREA* wrk)
;	---------------------------------
; Function hook_terminal
; ---------------------------------
_hook_terminal::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
;main-msx.c:292: hook((HOOK*) HTIMI,&(wrk->HTIMI_original),(uint16_t*) &new_timi);
	ld	bc, #_new_timi
	ld	e, 4 (ix)
	ld	d, 5 (ix)
	ld	hl, #0x0034
	add	hl, de
	ex	(sp), hl
	push	de
	push	bc
	ld	l, -2 (ix)
	ld	h, -1 (ix)
	push	hl
	ld	hl, #_HTIMI
	push	hl
	call	_hook
	ld	hl, #6
	add	hl, sp
	ld	sp, hl
	pop	de
;main-msx.c:293: hook((HOOK*) HCHPU,&(wrk->HCHPU_original),(uint16_t*) &new_chput);
	ld	bc, #_new_chput
	ld	hl, #0x002a
	add	hl, de
	ex	(sp), hl
	push	de
	push	bc
	ld	l, -2 (ix)
	ld	h, -1 (ix)
	push	hl
	ld	hl, #_HCHPU
	push	hl
	call	_hook
	ld	hl, #6
	add	hl, sp
	ld	sp, hl
	pop	de
;main-msx.c:294: hook((HOOK*) HCHGE,&(wrk->HCHGE_original),(uint16_t*) &new_chget);
	ld	bc, #_new_chget
	ld	hl, #0x002f
	add	hl, de
	push	bc
	push	hl
	ld	hl, #_HCHGE
	push	hl
	call	_hook
	ld	hl, #6
	add	hl, sp
;main-msx.c:295: }
	ld	sp, ix
	pop	ix
	ret
;main-msx.c:297: void unhook_terminal (WORKAREA* wrk)
;	---------------------------------
; Function unhook_terminal
; ---------------------------------
_unhook_terminal::
	push	ix
	ld	ix,#0
	add	ix,sp
;main-msx.c:299: unhook ((HOOK*) HTIMI,&(get_workarea ()->HTIMI_original));
	call	_get_workarea
	ld	de, #0x0034
	add	hl, de
	push	hl
	ld	hl, #_HTIMI
	push	hl
	call	_unhook
	pop	af
	pop	af
;main-msx.c:300: unhook ((HOOK*) HCHPU,&(get_workarea ()->HCHPU_original));
	call	_get_workarea
	ld	de, #0x002a
	add	hl, de
	push	hl
	ld	hl, #_HCHPU
	push	hl
	call	_unhook
	pop	af
	pop	af
;main-msx.c:301: unhook ((HOOK*) HCHGE,&(get_workarea ()->HCHGE_original));
	call	_get_workarea
	ld	de, #0x002f
	add	hl, de
	push	hl
	ld	hl, #_HCHGE
	push	hl
	call	_unhook
	pop	af
	pop	af
;main-msx.c:302: }
	pop	ix
	ret
;main-msx.c:304: void run_serial_terminal()
;	---------------------------------
; Function run_serial_terminal
; ---------------------------------
_run_serial_terminal::
;main-msx.c:306: WORKAREA* wrk = get_workarea ();
	call	_get_workarea
	ex	de, hl
;main-msx.c:309: while (true)
00108$:
;main-msx.c:311: if((readStatus() & 0x80) == 0) 
	push	de
	call	_readStatus
	ld	a, l
	pop	de
	rlca
	jr	C, 00108$
;main-msx.c:313: INTERRUPT_RESULT intres = device_interrupt(wrk,TERMINAL_MODE);
	push	de
	ld	a, #0x01
	push	af
	inc	sp
	push	de
	call	_device_interrupt
	pop	af
	inc	sp
	pop	de
;main-msx.c:314: if (intres==DEVICE_CONFIGURATION_SET)
	ld	a, l
	sub	a, #0x03
	jr	NZ, 00102$
;main-msx.c:315: print ("+Start Terminal program\r\n"); 
	push	hl
	push	de
	ld	bc, #___str_5
	push	bc
	call	_print
	pop	af
	pop	de
	pop	hl
00102$:
;main-msx.c:316: if (intres==DEVICE_SERIAL_CONNECTED)
	ld	a, l
	sub	a, #0x04
	jr	NZ, 00108$
;main-msx.c:321: hook_terminal (wrk);
	push	de
	call	_hook_terminal
	pop	af
;main-msx.c:322: }
	ret
___str_5:
	.ascii "+Start Terminal program"
	.db 0x0d
	.db 0x0a
	.db 0x00
;main-msx.c:324: void run_serial_monitor()
;	---------------------------------
; Function run_serial_monitor
; ---------------------------------
_run_serial_monitor::
;main-msx.c:326: WORKAREA* wrk = get_workarea ();
	call	_get_workarea
;main-msx.c:327: unhook_terminal (wrk);
	push	hl
	push	hl
	call	_unhook_terminal
	pop	af
	pop	hl
;main-msx.c:329: print ("+Use Monitor from host PC\r\n");
	ld	bc, #___str_6+0
	push	hl
	push	bc
	call	_print
	pop	af
	pop	hl
;main-msx.c:330: print ("+H for Help\r\n");
	ld	bc, #___str_7+0
	push	hl
	push	bc
	call	_print
	pop	af
	pop	hl
;main-msx.c:331: print ("+B to go back to BASIC\r\n");
	ld	bc, #___str_8+0
	push	hl
	push	bc
	call	_print
	pop	af
	call	_device_monitor_reset
	pop	hl
;main-msx.c:335: device_send_welcome (wrk);
	push	hl
	push	hl
	call	_device_send_welcome
	pop	af
	pop	hl
;main-msx.c:338: while (true)
00106$:
;main-msx.c:340: if((readStatus() & 0x80) == 0) 
	push	hl
	call	_readStatus
	ld	a, l
	pop	hl
	rlca
	jr	C, 00106$
;main-msx.c:342: if (device_interrupt(wrk,MONITOR_MODE)==MONITOR_EXIT_BASIC)
	push	hl
	xor	a, a
	push	af
	inc	sp
	push	hl
	call	_device_interrupt
	pop	af
	ld	a, l
	inc	sp
	pop	hl
	sub	a, #0x06
	jr	NZ, 00106$
;main-msx.c:350: hook_terminal (wrk);
	push	hl
	call	_hook_terminal
	pop	af
;main-msx.c:351: }
	ret
___str_6:
	.ascii "+Use Monitor from host PC"
	.db 0x0d
	.db 0x0a
	.db 0x00
___str_7:
	.ascii "+H for Help"
	.db 0x0d
	.db 0x0a
	.db 0x00
___str_8:
	.ascii "+B to go back to BASIC"
	.db 0x0d
	.db 0x0a
	.db 0x00
;main-msx.c:354: void basic_start ()
;	---------------------------------
; Function basic_start
; ---------------------------------
_basic_start::
;main-msx.c:363: __endasm;
	push	ix
	push	iy
	push	hl ; save BASIC pointer
	push	de
	push	bc
	push	af
;main-msx.c:366: unhook ((HOOK*) HCLEA,&(bootup_workarea.HCLEA_original));
	ld	hl, #(_bootup_workarea + 0x0039)
	push	hl
	ld	hl, #_HCLEA
	push	hl
	call	_unhook
	pop	af
;main-msx.c:368: print (MSG_MSXUSB);
	ld	hl, #_MSG_MSXUSB
	ex	(sp),hl
	call	_print
	pop	af
;main-msx.c:370: allocate_workarea (sizeof (WORKAREA));
	ld	hl, #0x0051
	call	_allocate_workarea
;main-msx.c:372: init_workarea();
	call	_init_workarea
;main-msx.c:374: if (init_serial_device (get_workarea()))
	call	_get_workarea
	push	hl
	call	_init_serial_device
	pop	af
	bit	0, l
	jr	Z, 00102$
;main-msx.c:375: run_serial_terminal();
	call	_run_serial_terminal
00102$:
;main-msx.c:384: __endasm;
	pop	af
	pop	bc
	pop	de
	pop	hl ; restore BASIC pointer
	pop	iy
	pop	ix
;main-msx.c:385: }
	ret
;main-msx.c:391: void initialize_himsav ()
;	---------------------------------
; Function initialize_himsav
; ---------------------------------
_initialize_himsav::
;main-msx.c:397: __endasm;
	push	hl ; save BASIC pointer
	push	de
	push	bc
;main-msx.c:399: unhook ((HOOK*) HLOPD,&(bootup_workarea.HLOPD_original));
	ld	hl, #(_bootup_workarea + 0x003e)
	push	hl
	ld	hl, #_HLOPD
	push	hl
	call	_unhook
	pop	af
	pop	af
;main-msx.c:400: if (h_phyd!=0xc9)
	ld	iy, #_h_phyd
	ld	a, 0 (iy)
	sub	a, #0xc9
	jr	Z, 00102$
;main-msx.c:402: print ("hello");
	ld	hl, #___str_9
	push	hl
	call	_print
	pop	af
;main-msx.c:403: himsav = himem;
	ld	hl, (_himem)
	ld	(_himsav), hl
00102$:
;main-msx.c:410: __endasm;
	pop	bc
	pop	de
	pop	hl
;main-msx.c:411: }
	ret
___str_9:
	.ascii "hello"
	.db 0x00
;main-msx.c:414: void main (void)
;	---------------------------------
; Function main
; ---------------------------------
_main::
;main-msx.c:416: print (MSG_MSXUSB);
	ld	hl, #_MSG_MSXUSB
	push	hl
	call	_print
;main-msx.c:417: print (MSG_LICENSE);
	ld	hl, #_MSG_LICENSE
	ex	(sp),hl
	call	_print
	pop	af
;main-msx.c:420: hook((HOOK*) HCLEA,&(bootup_workarea.HCLEA_original),(uint16_t*) &basic_start);
	ld	bc, #_basic_start
	push	bc
	ld	hl, #(_bootup_workarea + 0x0039)
	push	hl
	ld	hl, #_HCLEA
	push	hl
	call	_hook
	ld	hl, #6
	add	hl, sp
	ld	sp, hl
;main-msx.c:421: hook((HOOK*) HLOPD,&(bootup_workarea.HLOPD_original),(uint16_t*) &initialize_himsav);
	ld	bc, #_initialize_himsav
	push	bc
	ld	hl, #(_bootup_workarea + 0x003e)
	push	hl
	ld	hl, #_HLOPD
	push	hl
	call	_hook
	ld	hl, #6
	add	hl, sp
	ld	sp, hl
;main-msx.c:423: return;
;main-msx.c:424: }
	ret
;main-msx.c:437: char* onCallMONITOR(char* param) {
;	---------------------------------
; Function onCallMONITOR
; ---------------------------------
_onCallMONITOR::
;main-msx.c:439: while ((*param != 0) && (*param != 0x3a)) 
	pop	bc
	pop	hl
	push	hl
	push	bc
00102$:
	ld	a, (hl)
	or	a, a
	jr	Z, 00104$
	sub	a, #0x3a
	jr	Z, 00104$
;main-msx.c:440: param++;
	inc	hl
	jr	00102$
00104$:
;main-msx.c:442: run_serial_monitor ();
	push	hl
	call	_run_serial_monitor
	pop	hl
;main-msx.c:444: return param;
;main-msx.c:445: }
	ret
;main-msx.c:458: char onDeviceMON_getId() {
;	---------------------------------
; Function onDeviceMON_getId
; ---------------------------------
_onDeviceMON_getId::
;main-msx.c:459: print("The C handler for MON_getId says hi!\r\n\0");
	ld	hl, #___str_10
	push	hl
	call	_print
	pop	af
;main-msx.c:460: return 0; // we're the first device so we return 0
	ld	l, #0x00
;main-msx.c:461: }
	ret
___str_10:
	.ascii "The C handler for MON_getId says hi!"
	.db 0x0d
	.db 0x0a
	.db 0x00
	.db 0x00
;main-msx.c:474: void onDeviceMON_IO(char cmd,char* param) {
;	---------------------------------
; Function onDeviceMON_IO
; ---------------------------------
_onDeviceMON_IO::
	push	ix
	ld	ix,#0
	add	ix,sp
;main-msx.c:475: switch (cmd)
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
;main-msx.c:477: case 0: print ("OPEN\r\n");break;
00101$:
	ld	hl, #___str_11
	push	hl
	call	_print
	pop	af
	jr	00113$
;main-msx.c:478: case 2: print ("CLOSE\r\n");break;
00102$:
	ld	hl, #___str_12
	push	hl
	call	_print
	pop	af
	jr	00113$
;main-msx.c:479: case 4: print ("RANDOM ACCESS\r\n");break;
00103$:
	ld	hl, #___str_13
	push	hl
	call	_print
	pop	af
	jr	00113$
;main-msx.c:480: case 6: print ("SEQ OUTPUT\r\n");break;
00104$:
	ld	hl, #___str_14
	push	hl
	call	_print
	pop	af
	jr	00113$
;main-msx.c:481: case 8: print ("SEQ INPUT\r\n");break;
00105$:
	ld	hl, #___str_15
	push	hl
	call	_print
	pop	af
	jr	00113$
;main-msx.c:482: case 10: print ("LOC\r\n");break;
00106$:
	ld	hl, #___str_16
	push	hl
	call	_print
	pop	af
	jr	00113$
;main-msx.c:483: case 12: print ("LOF\r\n");break;
00107$:
	ld	hl, #___str_17
	push	hl
	call	_print
	pop	af
	jr	00113$
;main-msx.c:484: case 14: print ("EOF\r\n");break;
00108$:
	ld	hl, #___str_18
	push	hl
	call	_print
	pop	af
	jr	00113$
;main-msx.c:485: case 16: print ("FPOS\r\n");break;
00109$:
	ld	hl, #___str_19
	push	hl
	call	_print
	pop	af
	jr	00113$
;main-msx.c:486: case 18: print ("BACKUP\r\n");break;
00110$:
	ld	hl, #___str_20
	push	hl
	call	_print
	pop	af
	jr	00113$
;main-msx.c:487: case 255: print ("INQUIRE\r\n");break;
00111$:
	ld	hl, #___str_21
	push	hl
	call	_print
	pop	af
	jr	00113$
;main-msx.c:488: default: print ("UNKNOWN\r\n");break;
00112$:
	ld	hl, #___str_22
	push	hl
	call	_print
	pop	af
;main-msx.c:489: }
00113$:
;main-msx.c:490: print("The C handler for MON_IO says hi!\r\n\0");
	ld	hl, #___str_23
	push	hl
	call	_print
	pop	af
;main-msx.c:491: }
	pop	ix
	ret
___str_11:
	.ascii "OPEN"
	.db 0x0d
	.db 0x0a
	.db 0x00
___str_12:
	.ascii "CLOSE"
	.db 0x0d
	.db 0x0a
	.db 0x00
___str_13:
	.ascii "RANDOM ACCESS"
	.db 0x0d
	.db 0x0a
	.db 0x00
___str_14:
	.ascii "SEQ OUTPUT"
	.db 0x0d
	.db 0x0a
	.db 0x00
___str_15:
	.ascii "SEQ INPUT"
	.db 0x0d
	.db 0x0a
	.db 0x00
___str_16:
	.ascii "LOC"
	.db 0x0d
	.db 0x0a
	.db 0x00
___str_17:
	.ascii "LOF"
	.db 0x0d
	.db 0x0a
	.db 0x00
___str_18:
	.ascii "EOF"
	.db 0x0d
	.db 0x0a
	.db 0x00
___str_19:
	.ascii "FPOS"
	.db 0x0d
	.db 0x0a
	.db 0x00
___str_20:
	.ascii "BACKUP"
	.db 0x0d
	.db 0x0a
	.db 0x00
___str_21:
	.ascii "INQUIRE"
	.db 0x0d
	.db 0x0a
	.db 0x00
___str_22:
	.ascii "UNKNOWN"
	.db 0x0d
	.db 0x0a
	.db 0x00
___str_23:
	.ascii "The C handler for MON_IO says hi!"
	.db 0x0d
	.db 0x0a
	.db 0x00
	.db 0x00
	.area _CODE
	.area _INITIALIZER
	.area _CABS (ABS)
