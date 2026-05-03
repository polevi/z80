#include <stdio.h>
#include <stdlib.h>
#include "font6x8.h"

int print_binary(char c) {
    for(int i = 7; i >= 0; i--){
        printf("%d", (c >> i) & 1);
    }
    printf("\n");
}

int print_binary6(char c) {
    for(int i = 5; i >= 0; i--){
        printf("%d", (c >> i) & 1);
    }
    printf("\n");
}

int print_symbol(char n) {
   	char* bitmask = (char *)font6x8_ascii[n];
    print_binary(bitmask[0]);
    print_binary(bitmask[1]);
    print_binary(bitmask[2]);
    print_binary(bitmask[3]);
    print_binary(bitmask[4]);
    print_binary(bitmask[5]);
}

int print_symbol6(char* bitmask) {
    print_binary6(bitmask[0]);
    print_binary6(bitmask[1]);
    print_binary6(bitmask[2]);
    print_binary6(bitmask[3]);
    print_binary6(bitmask[4]);
    print_binary6(bitmask[5]);
    print_binary6(bitmask[6]);
    print_binary6(bitmask[7]);
}

int print_symbol_declaration(char* bitmask) {
    printf("db %d, %d, %d, %d, %d, %d, %d, %d",
        bitmask[0],
        bitmask[1],
        bitmask[2],
        bitmask[3],
        bitmask[4],
        bitmask[5],
        bitmask[6],
        bitmask[7]
    );  
}

char* rotate_symbol(char n) {
   	char* bitmask = (char *)font6x8_ascii[n];
    char* result = (char *)malloc(8);
    for(char i = 0; i < 8; i++) {
        char n = 1 << i;

        result[i] = 
            (!!(bitmask[5] & n) << 0) | 
            (!!(bitmask[4] & n) << 1) | 
            (!!(bitmask[3] & n) << 2) | 
            (!!(bitmask[2] & n) << 3) | 
            (!!(bitmask[1] & n) << 4) |
            (!!(bitmask[0] & n) << 5); 
    }    
    return result;
}


int main() {

    for(int i = 32; i < 127; i++) {
        char* s = rotate_symbol(i);
        print_symbol_declaration(s);
        printf("\t; '%c'\n", i);
    }

    return 0;    
}
