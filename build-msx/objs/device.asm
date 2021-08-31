;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.1.0 #12072 (Mac OS X x86_64)
;--------------------------------------------------------
	.module device
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _set_usb_host_mode
	.globl _check_exists
	.globl _handleEP0OUT
	.globl _handleEP0IN
	.globl _handleEP0Setup
	.globl _handleEP0SetupStandard
	.globl _handleEP0SetupClass
	.globl _read_and_process_data
	.globl _read_and_send_host
	.globl _print_memory
	.globl _handleIHX
	.globl _convertToStr
	.globl _convertHex
	.globl _set_target_device_address
	.globl _read_usb_data
	.globl _writeDataForEndpoint2
	.globl _writeDataForEndpoint0
	.globl _sendEP0STALL
	.globl _sendEP0NAK
	.globl _sendEP0ACK
	.globl _strupr
	.globl _host_putchar
	.globl _host_readByte
	.globl _host_go
	.globl _writeData
	.globl _writeCommand
	.globl _host_delay
	.globl _host_save
	.globl _host_load
	.globl _readData
	.globl _host_writeByte
	.globl _host_reset
	.globl _toupper
	.globl _uart_parameters
	.globl _request
	.globl _pstrMonitorCmdArgs
	.globl _strMonitorCmdArgs
	.globl _ihx_output_line
	.globl _ihx_bytes_processed
	.globl _strMonitorEcho
	.globl _IHX_TEMPLATE
	.globl _NEWLINE_MSG
	.globl _BYTES_MSG_ROM
	.globl _UNKNOWN_MSG
	.globl _WELCOME_MSG
	.globl _PRODUCER_SN_Des
	.globl _PRODUCER_Des
	.globl _MANUFACTURER_Des
	.globl _LangDes
	.globl _ConDes
	.globl _DevDes
	.globl _device_reset
	.globl _device_monitor_reset
	.globl _device_send
	.globl _device_send_welcome
	.globl _device_interrupt
	.globl _device_init
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_strMonitorEcho::
	.ds 65
_ihx_bytes_processed::
	.ds 34
_ihx_output_line::
	.ds 46
_strMonitorCmdArgs::
	.ds 65
_pstrMonitorCmdArgs::
	.ds 2
_request::
	.ds 64
_uart_parameters::
	.ds 7
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
;device.c:32: char * strupr (char *str) 
;	---------------------------------
; Function strupr
; ---------------------------------
_strupr::
	push	ix
;device.c:34: char *ret = str;
	ld	hl, #0 + 4
	add	hl, sp
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
;device.c:36: while (*str)
	ld	e, c
	ld	d, b
00101$:
	ld	a, (de)
	or	a, a
	jr	Z, 00103$
;device.c:38: *str = toupper (*str);
	ld	l, a
	ld	h, #0x00
	push	bc
	push	de
	push	hl
	call	_toupper
	pop	af
	pop	de
	pop	bc
	ld	a, l
	ld	(de), a
;device.c:39: ++str;
	inc	de
	jr	00101$
00103$:
;device.c:42: return ret;
	ld	l, c
	ld	h, b
;device.c:43: }
	pop	ix
	ret
_DevDes:
	.db #0x12	; 18
	.db #0x01	; 1
	.db #0x10	; 16
	.db #0x01	; 1
	.db #0x02	; 2
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x09	; 9
	.db #0x12	; 18
	.db #0x34	; 52	'4'
	.db #0x34	; 52	'4'
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x01	; 1
_ConDes:
	.db #0x09	; 9
	.db #0x02	; 2
	.db #0x43	; 67	'C'
	.db #0x00	; 0
	.db #0x02	; 2
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0xc0	; 192
	.db #0x19	; 25
	.db #0x09	; 9
	.db #0x04	; 4
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0x02	; 2
	.db #0x02	; 2
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x05	; 5
	.db #0x24	; 36
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x01	; 1
	.db #0x04	; 4
	.db #0x24	; 36
	.db #0x02	; 2
	.db #0x02	; 2
	.db #0x05	; 5
	.db #0x24	; 36
	.db #0x06	; 6
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0x05	; 5
	.db #0x24	; 36
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x07	; 7
	.db #0x05	; 5
	.db #0x81	; 129
	.db #0x03	; 3
	.db #0x08	; 8
	.db #0x00	; 0
	.db #0x14	; 20
	.db #0x09	; 9
	.db #0x04	; 4
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x02	; 2
	.db #0x0a	; 10
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x07	; 7
	.db #0x05	; 5
	.db #0x02	; 2
	.db #0x02	; 2
	.db #0x40	; 64
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x07	; 7
	.db #0x05	; 5
	.db #0x82	; 130
	.db #0x02	; 2
	.db #0x40	; 64
	.db #0x00	; 0
	.db #0x00	; 0
_LangDes:
	.db #0x04	; 4
	.db #0x03	; 3
	.db #0x09	; 9
	.db #0x04	; 4
_MANUFACTURER_Des:
	.db #0x14	; 20
	.db #0x03	; 3
	.db #0x53	; 83	'S'
	.db #0x00	; 0
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.db #0x75	; 117	'u'
	.db #0x00	; 0
	.db #0x72	; 114	'r'
	.db #0x00	; 0
	.db #0x63	; 99	'c'
	.db #0x00	; 0
	.db #0x65	; 101	'e'
	.db #0x00	; 0
	.db #0x72	; 114	'r'
	.db #0x00	; 0
	.db #0x6f	; 111	'o'
	.db #0x00	; 0
	.db #0x72	; 114	'r'
	.db #0x00	; 0
_PRODUCER_Des:
	.db #0x1c	; 28
	.db #0x03	; 3
	.db #0x4d	; 77	'M'
	.db #0x00	; 0
	.db #0x53	; 83	'S'
	.db #0x00	; 0
	.db #0x58	; 88	'X'
	.db #0x00	; 0
	.db #0x55	; 85	'U'
	.db #0x00	; 0
	.db #0x53	; 83	'S'
	.db #0x00	; 0
	.db #0x42	; 66	'B'
	.db #0x00	; 0
	.db #0x2d	; 45
	.db #0x00	; 0
	.db #0x53	; 83	'S'
	.db #0x00	; 0
	.db #0x65	; 101	'e'
	.db #0x00	; 0
	.db #0x72	; 114	'r'
	.db #0x00	; 0
	.db #0x69	; 105	'i'
	.db #0x00	; 0
	.db #0x61	; 97	'a'
	.db #0x00	; 0
	.db #0x6c	; 108	'l'
	.db #0x00	; 0
_PRODUCER_SN_Des:
	.db #0x12	; 18
	.db #0x03	; 3
	.db #0x32	; 50	'2'
	.db #0x00	; 0
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.db #0x32	; 50	'2'
	.db #0x00	; 0
	.db #0x31	; 49	'1'
	.db #0x00	; 0
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.db #0x37	; 55	'7'
	.db #0x00	; 0
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.db #0x31	; 49	'1'
	.db #0x00	; 0
_WELCOME_MSG:
	.db 0x0d
	.db 0x0a
	.ascii "MSXUSB Monitor"
	.db 0x0d
	.db 0x0a
	.ascii "--------------"
	.db 0x0d
	.db 0x0a
	.ascii "Mxxxx - display memory"
	.db 0x0d
	.db 0x0a
	.ascii "Sxxxx,yyyy,filename - save memory"
	.db 0x0d
	.db 0x0a
	.ascii "Lxxxx,filename - load memory"
	.db 0x0d
	.db 0x0a
	.ascii "Gxxxx - goto address"
	.db 0x0d
	.db 0x0a
	.ascii "R - Reset"
	.db 0x0d
	.db 0x0a
	.ascii "B - BASIC"
	.db 0x0d
	.db 0x0a
	.ascii "H - show this help text"
	.db 0x0d
	.db 0x0a
	.ascii "or, paste Intel HEX lines"
	.db 0x0d
	.db 0x0a
	.db 0x0d
	.db 0x0a
	.ascii "$ "
	.db 0x00
_UNKNOWN_MSG:
	.db 0x0d
	.db 0x0a
	.ascii "Invalid command"
	.db 0x0d
	.db 0x0a
	.ascii "$ "
	.db 0x00
_BYTES_MSG_ROM:
	.db 0x0d
	.ascii "0x00 bytes written to memory"
	.db 0x0d
	.db 0x0a
	.ascii "$ "
	.db 0x00
_NEWLINE_MSG:
	.db 0x0d
	.db 0x0a
	.ascii "$ "
	.db 0x00
_IHX_TEMPLATE:
	.db 0x0d
	.db 0x0a
	.ascii ":10A000002110A0CD07A0C97EA7C8CDA2002318F700"
	.db 0x00
;device.c:138: void device_reset (WORKAREA* wrk)
;	---------------------------------
; Function device_reset
; ---------------------------------
_device_reset::
;device.c:140: wrk->dataTransferLengthEP0 = 0;
	pop	de
	pop	bc
	push	bc
	push	de
	ld	hl, #0x0047
	add	hl, bc
	xor	a, a
	ld	(hl), a
	inc	hl
	ld	(hl), a
;device.c:141: wrk->dataToTransferEP0 = NULL;
	ld	hl, #0x0043
	add	hl, bc
	xor	a, a
	ld	(hl), a
	inc	hl
	ld	(hl), a
;device.c:142: wrk->dataTransferLengthEP2 = 0;
	ld	hl, #0x0049
	add	hl, bc
	xor	a, a
	ld	(hl), a
	inc	hl
	ld	(hl), a
;device.c:143: wrk->dataToTransferEP2 = NULL;
	ld	hl, #0x0045
	add	hl, bc
	xor	a, a
	ld	(hl), a
	inc	hl
	ld	(hl), a
;device.c:144: wrk->usb_device_address = 0;
	ld	hl, #0x004b
	add	hl, bc
	ld	(hl), #0x00
;device.c:145: wrk->usb_configuration_id = 0;
	ld	hl, #0x004c
	add	hl, bc
	ld	(hl), #0x00
;device.c:146: wrk->transaction_state = STATUS;
	ld	hl, #0x004f
	add	hl, bc
	ld	(hl), #0x02
;device.c:147: wrk->processing_command = CMD_NULL;
	ld	hl, #0x0050
	add	hl, bc
	ld	(hl), #0x00
;device.c:148: wrk->memory_address = 0xffff;
	ld	hl, #0x004d
	add	hl, bc
	ld	(hl), #0xff
	inc	hl
	ld	(hl), #0xff
;device.c:152: }
	ret
;device.c:153: void device_monitor_reset ()
;	---------------------------------
; Function device_monitor_reset
; ---------------------------------
_device_monitor_reset::
;device.c:155: strcpy (ihx_bytes_processed, BYTES_MSG_ROM);
	ld	de, #_ihx_bytes_processed
	ld	hl, #_BYTES_MSG_ROM
	xor	a, a
00103$:
	cp	a, (hl)
	ldi
	jr	NZ, 00103$
;device.c:156: strcpy (ihx_output_line, IHX_TEMPLATE);
	ld	de, #_ihx_output_line
	ld	hl, #_IHX_TEMPLATE
	xor	a, a
00104$:
	cp	a, (hl)
	ldi
	jr	NZ, 00104$
;device.c:157: }
	ret
;device.c:159: void sendEP0ACK ()
;	---------------------------------
; Function sendEP0ACK
; ---------------------------------
_sendEP0ACK::
;device.c:161: writeCommand (SET_ENDP3__TX_EP0);
	ld	l, #0x19
	call	_writeCommand
;device.c:162: writeData (SET_ENDP_ACK);
	ld	l, #0x00
;device.c:163: }
	jp	_writeData
;device.c:164: void sendEP0NAK ()
;	---------------------------------
; Function sendEP0NAK
; ---------------------------------
_sendEP0NAK::
;device.c:166: writeCommand (SET_ENDP3__TX_EP0);
	ld	l, #0x19
	call	_writeCommand
;device.c:167: writeData (SET_ENDP_NAK);
	ld	l, #0x0e
;device.c:168: }
	jp	_writeData
;device.c:169: void sendEP0STALL ()
;	---------------------------------
; Function sendEP0STALL
; ---------------------------------
_sendEP0STALL::
;device.c:171: writeCommand (SET_ENDP3__TX_EP0);
	ld	l, #0x19
	call	_writeCommand
;device.c:172: writeData (SET_ENDP_STALL);
	ld	l, #0x0f
;device.c:173: }
	jp	_writeData
;device.c:175: void writeDataForEndpoint0(WORKAREA* wrk)
;	---------------------------------
; Function writeDataForEndpoint0
; ---------------------------------
_writeDataForEndpoint0::
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl, #-6
	add	hl, sp
	ld	sp, hl
;device.c:177: int amount = min (EP0_PIPE_SIZE,wrk->dataTransferLengthEP0);
	ld	a, 4 (ix)
	ld	-6 (ix), a
	ld	a, 5 (ix)
	ld	-5 (ix), a
	ld	a, -6 (ix)
	add	a, #0x47
	ld	-4 (ix), a
	ld	a, -5 (ix)
	adc	a, #0x00
	ld	-3 (ix), a
	ld	l, -4 (ix)
	ld	h, -3 (ix)
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	ld	a, #0x08
	cp	a, c
	ld	a, #0x00
	sbc	a, b
	jr	NC, 00107$
	ld	bc, #0x0008
00107$:
	ld	-2 (ix), c
	ld	-1 (ix), b
;device.c:183: writeCommand(CH_CMD_WR_EP0);
	ld	l, #0x29
	call	_writeCommand
;device.c:184: writeData(amount);
	ld	l, -2 (ix)
	call	_writeData
;device.c:185: for(int i=0; i<amount; i++) 
	ld	a, -6 (ix)
	add	a, #0x43
	ld	c, a
	ld	a, -5 (ix)
	adc	a, #0x00
	ld	b, a
	ld	de, #0x0000
00103$:
;device.c:190: writeData(wrk->dataToTransferEP0[i]);
	ld	l, c
	ld	h, b
	ld	a, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, a
;device.c:185: for(int i=0; i<amount; i++) 
	ld	a, e
	sub	a, -2 (ix)
	ld	a, d
	sbc	a, -1 (ix)
	jp	PO, 00125$
	xor	a, #0x80
00125$:
	jp	P, 00101$
;device.c:190: writeData(wrk->dataToTransferEP0[i]);
	add	hl, de
	ld	l, (hl)
	push	bc
	push	de
	call	_writeData
	pop	de
	pop	bc
;device.c:185: for(int i=0; i<amount; i++) 
	inc	de
	jr	00103$
00101$:
;device.c:195: wrk->dataToTransferEP0 += amount;
	ld	a, l
	add	a, -2 (ix)
	ld	e, a
	ld	a, h
	adc	a, -1 (ix)
	ld	d, a
	ld	a, e
	ld	(bc), a
	inc	bc
	ld	a, d
	ld	(bc), a
;device.c:196: wrk->dataTransferLengthEP0 -= amount;
	ld	l, -4 (ix)
	ld	h, -3 (ix)
	ld	c, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, c
	ld	c, -2 (ix)
	ld	b, -1 (ix)
	cp	a, a
	sbc	hl, bc
	ex	de, hl
	pop	bc
	pop	hl
	push	hl
	push	bc
	ld	(hl), e
	inc	hl
	ld	(hl), d
;device.c:197: }
	ld	sp, ix
	pop	ix
	ret
;device.c:198: void writeDataForEndpoint2(WORKAREA* wrk)
;	---------------------------------
; Function writeDataForEndpoint2
; ---------------------------------
_writeDataForEndpoint2::
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl, #-6
	add	hl, sp
	ld	sp, hl
;device.c:200: int amount = min (BULK_OUT_ENDP_MAX_SIZE,wrk->dataTransferLengthEP2);
	ld	a, 4 (ix)
	ld	-6 (ix), a
	ld	a, 5 (ix)
	ld	-5 (ix), a
	ld	a, -6 (ix)
	add	a, #0x49
	ld	-4 (ix), a
	ld	a, -5 (ix)
	adc	a, #0x00
	ld	-3 (ix), a
	ld	l, -4 (ix)
	ld	h, -3 (ix)
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	ld	a, #0x40
	cp	a, c
	ld	a, #0x00
	sbc	a, b
	jr	NC, 00109$
	ld	bc, #0x0040
00109$:
;device.c:202: if (amount!=0)
	ld	a, b
	or	a, c
	jr	Z, 00107$
;device.c:207: writeCommand(CH_CMD_WR_EP2);
	push	bc
	ld	l, #0x2b
	call	_writeCommand
	pop	bc
;device.c:208: writeData(amount);
	ld	l, c
	push	bc
	call	_writeData
	pop	bc
;device.c:209: for(int i=0; i<amount; i++) 
	ld	a, -6 (ix)
	add	a, #0x45
	ld	-2 (ix), a
	ld	a, -5 (ix)
	adc	a, #0x00
	ld	-1 (ix), a
	ld	de, #0x0000
00105$:
;device.c:214: writeData(wrk->dataToTransferEP2[i]);
	ld	l, -2 (ix)
	ld	h, -1 (ix)
	ld	a, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, a
;device.c:209: for(int i=0; i<amount; i++) 
	ld	a, e
	sub	a, c
	ld	a, d
	sbc	a, b
	jp	PO, 00132$
	xor	a, #0x80
00132$:
	jp	P, 00101$
;device.c:214: writeData(wrk->dataToTransferEP2[i]);
	add	hl, de
	ld	l, (hl)
	push	bc
	push	de
	call	_writeData
	pop	de
	pop	bc
;device.c:209: for(int i=0; i<amount; i++) 
	inc	de
	jr	00105$
00101$:
;device.c:219: wrk->dataToTransferEP2 += amount;
	add	hl, bc
	ex	de, hl
	ld	l, -2 (ix)
	ld	h, -1 (ix)
	ld	(hl), e
	inc	hl
	ld	(hl), d
;device.c:220: wrk->dataTransferLengthEP2 -= amount;
	ld	l, -4 (ix)
	ld	h, -3 (ix)
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	cp	a, a
	sbc	hl, bc
	ex	de, hl
	pop	bc
	pop	hl
	push	hl
	push	bc
	ld	(hl), e
	inc	hl
	ld	(hl), d
00107$:
;device.c:222: }
	ld	sp, ix
	pop	ix
	ret
;device.c:224: size_t read_usb_data (uint8_t* pBuffer)
;	---------------------------------
; Function read_usb_data
; ---------------------------------
_read_usb_data::
;device.c:227: writeCommand(CH375_CMD_RD_USB_DATA_UNLOCK);
	ld	l, #0x28
	call	_writeCommand
;device.c:228: value = readData();
	call	_readData
	ld	e, l
;device.c:229: if (value==0)
	ld	a, e
	or	a, a
	jr	NZ, 00111$
;device.c:230: return 0;
	ld	hl, #0x0000
	ret
;device.c:231: for (uint8_t i=0;i<value;i++)
00111$:
	ld	d, #0x00
00105$:
	ld	a, d
	sub	a, e
	jr	NC, 00103$
;device.c:232: *(pBuffer+i) = readData();
	ld	iy, #2
	add	iy, sp
	ld	a, 0 (iy)
	add	a, d
	ld	c, a
	ld	a, 1 (iy)
	adc	a, #0x00
	ld	b, a
	push	bc
	push	de
	call	_readData
	ld	a, l
	pop	de
	pop	bc
	ld	(bc), a
;device.c:231: for (uint8_t i=0;i<value;i++)
	inc	d
	jr	00105$
00103$:
;device.c:233: return value;
	ld	d, #0x00
	ex	de, hl
;device.c:234: }
	ret
;device.c:236: void set_target_device_address (uint8_t address)
;	---------------------------------
; Function set_target_device_address
; ---------------------------------
_set_target_device_address::
;device.c:238: writeCommand (CH375_CMD_SET_USB_ADDR);
	ld	l, #0x13
	call	_writeCommand
;device.c:239: writeData(address);
	ld	iy, #2
	add	iy, sp
	ld	l, 0 (iy)
;device.c:241: }
	jp	_writeData
;device.c:243: uint16_t convertHex (char* start, uint8_t len)
;	---------------------------------
; Function convertHex
; ---------------------------------
_convertHex::
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl, #-9
	add	hl, sp
	ld	sp, hl
;device.c:245: uint16_t result=0;
	xor	a, a
	ld	-5 (ix), a
	ld	-4 (ix), a
;device.c:247: cur = start;
	ld	a, 4 (ix)
	ld	-3 (ix), a
	ld	a, 5 (ix)
	ld	-2 (ix), a
;device.c:248: while (len-- && *cur!='\0')
	ld	a, 6 (ix)
	ld	-1 (ix), a
00104$:
	ld	a, -1 (ix)
	ld	-6 (ix), a
	dec	-1 (ix)
	ld	a, -6 (ix)
	or	a, a
	jr	Z, 00106$
	ld	l, -3 (ix)
	ld	h, -2 (ix)
	ld	a, (hl)
	or	a, a
	jr	Z, 00106$
;device.c:250: *cur = *cur;
	ld	l, -3 (ix)
	ld	h, -2 (ix)
	ld	(hl), a
;device.c:251: uint8_t dec = *cur - '0';
	add	a, #0xd0
	ld	c, a
;device.c:252: if (dec>9)
	ld	a, #0x09
	sub	a, c
	jr	NC, 00102$
;device.c:253: dec -= 7;
	ld	a, c
	add	a, #0xf9
	ld	c, a
00102$:
;device.c:254: result = (result << 4) + dec;
	ld	a, -5 (ix)
	ld	-7 (ix), a
	ld	a, -4 (ix)
	ld	-6 (ix), a
	ld	b, #0x04
00130$:
	sla	-7 (ix)
	rl	-6 (ix)
	djnz	00130$
	ld	-5 (ix), c
	ld	-4 (ix), #0
	ld	a, -7 (ix)
	ld	-9 (ix), a
	ld	a, -6 (ix)
	ld	-8 (ix), a
	ld	a, -5 (ix)
	ld	-7 (ix), a
	ld	a, -4 (ix)
	ld	-6 (ix), a
	ld	a, -7 (ix)
	add	a, -9 (ix)
	ld	-5 (ix), a
	ld	a, -6 (ix)
	adc	a, -8 (ix)
	ld	-4 (ix), a
;device.c:255: cur++;
	inc	-3 (ix)
	jr	NZ, 00104$
	inc	-2 (ix)
	jp	00104$
00106$:
;device.c:257: return result;
	ld	l, -5 (ix)
	ld	h, -4 (ix)
;device.c:258: }
	ld	sp, ix
	pop	ix
	ret
;device.c:259: void convertToStr (uint8_t value, char* buffer)
;	---------------------------------
; Function convertToStr
; ---------------------------------
_convertToStr::
;device.c:261: uint8_t lo_nibble = value & 0x0f;
	ld	iy, #2
	add	iy, sp
	ld	a, 0 (iy)
	push	af
	and	a, #0x0f
	ld	c, a
	pop	af
;device.c:262: uint8_t hi_nibble = value >> 4;
	rlca
	rlca
	rlca
	rlca
	and	a, #0x0f
	ld	l, a
;device.c:264: *buffer = hi_nibble>9?hi_nibble+'A'-10:hi_nibble+'0';
	ld	e, 1 (iy)
	ld	d, 2 (iy)
	ld	b, l
	ld	a, #0x09
	sub	a, l
	jr	NC, 00103$
	ld	a, b
	add	a, #0x37
	jr	00104$
00103$:
	ld	a, b
	add	a, #0x30
00104$:
	ld	(de), a
;device.c:265: *(buffer+1) = lo_nibble>9?lo_nibble+'A'-10:lo_nibble+'0';
	inc	de
	ld	b, c
	ld	a, #0x09
	sub	a, c
	jr	NC, 00105$
	ld	a, b
	add	a, #0x37
	jr	00106$
00105$:
	ld	a, b
	add	a, #0x30
00106$:
	ld	(de), a
;device.c:266: }
	ret
;device.c:268: uint8_t handleIHX(char* ihxline)
;	---------------------------------
; Function handleIHX
; ---------------------------------
_handleIHX::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	dec	sp
;device.c:273: uint8_t type = convertHex (ihxline+6,2);
	ld	l, 4 (ix)
	ld	h, 5 (ix)
	ld	de, #0x0006
	add	hl, de
	ld	a, #0x02
	push	af
	inc	sp
	push	hl
	call	_convertHex
	pop	af
	inc	sp
	ex	de, hl
;device.c:274: if (type!=00)
	ld	a, e
	or	a, a
	jr	Z, 00102$
;device.c:275: return 0;
	ld	l, #0x00
	jp	00106$
00102$:
;device.c:279: uint8_t byteCount = convertHex (ihxline,2);
	ld	a, #0x02
	push	af
	inc	sp
	ld	l, 4 (ix)
	ld	h, 5 (ix)
	push	hl
	call	_convertHex
	pop	af
	inc	sp
;device.c:280: uint16_t addressStart = convertHex (ihxline+2,4);
	ld	c, 4 (ix)
	ld	b, 5 (ix)
	inc	bc
	inc	bc
	push	hl
	ld	a, #0x04
	push	af
	inc	sp
	push	bc
	call	_convertHex
	pop	af
	inc	sp
	ex	de, hl
	pop	hl
;device.c:286: ihxline += 8;
	ld	a, 4 (ix)
	add	a, #0x08
	ld	4 (ix), a
	jr	NC, 00124$
	inc	5 (ix)
00124$:
;device.c:287: while (byteCount--)
	ld	c, #0x00
	ld	a, 4 (ix)
	ld	-3 (ix), a
	ld	a, 5 (ix)
	ld	-2 (ix), a
	ld	-1 (ix), l
00103$:
	ld	b, -1 (ix)
	dec	-1 (ix)
	ld	a, b
	or	a, a
	jr	Z, 00105$
;device.c:289: value = convertHex (ihxline,2);
	push	bc
	push	de
	ld	a, #0x02
	push	af
	inc	sp
	ld	l, -3 (ix)
	ld	h, -2 (ix)
	push	hl
	call	_convertHex
	pop	af
	inc	sp
	pop	de
	pop	bc
	ld	b, l
;device.c:290: host_writeByte (addressStart++,value);
	ld	l, e
	ld	h, d
	inc	de
	push	bc
	push	de
	push	bc
	inc	sp
	push	hl
	call	_host_writeByte
	pop	af
	inc	sp
	pop	de
	pop	bc
;device.c:291: bytesWritten++;
	inc	c
;device.c:292: ihxline+=2;
	ld	a, -3 (ix)
	add	a, #0x02
	ld	-3 (ix), a
	jr	NC, 00103$
	inc	-2 (ix)
	jr	00103$
00105$:
;device.c:303: return bytesWritten;
	ld	l, c
00106$:
;device.c:304: }
	ld	sp, ix
	pop	ix
	ret
;device.c:306: void print_memory (WORKAREA* wrk)
;	---------------------------------
; Function print_memory
; ---------------------------------
_print_memory::
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl, #-6
	add	hl, sp
	ld	sp, hl
;device.c:315: wrk->dataToTransferEP2 = (uint8_t*) ihx_output_line;
	ld	c, 4 (ix)
	ld	b, 5 (ix)
	ld	hl, #0x0045
	add	hl, bc
	ex	de, hl
	ld	a, #<(_ihx_output_line)
	ld	(de), a
	inc	de
	ld	a, #>(_ihx_output_line)
	ld	(de), a
;device.c:316: wrk->dataTransferLengthEP2 = sizeof (ihx_output_line);
	ld	hl, #0x0049
	add	hl, bc
	ld	(hl), #0x2e
	inc	hl
	ld	(hl), #0x00
;device.c:319: uint16_t address = wrk->memory_address;
	ld	hl, #0x004d
	add	hl, bc
	ex	de, hl
	ld	a, (de)
	ld	-6 (ix), a
	inc	de
	ld	a, (de)
	ld	-5 (ix), a
	dec	de
;device.c:320: addr_high = address>>8;
	ld	l, -5 (ix)
;device.c:321: addr_low = address&0xff;
	ld	c, -6 (ix)
;device.c:322: convertToStr (addr_high,ihx_output_line+5);
	push	bc
	push	de
	ld	de, #(_ihx_output_line + 0x0005)
	push	de
	ld	a, l
	push	af
	inc	sp
	call	_convertToStr
	pop	af
	inc	sp
	pop	de
	pop	bc
;device.c:323: convertToStr (addr_low,ihx_output_line+7);
	push	de
	ld	hl, #(_ihx_output_line + 0x0007)
	push	hl
	ld	a, c
	push	af
	inc	sp
	call	_convertToStr
	pop	af
;device.c:331: char* membufptr = ihx_output_line+11;
	ld	-2 (ix), #<((_ihx_output_line + 0x000b))
	ld	-1 (ix), #>((_ihx_output_line + 0x000b))
	inc	sp
	pop	de
;device.c:332: for (int i=0;i<0x10;i++)
	ld	bc, #0x0000
00103$:
	ld	a, c
	sub	a, #0x10
	ld	a, b
	rla
	ccf
	rra
	sbc	a, #0x80
	jr	NC, 00101$
;device.c:334: value = host_readByte(address+i);
	ld	a, -6 (ix)
	ld	h, -5 (ix)
	ld	-4 (ix), c
	ld	-3 (ix), b
	add	a, -4 (ix)
	ld	l, a
	ld	a, h
	adc	a, -3 (ix)
	ld	h, a
	push	bc
	push	de
	call	_host_readByte
	ld	a, l
	ld	l, -2 (ix)
	ld	h, -1 (ix)
	push	hl
	push	af
	inc	sp
	call	_convertToStr
	pop	af
	inc	sp
	pop	de
	pop	bc
;device.c:336: membufptr+=2;
	ld	a, -2 (ix)
	add	a, #0x02
	ld	-2 (ix), a
	jr	NC, 00118$
	inc	-1 (ix)
00118$:
;device.c:332: for (int i=0;i<0x10;i++)
	inc	bc
	jr	00103$
00101$:
;device.c:349: wrk->memory_address += 0x10;
	ld	l, e
	ld	h, d
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	ld	hl, #0x0010
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, c
	ld	(de), a
	inc	de
	ld	a, b
	ld	(de), a
;device.c:350: }
	ld	sp, ix
	pop	ix
	ret
;device.c:352: void device_send (WORKAREA* wrk,char* buffer,uint16_t length)
;	---------------------------------
; Function device_send
; ---------------------------------
_device_send::
;device.c:354: wrk->dataToTransferEP2 = (uint8_t*) buffer;
	pop	de
	pop	bc
	push	bc
	push	de
	ld	hl, #0x0045
	add	hl, bc
	ld	iy, #4
	add	iy, sp
	ld	a, 0 (iy)
	ld	(hl), a
	inc	hl
	ld	a, 1 (iy)
	ld	(hl), a
;device.c:355: wrk->dataTransferLengthEP2 = length;
	ld	hl, #0x0049
	add	hl, bc
	ld	a, 2 (iy)
	inc	iy
	inc	iy
	ld	(hl), a
	inc	hl
	ld	a, 1 (iy)
	ld	(hl), a
;device.c:356: writeDataForEndpoint2 (wrk);
	push	bc
	call	_writeDataForEndpoint2
	pop	af
;device.c:357: }
	ret
;device.c:358: void device_send_welcome (WORKAREA* wrk)
;	---------------------------------
; Function device_send_welcome
; ---------------------------------
_device_send_welcome::
;device.c:360: device_send (wrk,WELCOME_MSG,sizeof (WELCOME_MSG));
	ld	hl, #0x00e0
	push	hl
	ld	hl, #_WELCOME_MSG
	push	hl
	ld	hl, #6
	add	hl, sp
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	push	bc
	call	_device_send
	ld	hl, #6
	add	hl, sp
	ld	sp, hl
;device.c:361: }
	ret
;device.c:363: void read_and_send_host()
;	---------------------------------
; Function read_and_send_host
; ---------------------------------
_read_and_send_host::
;device.c:366: writeCommand(CH375_CMD_RD_USB_DATA_UNLOCK);
	ld	l, #0x28
	call	_writeCommand
;device.c:367: length = readData();
	call	_readData
	ld	a, l
	ld	c, a
;device.c:368: if (length)
	or	a, a
	ret	Z
;device.c:370: for (uint8_t i=0;i<length;i++)
	ld	b, #0x00
00105$:
	ld	a, b
	sub	a, c
	ret	NC
;device.c:371: host_putchar (readData());
	push	bc
	call	_readData
	call	_host_putchar
	pop	bc
;device.c:370: for (uint8_t i=0;i<length;i++)
	inc	b
;device.c:373: }
	jr	00105$
;device.c:375: INTERRUPT_RESULT read_and_process_data(WORKAREA* wrk)
;	---------------------------------
; Function read_and_process_data
; ---------------------------------
_read_and_process_data::
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl, #-20
	add	hl, sp
	ld	sp, hl
;device.c:377: INTERRUPT_RESULT intres = DEVICE_INTERRUPT_OKAY;
	ld	-20 (ix), #0
;device.c:380: writeCommand(CH375_CMD_RD_USB_DATA_UNLOCK);
	ld	l, #0x28
	call	_writeCommand
;device.c:381: length = readData(); // read length
	call	_readData
	ld	-1 (ix), l
	ld	-19 (ix), l
;device.c:382: if (length==0)
	ld	a, -1 (ix)
	or	a, a
	jr	NZ, 00102$
;device.c:383: return DEVICE_INTERRUPT_ERROR;
	ld	l, #0x01
	jp	00158$
00102$:
;device.c:387: char* pstrMonitorEcho = strMonitorEcho;
	ld	-3 (ix), #<(_strMonitorEcho)
	ld	-2 (ix), #>(_strMonitorEcho)
;device.c:388: wrk->dataToTransferEP2 = NULL;
	ld	a, 4 (ix)
	ld	-18 (ix), a
	ld	a, 5 (ix)
	ld	-17 (ix), a
	ld	a, -18 (ix)
	add	a, #0x45
	ld	-16 (ix), a
	ld	a, -17 (ix)
	adc	a, #0x00
	ld	-15 (ix), a
	ld	l, -16 (ix)
	ld	h, -15 (ix)
	xor	a, a
	ld	(hl), a
	inc	hl
	ld	(hl), a
;device.c:389: wrk->dataTransferLengthEP2 = 0;
	ld	a, -18 (ix)
	add	a, #0x49
	ld	-14 (ix), a
	ld	a, -17 (ix)
	adc	a, #0x00
	ld	-13 (ix), a
	ld	l, -14 (ix)
	ld	h, -13 (ix)
	xor	a, a
	ld	(hl), a
	inc	hl
	ld	(hl), a
;device.c:391: for (uint8_t i=0;i<length;i++)
	ld	a, -18 (ix)
	ld	-12 (ix), a
	ld	a, -17 (ix)
	ld	-11 (ix), a
	ld	a, -18 (ix)
	ld	-10 (ix), a
	ld	a, -17 (ix)
	ld	-9 (ix), a
	ld	a, -18 (ix)
	ld	-8 (ix), a
	ld	a, -17 (ix)
	ld	-7 (ix), a
	ld	-1 (ix), #0
00156$:
	ld	a, -1 (ix)
	sub	a, -19 (ix)
	jp	NC, 00152$
;device.c:393: value = toupper(readData());
	call	_readData
	ld	-4 (ix), l
	ld	-5 (ix), l
	ld	-4 (ix), #0
	ld	h, #0
	push	hl
	call	_toupper
	pop	af
	ld	-5 (ix), l
	ld	-4 (ix), h
	ld	a, -5 (ix)
	ld	-6 (ix), a
;device.c:395: if (wrk->processing_command!=CMD_IHX && value!=':')
	ld	a, -18 (ix)
	add	a, #0x50
	ld	-5 (ix), a
	ld	a, -17 (ix)
	adc	a, #0x00
	ld	-4 (ix), a
	ld	l, -5 (ix)
	ld	h, -4 (ix)
	ld	a, (hl)
	sub	a, #0x04
	jr	Z, 00104$
	ld	a, -6 (ix)
	sub	a, #0x3a
	jr	Z, 00104$
;device.c:396: *pstrMonitorEcho++ = value;
	ld	l, -3 (ix)
	ld	h, -2 (ix)
	ld	a, -6 (ix)
	ld	(hl), a
	inc	-3 (ix)
	jr	NZ, 00313$
	inc	-2 (ix)
00313$:
00104$:
;device.c:399: switch (value)
	ld	a, -6 (ix)
	sub	a, #0x0d
	jp	Z,00131$
	ld	a, -6 (ix)
	sub	a, #0x1b
	jp	Z,00130$
	ld	a, -6 (ix)
	sub	a, #0x3a
	jp	Z,00121$
	ld	a, -6 (ix)
	sub	a, #0x42
	jp	Z,00115$
	ld	a, -6 (ix)
	sub	a, #0x47
	jr	Z, 00106$
	ld	a, -6 (ix)
	sub	a, #0x48
	jp	Z,00118$
	ld	a, -6 (ix)
	sub	a, #0x4c
	jp	Z,00127$
	ld	a, -6 (ix)
	sub	a, #0x4d
	jr	Z, 00109$
	ld	a, -6 (ix)
	sub	a, #0x52
	jr	Z, 00112$
	ld	a, -6 (ix)
	sub	a, #0x53
	jp	Z,00124$
	jp	00148$
;device.c:401: case 'G': 
00106$:
;device.c:402: if (wrk->processing_command==CMD_NULL)
	ld	l, -5 (ix)
	ld	h, -4 (ix)
	ld	a, (hl)
	or	a, a
	jp	NZ, 00148$
;device.c:404: wrk->processing_command = CMD_GO; 
	ld	l, -5 (ix)
	ld	h, -4 (ix)
	ld	(hl), #0x01
;device.c:405: pstrMonitorCmdArgs = strMonitorCmdArgs;
	ld	iy, #_pstrMonitorCmdArgs
	ld	0 (iy), #<(_strMonitorCmdArgs)
	ld	1 (iy), #>(_strMonitorCmdArgs)
;device.c:407: break;
	jp	00148$
;device.c:408: case 'M': 
00109$:
;device.c:409: if (wrk->processing_command==CMD_NULL)
	ld	l, -5 (ix)
	ld	h, -4 (ix)
	ld	a, (hl)
	or	a, a
	jp	NZ, 00148$
;device.c:411: wrk->processing_command = CMD_MEMORY; 
	ld	l, -5 (ix)
	ld	h, -4 (ix)
	ld	(hl), #0x06
;device.c:412: pstrMonitorCmdArgs = strMonitorCmdArgs;
	ld	iy, #_pstrMonitorCmdArgs
	ld	0 (iy), #<(_strMonitorCmdArgs)
	ld	1 (iy), #>(_strMonitorCmdArgs)
;device.c:414: break;
	jp	00148$
;device.c:415: case 'R': 
00112$:
;device.c:416: if (wrk->processing_command==CMD_NULL)
	ld	l, -5 (ix)
	ld	h, -4 (ix)
	ld	a, (hl)
	or	a, a
	jp	NZ, 00148$
;device.c:418: wrk->processing_command = CMD_RESET; 
	ld	l, -5 (ix)
	ld	h, -4 (ix)
	ld	(hl), #0x02
;device.c:419: pstrMonitorCmdArgs = NULL;
	ld	hl, #0x0000
	ld	(_pstrMonitorCmdArgs), hl
;device.c:421: break;
	jp	00148$
;device.c:422: case 'B': 
00115$:
;device.c:423: if (wrk->processing_command==CMD_NULL)
	ld	l, -5 (ix)
	ld	h, -4 (ix)
	ld	a, (hl)
	or	a, a
	jp	NZ, 00148$
;device.c:425: wrk->processing_command = CMD_BASIC; 
	ld	l, -5 (ix)
	ld	h, -4 (ix)
	ld	(hl), #0x03
;device.c:426: pstrMonitorCmdArgs = NULL;
	ld	hl, #0x0000
	ld	(_pstrMonitorCmdArgs), hl
;device.c:428: break;
	jp	00148$
;device.c:429: case 'H': 
00118$:
;device.c:430: if (wrk->processing_command==CMD_NULL)
	ld	l, -5 (ix)
	ld	h, -4 (ix)
	ld	a, (hl)
	or	a, a
	jp	NZ, 00148$
;device.c:432: wrk->processing_command = CMD_HELP; 
	ld	l, -5 (ix)
	ld	h, -4 (ix)
	ld	(hl), #0x05
;device.c:433: pstrMonitorCmdArgs = NULL;
	ld	hl, #0x0000
	ld	(_pstrMonitorCmdArgs), hl
;device.c:435: break;
	jp	00148$
;device.c:436: case ':': 
00121$:
;device.c:437: if (wrk->processing_command==CMD_NULL)
	ld	l, -5 (ix)
	ld	h, -4 (ix)
	ld	a, (hl)
	or	a, a
	jp	NZ, 00148$
;device.c:439: wrk->processing_command = CMD_IHX; 
	ld	l, -5 (ix)
	ld	h, -4 (ix)
	ld	(hl), #0x04
;device.c:440: pstrMonitorCmdArgs = strMonitorCmdArgs;
	ld	iy, #_pstrMonitorCmdArgs
	ld	0 (iy), #<(_strMonitorCmdArgs)
	ld	1 (iy), #>(_strMonitorCmdArgs)
;device.c:442: break;
	jp	00148$
;device.c:443: case 'S': 
00124$:
;device.c:444: if (wrk->processing_command==CMD_NULL)
	ld	l, -5 (ix)
	ld	h, -4 (ix)
	ld	a, (hl)
	or	a, a
	jp	NZ, 00148$
;device.c:446: wrk->processing_command = CMD_SAVE; 
	ld	l, -5 (ix)
	ld	h, -4 (ix)
	ld	(hl), #0x07
;device.c:447: pstrMonitorCmdArgs = strMonitorCmdArgs;
	ld	iy, #_pstrMonitorCmdArgs
	ld	0 (iy), #<(_strMonitorCmdArgs)
	ld	1 (iy), #>(_strMonitorCmdArgs)
;device.c:449: break;
	jp	00148$
;device.c:450: case 'L': 
00127$:
;device.c:451: if (wrk->processing_command==CMD_NULL)
	ld	l, -5 (ix)
	ld	h, -4 (ix)
	ld	a, (hl)
	or	a, a
	jp	NZ, 00148$
;device.c:453: wrk->processing_command = CMD_LOAD; 
	ld	l, -5 (ix)
	ld	h, -4 (ix)
	ld	(hl), #0x08
;device.c:454: pstrMonitorCmdArgs = strMonitorCmdArgs;
	ld	iy, #_pstrMonitorCmdArgs
	ld	0 (iy), #<(_strMonitorCmdArgs)
	ld	1 (iy), #>(_strMonitorCmdArgs)
;device.c:456: break;
	jp	00148$
;device.c:457: case 0x1b:
00130$:
;device.c:458: wrk->dataToTransferEP2 = (uint8_t*) NEWLINE_MSG;
	ld	l, -16 (ix)
	ld	h, -15 (ix)
	ld	(hl), #<(_NEWLINE_MSG)
	inc	hl
	ld	(hl), #>(_NEWLINE_MSG)
;device.c:459: wrk->dataTransferLengthEP2 = sizeof (NEWLINE_MSG);
	ld	l, -14 (ix)
	ld	h, -13 (ix)
	ld	(hl), #0x05
	inc	hl
	ld	(hl), #0x00
;device.c:460: wrk->processing_command = CMD_NULL;
	ld	l, -5 (ix)
	ld	h, -4 (ix)
	ld	(hl), #0x00
;device.c:461: wrk->memory_address=0xffff;
	ld	l, -18 (ix)
	ld	h, -17 (ix)
	ld	de, #0x004d
	add	hl, de
	ld	(hl), #0xff
	inc	hl
	ld	(hl), #0xff
;device.c:462: break;
	jp	00148$
;device.c:463: case '\r':
00131$:
;device.c:465: switch (wrk->processing_command)
	ld	l, -5 (ix)
	ld	h, -4 (ix)
	ld	c, (hl)
	ld	a, #0x08
	sub	a, c
	jp	C, 00148$
	ld	b, #0x00
	ld	hl, #00324$
	add	hl, bc
	add	hl, bc
	add	hl, bc
	jp	(hl)
00324$:
	jp	00146$
	jp	00132$
	jp	00136$
	jp	00137$
	jp	00139$
	jp	00138$
	jp	00133$
	jp	00143$
	jp	00140$
;device.c:467: case CMD_GO:
00132$:
;device.c:468: host_go(convertHex (strMonitorCmdArgs+1,4));
	ld	a, #0x04
	push	af
	inc	sp
	ld	hl, #(_strMonitorCmdArgs + 0x0001)
	push	hl
	call	_convertHex
	pop	af
	inc	sp
	call	_host_go
;device.c:469: wrk->dataToTransferEP2 = (uint8_t*) NEWLINE_MSG;
	ld	l, -16 (ix)
	ld	h, -15 (ix)
	ld	(hl), #<(_NEWLINE_MSG)
	inc	hl
	ld	(hl), #>(_NEWLINE_MSG)
;device.c:470: wrk->dataTransferLengthEP2 = sizeof (NEWLINE_MSG);
	ld	l, -14 (ix)
	ld	h, -13 (ix)
	ld	(hl), #0x05
	inc	hl
	ld	(hl), #0x00
;device.c:471: wrk->processing_command = CMD_NULL;
	ld	l, -5 (ix)
	ld	h, -4 (ix)
	ld	(hl), #0x00
;device.c:472: break;
	jp	00148$
;device.c:473: case CMD_MEMORY:
00133$:
;device.c:474: if (wrk->memory_address==0xffff)
	ld	a, -18 (ix)
	add	a, #0x4d
	ld	c, a
	ld	a, -17 (ix)
	adc	a, #0x00
	ld	b, a
	ld	l, c
	ld	h, b
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ld	a, e
	and	a, d
	inc	a
	jr	NZ, 00135$
;device.c:475: wrk->memory_address = convertHex (strMonitorCmdArgs+1,4);
	push	bc
	ld	a, #0x04
	push	af
	inc	sp
	ld	hl, #(_strMonitorCmdArgs + 0x0001)
	push	hl
	call	_convertHex
	pop	af
	inc	sp
	ex	de, hl
	pop	bc
	ld	a, e
	ld	(bc), a
	inc	bc
	ld	a, d
	ld	(bc), a
00135$:
;device.c:476: print_memory(wrk);
	pop	bc
	pop	hl
	push	hl
	push	bc
	push	hl
	call	_print_memory
	pop	af
;device.c:477: break;
	jp	00148$
;device.c:478: case CMD_RESET:
00136$:
;device.c:479: host_reset ();
	call	_host_reset
;device.c:480: wrk->dataToTransferEP2 = (uint8_t*) NEWLINE_MSG;
	ld	l, -16 (ix)
	ld	h, -15 (ix)
	ld	(hl), #<(_NEWLINE_MSG)
	inc	hl
	ld	(hl), #>(_NEWLINE_MSG)
;device.c:481: wrk->dataTransferLengthEP2 = sizeof (NEWLINE_MSG);
	ld	l, -14 (ix)
	ld	h, -13 (ix)
	ld	(hl), #0x05
	inc	hl
	ld	(hl), #0x00
;device.c:482: wrk->processing_command = CMD_NULL;
	ld	l, -5 (ix)
	ld	h, -4 (ix)
	ld	(hl), #0x00
;device.c:483: break;
	jp	00148$
;device.c:484: case CMD_BASIC:
00137$:
;device.c:485: intres = MONITOR_EXIT_BASIC;
	ld	-20 (ix), #0x06
;device.c:486: wrk->dataToTransferEP2 = (uint8_t*) NEWLINE_MSG;
	ld	l, -16 (ix)
	ld	h, -15 (ix)
	ld	(hl), #<(_NEWLINE_MSG)
	inc	hl
	ld	(hl), #>(_NEWLINE_MSG)
;device.c:487: wrk->dataTransferLengthEP2 = sizeof (NEWLINE_MSG);
	ld	l, -14 (ix)
	ld	h, -13 (ix)
	ld	(hl), #0x05
	inc	hl
	ld	(hl), #0x00
;device.c:488: wrk->processing_command = CMD_NULL;
	ld	l, -5 (ix)
	ld	h, -4 (ix)
	ld	(hl), #0x00
;device.c:489: break;
	jp	00148$
;device.c:490: case CMD_HELP:
00138$:
;device.c:491: wrk->dataToTransferEP2 = (uint8_t*) WELCOME_MSG;
	ld	l, -16 (ix)
	ld	h, -15 (ix)
	ld	(hl), #<(_WELCOME_MSG)
	inc	hl
	ld	(hl), #>(_WELCOME_MSG)
;device.c:492: wrk->dataTransferLengthEP2 = sizeof (WELCOME_MSG);
	ld	l, -14 (ix)
	ld	h, -13 (ix)
	ld	(hl), #0xe0
	inc	hl
	ld	(hl), #0x00
;device.c:493: wrk->processing_command = CMD_NULL;
	ld	l, -5 (ix)
	ld	h, -4 (ix)
	ld	(hl), #0x00
;device.c:494: break;
	jp	00148$
;device.c:495: case CMD_IHX:
00139$:
;device.c:496: *pstrMonitorCmdArgs = '\0';
	ld	hl, (_pstrMonitorCmdArgs)
	ld	(hl), #0x00
;device.c:497: uint8_t bytesWritten = handleIHX (strMonitorCmdArgs+1);
	ld	hl, #(_strMonitorCmdArgs + 0x0001)
	push	hl
	call	_handleIHX
	pop	af
	ld	a, l
;device.c:499: convertToStr (bytesWritten,ihx_bytes_processed+3);
	ld	hl, #(_ihx_bytes_processed + 0x0003)
	push	hl
	push	af
	inc	sp
	call	_convertToStr
	pop	af
	inc	sp
;device.c:500: wrk->dataToTransferEP2 = (uint8_t*) ihx_bytes_processed;
	ld	l, -16 (ix)
	ld	h, -15 (ix)
	ld	(hl), #<(_ihx_bytes_processed)
	inc	hl
	ld	(hl), #>(_ihx_bytes_processed)
;device.c:501: wrk->dataTransferLengthEP2 = sizeof (ihx_bytes_processed);
	ld	l, -14 (ix)
	ld	h, -13 (ix)
	ld	(hl), #0x22
	inc	hl
	ld	(hl), #0x00
;device.c:502: wrk->processing_command = CMD_NULL;
	ld	l, -5 (ix)
	ld	h, -4 (ix)
	ld	(hl), #0x00
;device.c:503: break;
	jp	00148$
;device.c:504: case CMD_LOAD:
00140$:
;device.c:505: *pstrMonitorCmdArgs = '\0';
	ld	hl, (_pstrMonitorCmdArgs)
	ld	(hl), #0x00
;device.c:506: if ((pstrMonitorCmdArgs-strMonitorCmdArgs)>5)
	ld	iy, #_pstrMonitorCmdArgs
	ld	a, 0 (iy)
	sub	a, #<(_strMonitorCmdArgs)
	ld	c, a
	ld	a, 1 (iy)
	sbc	a, #>(_strMonitorCmdArgs)
	ld	b, a
	ld	a, #0x05
	cp	a, c
	ld	a, #0x00
	sbc	a, b
	jp	PO, 00327$
	xor	a, #0x80
00327$:
	jp	P, 00142$
;device.c:507: host_load(convertHex (strMonitorCmdArgs+1,4),strMonitorCmdArgs+6);
	ld	a, #0x04
	push	af
	inc	sp
	ld	hl, #(_strMonitorCmdArgs + 0x0001)
	push	hl
	call	_convertHex
	pop	af
	inc	sp
	ld	de, #(_strMonitorCmdArgs + 0x0006)
	push	de
	push	hl
	call	_host_load
	pop	af
	pop	af
00142$:
;device.c:508: wrk->dataToTransferEP2 = (uint8_t*) NEWLINE_MSG;
	ld	l, -10 (ix)
	ld	h, -9 (ix)
	ld	de, #0x0045
	add	hl, de
	ld	(hl), #<(_NEWLINE_MSG)
	inc	hl
	ld	(hl), #>(_NEWLINE_MSG)
;device.c:509: wrk->dataTransferLengthEP2 = sizeof (NEWLINE_MSG);
	ld	l, -10 (ix)
	ld	h, -9 (ix)
	ld	de, #0x0049
	add	hl, de
	ld	(hl), #0x05
	inc	hl
	ld	(hl), #0x00
;device.c:510: wrk->processing_command = CMD_NULL;
	ld	l, -10 (ix)
	ld	h, -9 (ix)
	ld	de, #0x0050
	add	hl, de
	ld	(hl), #0x00
;device.c:511: break;
	jp	00148$
;device.c:512: case CMD_SAVE:
00143$:
;device.c:513: *pstrMonitorCmdArgs = '\0';
	ld	hl, (_pstrMonitorCmdArgs)
	ld	(hl), #0x00
;device.c:514: if ((pstrMonitorCmdArgs-strMonitorCmdArgs)>10)
	ld	iy, #_pstrMonitorCmdArgs
	ld	a, 0 (iy)
	sub	a, #<(_strMonitorCmdArgs)
	ld	c, a
	ld	a, 1 (iy)
	sbc	a, #>(_strMonitorCmdArgs)
	ld	b, a
	ld	a, #0x0a
	cp	a, c
	ld	a, #0x00
	sbc	a, b
	jp	PO, 00328$
	xor	a, #0x80
00328$:
	jp	P, 00145$
;device.c:515: host_save(convertHex (strMonitorCmdArgs+1,4),convertHex (strMonitorCmdArgs+6,4),strMonitorCmdArgs+11);
	ld	a, #0x04
	push	af
	inc	sp
	ld	hl, #(_strMonitorCmdArgs + 0x0006)
	push	hl
	call	_convertHex
	pop	af
	inc	sp
	push	hl
	ld	a, #0x04
	push	af
	inc	sp
	ld	hl, #(_strMonitorCmdArgs + 0x0001)
	push	hl
	call	_convertHex
	pop	af
	inc	sp
	pop	de
	ld	bc, #(_strMonitorCmdArgs + 0x000b)
	push	bc
	push	de
	push	hl
	call	_host_save
	ld	hl, #6
	add	hl, sp
	ld	sp, hl
00145$:
;device.c:516: wrk->dataToTransferEP2 = (uint8_t*) NEWLINE_MSG;
	ld	l, -12 (ix)
	ld	h, -11 (ix)
	ld	de, #0x0045
	add	hl, de
	ld	(hl), #<(_NEWLINE_MSG)
	inc	hl
	ld	(hl), #>(_NEWLINE_MSG)
;device.c:517: wrk->dataTransferLengthEP2 = sizeof (NEWLINE_MSG);
	ld	l, -12 (ix)
	ld	h, -11 (ix)
	ld	de, #0x0049
	add	hl, de
	ld	(hl), #0x05
	inc	hl
	ld	(hl), #0x00
;device.c:518: wrk->processing_command = CMD_NULL;
	ld	l, -12 (ix)
	ld	h, -11 (ix)
	ld	de, #0x0050
	add	hl, de
	ld	(hl), #0x00
;device.c:519: break;
	jr	00148$
;device.c:520: case CMD_NULL:
00146$:
;device.c:521: wrk->dataToTransferEP2 = (uint8_t*) UNKNOWN_MSG;
	ld	l, -16 (ix)
	ld	h, -15 (ix)
	ld	(hl), #<(_UNKNOWN_MSG)
	inc	hl
	ld	(hl), #>(_UNKNOWN_MSG)
;device.c:522: wrk->dataTransferLengthEP2 = sizeof (UNKNOWN_MSG);
	ld	l, -14 (ix)
	ld	h, -13 (ix)
	ld	(hl), #0x16
	inc	hl
	ld	(hl), #0x00
;device.c:527: }
00148$:
;device.c:528: if (wrk->processing_command!=CMD_NULL && pstrMonitorCmdArgs != NULL)
	ld	l, -8 (ix)
	ld	h, -7 (ix)
	ld	de, #0x0050
	add	hl, de
	ld	a, (hl)
	or	a, a
	jr	Z, 00157$
	ld	iy, #_pstrMonitorCmdArgs
	ld	a, 1 (iy)
	or	a, 0 (iy)
	jr	Z, 00157$
;device.c:529: *(pstrMonitorCmdArgs++) = value;
	ld	hl, (_pstrMonitorCmdArgs)
	ld	-5 (ix), l
	ld	-4 (ix), h
	ld	a, -6 (ix)
	ld	(hl), a
	ld	hl, (_pstrMonitorCmdArgs)
	inc	hl
	ld	(_pstrMonitorCmdArgs), hl
00157$:
;device.c:391: for (uint8_t i=0;i<length;i++)
	inc	-1 (ix)
	jp	00156$
00152$:
;device.c:533: if (wrk->dataToTransferEP2==NULL)
	ld	a, 4 (ix)
	ld	-9 (ix), a
	ld	a, 5 (ix)
	ld	-8 (ix), a
	ld	a, -9 (ix)
	add	a, #0x45
	ld	-7 (ix), a
	ld	a, -8 (ix)
	adc	a, #0x00
	ld	-6 (ix), a
	ld	l, -7 (ix)
	ld	h, -6 (ix)
	ld	a, (hl)
	ld	-5 (ix), a
	inc	hl
	ld	a, (hl)
	ld	-4 (ix), a
	or	a, -5 (ix)
	jr	NZ, 00154$
;device.c:536: wrk->dataToTransferEP2 = (uint8_t*) strMonitorEcho;
	ld	l, -7 (ix)
	ld	h, -6 (ix)
	ld	(hl), #<(_strMonitorEcho)
	inc	hl
	ld	(hl), #>(_strMonitorEcho)
;device.c:537: wrk->dataTransferLengthEP2 = pstrMonitorEcho - strMonitorEcho;
	ld	a, -9 (ix)
	add	a, #0x49
	ld	-7 (ix), a
	ld	a, -8 (ix)
	adc	a, #0x00
	ld	-6 (ix), a
	ld	a, -3 (ix)
	sub	a, #<(_strMonitorEcho)
	ld	-5 (ix), a
	ld	a, -2 (ix)
	sbc	a, #>(_strMonitorEcho)
	ld	-4 (ix), a
	ld	a, -5 (ix)
	ld	-2 (ix), a
	ld	a, -4 (ix)
	ld	-1 (ix), a
	ld	l, -7 (ix)
	ld	h, -6 (ix)
	ld	a, -2 (ix)
	ld	(hl), a
	inc	hl
	ld	a, -1 (ix)
	ld	(hl), a
00154$:
;device.c:539: writeDataForEndpoint2 (wrk);  
	ld	l, -9 (ix)
	ld	h, -8 (ix)
	push	hl
	call	_writeDataForEndpoint2
	pop	af
;device.c:541: return intres;
	ld	l, -20 (ix)
00158$:
;device.c:542: }
	ld	sp, ix
	pop	ix
	ret
;device.c:543: INTERRUPT_RESULT handleEP0SetupClass (WORKAREA* wrk)
;	---------------------------------
; Function handleEP0SetupClass
; ---------------------------------
_handleEP0SetupClass::
	push	ix
	ld	ix,#0
	add	ix,sp
	dec	sp
;device.c:545: INTERRUPT_RESULT intres = DEVICE_INTERRUPT_OKAY;
	ld	-1 (ix), #0
;device.c:549: switch (request.r.bRequest)              // Analyze the class request code and process it
	ld	hl, #_request + 1
	ld	a, (hl)
	cp	a,#0x20
	jr	Z, 00109$
	cp	a,#0x21
	jr	Z, 00102$
	sub	a, #0x22
	jr	Z, 00103$
	jr	00109$
;device.c:558: case GET_LINE_CODING: // GET_LINE_CODING
00102$:
;device.c:562: wrk->dataToTransferEP0 = (uint8_t*) &uart_parameters;
	ld	c, 4 (ix)
	ld	b, 5 (ix)
	ld	hl, #0x0043
	add	hl, bc
	ex	de, hl
	ld	a, #<(_uart_parameters)
	ld	(de), a
	inc	de
	ld	a, #>(_uart_parameters)
	ld	(de), a
;device.c:563: wrk->dataTransferLengthEP0 = min ((uint16_t) sizeof(UART_PARA),request.r.wLength);;
	ld	hl, #0x0047
	add	hl, bc
	ex	de, hl
	ld	bc, (#_request + 6)
	ld	a, #0x07
	cp	a, c
	ld	a, #0x00
	sbc	a, b
	jr	NC, 00112$
	ld	bc, #0x0007
00112$:
	ld	a, c
	ld	(de), a
	inc	de
	ld	a, b
	ld	(de), a
;device.c:564: break;
	jr	00109$
;device.c:565: case SET_CONTROL_LINE_STATE: // SET_CONTROL_LINE_STATE
00103$:
;device.c:569: sendEP0ACK ();
	call	_sendEP0ACK
;device.c:570: if (request.r.wValue && 0x01)
	ld	hl, (#_request + 2)
	ld	a, h
	or	a, l
	jr	Z, 00105$
;device.c:571: intres = DEVICE_SERIAL_CONNECTED;   
	ld	-1 (ix), #0x04
	jr	00109$
00105$:
;device.c:573: intres = DEVICE_SERIAL_DISCONNECTED;   
	ld	-1 (ix), #0x05
;device.c:580: }            
00109$:
;device.c:581: return intres;
	ld	l, -1 (ix)
;device.c:582: }
	inc	sp
	pop	ix
	ret
;device.c:583: INTERRUPT_RESULT handleEP0SetupStandard(WORKAREA* wrk)
;	---------------------------------
; Function handleEP0SetupStandard
; ---------------------------------
_handleEP0SetupStandard::
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl, #-9
	add	hl, sp
	ld	sp, hl
;device.c:585: INTERRUPT_RESULT intres = DEVICE_INTERRUPT_OKAY;
	ld	-9 (ix), #0
;device.c:589: switch(request.r.bRequest)
	ld	hl, #_request + 1
	ld	l, (hl)
	ld	a, l
	or	a, a
	jp	Z,00122$
	ld	a, l
	dec	a
	jp	Z,00122$
;device.c:597: switch (request.r.wValue>>8)
	ld	de, #_request + 2
;device.c:604: wrk->dataToTransferEP0 = (uint8_t*) DevDes;
	ld	c, 4 (ix)
	ld	b, 5 (ix)
;device.c:589: switch(request.r.bRequest)
	ld	a, l
	sub	a, #0x05
	jp	Z,00115$
;device.c:604: wrk->dataToTransferEP0 = (uint8_t*) DevDes;
	ld	a, c
	add	a, #0x43
	ld	-8 (ix), a
	ld	a, b
	adc	a, #0x00
	ld	-7 (ix), a
;device.c:605: wrk->dataTransferLengthEP0 = min ((uint16_t) sizeof(DevDes),request.r.wLength);
	ld	a, c
	add	a, #0x47
	ld	-6 (ix), a
	ld	a, b
	adc	a, #0x00
	ld	-5 (ix), a
;device.c:589: switch(request.r.bRequest)
	ld	a, l
	sub	a, #0x06
	jr	Z, 00101$
;device.c:678: wrk->dataToTransferEP0 = &(wrk->usb_configuration_id);
	ld	a, c
	add	a, #0x4c
	ld	c, a
	jr	NC, 00242$
	inc	b
00242$:
;device.c:589: switch(request.r.bRequest)
	ld	a,l
	cp	a,#0x08
	jp	Z,00112$
	sub	a, #0x09
	jp	Z,00116$
	jp	00122$
;device.c:593: case USB_REQ_GET_DESCRIPTOR:
00101$:
;device.c:597: switch (request.r.wValue>>8)
	ld	a, (de)
	ld	-4 (ix), a
	inc	de
	ld	a, (de)
	ld	-3 (ix), a
	ld	c, a
	ld	b, #0x00
	ld	-2 (ix), c
	ld	-1 (ix), b
;device.c:605: wrk->dataTransferLengthEP0 = min ((uint16_t) sizeof(DevDes),request.r.wLength);
;device.c:597: switch (request.r.wValue>>8)
	ld	a, -2 (ix)
	dec	a
	or	a, -1 (ix)
	jr	Z, 00102$
	ld	a, -2 (ix)
	sub	a, #0x02
	or	a, -1 (ix)
	jr	Z, 00103$
	ld	a, -2 (ix)
	sub	a, #0x03
	or	a, -1 (ix)
	jr	Z, 00104$
	jp	00111$
;device.c:599: case USB_DESC_DEVICE: 
00102$:
;device.c:604: wrk->dataToTransferEP0 = (uint8_t*) DevDes;
	ld	l, -8 (ix)
	ld	h, -7 (ix)
	ld	(hl), #<(_DevDes)
	inc	hl
	ld	(hl), #>(_DevDes)
;device.c:605: wrk->dataTransferLengthEP0 = min ((uint16_t) sizeof(DevDes),request.r.wLength);
	ld	bc, (#(_request + 0x0006) + 0)
	ld	a, #0x12
	cp	a, c
	ld	a, #0x00
	sbc	a, b
	jr	NC, 00125$
	ld	bc, #0x0012
00125$:
	ld	l, -6 (ix)
	ld	h, -5 (ix)
	ld	(hl), c
	inc	hl
	ld	(hl), b
;device.c:606: break;
	jp	00111$
;device.c:608: case USB_DESC_CONFIGURATION: 
00103$:
;device.c:613: wrk->dataToTransferEP0 = (uint8_t*) ConDes;
	ld	l, -8 (ix)
	ld	h, -7 (ix)
	ld	(hl), #<(_ConDes)
	inc	hl
	ld	(hl), #>(_ConDes)
;device.c:614: wrk->dataTransferLengthEP0 = min ((uint16_t) sizeof(ConDes),request.r.wLength);
	ld	bc, (#(_request + 0x0006) + 0)
	ld	a, #0x43
	cp	a, c
	ld	a, #0x00
	sbc	a, b
	jr	NC, 00127$
	ld	bc, #0x0043
00127$:
	ld	l, -6 (ix)
	ld	h, -5 (ix)
	ld	(hl), c
	inc	hl
	ld	(hl), b
;device.c:615: break;
	jp	00111$
;device.c:617: case USB_DESC_STRING: 
00104$:
;device.c:622: uint8_t stringIndex = request.r.wValue&0xff;  
	ld	a, -4 (ix)
;device.c:623: switch(stringIndex)
	or	a, a
	jr	Z, 00105$
	cp	a, #0x01
	jr	Z, 00107$
	cp	a, #0x02
	jr	Z, 00106$
	sub	a, #0x03
	jr	Z, 00108$
	jp	00111$
;device.c:625: case 0: 
00105$:
;device.c:630: wrk->dataToTransferEP0 = (uint8_t*) LangDes;
	ld	l, -8 (ix)
	ld	h, -7 (ix)
	ld	(hl), #<(_LangDes)
	inc	hl
	ld	(hl), #>(_LangDes)
;device.c:631: wrk->dataTransferLengthEP0 = min ((uint16_t) sizeof(LangDes),request.r.wLength);
	ld	bc, (#(_request + 0x0006) + 0)
	ld	a, #0x04
	cp	a, c
	ld	a, #0x00
	sbc	a, b
	jr	NC, 00129$
	ld	bc, #0x0004
00129$:
	ld	l, -6 (ix)
	ld	h, -5 (ix)
	ld	(hl), c
	inc	hl
	ld	(hl), b
;device.c:632: break;
	jp	00111$
;device.c:634: case STRING_DESC_PRODUCT: 
00106$:
;device.c:639: wrk->dataToTransferEP0 = (uint8_t*) PRODUCER_Des;
	ld	l, -8 (ix)
	ld	h, -7 (ix)
	ld	(hl), #<(_PRODUCER_Des)
	inc	hl
	ld	(hl), #>(_PRODUCER_Des)
;device.c:640: wrk->dataTransferLengthEP0 = min ((uint16_t) sizeof(PRODUCER_Des),request.r.wLength);
	ld	bc, (#(_request + 0x0006) + 0)
	ld	a, #0x1c
	cp	a, c
	ld	a, #0x00
	sbc	a, b
	jr	NC, 00131$
	ld	bc, #0x001c
00131$:
	ld	l, -6 (ix)
	ld	h, -5 (ix)
	ld	(hl), c
	inc	hl
	ld	(hl), b
;device.c:641: break;
	jr	00111$
;device.c:643: case STRING_DESC_MANUFACTURER: 
00107$:
;device.c:648: wrk->dataToTransferEP0 = (uint8_t*) MANUFACTURER_Des;
	ld	l, -8 (ix)
	ld	h, -7 (ix)
	ld	(hl), #<(_MANUFACTURER_Des)
	inc	hl
	ld	(hl), #>(_MANUFACTURER_Des)
;device.c:649: wrk->dataTransferLengthEP0 = min ((uint16_t) sizeof(MANUFACTURER_Des),request.r.wLength);
	ld	bc, (#(_request + 0x0006) + 0)
	ld	a, #0x14
	cp	a, c
	ld	a, #0x00
	sbc	a, b
	jr	NC, 00133$
	ld	bc, #0x0014
00133$:
	ld	l, -6 (ix)
	ld	h, -5 (ix)
	ld	(hl), c
	inc	hl
	ld	(hl), b
;device.c:650: break;
	jr	00111$
;device.c:652: case STRING_DESC_SERIAL:
00108$:
;device.c:657: wrk->dataToTransferEP0 = (uint8_t*) PRODUCER_SN_Des;
	ld	l, -8 (ix)
	ld	h, -7 (ix)
	ld	(hl), #<(_PRODUCER_SN_Des)
	inc	hl
	ld	(hl), #>(_PRODUCER_SN_Des)
;device.c:658: wrk->dataTransferLengthEP0 = min ((uint16_t) sizeof(PRODUCER_SN_Des),request.r.wLength);
	ld	hl, #(_request + 0x0006)
	ld	a, (hl)
	ld	-2 (ix), a
	inc	hl
	ld	a, (hl)
	ld	-1 (ix), a
	ld	a, #0x12
	cp	a, -2 (ix)
	ld	a, #0x00
	sbc	a, -1 (ix)
	jr	NC, 00135$
	ld	-2 (ix), #0x12
	ld	-1 (ix), #0
00135$:
	ld	l, -6 (ix)
	ld	h, -5 (ix)
	ld	a, -2 (ix)
	ld	(hl), a
	inc	hl
	ld	a, -1 (ix)
	ld	(hl), a
;device.c:671: }
00111$:
;device.c:672: writeDataForEndpoint0(wrk);
	ld	l, 4 (ix)
	ld	h, 5 (ix)
	push	hl
	call	_writeDataForEndpoint0
	pop	af
;device.c:673: break;                   
	jr	00122$
;device.c:674: case USB_REQ_GET_CONFIGURATION:
00112$:
;device.c:678: wrk->dataToTransferEP0 = &(wrk->usb_configuration_id);
	ld	l, -8 (ix)
	ld	h, -7 (ix)
	ld	(hl), c
	inc	hl
	ld	(hl), b
;device.c:679: wrk->dataTransferLengthEP0 = 1;
	ld	l, -6 (ix)
	ld	h, -5 (ix)
	ld	(hl), #0x01
	inc	hl
	ld	(hl), #0x00
;device.c:680: break;
	jr	00122$
;device.c:693: case USB_REQ_SET_ADDRESS:
00115$:
;device.c:694: intres = DEVICE_ADDRESS_SET;
	ld	-9 (ix), #0x02
;device.c:695: wrk->usb_device_address = request.r.wValue;
	ld	hl, #0x004b
	add	hl, bc
	ld	a, (de)
	ld	(hl), a
;device.c:699: sendEP0ACK ();
	call	_sendEP0ACK
;device.c:700: break;
	jr	00122$
;device.c:701: case USB_REQ_SET_CONFIGURATION:
00116$:
;device.c:702: intres = DEVICE_CONFIGURATION_SET;
	ld	-9 (ix), #0x03
;device.c:706: if (request.r.wValue==USB_CONFIGURATION_ID) 
	ex	de,hl
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ld	l, e
	ld	h, d
	ld	a, l
	dec	a
	or	a, h
	jr	NZ, 00118$
;device.c:707: wrk->usb_configuration_id = request.r.wValue;
	ld	a, e
	ld	(bc), a
00118$:
;device.c:708: sendEP0ACK ();
	call	_sendEP0ACK
;device.c:725: }
00122$:
;device.c:726: return intres;
	ld	l, -9 (ix)
;device.c:727: }
	ld	sp, ix
	pop	ix
	ret
;device.c:728: INTERRUPT_RESULT handleEP0Setup (WORKAREA* wrk)
;	---------------------------------
; Function handleEP0Setup
; ---------------------------------
_handleEP0Setup::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	dec	sp
;device.c:730: INTERRUPT_RESULT intres = DEVICE_INTERRUPT_OKAY;
	ld	-3 (ix), #0
;device.c:735: wrk->transaction_state = SETUP;
	ld	c, 4 (ix)
	ld	b, 5 (ix)
	ld	hl, #0x004f
	add	hl, bc
	ld	(hl), #0x00
;device.c:740: size_t length = read_usb_data (request.buffer);
	push	bc
	ld	hl, #_request
	push	hl
	call	_read_usb_data
	pop	af
	pop	bc
;device.c:749: wrk->dataTransferLengthEP0 = request.r.wLength;
	ld	hl, #0x0047
	add	hl, bc
	ld	-2 (ix), l
	ld	-1 (ix), h
	ld	de, (#_request + 6)
	ld	l, -2 (ix)
	ld	h, -1 (ix)
	ld	(hl), e
	inc	hl
	ld	(hl), d
;device.c:751: switch (request.r.bmRequestType & USB_TYPE_MASK)
	ld	a, (#_request + 0)
	and	a,#0x60
	jr	Z, 00101$
	sub	a, #0x20
	jr	Z, 00102$
	jr	00104$
;device.c:753: case USB_TYPE_STANDARD: 
00101$:
;device.c:754: intres = handleEP0SetupStandard (wrk); 
	push	bc
	call	_handleEP0SetupStandard
	pop	af
	ld	-3 (ix), l
;device.c:755: break;
	jr	00104$
;device.c:756: case USB_TYPE_CLASS:    
00102$:
;device.c:757: intres = handleEP0SetupClass (wrk); 
	push	bc
	call	_handleEP0SetupClass
	pop	af
	ld	-3 (ix), l
;device.c:764: }
00104$:
;device.c:765: return intres;
	ld	l, -3 (ix)
;device.c:766: }
	ld	sp, ix
	pop	ix
	ret
;device.c:768: void handleEP0IN (WORKAREA* wrk)
;	---------------------------------
; Function handleEP0IN
; ---------------------------------
_handleEP0IN::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
;device.c:772: if (wrk->transaction_state!=SETUP && wrk->transaction_state!=DATA) 
	ld	a, 4 (ix)
	ld	-2 (ix), a
	ld	a, 5 (ix)
	ld	-1 (ix), a
	ld	a, -2 (ix)
	add	a, #0x4f
	ld	c, a
	ld	a, -1 (ix)
	adc	a, #0x00
	ld	b, a
	ld	a, (bc)
	or	a, a
	jr	Z, 00102$
	dec	a
	jr	Z, 00102$
;device.c:777: writeCommand (CH375_CMD_UNLOCK_USB);
	ld	l, #0x23
	call	_writeCommand
;device.c:778: return;
	jr	00109$
00102$:
;device.c:780: if (wrk->dataTransferLengthEP0==0) 
	pop	de
	push	de
	ld	hl, #71
	add	hl, de
	ld	a, (hl)
	inc	hl
	or	a, (hl)
	jr	NZ, 00105$
;device.c:782: wrk->transaction_state = STATUS;
	ld	a, #0x02
	ld	(bc), a
	jr	00106$
00105$:
;device.c:789: wrk->transaction_state = DATA;
	ld	a, #0x01
	ld	(bc), a
00106$:
;device.c:795: switch(request.r.bRequest)
	ld	a, (#(_request + 0x0001) + 0)
	sub	a, #0x05
	jr	NZ, 00108$
;device.c:802: set_target_device_address (wrk->usb_device_address);
	pop	bc
	push	bc
	ld	hl, #75
	add	hl, bc
	ld	a, (hl)
	push	af
	inc	sp
	call	_set_target_device_address
	inc	sp
;device.c:804: }
00108$:
;device.c:806: writeDataForEndpoint0 (wrk);
	pop	hl
	push	hl
	push	hl
	call	_writeDataForEndpoint0
	pop	af
;device.c:807: writeCommand (CH375_CMD_UNLOCK_USB);
	ld	l, #0x23
	call	_writeCommand
00109$:
;device.c:808: }
	ld	sp, ix
	pop	ix
	ret
;device.c:809: void handleEP0OUT(WORKAREA* wrk)
;	---------------------------------
; Function handleEP0OUT
; ---------------------------------
_handleEP0OUT::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
;device.c:812: if (wrk->transaction_state!=SETUP && wrk->transaction_state!=DATA) 
	ld	e, 4 (ix)
	ld	d, 5 (ix)
	ld	hl, #0x004f
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	Z, 00102$
	dec	a
	jr	Z, 00102$
;device.c:817: sendEP0STALL();
	call	_sendEP0STALL
;device.c:818: writeCommand (CH375_CMD_UNLOCK_USB);
	ld	l, #0x23
	call	_writeCommand
;device.c:819: return;
	jr	00110$
00102$:
;device.c:821: if (wrk->dataTransferLengthEP0==0) 
	ld	hl, #0x0047
	add	hl, de
	ex	(sp), hl
	pop	hl
	push	hl
	ld	a, (hl)
	inc	hl
	or	a, (hl)
	jr	NZ, 00105$
;device.c:823: wrk->transaction_state = STATUS;
	ld	a, #0x02
	ld	(bc), a
	jr	00106$
00105$:
;device.c:830: wrk->transaction_state = DATA;
	ld	a, #0x01
	ld	(bc), a
00106$:
;device.c:837: uint8_t current_request = request.r.bRequest;
	ld	hl, #_request+1
	ld	c, (hl)
;device.c:840: size_t length = read_usb_data (request.buffer);
	push	bc
	ld	hl, #_request
	push	hl
	call	_read_usb_data
	pop	af
	pop	bc
;device.c:853: wrk->dataTransferLengthEP0 = 0;
	pop	hl
	push	hl
	xor	a, a
	ld	(hl), a
	inc	hl
	ld	(hl), a
;device.c:854: switch(current_request)
	ld	a, c
	sub	a, #0x20
	jr	NZ, 00110$
;device.c:861: sendEP0ACK ();
	call	_sendEP0ACK
;device.c:866: }
00110$:
;device.c:867: }
	ld	sp, ix
	pop	ix
	ret
;device.c:868: INTERRUPT_RESULT device_interrupt (WORKAREA* wrk, DEVICE_MODE mode)
;	---------------------------------
; Function device_interrupt
; ---------------------------------
_device_interrupt::
	push	ix
	ld	ix,#0
	add	ix,sp
	dec	sp
;device.c:870: INTERRUPT_RESULT intres = DEVICE_INTERRUPT_OKAY;
	ld	-1 (ix), #0
;device.c:873: writeCommand(CH375_CMD_GET_STATUS);
	ld	l, #0x22
	call	_writeCommand
;device.c:874: uint8_t interruptType = readData ();
	call	_readData
	ld	c, l
;device.c:876: if((interruptType & USB_BUS_RESET_MASK) == USB_INT_BUS_RESET)
	ld	e, c
	ld	d, #0x00
	ld	a, e
	and	a, #0x03
	ld	e, a
	ld	b, #0x00
	ld	a, e
	sub	a, #0x03
	or	a, b
	jr	NZ, 00102$
;device.c:877: interruptType = USB_INT_BUS_RESET;
	ld	c, #0x03
00102$:
;device.c:883: switch(interruptType)
	ld	a, #0x0c
	sub	a, c
	jp	C, 00115$
	ld	b, #0x00
	ld	hl, #00136$
	add	hl, bc
	add	hl, bc
	add	hl, bc
	jp	(hl)
00136$:
	jp	00107$
	jp	00109$
	jp	00111$
	jp	00104$
	jp	00115$
	jp	00103$
	jp	00115$
	jp	00115$
	jp	00106$
	jp	00108$
	jp	00110$
	jp	00115$
	jp	00105$
;device.c:885: case USB_INT_USB_SUSPEND:
00103$:
;device.c:886: writeCommand(CH_CMD_ENTER_SLEEP);
	ld	l, #0x03
	call	_writeCommand
;device.c:887: writeCommand (CH375_CMD_UNLOCK_USB);
	ld	l, #0x23
	call	_writeCommand
;device.c:888: break;
	jp	00116$
;device.c:889: case USB_INT_BUS_RESET:
00104$:
;device.c:890: device_reset (wrk);
	ld	l, 4 (ix)
	ld	h, 5 (ix)
	push	hl
	call	_device_reset
	pop	af
;device.c:891: writeCommand (CH375_CMD_UNLOCK_USB);
	ld	l, #0x23
	call	_writeCommand
;device.c:892: break;
	jr	00116$
;device.c:894: case USB_INT_EP0_SETUP:
00105$:
;device.c:895: intres = handleEP0Setup (wrk);
	ld	l, 4 (ix)
	ld	h, 5 (ix)
	push	hl
	call	_handleEP0Setup
	pop	af
	ld	-1 (ix), l
;device.c:896: break;
	jr	00116$
;device.c:899: case USB_INT_EP0_IN:
00106$:
;device.c:900: handleEP0IN (wrk);
	ld	l, 4 (ix)
	ld	h, 5 (ix)
	push	hl
	call	_handleEP0IN
	pop	af
;device.c:901: break;
	jr	00116$
;device.c:903: case USB_INT_EP0_OUT:
00107$:
;device.c:904: handleEP0OUT (wrk);
	ld	l, 4 (ix)
	ld	h, 5 (ix)
	push	hl
	call	_handleEP0OUT
	pop	af
;device.c:905: break;  
	jr	00116$
;device.c:907: case USB_INT_EP1_IN:
00108$:
;device.c:911: writeCommand (CH375_CMD_UNLOCK_USB);
	ld	l, #0x23
	call	_writeCommand
;device.c:912: break;
	jr	00116$
;device.c:913: case USB_INT_EP1_OUT:
00109$:
;device.c:918: length = read_usb_data (request.buffer);
	ld	hl, #_request
	push	hl
	call	_read_usb_data
	pop	af
;device.c:927: break;
	jr	00116$
;device.c:929: case USB_INT_EP2_IN:
00110$:
;device.c:932: writeDataForEndpoint2 (wrk);
	ld	l, 4 (ix)
	ld	h, 5 (ix)
	push	hl
	call	_writeDataForEndpoint2
	pop	af
;device.c:933: writeCommand (CH375_CMD_UNLOCK_USB);
	ld	l, #0x23
	call	_writeCommand
;device.c:934: break;
	jr	00116$
;device.c:935: case USB_INT_EP2_OUT:
00111$:
;device.c:936: if (mode==MONITOR_MODE)
	ld	a, 6 (ix)
	or	a, a
	jr	NZ, 00113$
;device.c:937: intres = read_and_process_data (wrk);
	ld	l, 4 (ix)
	ld	h, 5 (ix)
	push	hl
	call	_read_and_process_data
	pop	af
	ld	-1 (ix), l
	jr	00116$
00113$:
;device.c:939: read_and_send_host ();   
	call	_read_and_send_host
;device.c:940: break;
	jr	00116$
;device.c:941: default:
00115$:
;device.c:945: writeCommand (CH375_CMD_UNLOCK_USB);
	ld	l, #0x23
	call	_writeCommand
;device.c:947: }
00116$:
;device.c:948: return intres;
	ld	l, -1 (ix)
;device.c:949: }
	inc	sp
	pop	ix
	ret
;device.c:951: bool check_exists ()
;	---------------------------------
; Function check_exists
; ---------------------------------
_check_exists::
;device.c:955: writeCommand (CH375_CMD_CHECK_EXIST);
	ld	l, #0x06
	call	_writeCommand
;device.c:956: writeData(value);
	ld	l, #0xbe
	call	_writeData
;device.c:957: new_value = readData ();
	call	_readData
	ld	a, l
;device.c:963: return new_value==value;
	sub	a, #0x41
	ld	a, #0x01
	jr	Z, 00104$
	xor	a, a
00104$:
	ld	l, a
;device.c:964: }
	ret
;device.c:966: bool set_usb_host_mode (uint8_t mode)
;	---------------------------------
; Function set_usb_host_mode
; ---------------------------------
_set_usb_host_mode::
;device.c:968: writeCommand(CH375_CMD_SET_USB_MODE);
	ld	l, #0x15
	call	_writeCommand
;device.c:969: writeData(mode);
	ld	iy, #2
	add	iy, sp
	ld	l, 0 (iy)
	call	_writeData
;device.c:972: for(int i=0; i!=200; i++ )
	ld	bc, #0x0000
00105$:
	ld	a, c
	sub	a, #0xc8
	or	a, b
	jr	Z, 00103$
;device.c:974: value = readData();
	push	bc
	call	_readData
	ld	a, l
	pop	bc
;device.c:975: if ( value == CH_ST_RET_SUCCESS )
	sub	a, #0x51
	jr	NZ, 00106$
;device.c:976: return true;
	ld	l, #0x01
	ret
00106$:
;device.c:972: for(int i=0; i!=200; i++ )
	inc	bc
	jr	00105$
00103$:
;device.c:979: return false;
	ld	l, #0x00
;device.c:980: }
	ret
;device.c:982: bool device_init ()
;	---------------------------------
; Function device_init
; ---------------------------------
_device_init::
;device.c:984: if (!check_exists())
	call	_check_exists
	bit	0, l
	jr	NZ, 00102$
;device.c:985: return false;
	ld	l, #0x00
	ret
00102$:
;device.c:987: writeCommand (CH375_CMD_RESET_ALL);
	ld	l, #0x05
	call	_writeCommand
;device.c:988: host_delay (500);
	ld	hl, #0x01f4
	push	hl
	call	_host_delay
;device.c:990: if (!set_usb_host_mode(CH375_USB_MODE_DEVICE_OUTER_FW))
	ld	h,#0x01
	ex	(sp),hl
	inc	sp
	call	_set_usb_host_mode
	inc	sp
	bit	0, l
;device.c:995: return false;
;device.c:1000: return true;
	ld	l, #0x00
	ret	Z
	ld	l, #0x01
;device.c:1001: }
	ret
	.area _CODE
	.area _INITIALIZER
	.area _CABS (ABS)
