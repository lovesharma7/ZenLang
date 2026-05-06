#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "../include/icg.h"

#define MAX_CODE 200

typedef struct {
    char result[50];
    char arg1[50];
    char op[20];
    char arg2[50];
} Instruction;

Instruction code[MAX_CODE];

int code_index = 0;

int temp_count = 0;
int label_count = 0;

char* new_temp() {
    char *temp = (char*)malloc(20);
    sprintf(temp, "t%d", temp_count++);
    return temp;
}

char* new_label() {
    char *label = (char*)malloc(20);
    sprintf(label, "L%d", label_count++);
    return label;
}

void generate(char *result, char *arg1, char *op, char *arg2) {
    strcpy(code[code_index].result, result);
    strcpy(code[code_index].arg1, arg1);
    strcpy(code[code_index].op, op);
    strcpy(code[code_index].arg2, arg2);
    code_index++;
}

void print_ir() {
    printf("\nIntermediate Code (3AC):\n");
    for(int i = 0; i < code_index; i++) {

        if(strcmp(code[i].op, "=") == 0) {
            printf("%s = %s\n",
                code[i].result,
                code[i].arg1);
        }

        else if(strcmp(code[i].op, "PRINT") == 0) {

            printf("PRINT %s\n",
                code[i].result);
        }

        else if(strcmp(code[i].op, "INPUT") == 0) {

            printf("INPUT %s\n",
                code[i].result);
        }

        else if(strcmp(code[i].op, "LABEL") == 0) {

            printf("%s:\n",
                code[i].result);
        }

        else if(strcmp(code[i].op, "GOTO") == 0) {

            printf("GOTO %s\n",
                code[i].result);
        }

        else if(strcmp(code[i].op, "IF") == 0) {

            printf("IF %s GOTO %s\n",
                code[i].arg1,
                code[i].result);
        }

        else {

            printf("%s = %s %s %s\n",
                code[i].result,
                code[i].arg1,
                code[i].op,
                code[i].arg2);
        }
    }
}
