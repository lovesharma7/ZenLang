#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#define MAX_SYMBOLS 100

typedef struct {
    char name[50];
    char type[20];
} Symbol;

extern Symbol table[MAX_SYMBOLS];
extern int symbol_count;

void insert_symbol(char *name, char *type);
char* lookup_symbol(char *name);
void print_symbol_table();

#endif
