BDOS    .equ 0xf37d
SETDMA  .equ 0x1a
OPEN    .equ 0x0f
BLREAD  .equ 0x27
CHPUT equ 0A2h
RSLREG equ 0138h

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

    ld hl, txt_hello
    call PRINT
    call RSLREG
    call PRINT_HEX
    ld a, (0xffff)
    call PRINT_HEX
    
    ld (0xd800),sp
    ld a, (0xd800)
    call PRINT_HEX
    ld a, (0xd801)
    call PRINT_HEX
    ret

txt_hello: db "hello world\r\n\0"

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


endadr: