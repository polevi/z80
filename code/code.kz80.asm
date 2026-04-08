Start:
    .model Spectrum48
    .org 40000

    screen_address equ 16384
    symbol_table_address equ 15616

    ;ld de, symbol_table_address + (65 - 32) * 8; symbol table starts with space, i.e. offset of 'A' is 65 - 32
    ld de, hello
    ld hl, screen_address
    call print_string

    jp #12a9    ; jump back to main cycle when terminated

; HL - screen address
; DE - string address
print_string:
    ld a, (de); next symbol to print
    cp 0 ; check zero terminator
    ret z

    ; save registers
    push de
    push hl
    
    ; calculate character offset = symbol_table_address + (symbol code - 32) * 8
    sub a, 32
    ; move a to de
    ld e, a
    ld d, 0
    ; in order to multiply by eight, we need to shift three times
    rlc e
    rl d
    rlc e
    rl d
    rlc e
    rl d
    ; add offset to base
    ld hl, symbol_table_address
    add hl, de 

    ex de, hl; hl -> de
    pop hl; restore screen address
    push hl

    ld b, 8; counter
    print_symbol:
        ld a, (de)
        ld (hl), a
        inc de
        inc h
        dec b
        jr nz, print_symbol         

    ; restore and increment
    pop hl
    pop de
    inc hl
    inc de
    jr print_string ; goto begin

hello:  db 'H', 'E', 'L', 'L', 'O', ',', ' ', 'W', 'O', 'R', 'L', 'D', '!', 0
