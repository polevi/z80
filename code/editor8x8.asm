.module editor8x8

    screen_address equ 16384
    symbol_table_address equ 15616

    ; de - string address
    print_string_at_cursor:
        call get_cursor_address
        call print_string

    ; hl - screen address
    ; de - string address
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


    ; returns address in hl
    get_cursor_address:
        push de

        ld a, (cursor_pos_y)
        ld d, 0
        ld e, a
        rlc e
        rlc e
        rlc e
        rlc e
        rlc e
        ld hl, screen_address
        add hl, de

        ld a, (cursor_pos_x)
        ld d, 0
        ld e, a
        add hl, de

        pop de
        ret 

    cursor_pos_x db 16
    cursor_pos_y db 5

.endmodule