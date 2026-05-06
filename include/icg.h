#ifndef ICG_H
#define ICG_H

extern int code_index;

void generate(char *result, char *arg1, char *op, char *arg2);

char* new_temp();

char* new_label();

void print_ir();

#endif
