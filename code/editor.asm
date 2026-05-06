.module editor

    screen_address equ 16384

    ; de - string address
    print_string_at_cursor:
        call get_cursor_address
        call print_string

    ; hl - screen address
    ; de - string address
    print_string:
        ld a, (de); next symbol to print
        and a ; check zero terminator
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
        sla e
        rl d
        sla e
        rl d
        sla e
        rl d
        ; add offset to base
        ld hl, symbol_table.address
        add hl, de 

        ex de, hl; hl -> de
        pop hl; restore screen address
        push hl

        call print_symbol_6x8
        //ld b, 8; counter
        //print_symbol:
        //    ld a, (de)
        //    ld (hl), a
        //    inc de
        //    inc h
        //    djnz print_symbol         

        ; restore and increment
        pop hl
        pop de
        inc hl
        inc de
        jr print_string ; goto begin


    ; hl - screen address
    ; de - symbol bit mask
    print_symbol_6x8:
        ld b, 8; counter
        print_symbol:
            ld a, (de)
            ld (hl), a
            inc de
            inc h
            djnz print_symbol       
        ret

    ; returns address in hl
    get_cursor_address:
        ld ix, variables
        ld l, (ix + 0)
        ld h, (ix + 1)
        call get_cell_address_42
        ret

    ; x, y in hl
    ; returns address in hl
    get_cell_address:
        ld a, h
        and 7
        rrca
        rrca
        rrca
        add l
        ld l, a

        ld a, h
        and 24
        or 64
        ld h, a

        ret 

    ; x, y in hl
    ; returns address in hl, shift in accumulator
    get_cell_address_42:

        ; l * 6 div 8
        ld a, l
        sla a
        sla a
        add l
        add l
        ld l, a
        sra l
        sra l
        sra l ; x
        and 7 ; mod 8, i.e. bit offset
        push af
        
        ; add y div 8 * 32
        ld a, h
        and 7
        rrca
        rrca
        rrca
        add l
        ld l, a

        ld a, h
        and 24
        or 64
        ld h, a

        pop af ; bit offset in a
        ret 

    variables:
        cursor_pos_x db 10
        cursor_pos_y db 0

.endmodule

#include "symbol_table.asm"
