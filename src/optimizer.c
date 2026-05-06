#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

#include "../include/icg.h"

typedef struct {
    char result[20];
    char arg1[20];
    char op[10];
    char arg2[20];
} Instruction;

extern Instruction code[];
extern int code_index;

int is_number(char *str) {
    if(str == NULL || strlen(str) == 0)
        return 0;
    for(int i = 0; str[i]; i++) {
        if(!isdigit(str[i]) && str[i] != '.')
            return 0;
    }
    return 1;
}

void optimize_ir() {
    for(int i = 0; i < code_index; i++) {

        if(
            strcmp(code[i].op, "+") == 0 ||
            strcmp(code[i].op, "-") == 0 ||
            strcmp(code[i].op, "*") == 0 ||
            strcmp(code[i].op, "/") == 0 ||
            strcmp(code[i].op, "%") == 0
        ) {

            if(is_number(code[i].arg1) && is_number(code[i].arg2)) {

                int a = atoi(code[i].arg1);
                int b = atoi(code[i].arg2);

                int result = 0;

                if(strcmp(code[i].op, "+") == 0)
                    result = a + b;

                else if(strcmp(code[i].op, "-") == 0)
                    result = a - b;

                else if(strcmp(code[i].op, "*") == 0)
                    result = a * b;

                else if(strcmp(code[i].op, "/") == 0 && b != 0)
                    result = a / b;

                else if(strcmp(code[i].op, "%") == 0 && b != 0)
                    result = a % b;

                sprintf(code[i].arg1, "%d", result);

                strcpy(code[i].op, "=");

                strcpy(code[i].arg2, "");
            }
        }
    }
}
