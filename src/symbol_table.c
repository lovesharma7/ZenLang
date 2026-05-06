#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "../include/symbol_table.h"

Symbol table[MAX_SYMBOLS];
int symbol_count = 0;

void insert_symbol(char *name, char *type) {
    for(int i = 0; i < symbol_count; i++) {
        if(strcmp(table[i].name, name) == 0) {
            printf("Semantic Error: Variable '%s' already declared\n", name);
            exit(1);
        }
    }
    strcpy(table[symbol_count].name, name);
    strcpy(table[symbol_count].type, type);
    symbol_count++;
}

char* lookup_symbol(char *name) {
    for(int i = 0; i < symbol_count; i++) {
        if(strcmp(table[i].name, name) == 0) {
            return table[i].type;
        }
    }
    return NULL;
}

void print_symbol_table() {
    printf("\nSymbol Table:\n");
    for(int i = 0; i < symbol_count; i++) {
        printf("%s : %s\n", table[i].name, table[i].type);
    }
}
