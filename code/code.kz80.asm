Start:
    .model Spectrum48
    .org 40000

    ld de, hello
    call editor.print_string_at_cursor

    jp #12a9    ; jump back to main cycle when terminated

#include "editor.asm"

hello:  db 'H', 'e', 'l', 'l', 'o', ',', ' ', 'w', 'o', 'r', 'l', 'd', '!', 0
