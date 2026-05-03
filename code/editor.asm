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
        sla e
        rl d
        sla e
        rl d
        sla e
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

    cursor_pos_x db 0
    cursor_pos_y db 0

    symbol_table_address:
        db 0, 0, 0, 0, 0, 0, 0, 0       ; ' '
        db 4, 4, 4, 4, 0, 4, 0, 0       ; '!'
        db 10, 10, 0, 0, 0, 0, 0, 0     ; '"'
        db 0, 10, 31, 10, 31, 10, 0, 0  ; '#'
        db 4, 14, 20, 14, 5, 14, 4, 0   ; '$'
        db 0, 17, 18, 4, 9, 17, 0, 0    ; '%'
        db 12, 16, 8, 21, 18, 13, 0, 0  ; '&'
        db 4, 4, 0, 0, 0, 0, 0, 0       ; '''
        db 6, 8, 8, 8, 8, 8, 6, 0       ; '('
        db 12, 2, 2, 2, 2, 2, 12, 0     ; ')'
        db 0, 4, 4, 31, 10, 17, 0, 0    ; '*'
        db 0, 4, 4, 31, 4, 4, 0, 0      ; '+'
        db 0, 0, 0, 0, 4, 8, 0, 0       ; ','
        db 0, 0, 0, 31, 0, 0, 0, 0      ; '-'
        db 0, 0, 0, 0, 4, 0, 0, 0       ; '.'
        db 0, 1, 2, 4, 8, 16, 0, 0      ; '/'
        db 6, 9, 9, 9, 9, 6, 0, 0       ; '0'
        db 2, 6, 2, 2, 2, 7, 0, 0       ; '1'
        db 6, 9, 1, 2, 4, 15, 0, 0      ; '2'
        db 6, 9, 2, 1, 9, 6, 0, 0       ; '3'
        db 2, 6, 10, 15, 2, 2, 0, 0     ; '4'
        db 15, 8, 14, 1, 9, 6, 0, 0     ; '5'
        db 2, 4, 14, 9, 9, 6, 0, 0      ; '6'
        db 15, 1, 2, 4, 4, 4, 0, 0      ; '7'
        db 6, 9, 6, 9, 9, 6, 0, 0       ; '8'
        db 6, 9, 9, 7, 1, 2, 0, 0       ; '9'
        db 0, 0, 4, 0, 4, 0, 0, 0       ; ':'
        db 0, 0, 4, 0, 4, 8, 0, 0       ; ';'
        db 0, 2, 4, 8, 4, 2, 0, 0       ; '<'
        db 0, 0, 14, 0, 14, 0, 0, 0     ; '='
        db 0, 8, 4, 2, 4, 8, 0, 0       ; '>'
        db 12, 18, 2, 4, 0, 4, 0, 0     ; '?'
        db 12, 18, 22, 22, 16, 14, 0, 0 ; '@'
        db 4, 4, 10, 14, 17, 17, 0, 0   ; 'A'
        db 14, 9, 14, 9, 9, 14, 0, 0    ; 'B'
        db 6, 9, 8, 8, 9, 6, 0, 0       ; 'C'
        db 14, 9, 9, 9, 9, 14, 0, 0     ; 'D'
        db 15, 8, 15, 8, 8, 15, 0, 0    ; 'E'
        db 15, 8, 15, 8, 8, 8, 0, 0     ; 'F'
        db 6, 9, 8, 11, 9, 6, 0, 0      ; 'G'
        db 9, 9, 15, 9, 9, 9, 0, 0      ; 'H'
        db 14, 4, 4, 4, 4, 14, 0, 0     ; 'I'
        db 6, 2, 2, 18, 18, 12, 0, 0    ; 'J'
        db 9, 10, 12, 12, 10, 9, 0, 0   ; 'K'
        db 8, 8, 8, 8, 8, 15, 0, 0      ; 'L'
        db 17, 27, 27, 21, 17, 17, 0, 0 ; 'M'
        db 9, 13, 13, 11, 11, 9, 0, 0   ; 'N'
        db 6, 9, 9, 9, 9, 6, 0, 0       ; 'O'
        db 14, 9, 9, 14, 8, 8, 0, 0     ; 'P'
        db 12, 18, 18, 18, 18, 12, 2, 0 ; 'Q'
        db 14, 9, 9, 14, 10, 9, 0, 0    ; 'R'
        db 6, 9, 4, 2, 9, 6, 0, 0       ; 'S'
        db 31, 4, 4, 4, 4, 4, 0, 0      ; 'T'
        db 17, 17, 17, 17, 17, 14, 0, 0 ; 'U'
        db 17, 17, 17, 17, 10, 4, 0, 0  ; 'V'
        db 17, 17, 21, 21, 21, 10, 0, 0 ; 'W'
        db 17, 10, 4, 4, 10, 17, 0, 0   ; 'X'
        db 17, 17, 10, 4, 4, 4, 0, 0    ; 'Y'
        db 15, 1, 2, 4, 8, 15, 0, 0     ; 'Z'
        db 14, 8, 8, 8, 8, 14, 0, 0     ; '['
        db 0, 16, 8, 4, 2, 1, 0, 0      ; '\'
        db 14, 2, 2, 2, 2, 14, 0, 0     ; ']'
        db 4, 10, 17, 0, 0, 0, 0, 0     ; '^'
        db 0, 0, 0, 0, 0, 0, 31, 0      ; '_'
        db 4, 2, 0, 0, 0, 0, 0, 0       ; '`'
        db 0, 0, 12, 18, 18, 13, 0, 0   ; 'a'
        db 8, 8, 14, 9, 9, 14, 0, 0     ; 'b'
        db 0, 0, 6, 8, 8, 6, 0, 0       ; 'c'
        db 1, 1, 7, 9, 9, 7, 0, 0       ; 'd'
        db 0, 6, 9, 15, 8, 6, 0, 0      ; 'e'
        db 3, 4, 31, 4, 4, 4, 0, 0      ; 'f'
        db 0, 7, 9, 9, 7, 1, 6, 0       ; 'g'
        db 8, 8, 14, 9, 9, 9, 0, 0      ; 'h'
        db 4, 0, 12, 4, 4, 14, 0, 0     ; 'i'
        db 2, 0, 6, 2, 2, 18, 12, 0     ; 'j'
        db 8, 9, 10, 12, 10, 9, 0, 0    ; 'k'
        db 8, 8, 8, 8, 9, 6, 0, 0       ; 'l'
        db 0, 17, 27, 21, 21, 17, 0, 0  ; 'm'
        db 0, 6, 9, 9, 9, 9, 0, 0       ; 'n'
        db 0, 6, 9, 9, 9, 6, 0, 0       ; 'o'
        db 0, 14, 9, 9, 14, 8, 8, 0     ; 'p'
        db 0, 7, 9, 9, 7, 1, 1, 0       ; 'q'
        db 0, 0, 11, 4, 4, 4, 0, 0      ; 'r'
        db 0, 6, 8, 6, 1, 6, 0, 0       ; 's'
        db 0, 4, 14, 4, 5, 2, 0, 0      ; 't'
        db 0, 0, 17, 17, 17, 14, 0, 0   ; 'u'
        db 0, 0, 17, 17, 10, 4, 0, 0    ; 'v'
        db 0, 0, 17, 21, 21, 10, 0, 0   ; 'w'
        db 0, 17, 10, 4, 10, 17, 0, 0   ; 'x'
        db 0, 0, 17, 10, 4, 4, 8, 0     ; 'y'
        db 0, 0, 15, 2, 4, 15, 0, 0     ; 'z'
        db 3, 4, 4, 24, 4, 4, 3, 0      ; '{'
        db 4, 4, 4, 4, 4, 4, 4, 0       ; '|'
        db 24, 4, 4, 3, 4, 4, 24, 0     ; '}'
        db 0, 0, 8, 21, 2, 0, 0, 0      ; '~'
   
.endmodule