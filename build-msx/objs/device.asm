;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.0.3 #11868 (Mac OS X x86_64)
;--------------------------------------------------------
	.module device
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _set_usb_host_mode
	.globl _check_exists
	.globl _read_and_process_data
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
	.globl _reset
	.globl _millis_elapsed
	.globl _msdelay
	.globl _msx_wait
	.globl _strupr
	.globl _strlen
	.globl _host_go
	.globl _readData
	.globl _writeData
	.globl _writeCommand
	.globl _host_readByte
	.globl _host_writeByte
	.globl _host_basic_interpreter
	.globl _host_reset
	.globl _toupper
	.globl _memory_buffer
	.globl _NEWLINE_MSG
	.globl _BYTES_MSG
	.globl _UNKNOWN_MSG
	.globl _WELCOME_MSG
	.globl _transaction_state
	.globl _usb_terminal_open
	.globl _twoZeroBytes
	.globl _oneZeroByte
	.globl _oneOneByte
	.globl _PRODUCER_SN_Des
	.globl _PRODUCER_Des
	.globl _MANUFACTURER_Des
	.globl _LangDes
	.globl _ConDes
	.globl _DevDes
	.globl _payloadptr
	.globl _payload
	.globl _processing_command
	.globl _resultBuffer
	.globl _length
	.globl _request
	.globl _uart_parameters
	.globl _usb_configuration_id
	.globl _usb_device_address
	.globl _dataLength2
	.globl _dataLength
	.globl _dataToTransfer2
	.globl _dataToTransfer
	.globl _handleInterrupt
	.globl _initDevice
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_millis_elapsed_FRAME_COUNTER_65536_95	=	0xfc9e
_dataToTransfer::
	.ds 2
_dataToTransfer2::
	.ds 2
_dataLength::
	.ds 2
_dataLength2::
	.ds 2
_usb_device_address::
	.ds 1
_usb_configuration_id::
	.ds 1
_uart_parameters::
	.ds 7
_request::
	.ds 64
_length::
	.ds 2
_resultBuffer::
	.ds 65
_processing_command::
	.ds 1
_payload::
	.ds 65
_payloadptr::
	.ds 2
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
_DevDes::
	.ds 18
_ConDes::
	.ds 67
_LangDes::
	.ds 4
_MANUFACTURER_Des::
	.ds 44
_PRODUCER_Des::
	.ds 38
_PRODUCER_SN_Des::
	.ds 18
_oneOneByte::
	.ds 1
_oneZeroByte::
	.ds 1
_twoZeroBytes::
	.ds 2
_usb_terminal_open::
	.ds 1
_transaction_state::
	.ds 1
_WELCOME_MSG::
	.ds 151
_UNKNOWN_MSG::
	.ds 22
_BYTES_MSG::
	.ds 34
_NEWLINE_MSG::
	.ds 5
_memory_buffer::
	.ds 50
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
;device.c:15: char * strupr (char *str) 
;	---------------------------------
; Function strupr
; ---------------------------------
_strupr::
	push	ix
;device.c:17: char *ret = str;
	ld	hl, #0 + 4
	add	hl, sp
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
;device.c:19: while (*str)
	ld	e, c
	ld	d, b
00101$:
	ld	a, (de)
	or	a, a
	jr	Z, 00103$
;device.c:21: *str = toupper (*str);
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
;device.c:22: ++str;
	inc	de
	jr	00101$
00103$:
;device.c:25: return ret;
	ld	l, c
	ld	h, b
;device.c:26: }
	pop	ix
	ret
;device.c:64: void msx_wait (uint16_t times_jiffy)  __z88dk_fastcall __naked
;	---------------------------------
; Function msx_wait
; ---------------------------------
_msx_wait::
;device.c:78: __endasm; 
;	Wait a determined number of interrupts
;	Input: BC = number of 1/framerate interrupts to wait
;	Output: (none)
	    WAIT:
	halt	; waits 1/50th or 1/60th of a second till next interrupt
	dec	hl
	ld	a,h
	or	l
	jr	nz, WAIT
	ret
;device.c:79: }
;device.c:81: void msdelay (int milliseconds)
;	---------------------------------
; Function msdelay
; ---------------------------------
_msdelay::
;device.c:83: msx_wait (milliseconds/20);
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
;device.c:84: }
	jp	_msx_wait
;device.c:85: uint32_t millis_elapsed () 
;	---------------------------------
; Function millis_elapsed
; ---------------------------------
_millis_elapsed::
;device.c:88: return FRAME_COUNTER*20;
	ld	hl, (_millis_elapsed_FRAME_COUNTER_65536_95)
	ld	c, l
	ld	b, h
	add	hl, hl
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	ld	de, #0x0000
;device.c:89: }
	ret
;device.c:202: void reset ()
;	---------------------------------
; Function reset
; ---------------------------------
_reset::
;device.c:204: dataLength = 0;
	ld	hl, #0x0000
	ld	(_dataLength), hl
;device.c:205: dataToTransfer = NULL;
	ld	l, h
	ld	(_dataToTransfer), hl
;device.c:206: usb_device_address = 0;
	ld	hl, #_usb_device_address
	ld	(hl), #0x00
;device.c:207: usb_configuration_id = 0;
	ld	hl, #_usb_configuration_id
	ld	(hl), #0x00
;device.c:208: transaction_state = STATUS;
	ld	hl, #_transaction_state
	ld	(hl), #0x02
;device.c:209: usb_terminal_open = false;
	ld	hl, #_usb_terminal_open
	ld	(hl), #0x00
;device.c:213: }
	ret
;device.c:215: void sendEP0ACK ()
;	---------------------------------
; Function sendEP0ACK
; ---------------------------------
_sendEP0ACK::
;device.c:217: writeCommand (SET_ENDP3__TX_EP0);
	ld	l, #0x19
	call	_writeCommand
;device.c:218: writeData (SET_ENDP_ACK);
	ld	l, #0x00
;device.c:219: }
	jp	_writeData
;device.c:220: void sendEP0NAK ()
;	---------------------------------
; Function sendEP0NAK
; ---------------------------------
_sendEP0NAK::
;device.c:222: writeCommand (SET_ENDP3__TX_EP0);
	ld	l, #0x19
	call	_writeCommand
;device.c:223: writeData (SET_ENDP_NAK);
	ld	l, #0x0e
;device.c:224: }
	jp	_writeData
;device.c:225: void sendEP0STALL ()
;	---------------------------------
; Function sendEP0STALL
; ---------------------------------
_sendEP0STALL::
;device.c:227: writeCommand (SET_ENDP3__TX_EP0);
	ld	l, #0x19
	call	_writeCommand
;device.c:228: writeData (SET_ENDP_STALL);
	ld	l, #0x0f
;device.c:229: }
	jp	_writeData
;device.c:231: void writeDataForEndpoint0()
;	---------------------------------
; Function writeDataForEndpoint0
; ---------------------------------
_writeDataForEndpoint0::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
;device.c:233: int amount = min (EP0_PIPE_SIZE,dataLength);
	ld	hl, #_dataLength
	ld	a, #0x08
	cp	a, (hl)
	ld	a, #0x00
	inc	hl
	sbc	a, (hl)
	jp	PO, 00125$
	xor	a, #0x80
00125$:
	jp	P, 00107$
	ld	hl, #0x0008
	jr	00108$
00107$:
	ld	hl, (_dataLength)
00108$:
	inc	sp
	inc	sp
	push	hl
;device.c:239: writeCommand(CH_CMD_WR_EP0);
	ld	l, #0x29
	call	_writeCommand
;device.c:240: writeData(amount);
	ld	l, -2 (ix)
	call	_writeData
;device.c:241: for(int i=0; i<amount; i++) 
	ld	bc, #0x0000
00103$:
	ld	a, c
	sub	a, -2 (ix)
	ld	a, b
	sbc	a, -1 (ix)
	jp	PO, 00126$
	xor	a, #0x80
00126$:
	jp	P, 00101$
;device.c:246: writeData(dataToTransfer[i]);
	ld	hl, (_dataToTransfer)
	add	hl, bc
	ld	l, (hl)
	push	bc
	call	_writeData
	pop	bc
;device.c:241: for(int i=0; i<amount; i++) 
	inc	bc
	jr	00103$
00101$:
;device.c:251: dataToTransfer += amount;
	ld	hl, #_dataToTransfer
	ld	a, (hl)
	add	a, -2 (ix)
	ld	(hl), a
	inc	hl
	ld	a, (hl)
	adc	a, -1 (ix)
	ld	(hl), a
;device.c:252: dataLength -= amount;
	ld	hl, #_dataLength
	ld	a, (hl)
	sub	a, -2 (ix)
	ld	(hl), a
	inc	hl
	ld	a, (hl)
	sbc	a, -1 (ix)
	ld	(hl), a
;device.c:253: }
	ld	sp, ix
	pop	ix
	ret
;device.c:254: void writeDataForEndpoint2()
;	---------------------------------
; Function writeDataForEndpoint2
; ---------------------------------
_writeDataForEndpoint2::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
;device.c:256: int amount = min (BULK_OUT_ENDP_MAX_SIZE,dataLength2);
	ld	hl, #_dataLength2
	ld	a, #0x40
	cp	a, (hl)
	ld	a, #0x00
	inc	hl
	sbc	a, (hl)
	jp	PO, 00132$
	xor	a, #0x80
00132$:
	jp	P, 00109$
	ld	hl, #0x0040
	jr	00110$
00109$:
	ld	hl, (_dataLength2)
00110$:
	inc	sp
	inc	sp
	push	hl
;device.c:258: if (amount!=0)
	ld	a, -1 (ix)
	or	a, -2 (ix)
	jr	Z, 00107$
;device.c:263: writeCommand(CH_CMD_WR_EP2);
	ld	l, #0x2b
	call	_writeCommand
;device.c:264: writeData(amount);
	ld	l, -2 (ix)
	call	_writeData
;device.c:265: for(int i=0; i<amount; i++) 
	ld	bc, #0x0000
00105$:
	ld	a, c
	sub	a, -2 (ix)
	ld	a, b
	sbc	a, -1 (ix)
	jp	PO, 00133$
	xor	a, #0x80
00133$:
	jp	P, 00101$
;device.c:270: writeData(dataToTransfer2[i]);
	ld	hl, (_dataToTransfer2)
	add	hl, bc
	ld	l, (hl)
	push	bc
	call	_writeData
	pop	bc
;device.c:265: for(int i=0; i<amount; i++) 
	inc	bc
	jr	00105$
00101$:
;device.c:275: dataToTransfer2 += amount;
	ld	hl, #_dataToTransfer2
	ld	a, (hl)
	add	a, -2 (ix)
	ld	(hl), a
	inc	hl
	ld	a, (hl)
	adc	a, -1 (ix)
	ld	(hl), a
;device.c:276: dataLength2 -= amount;
	ld	hl, #_dataLength2
	ld	a, (hl)
	sub	a, -2 (ix)
	ld	(hl), a
	inc	hl
	ld	a, (hl)
	sbc	a, -1 (ix)
	ld	(hl), a
00107$:
;device.c:278: }
	ld	sp, ix
	pop	ix
	ret
;device.c:280: size_t read_usb_data (uint8_t* pBuffer)
;	---------------------------------
; Function read_usb_data
; ---------------------------------
_read_usb_data::
;device.c:283: writeCommand(CH375_CMD_RD_USB_DATA_UNLOCK);
	ld	l, #0x28
	call	_writeCommand
;device.c:284: value = readData();
	call	_readData
	ld	c, l
;device.c:285: if (value==0)
	ld	a, c
	or	a, a
	jr	NZ, 00111$
;device.c:286: return 0;
	ld	hl, #0x0000
	ret
;device.c:287: for (uint8_t i=0;i<value;i++)
00111$:
	ld	b, #0x00
00105$:
	ld	a, b
	sub	a, c
	jr	NC, 00103$
;device.c:288: *(pBuffer+i) = readData();
	ld	iy, #2
	add	iy, sp
	ld	a, 0 (iy)
	add	a, b
	ld	e, a
	ld	a, 1 (iy)
	adc	a, #0x00
	ld	d, a
	push	bc
	push	de
	call	_readData
	ld	a, l
	pop	de
	pop	bc
	ld	(de), a
;device.c:287: for (uint8_t i=0;i<value;i++)
	inc	b
	jr	00105$
00103$:
;device.c:289: return value;
	ld	h, #0x00
	ld	l, c
;device.c:290: }
	ret
;device.c:292: void set_target_device_address (uint8_t address)
;	---------------------------------
; Function set_target_device_address
; ---------------------------------
_set_target_device_address::
;device.c:294: writeCommand (CH375_CMD_SET_USB_ADDR);
	ld	l, #0x13
	call	_writeCommand
;device.c:295: writeData(address);
	ld	iy, #2
	add	iy, sp
	ld	l, 0 (iy)
;device.c:297: }
	jp	_writeData
;device.c:306: uint16_t convertHex (char* start, uint8_t len)
;	---------------------------------
; Function convertHex
; ---------------------------------
_convertHex::
	push	ix
	ld	ix,#0
	add	ix,sp
	dec	sp
;device.c:308: uint16_t result=0;
	ld	bc, #0x0000
;device.c:310: cur = start;
	ld	e, 4 (ix)
	ld	d, 5 (ix)
;device.c:311: while (len-- && *cur!='\0')
	ld	a, 6 (ix)
	ld	-1 (ix), a
00104$:
	ld	l, -1 (ix)
	dec	-1 (ix)
	ld	a, l
	or	a, a
	jr	Z, 00106$
	ld	a, (de)
	or	a, a
	jr	Z, 00106$
;device.c:313: *cur = *cur;
	ld	(de), a
;device.c:314: uint8_t dec = *cur - '0';
	add	a, #0xd0
	ld	l, a
;device.c:315: if (dec>9)
	ld	a, #0x09
	sub	a, l
	jr	NC, 00102$
;device.c:316: dec -= 7;
	ld	a, l
	add	a, #0xf9
	ld	l, a
00102$:
;device.c:317: result = (result << 4) + dec;
	sla	c
	rl	b
	sla	c
	rl	b
	sla	c
	rl	b
	sla	c
	rl	b
	ld	h, #0x00
	add	hl, bc
	ld	c, l
	ld	b, h
;device.c:318: cur++;
	inc	de
	jr	00104$
00106$:
;device.c:320: return result;
	ld	l, c
	ld	h, b
;device.c:321: }
	inc	sp
	pop	ix
	ret
;device.c:322: void convertToStr (uint8_t value, char* buffer)
;	---------------------------------
; Function convertToStr
; ---------------------------------
_convertToStr::
;device.c:324: uint8_t lo_nibble = value & 0x0f;
	ld	iy, #2
	add	iy, sp
	ld	a, 0 (iy)
	push	af
	and	a, #0x0f
	ld	c, a
	pop	af
;device.c:325: uint8_t hi_nibble = value >> 4;
	rlca
	rlca
	rlca
	rlca
	and	a, #0x0f
	ld	l, a
;device.c:327: *buffer = hi_nibble>9?hi_nibble+'A'-10:hi_nibble+'0';
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
;device.c:328: *(buffer+1) = lo_nibble>9?lo_nibble+'A'-10:lo_nibble+'0';
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
;device.c:329: }
	ret
;device.c:331: uint8_t handleIHX(char* ihxline)
;	---------------------------------
; Function handleIHX
; ---------------------------------
_handleIHX::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	dec	sp
;device.c:336: uint8_t type = convertHex (ihxline+6,2);
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
;device.c:337: if (type!=00)
	ld	a, l
	inc	sp
	or	a, a
	jr	Z, 00102$
;device.c:338: return 0;
	ld	l, #0x00
	jp	00106$
00102$:
;device.c:342: uint8_t byteCount = convertHex (ihxline,2);
	ld	a, #0x02
	push	af
	inc	sp
	ld	l, 4 (ix)
	ld	h, 5 (ix)
	push	hl
	call	_convertHex
	pop	af
	ld	b, l
	inc	sp
;device.c:343: uint16_t addressStart = convertHex (ihxline+2,4);
	ld	e, 4 (ix)
	ld	d, 5 (ix)
	inc	de
	inc	de
	push	bc
	ld	a, #0x04
	push	af
	inc	sp
	push	de
	call	_convertHex
	pop	af
	inc	sp
	pop	bc
	ex	de,hl
;device.c:349: ihxline += 8;
	ld	a, 4 (ix)
	add	a, #0x08
	ld	4 (ix), a
	jr	NC, 00124$
	inc	5 (ix)
00124$:
;device.c:350: while (byteCount--)
	ld	c, #0x00
	ld	a, 4 (ix)
	ld	-2 (ix), a
	ld	a, 5 (ix)
	ld	-1 (ix), a
00103$:
	ld	a, b
	dec	b
	or	a, a
	jr	Z, 00105$
;device.c:352: value = convertHex (ihxline,2);
	push	bc
	push	de
	ld	a, #0x02
	push	af
	inc	sp
	ld	l, -2 (ix)
	ld	h, -1 (ix)
	push	hl
	call	_convertHex
	pop	af
	inc	sp
	pop	de
	pop	bc
	ld	-3 (ix), l
;device.c:353: host_writeByte (addressStart++,value);
	ld	l, e
	ld	h, d
	inc	de
	push	bc
	push	de
	ld	a, -3 (ix)
	push	af
	inc	sp
	push	hl
	call	_host_writeByte
	pop	af
	inc	sp
	pop	de
	pop	bc
;device.c:354: bytesWritten++;
	inc	c
;device.c:355: ihxline+=2;
	ld	a, -2 (ix)
	add	a, #0x02
	ld	-2 (ix), a
	jr	NC, 00103$
	inc	-1 (ix)
	jr	00103$
00105$:
;device.c:366: return bytesWritten;
	ld	l, c
00106$:
;device.c:367: }
	ld	sp, ix
	pop	ix
	ret
;device.c:370: void print_memory (uint16_t address)
;	---------------------------------
; Function print_memory
; ---------------------------------
_print_memory::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
;device.c:372: dataToTransfer2 = memory_buffer;
	ld	bc, #_memory_buffer+0
	ld	(_dataToTransfer2), bc
;device.c:373: dataLength2 = sizeof (memory_buffer);
	ld	hl, #0x0032
	ld	(_dataLength2), hl
;device.c:375: convertToStr (address>>8,memory_buffer+5);
	ld	hl, #(_memory_buffer + 0x0005)
	ld	d, 5 (ix)
	ld	e, #0x00
	push	bc
	push	hl
	push	de
	inc	sp
	call	_convertToStr
	pop	af
	inc	sp
	pop	bc
;device.c:376: convertToStr (address&0xff,memory_buffer+7);
	ld	de, #(_memory_buffer + 0x0007)
	ld	a, 4 (ix)
	push	bc
	push	de
	push	af
	inc	sp
	call	_convertToStr
	pop	af
	inc	sp
	pop	bc
;device.c:377: char* membufptr = memory_buffer+11;
	ld	bc, #(_memory_buffer + 0x000b)
;device.c:378: for (int i=0;i<0x10;i++)
	ld	de, #0x0000
00103$:
	ld	a, e
	sub	a, #0x10
	ld	a, d
	rla
	ccf
	rra
	sbc	a, #0x80
	jr	NC, 00105$
;device.c:380: convertToStr (host_readByte(address+i),membufptr);
	ld	l, 4 (ix)
	ld	h, 5 (ix)
	inc	sp
	inc	sp
	push	de
	ld	a, -2 (ix)
	add	a, l
	ld	l, a
	ld	a, -1 (ix)
	adc	a, h
	ld	h, a
	push	bc
	push	de
	push	hl
	call	_host_readByte
	pop	af
	ld	a, l
	pop	de
	pop	bc
	push	bc
	push	de
	push	bc
	push	af
	inc	sp
	call	_convertToStr
	pop	af
	inc	sp
	pop	de
	pop	bc
;device.c:381: membufptr+=2;
	inc	bc
	inc	bc
;device.c:378: for (int i=0;i<0x10;i++)
	inc	de
	jr	00103$
00105$:
;device.c:383: }
	ld	sp, ix
	pop	ix
	ret
;device.c:398: void read_and_process_data()
;	---------------------------------
; Function read_and_process_data
; ---------------------------------
_read_and_process_data::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	push	af
	dec	sp
;device.c:402: writeCommand(CH375_CMD_RD_USB_DATA_UNLOCK);
	ld	l, #0x28
	call	_writeCommand
;device.c:403: length = readData(); // read length
	call	_readData
	ld	c, l
	ld	-5 (ix), c
;device.c:404: if (length==0)
	ld	a, c
	or	a, a
;device.c:405: return;
	jp	Z,00132$
;device.c:409: char* resultptr = resultBuffer;
	ld	-3 (ix), #<(_resultBuffer)
	ld	-2 (ix), #>(_resultBuffer)
;device.c:410: dataToTransfer2 = NULL;
	ld	hl, #0x0000
	ld	(_dataToTransfer2), hl
;device.c:411: dataLength2 = 0;
	ld	l, h
	ld	(_dataLength2), hl
;device.c:413: for (uint8_t i=0;i<length;i++)
	ld	-1 (ix), #0
00130$:
	ld	a, -1 (ix)
	sub	a, -5 (ix)
	jp	NC, 00126$
;device.c:415: value = readData();
	call	_readData
	ld	-4 (ix), l
;device.c:417: if (processing_command!=CMD_IHX && value!=':')
	ld	a,(#_processing_command + 0)
	sub	a, #0x04
	jr	Z, 00104$
	ld	a, -4 (ix)
	sub	a, #0x3a
	jr	Z, 00104$
;device.c:418: *resultptr++ = value;
	pop	bc
	pop	hl
	push	hl
	push	bc
	ld	a, -4 (ix)
	ld	(hl), a
	inc	-3 (ix)
	jr	NZ, 00217$
	inc	-2 (ix)
00217$:
00104$:
;device.c:421: switch (toupper(value))
	ld	c, -4 (ix)
	ld	b, #0x00
	push	bc
	call	_toupper
	pop	af
	ld	e, l
	ld	d, h
;device.c:473: *payloadptr = '\0';
	ld	bc, (_payloadptr)
;device.c:421: switch (toupper(value))
	ld	a, e
	sub	a, #0x0d
	or	a, d
	jp	Z,00112$
	ld	a, e
	sub	a, #0x3a
	or	a, d
	jr	Z, 00111$
	ld	a, e
	sub	a, #0x47
	or	a, d
	jr	Z, 00106$
	ld	a, e
	sub	a, #0x48
	or	a, d
	jr	Z, 00110$
	ld	a, e
	sub	a, #0x4d
	or	a, d
	jr	Z, 00107$
	ld	a, e
	sub	a, #0x52
	or	a, d
	jr	Z, 00108$
	ld	a, e
	sub	a, #0x58
	or	a, d
	jr	Z, 00109$
	jp	00121$
;device.c:423: case 'G': 
00106$:
;device.c:424: processing_command = CMD_GO; 
	ld	iy, #_processing_command
	ld	0 (iy), #0x01
;device.c:425: payloadptr = payload;
	ld	iy, #_payloadptr
	ld	0 (iy), #<(_payload)
	ld	1 (iy), #>(_payload)
;device.c:426: break;
	jp	00131$
;device.c:427: case 'M': 
00107$:
;device.c:428: processing_command = CMD_MEMORY; 
	ld	iy, #_processing_command
	ld	0 (iy), #0x06
;device.c:429: payloadptr = payload;
	ld	iy, #_payloadptr
	ld	0 (iy), #<(_payload)
	ld	1 (iy), #>(_payload)
;device.c:430: break;
	jp	00131$
;device.c:431: case 'R': 
00108$:
;device.c:432: processing_command = CMD_RESET; 
	ld	hl, #_processing_command
	ld	(hl), #0x02
;device.c:433: payloadptr = NULL;
	ld	hl, #0x0000
	ld	(_payloadptr), hl
;device.c:434: break;
	jp	00131$
;device.c:435: case 'X': 
00109$:
;device.c:436: processing_command = CMD_BASIC; 
	ld	hl, #_processing_command
	ld	(hl), #0x03
;device.c:437: payloadptr = NULL;
	ld	hl, #0x0000
	ld	(_payloadptr), hl
;device.c:438: break;
	jp	00131$
;device.c:439: case 'H': 
00110$:
;device.c:440: processing_command = CMD_HELP; 
	ld	hl, #_processing_command
	ld	(hl), #0x05
;device.c:441: payloadptr = NULL;
	ld	hl, #0x0000
	ld	(_payloadptr), hl
;device.c:442: break;
	jp	00131$
;device.c:443: case ':': 
00111$:
;device.c:444: processing_command = CMD_IHX; 
	ld	iy, #_processing_command
	ld	0 (iy), #0x04
;device.c:445: payloadptr = payload;
	ld	iy, #_payloadptr
	ld	0 (iy), #<(_payload)
	ld	1 (iy), #>(_payload)
;device.c:446: break;
	jp	00131$
;device.c:447: case '\r':
00112$:
;device.c:448: switch (processing_command)
	ld	a, #0x06
	ld	hl, #_processing_command
	sub	a, (hl)
	jp	C, 00120$
;device.c:451: host_go(convertHex (payload,payloadptr-payload));
	ld	hl, #_payloadptr
	ld	e, (hl)
;device.c:448: switch (processing_command)
	push	de
	ld	iy, #_processing_command
	ld	e, 0 (iy)
	ld	d, #0x00
	ld	hl, #00225$
	add	hl, de
	add	hl, de
	add	hl, de
	pop	de
	jp	(hl)
00225$:
	jp	00119$
	jp	00113$
	jp	00115$
	jp	00116$
	jp	00118$
	jp	00117$
	jp	00114$
;device.c:450: case CMD_GO:
00113$:
;device.c:451: host_go(convertHex (payload,payloadptr-payload));
	ld	c, #<(_payload)
	ld	a, e
	sub	a, c
	ld	b, a
	push	bc
	inc	sp
	ld	hl, #_payload
	push	hl
	call	_convertHex
	pop	af
	inc	sp
	push	hl
	call	_host_go
	pop	af
;device.c:452: dataToTransfer2 = (uint8_t*) NEWLINE_MSG;
	ld	iy, #_dataToTransfer2
	ld	0 (iy), #<(_NEWLINE_MSG)
	ld	1 (iy), #>(_NEWLINE_MSG)
;device.c:453: dataLength2 = sizeof (NEWLINE_MSG);
	ld	hl, #0x0005
	ld	(_dataLength2), hl
;device.c:454: break;
	jp	00120$
;device.c:455: case CMD_MEMORY:
00114$:
;device.c:456: print_memory(convertHex (payload,payloadptr-payload));
	ld	c, #<(_payload)
	ld	a, e
	sub	a, c
	ld	b, a
	push	bc
	inc	sp
	ld	hl, #_payload
	push	hl
	call	_convertHex
	pop	af
	inc	sp
	push	hl
	call	_print_memory
	pop	af
;device.c:457: break;
	jp	00120$
;device.c:458: case CMD_RESET:
00115$:
;device.c:459: host_reset ();
	call	_host_reset
;device.c:460: dataToTransfer2 = (uint8_t*) NEWLINE_MSG;
	ld	iy, #_dataToTransfer2
	ld	0 (iy), #<(_NEWLINE_MSG)
	ld	1 (iy), #>(_NEWLINE_MSG)
;device.c:461: dataLength2 = sizeof (NEWLINE_MSG);
	ld	hl, #0x0005
	ld	(_dataLength2), hl
;device.c:462: break;
	jr	00120$
;device.c:463: case CMD_BASIC:
00116$:
;device.c:464: host_basic_interpreter();
	call	_host_basic_interpreter
;device.c:465: dataToTransfer2 = (uint8_t*) NEWLINE_MSG;
	ld	iy, #_dataToTransfer2
	ld	0 (iy), #<(_NEWLINE_MSG)
	ld	1 (iy), #>(_NEWLINE_MSG)
;device.c:466: dataLength2 = sizeof (NEWLINE_MSG);
	ld	hl, #0x0005
	ld	(_dataLength2), hl
;device.c:467: break;
	jr	00120$
;device.c:468: case CMD_HELP:
00117$:
;device.c:469: dataToTransfer2 = (uint8_t*) WELCOME_MSG;
	ld	iy, #_dataToTransfer2
	ld	0 (iy), #<(_WELCOME_MSG)
	ld	1 (iy), #>(_WELCOME_MSG)
;device.c:470: dataLength2 = sizeof (WELCOME_MSG);
	ld	hl, #0x0097
	ld	(_dataLength2), hl
;device.c:471: break;
	jr	00120$
;device.c:472: case CMD_IHX:
00118$:
;device.c:473: *payloadptr = '\0';
	xor	a, a
	ld	(bc), a
;device.c:474: uint8_t bytesWritten = handleIHX (payload);
	ld	hl, #_payload
	push	hl
	call	_handleIHX
	pop	af
;device.c:476: convertToStr (bytesWritten,BYTES_MSG+3);
	ld	de, #(_BYTES_MSG + 0x0003)
	push	de
	ld	a, l
	push	af
	inc	sp
	call	_convertToStr
	pop	af
	inc	sp
;device.c:477: dataToTransfer2 = (uint8_t*) BYTES_MSG;
	ld	iy, #_dataToTransfer2
	ld	0 (iy), #<(_BYTES_MSG)
	ld	1 (iy), #>(_BYTES_MSG)
;device.c:478: dataLength2 = sizeof (BYTES_MSG);
	ld	hl, #0x0022
	ld	(_dataLength2), hl
;device.c:479: break;
	jr	00120$
;device.c:480: case CMD_NULL:
00119$:
;device.c:481: dataToTransfer2 = (uint8_t*) UNKNOWN_MSG;
	ld	iy, #_dataToTransfer2
	ld	0 (iy), #<(_UNKNOWN_MSG)
	ld	1 (iy), #>(_UNKNOWN_MSG)
;device.c:482: dataLength2 = sizeof (UNKNOWN_MSG);
	ld	hl, #0x0016
	ld	(_dataLength2), hl
;device.c:484: }
00120$:
;device.c:485: processing_command = CMD_NULL;
	ld	hl, #_processing_command
	ld	(hl), #0x00
;device.c:486: break;
	jr	00131$
;device.c:487: default:
00121$:
;device.c:488: if (processing_command!=CMD_NULL && payloadptr != NULL)
	ld	a,(#_processing_command + 0)
	or	a, a
	jr	Z, 00131$
	ld	iy, #_payloadptr
	ld	a, 1 (iy)
	or	a, 0 (iy)
	jr	Z, 00131$
;device.c:489: *(payloadptr++) = value;
	ld	a, -4 (ix)
	ld	(bc), a
	ld	hl, (_payloadptr)
	inc	hl
	ld	(_payloadptr), hl
;device.c:490: }
00131$:
;device.c:413: for (uint8_t i=0;i<length;i++)
	inc	-1 (ix)
	jp	00130$
00126$:
;device.c:494: if (dataToTransfer2==NULL)
	ld	iy, #_dataToTransfer2
	ld	a, 1 (iy)
	or	a, 0 (iy)
	jr	NZ, 00128$
;device.c:497: dataToTransfer2 = (uint8_t*) resultBuffer;
	ld	hl, #_resultBuffer
	ld	(_dataToTransfer2), hl
;device.c:498: dataLength2 = resultptr - resultBuffer;
	ld	hl, #_dataLength2
	ld	a, -3 (ix)
	sub	a, #<(_resultBuffer)
	ld	(hl), a
	ld	a, -2 (ix)
	sbc	a, #>(_resultBuffer)
	inc	hl
	ld	(hl), a
00128$:
;device.c:500: writeDataForEndpoint2 ();  
	call	_writeDataForEndpoint2
00132$:
;device.c:501: }
	ld	sp, ix
	pop	ix
	ret
;device.c:504: void handleInterrupt ()
;	---------------------------------
; Function handleInterrupt
; ---------------------------------
_handleInterrupt::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	push	af
;device.c:507: writeCommand(CH375_CMD_GET_STATUS);
	ld	l, #0x22
	call	_writeCommand
;device.c:508: uint8_t interruptType = readData ();
	call	_readData
;device.c:510: if((interruptType & USB_BUS_RESET_MASK) == USB_INT_BUS_RESET)
	ld	-1 (ix), l
	ld	a, l
	and	a, #0x03
	ld	c, a
	ld	b, #0x00
	ld	a, c
	sub	a, #0x03
	or	a, b
	jr	NZ, 00102$
;device.c:511: interruptType = USB_INT_BUS_RESET;
	ld	-1 (ix), #0x03
00102$:
;device.c:517: switch(interruptType)
	ld	a, #0x0c
	sub	a, -1 (ix)
	jp	C, 00169$
	ld	c, -1 (ix)
	ld	b, #0x00
	ld	hl, #00386$
	add	hl, bc
	add	hl, bc
	add	hl, bc
	jp	(hl)
00386$:
	jp	00155$
	jp	00166$
	jp	00168$
	jp	00104$
	jp	00169$
	jp	00103$
	jp	00169$
	jp	00169$
	jp	00146$
	jp	00165$
	jp	00167$
	jp	00169$
	jp	00105$
;device.c:519: case USB_INT_USB_SUSPEND:
00103$:
;device.c:520: writeCommand(CH_CMD_ENTER_SLEEP);
	ld	l, #0x03
	call	_writeCommand
;device.c:521: writeCommand (CH375_CMD_UNLOCK_USB);
	ld	l, #0x23
	call	_writeCommand
;device.c:522: break;
	jp	00171$
;device.c:523: case USB_INT_BUS_RESET:
00104$:
;device.c:525: reset ();
	call	_reset
;device.c:526: writeCommand (CH375_CMD_UNLOCK_USB);
	ld	l, #0x23
	call	_writeCommand
;device.c:527: break;
	jp	00171$
;device.c:529: case USB_INT_EP0_SETUP:
00105$:
;device.c:535: transaction_state = SETUP;
	ld	hl, #_transaction_state
	ld	(hl), #0x00
;device.c:540: int length = read_usb_data (request.buffer);
	ld	hl, #_request
	push	hl
	call	_read_usb_data
	pop	af
;device.c:549: dataLength = request.r.wLength;
	ld	hl, (#(_request + 0x0006) + 0)
	ld	(_dataLength), hl
;device.c:557: if ((request.r.bmRequestType & USB_TYPE_MASK)==USB_TYPE_CLASS)
	ld	a, (#_request + 0)
	and	a, #0x60
	sub	a, #0x20
	jr	NZ, 00116$
;device.c:562: switch (request.r.bRequest)              // Analyze the class request code and process it
	ld	a, (#_request + 1)
	cp	a, #0x20
	jr	Z, 00116$
	cp	a, #0x21
	jr	Z, 00107$
	sub	a, #0x22
	jr	Z, 00108$
	jr	00116$
;device.c:571: case GET_LINE_CODING: // GET_LINE_CODING
00107$:
;device.c:575: dataToTransfer = (uint8_t*) &uart_parameters;
	ld	hl, #_uart_parameters+0
	ld	(_dataToTransfer), hl
;device.c:576: dataLength = min ((uint16_t) sizeof(UART_PARA),request.r.wLength);;
	ld	bc, (#(_request + 0x0006) + 0)
	ld	a, #0x07
	cp	a, c
	ld	a, #0x00
	sbc	a, b
	jr	NC, 00173$
	ld	bc, #0x0007
00173$:
	ld	(_dataLength), bc
;device.c:577: break;
	jr	00116$
;device.c:578: case SET_CONTROL_LINE_STATE: // SET_CONTROL_LINE_STATE
00108$:
;device.c:582: sendEP0ACK ();
	call	_sendEP0ACK
;device.c:583: if (request.r.wValue && 0x01)
	ld	hl, (#_request + 2)
	ld	a, h
	or	a, l
	jr	Z, 00110$
;device.c:585: usb_terminal_open = true;   
	ld	hl, #_usb_terminal_open
	ld	(hl), #0x01
;device.c:587: dataToTransfer2 = (uint8_t*) WELCOME_MSG;
	ld	bc, #_WELCOME_MSG+0
	ld	(_dataToTransfer2), bc
;device.c:588: dataLength2 = strlen (WELCOME_MSG);
	push	bc
	call	_strlen
	pop	af
	ld	(_dataLength2), hl
;device.c:589: writeDataForEndpoint2 ();
	call	_writeDataForEndpoint2
	jr	00116$
00110$:
;device.c:592: usb_terminal_open = false;   
	ld	hl, #_usb_terminal_open
	ld	(hl), #0x00
;device.c:600: }                    
00116$:
;device.c:602: if ((request.r.bmRequestType & USB_TYPE_MASK)==USB_TYPE_STANDARD)
	ld	a, (#_request + 0)
	and	a, #0x60
	jp	NZ,00171$
;device.c:607: if ((request.r.bmRequestType & USB_DIR_MASK) == USB_DIR_IN) // IN
	ld	a, (#_request + 0)
	and	a, #0x80
	ld	c, a
	ld	b, #0x00
	ld	a, c
	sub	a, #0x80
	or	a, b
	jp	NZ,00142$
;device.c:612: switch(request.r.bRequest)
	ld	a, (#_request + 1)
	or	a, a
	jp	Z,00171$
	cp	a, #0x06
	jr	Z, 00117$
	sub	a, #0x08
	jp	Z,00128$
	jp	00171$
;device.c:614: case USB_REQ_GET_DESCRIPTOR:
00117$:
;device.c:619: switch (request.r.wValue>>8)
	ld	hl, #_request + 2
	ld	a, (hl)
	ld	-4 (ix), a
	inc	hl
	ld	a, (hl)
	ld	-3 (ix), a
	ld	c, a
	ld	b, #0x00
	ld	-2 (ix), c
	ld	-1 (ix), b
	ld	a, -2 (ix)
	dec	a
	or	a, -1 (ix)
	jr	Z, 00118$
	ld	a, -2 (ix)
	sub	a, #0x02
	or	a, -1 (ix)
	jr	Z, 00119$
	ld	a, -2 (ix)
	sub	a, #0x03
	or	a, -1 (ix)
	jr	Z, 00120$
	jp	00127$
;device.c:621: case USB_DESC_DEVICE: 
00118$:
;device.c:626: dataToTransfer = DevDes;
	ld	hl, #_DevDes+0
	ld	(_dataToTransfer), hl
;device.c:627: dataLength = min ((uint16_t) sizeof(DevDes),request.r.wLength);
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
	jr	NC, 00175$
	ld	-2 (ix), #0x12
	xor	a, a
	ld	-1 (ix), a
00175$:
	ld	l, -2 (ix)
	ld	h, -1 (ix)
	ld	(_dataLength), hl
;device.c:628: break;
	jp	00127$
;device.c:630: case USB_DESC_CONFIGURATION: 
00119$:
;device.c:635: dataToTransfer = ConDes;
	ld	hl, #_ConDes+0
	ld	(_dataToTransfer), hl
;device.c:636: dataLength = min ((uint16_t) sizeof(ConDes),request.r.wLength);
	ld	hl, #(_request + 0x0006)
	ld	a, (hl)
	ld	-2 (ix), a
	inc	hl
	ld	a, (hl)
	ld	-1 (ix), a
	ld	a, #0x43
	cp	a, -2 (ix)
	ld	a, #0x00
	sbc	a, -1 (ix)
	jr	NC, 00177$
	ld	-2 (ix), #0x43
	xor	a, a
	ld	-1 (ix), a
00177$:
	ld	l, -2 (ix)
	ld	h, -1 (ix)
	ld	(_dataLength), hl
;device.c:637: break;
	jp	00127$
;device.c:639: case USB_DESC_STRING: 
00120$:
;device.c:644: uint8_t stringIndex = request.r.wValue&0xff;  
	ld	a, -4 (ix)
;device.c:645: switch(stringIndex)
	or	a, a
	jr	Z, 00121$
	cp	a, #0x01
	jr	Z, 00123$
	cp	a, #0x02
	jr	Z, 00122$
	sub	a, #0x03
	jr	Z, 00124$
	jr	00127$
;device.c:647: case 0: 
00121$:
;device.c:652: dataToTransfer = LangDes;
	ld	hl, #_LangDes+0
	ld	(_dataToTransfer), hl
;device.c:653: dataLength = min ((uint16_t) sizeof(LangDes),request.r.wLength);
	ld	bc, (#(_request + 0x0006) + 0)
	ld	a, #0x04
	cp	a, c
	ld	a, #0x00
	sbc	a, b
	jr	NC, 00179$
	ld	bc, #0x0004
00179$:
	ld	(_dataLength), bc
;device.c:654: break;
	jr	00127$
;device.c:656: case STRING_DESC_PRODUCT: 
00122$:
;device.c:661: dataToTransfer = PRODUCER_Des;
	ld	hl, #_PRODUCER_Des+0
	ld	(_dataToTransfer), hl
;device.c:662: dataLength = min ((uint16_t) sizeof(PRODUCER_Des),request.r.wLength);
	ld	bc, (#(_request + 0x0006) + 0)
	ld	a, #0x26
	cp	a, c
	ld	a, #0x00
	sbc	a, b
	jr	NC, 00181$
	ld	bc, #0x0026
00181$:
	ld	(_dataLength), bc
;device.c:663: break;
	jr	00127$
;device.c:665: case STRING_DESC_MANUFACTURER: 
00123$:
;device.c:670: dataToTransfer = MANUFACTURER_Des;
	ld	hl, #_MANUFACTURER_Des+0
	ld	(_dataToTransfer), hl
;device.c:671: dataLength = min ((uint16_t) sizeof(MANUFACTURER_Des),request.r.wLength);
	ld	bc, (#(_request + 0x0006) + 0)
	ld	a, #0x2c
	cp	a, c
	ld	a, #0x00
	sbc	a, b
	jr	NC, 00183$
	ld	bc, #0x002c
00183$:
	ld	(_dataLength), bc
;device.c:672: break;
	jr	00127$
;device.c:674: case STRING_DESC_SERIAL:
00124$:
;device.c:679: dataToTransfer = PRODUCER_SN_Des;
	ld	hl, #_PRODUCER_SN_Des+0
	ld	(_dataToTransfer), hl
;device.c:680: dataLength = min ((uint16_t) sizeof(PRODUCER_SN_Des),request.r.wLength);
	ld	bc, (#(_request + 0x0006) + 0)
	ld	a, #0x12
	cp	a, c
	ld	a, #0x00
	sbc	a, b
	jr	NC, 00185$
	ld	bc, #0x0012
00185$:
	ld	(_dataLength), bc
;device.c:693: }
00127$:
;device.c:694: writeDataForEndpoint0();
	call	_writeDataForEndpoint0
;device.c:695: break;                   
	jp	00171$
;device.c:697: case USB_REQ_GET_CONFIGURATION:
00128$:
;device.c:701: dataToTransfer = &usb_configuration_id;
	ld	hl, #_usb_configuration_id+0
	ld	(_dataToTransfer), hl
;device.c:702: dataLength = 1;
	ld	hl, #0x0001
	ld	(_dataLength), hl
;device.c:703: break;
	jp	00171$
;device.c:719: }
00142$:
;device.c:726: switch(request.r.bRequest)
	ld	a, (#_request + 1)
	cp	a, #0x01
	jp	Z,00171$
	cp	a, #0x05
	jr	Z, 00133$
	sub	a, #0x09
	jr	Z, 00134$
	jp	00171$
;device.c:728: case USB_REQ_SET_ADDRESS:
00133$:
;device.c:730: usb_device_address = request.r.wValue;
	ld	a, (#_request + 2)
	ld	(_usb_device_address+0), a
;device.c:735: sendEP0ACK ();
	call	_sendEP0ACK
;device.c:736: break;
	jp	00171$
;device.c:738: case USB_REQ_SET_CONFIGURATION:
00134$:
;device.c:743: if (request.r.wValue==USB_CONFIGURATION_ID) 
	ld	hl, (#_request + 2)
	ld	c, l
	ld	b, h
	ld	a, c
	dec	a
	or	a, b
	jr	NZ, 00136$
;device.c:744: usb_configuration_id = request.r.wValue;
	ld	a, l
	ld	(#_usb_configuration_id), a
00136$:
;device.c:745: sendEP0ACK ();
	call	_sendEP0ACK
;device.c:746: break; 
	jp	00171$
;device.c:774: case USB_INT_EP0_IN:
00146$:
;device.c:776: if (transaction_state!=SETUP && transaction_state!=DATA) 
	ld	iy, #_transaction_state
	ld	a, 0 (iy)
	or	a, a
	jr	Z, 00148$
	ld	a, 0 (iy)
	dec	a
	jr	Z, 00148$
;device.c:781: writeCommand (CH375_CMD_UNLOCK_USB);
	ld	l, #0x23
	call	_writeCommand
;device.c:782: break;
	jp	00171$
00148$:
;device.c:784: if (dataLength==0) {
	ld	iy, #_dataLength
	ld	a, 1 (iy)
	or	a, 0 (iy)
	jr	NZ, 00151$
;device.c:785: transaction_state = STATUS;
	ld	hl, #_transaction_state
	ld	(hl), #0x02
	jr	00152$
00151$:
;device.c:791: transaction_state = DATA;
	ld	hl, #_transaction_state
	ld	(hl), #0x01
00152$:
;device.c:797: switch(request.r.bRequest)
	ld	a, (#(_request + 0x0001) + 0)
	sub	a, #0x05
	jr	NZ, 00154$
;device.c:805: set_target_device_address (usb_device_address);
	ld	a,(#_usb_device_address + 0)
	push	af
	inc	sp
	call	_set_target_device_address
	inc	sp
;device.c:808: }
00154$:
;device.c:810: writeDataForEndpoint0 ();
	call	_writeDataForEndpoint0
;device.c:811: writeCommand (CH375_CMD_UNLOCK_USB);
	ld	l, #0x23
	call	_writeCommand
;device.c:812: break;
	jp	00171$
;device.c:815: case USB_INT_EP0_OUT:
00155$:
;device.c:817: if (transaction_state!=SETUP && transaction_state!=DATA) 
	ld	iy, #_transaction_state
	ld	a, 0 (iy)
	or	a, a
	jr	Z, 00157$
	ld	a, 0 (iy)
	dec	a
	jr	Z, 00157$
;device.c:822: sendEP0STALL();
	call	_sendEP0STALL
;device.c:823: writeCommand (CH375_CMD_UNLOCK_USB);
	ld	l, #0x23
	call	_writeCommand
;device.c:824: break;
	jr	00171$
00157$:
;device.c:826: if (dataLength==0) 
	ld	iy, #_dataLength
	ld	a, 1 (iy)
	or	a, 0 (iy)
	jr	NZ, 00160$
;device.c:828: transaction_state = STATUS;
	ld	hl, #_transaction_state
	ld	(hl), #0x02
	jr	00161$
00160$:
;device.c:835: transaction_state = DATA;
	ld	hl, #_transaction_state
	ld	(hl), #0x01
00161$:
;device.c:842: uint8_t current_request = request.r.bRequest;
	ld	hl, #(_request + 0x0001)
	ld	c, (hl)
;device.c:845: length = read_usb_data (request.buffer);
	push	bc
	ld	hl, #_request
	push	hl
	call	_read_usb_data
	pop	af
	pop	bc
	ld	(_length), hl
;device.c:846: length = min (length,request.r.wLength);
	ld	de, (#(_request + 0x0006) + 0)
	ld	hl, (_length)
	ld	a, l
	sub	a, e
	ld	a, h
	sbc	a, d
	jr	NC, 00187$
	ld	e, l
	ld	d, h
00187$:
	ld	(_length), de
;device.c:858: dataLength = 0;
	ld	hl, #0x0000
	ld	(_dataLength), hl
;device.c:859: switch(current_request)
	ld	a, c
	sub	a, #0x20
	jr	NZ, 00171$
;device.c:867: sendEP0ACK ();
	call	_sendEP0ACK
;device.c:868: break;
	jr	00171$
;device.c:879: case USB_INT_EP1_IN:
00165$:
;device.c:883: writeCommand (CH375_CMD_UNLOCK_USB);
	ld	l, #0x23
	call	_writeCommand
;device.c:884: break;
	jr	00171$
;device.c:885: case USB_INT_EP1_OUT:
00166$:
;device.c:890: length = read_usb_data (request.buffer);
	ld	hl, #_request
	push	hl
	call	_read_usb_data
	pop	af
	ld	(_length), hl
;device.c:899: break;
	jr	00171$
;device.c:901: case USB_INT_EP2_IN:
00167$:
;device.c:904: writeDataForEndpoint2 ();
	call	_writeDataForEndpoint2
;device.c:905: writeCommand (CH375_CMD_UNLOCK_USB);
	ld	l, #0x23
	call	_writeCommand
;device.c:906: break;
	jr	00171$
;device.c:907: case USB_INT_EP2_OUT:
00168$:
;device.c:908: read_and_process_data ();
	call	_read_and_process_data
;device.c:909: break;
	jr	00171$
;device.c:910: default:
00169$:
;device.c:914: writeCommand (CH375_CMD_UNLOCK_USB);
	ld	l, #0x23
	call	_writeCommand
;device.c:916: }
00171$:
;device.c:917: }
	ld	sp, ix
	pop	ix
	ret
;device.c:919: bool check_exists ()
;	---------------------------------
; Function check_exists
; ---------------------------------
_check_exists::
;device.c:923: writeCommand (CH375_CMD_CHECK_EXIST);
	ld	l, #0x06
	call	_writeCommand
;device.c:924: writeData(value);
	ld	l, #0xbe
	call	_writeData
;device.c:925: new_value = readData ();
	call	_readData
	ld	a, l
;device.c:931: return new_value==value;
	sub	a, #0x41
	ld	a, #0x01
	jr	Z, 00104$
	xor	a, a
00104$:
	ld	l, a
;device.c:932: }
	ret
;device.c:934: bool set_usb_host_mode (uint8_t mode)
;	---------------------------------
; Function set_usb_host_mode
; ---------------------------------
_set_usb_host_mode::
;device.c:936: writeCommand(CH375_CMD_SET_USB_MODE);
	ld	l, #0x15
	call	_writeCommand
;device.c:937: writeData(mode);
	ld	iy, #2
	add	iy, sp
	ld	l, 0 (iy)
	call	_writeData
;device.c:940: for(int i=0; i!=200; i++ )
	ld	bc, #0x0000
00105$:
	ld	a, c
	sub	a, #0xc8
	or	a, b
	jr	Z, 00103$
;device.c:942: value = readData();
	push	bc
	call	_readData
	ld	a, l
	pop	bc
;device.c:943: if ( value == CH_ST_RET_SUCCESS )
	sub	a, #0x51
	jr	NZ, 00106$
;device.c:944: return true;
	ld	l, #0x01
	ret
00106$:
;device.c:940: for(int i=0; i!=200; i++ )
	inc	bc
	jr	00105$
00103$:
;device.c:947: return false;
	ld	l, #0x00
;device.c:948: }
	ret
;device.c:950: bool initDevice ()
;	---------------------------------
; Function initDevice
; ---------------------------------
_initDevice::
;device.c:952: if (!check_exists())
	call	_check_exists
	ld	a, l
;device.c:953: return false;
	or	a,a
	jr	NZ, 00102$
	ld	l,a
	ret
00102$:
;device.c:955: writeCommand (CH375_CMD_RESET_ALL);
	ld	l, #0x05
	call	_writeCommand
;device.c:956: msdelay (500);
	ld	hl, #0x01f4
	push	hl
	call	_msdelay
;device.c:959: if (!set_usb_host_mode(CH375_USB_MODE_DEVICE_OUTER_FW))
	ld	h,#0x01
	ex	(sp),hl
	inc	sp
	call	_set_usb_host_mode
	ld	a, l
	inc	sp
;device.c:964: return false;
	or	a,a
	jr	NZ, 00104$
	ld	l,a
	ret
00104$:
;device.c:969: return true;
	ld	l, #0x01
;device.c:970: }
	ret
	.area _CODE
	.area _INITIALIZER
__xinit__DevDes:
	.db #0x12	; 18
	.db #0x01	; 1
	.db #0x10	; 16
	.db #0x01	; 1
	.db #0x02	; 2
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0xc0	; 192
	.db #0x16	; 22
	.db #0x83	; 131
	.db #0x04	; 4
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x01	; 1
__xinit__ConDes:
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
__xinit__LangDes:
	.db #0x04	; 4
	.db #0x03	; 3
	.db #0x09	; 9
	.db #0x04	; 4
__xinit__MANUFACTURER_Des:
	.db #0x2c	; 44
	.db #0x03	; 3
	.db #0x77	; 119	'w'
	.db #0x00	; 0
	.db #0x77	; 119	'w'
	.db #0x00	; 0
	.db #0x77	; 119	'w'
	.db #0x00	; 0
	.db #0x2e	; 46
	.db #0x00	; 0
	.db #0x74	; 116	't'
	.db #0x00	; 0
	.db #0x65	; 101	'e'
	.db #0x00	; 0
	.db #0x6d	; 109	'm'
	.db #0x00	; 0
	.db #0x63	; 99	'c'
	.db #0x00	; 0
	.db #0x6f	; 111	'o'
	.db #0x00	; 0
	.db #0x63	; 99	'c'
	.db #0x00	; 0
	.db #0x6f	; 111	'o'
	.db #0x00	; 0
	.db #0x6e	; 110	'n'
	.db #0x00	; 0
	.db #0x74	; 116	't'
	.db #0x00	; 0
	.db #0x72	; 114	'r'
	.db #0x00	; 0
	.db #0x6f	; 111	'o'
	.db #0x00	; 0
	.db #0x6c	; 108	'l'
	.db #0x00	; 0
	.db #0x73	; 115	's'
	.db #0x00	; 0
	.db #0x2e	; 46
	.db #0x00	; 0
	.db #0x63	; 99	'c'
	.db #0x00	; 0
	.db #0x6f	; 111	'o'
	.db #0x00	; 0
	.db #0x6d	; 109	'm'
	.db #0x00	; 0
__xinit__PRODUCER_Des:
	.db #0x26	; 38
	.db #0x03	; 3
	.db #0x4e	; 78	'N'
	.db #0x00	; 0
	.db #0x65	; 101	'e'
	.db #0x00	; 0
	.db #0x74	; 116	't'
	.db #0x00	; 0
	.db #0x77	; 119	'w'
	.db #0x00	; 0
	.db #0x6f	; 111	'o'
	.db #0x00	; 0
	.db #0x72	; 114	'r'
	.db #0x00	; 0
	.db #0x6b	; 107	'k'
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x43	; 67	'C'
	.db #0x00	; 0
	.db #0x6f	; 111	'o'
	.db #0x00	; 0
	.db #0x6e	; 110	'n'
	.db #0x00	; 0
	.db #0x74	; 116	't'
	.db #0x00	; 0
	.db #0x72	; 114	'r'
	.db #0x00	; 0
	.db #0x6f	; 111	'o'
	.db #0x00	; 0
	.db #0x6c	; 108	'l'
	.db #0x00	; 0
	.db #0x6c	; 108	'l'
	.db #0x00	; 0
	.db #0x65	; 101	'e'
	.db #0x00	; 0
	.db #0x72	; 114	'r'
	.db #0x00	; 0
__xinit__PRODUCER_SN_Des:
	.db #0x10	; 16
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
__xinit__oneOneByte:
	.db #0x01	; 1
__xinit__oneZeroByte:
	.db #0x00	; 0
__xinit__twoZeroBytes:
	.db #0x00	; 0
	.db #0x00	; 0
__xinit__usb_terminal_open:
	.db #0x00	;  0
__xinit__transaction_state:
	.db #0x02	; 2
__xinit__WELCOME_MSG:
	.db 0x0d
	.db 0x0a
	.ascii "MSXUSB Monitor"
	.db 0x0d
	.db 0x0a
	.ascii "Mxxxx - display memory"
	.db 0x0d
	.db 0x0a
	.ascii "Gxxxx - goto address"
	.db 0x0d
	.db 0x0a
	.ascii "R - Reset"
	.db 0x0d
	.db 0x0a
	.ascii "X - exit to BASIC"
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
__xinit__UNKNOWN_MSG:
	.db 0x0d
	.db 0x0a
	.ascii "Invalid command"
	.db 0x0d
	.db 0x0a
	.ascii "$ "
	.db 0x00
__xinit__BYTES_MSG:
	.db 0x0d
	.ascii "0x00 bytes written to memory"
	.db 0x0d
	.db 0x0a
	.ascii "$ "
	.db 0x00
__xinit__NEWLINE_MSG:
	.db 0x0d
	.db 0x0a
	.ascii "$ "
	.db 0x00
__xinit__memory_buffer:
	.db 0x0d
	.db 0x0a
	.ascii ":10A000002110A0CD07A0C97EA7C8CDA2002318F700"
	.db 0x0d
	.db 0x0a
	.ascii "$ "
	.db 0x00
	.area _CABS (ABS)
