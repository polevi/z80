#include <stdio.h>
#include "font6x8.h"

int main() {
    for(int i = 0; i < 128 * 6; i+=6) {
    	char* bitmask = (char *)font6x8_ascii[i];
        printf("%d\n", bitmask[0]);
    }
    return 0;
}