#ifndef CODEGEN_H
#define CODEGEN_H

#include <stdio.h>

extern FILE *fp;

void emit(char *code);

void generate_c_code();

#endif
