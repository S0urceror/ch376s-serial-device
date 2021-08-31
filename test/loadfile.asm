BDOS    .equ 0xf37d
SETDMA  .equ 0x1a
OPEN    .equ 0x0f
BLREAD  .equ 0x27
CHPUT equ 0A2h

;    db 0x0FE
;    dw start, endadr, start

    org 0D000h
start: 
main:
    ld (0xd800),sp
    ld a, (0xd800)
    call PRINT_HEX
    ld a, (0xd801)
    call PRINT_HEX

    ld hl,TXT_CLEARFCB
    call PRINT
    call clearfcb

    ld hl,TXT_LOADFILE
    call PRINT
    ld hl, 0xd800
    push hl
    ld hl, FCB
    push hl
    call loadfile
    pop hl
    pop hl
    jr nz, main_error
    ld hl,TXT_DONE
    call PRINT
    ld (0xd800),sp
    ld a, (0xd800)
    call PRINT_HEX
    ld a, (0xd801)
    call PRINT_HEX
    ret
main_error:
    ld hl,TXT_ERROR
    call PRINT
    ret

TXT_CLEARFCB: DB "Clearing FCB\r\n\0"
TXT_LOADFILE: DB "Loading file\r\n\0"
TXT_DONE: DB "Done\r\n\0"
TXT_ERROR: DB "Error\r\n\0"
TXT_OPEN: DB "Opened\r\n\0"
; PRINT a zero-terminated string in MSX-DOS
; INPUT: HL points to start of string
PRINT:
    ; Check if the passed HL lies between start and end
    ;
    ; ASSERT HL>=TXT_ZERO_TERMINATED_START && HL<TXT_ZERO_TERMINATED_END
    ld a, (hl)
    and a
    ret z
    ;
    call CHPUT
    ;
    inc hl
    jr PRINT

clearfcb:
    ld	bc,24
    ld	hl,FCBEND
    ld	de,FCBEND+1
    ld	(hl),0
    ldir
    ret

resetfcb:
    ; record size 1 byte
    ld	hl,1
    ld	(FCB+14),hl
    ; reset current record
    ld	hl,0
    ld	(FCB+33),hl
    ld	(FCB+35),hl
    ret

filesizefcb:
    ld	hl, (FCB + 0x0010)
    ret
loadfile:
    ld      iy, 4
    add     iy, sp

    ; set location in memory to receive the data
    ld      e,(iy)  ; retrieve [address] from stack
    ld      d,(iy+1)
    ld      c,SETDMA
    call    BDOS
    ; open file
    ld      de, FCB
    ld      c, OPEN
    call    BDOS
    and     a ; check for error
    ret     nz ; disk error
    ld hl, TXT_OPEN
    call PRINT
    call    resetfcb
    ; read file in memory
    call    filesizefcb
    ld      de, FCB
    ld      c, BLREAD
    call    BDOS
    and     a ; check for error
    ;ret     nz ; disk error
    ret

FCB:	defb	0
FNAME:	defb	"TEST    TXT"
FCBEND:	defs 25


;       Subroutine      Print 8-bit hexidecimal number
;       Inputs          A - number to be printed - 0ABh
;       Outputs         ________________________
PRINT_HEX:
    push af
    push bc
    push de
    call __NUMTOHEX
    ld a, d
    call CHPUT
    ld a, e
    call CHPUT
    pop de
    pop bc
    pop af
    ret
;       Subroutine      Convert 8-bit hexidecimal number to ASCII reprentation
;       Inputs          A - number to be printed - 0ABh
;       Outputs         DE - two byte ASCII values - D=65 / 'A' and E=66 / 'B'
__NUMTOHEX:
    ld c, a   ; a = number to convert
    call _NTH1
    ld d, a
    ld a, c
    call _NTH2
    ld e, a
    ret  ; return with hex number in de
_NTH1:
    rra
    rra
    rra
    rra
_NTH2:
    or 0F0h
    daa
    add a, 0A0h
    adc a, 040h ; Ascii hex at this point (0 to F)   
    ret


endadr: