#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "icg.h"
#include "symbol_table.h"
#include "codegen.h"

FILE *fp;

char generated_code[50000] = "";

typedef struct {
    char result[50];
    char arg1[50];
    char op[20];
    char arg2[50];
} Instruction;

extern Instruction code[];
extern int code_index;

extern Symbol table[];
extern int symbol_count;

void emit(char *code) {
    strcat(generated_code, code);
}

int is_temp(char *str) {
    return str[0] == 't';
}

void generate_c_code() {
    fp = fopen("output/output.c", "w");
    if(!fp) {
        printf("Error creating output file\n");
        return;
    }

    fprintf(fp, "#include <stdio.h>\n");
    fprintf(fp, "#include <string.h>\n\n");
    fprintf(fp, "int main() {\n\n");

    for(int i = 0; i < symbol_count; i++) {
        if(strcmp(table[i].type, "num") == 0) {
            fprintf(
                fp,
                "    int %s;\n",
                table[i].name
            );
        }
        else if(strcmp(table[i].type, "dec") == 0) {
            fprintf(
                fp,
                "    float %s;\n",
                table[i].name
            );
        }
        else if(strcmp(table[i].type, "flag") == 0) {
            fprintf(
                fp,
                "    int %s;\n",
                table[i].name
            );
        }
        else {
            fprintf(
                fp,
                "    char %s[100];\n",
                table[i].name
            );
        }
    }

    char temps[100][20];
    int temp_var_count = 0;
    for(int i = 0; i < code_index; i++) {
        if(is_temp(code[i].result)) {
            int found = 0;
            for(int j = 0; j < temp_var_count; j++) {
                if(strcmp(
                    temps[j],
                    code[i].result
                ) == 0) {
                    found = 1;
                    break;
                }
            }
            if(!found) {
                strcpy(
                    temps[temp_var_count++],
                    code[i].result
                );
            }
        }
    }

    if(temp_var_count > 0) {
        fprintf(fp, "\n    float ");
        for(int i = 0; i < temp_var_count; i++) {
            fprintf(fp, "%s", temps[i]);
            if(i != temp_var_count - 1) {
                fprintf(fp, ", ");
            }
        }
        fprintf(fp, ";\n");
    }
    fprintf(fp, "\n");
    fprintf(fp, "%s", generated_code);
    fprintf(fp, "\n    return 0;\n");
    fprintf(fp, "}\n");
    fclose(fp);
}
