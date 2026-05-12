%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "symbol_table.h"
#include "icg.h"
#include "optimizer.h"
#include "codegen.h"

int yylex();
void yyerror(const char *s);

extern FILE *yyin;
char current_type[20];
%}

%union {
    int num_val;
    float dec_val;
    char* str;
}

%token <num_val> NUM_LITERAL
%token <dec_val> DEC_LITERAL
%token <str> IDENTIFIER
%token <str> STRING_LITERAL

%token NUM_TYPE
%token DEC_TYPE
%token FLAG_TYPE
%token TEXT_TYPE

%token IF
%token ELSE
%token LOOP
%token SHOW
%token ASK

%token AND
%token OR
%token NOT

%token IS
%token ISNOT

%token LT
%token GT
%token LE
%token GE

%token PLUS
%token MINUS
%token MUL
%token DIV
%token MOD

%token ASSIGN

%token SEMICOLON
%token COMMA
%token LPAREN
%token RPAREN
%token LBRACE
%token RBRACE

%type <str> expression
%type <str> condition

%left OR
%left AND
%left IS ISNOT
%left LT GT LE GE
%left PLUS MINUS
%left MUL DIV MOD
%right NOT

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%

program:
    statements
;

statements:
      statements statement
    | statement
;

statement:
      declaration
    | assignment
    | show_stmt
    | ask_stmt
    | if_stmt
    | loop_stmt
;

block:
    LBRACE statements RBRACE
;

declaration:
      normal_declaration
    | text_declaration
;

normal_declaration:
      type IDENTIFIER ASSIGN expression SEMICOLON
        {
            insert_symbol($2, current_type);

            generate($2, $4, "=", "");

            char buffer[200];
            sprintf(buffer, "    %s = %s;\n", $2, $4);
            emit(buffer);
        }

    | type IDENTIFIER SEMICOLON
        {
            insert_symbol($2, current_type);
        }
;

text_declaration:
      TEXT_TYPE IDENTIFIER ASSIGN STRING_LITERAL SEMICOLON
        {
            insert_symbol($2, "text");

            char buffer[300];
            sprintf(buffer, "    strcpy(%s, %s);\n", $2, $4);
            emit(buffer);
        }
    | TEXT_TYPE IDENTIFIER SEMICOLON
        {
            insert_symbol($2, "text");
        }
;

type:
      NUM_TYPE   { strcpy(current_type, "num"); }
    | DEC_TYPE   { strcpy(current_type, "dec"); }
    | FLAG_TYPE  { strcpy(current_type, "flag"); }
;

assignment:
      IDENTIFIER ASSIGN expression SEMICOLON
        {
            if(lookup_symbol($1) == NULL) {
                printf("Semantic Error: Variable '%s' not declared\n", $1);
                exit(1);
            }

            generate($1, $3, "=", "");

            char buffer[200];
            sprintf(buffer, "    %s = %s;\n", $1, $3);
            emit(buffer);
        }
;

show_stmt:

      SHOW expression SEMICOLON
        {
            char buffer[300];

            char *type = lookup_symbol($2);

            if(type != NULL) {

                if(strcmp(type, "text") == 0) {

                    sprintf(
                        buffer,
                        "    printf(\"%%s\\n\", %s);\n",
                        $2
                    );
                }

                else if(strcmp(type, "dec") == 0) {

                    sprintf(
                        buffer,
                        "    printf(\"%%f\\n\", %s);\n",
                        $2
                    );
                }

                else {

                    sprintf(
                        buffer,
                        "    printf(\"%%d\\n\", %s);\n",
                        $2
                    );
                }
            }

            else {

                sprintf(
                    buffer,
                    "    printf(\"%%f\\n\", %s);\n",
                    $2
                );
            }

            emit(buffer);
        }

    | SHOW STRING_LITERAL SEMICOLON
        {
            char buffer[500];

            sprintf(
                buffer,
                "    printf(%s);\n",
                $2
            );

            emit(buffer);
        }
;

ask_stmt:
      ASK IDENTIFIER SEMICOLON
        {
            char *type = lookup_symbol($2);
            if(type == NULL) {
                printf("Semantic Error: Variable '%s' not declared\n", $2);
                exit(1);
            }

            char buffer[200];
            if (strcmp(type, "text") == 0) {
                sprintf(buffer, "    scanf(\"%%s\", &%s);\n", $2);
            }
            else if (strcmp(type, "dec") == 0) {
                sprintf(buffer, "    scanf(\"%%f\", &%s);\n", $2);
            }
            else {
                sprintf(buffer, "    scanf(\"%%d\", &%s);\n", $2);
            }
            emit(buffer);
        }
;

if_header:
    IF LPAREN condition RPAREN
    {
        char buffer[300];
        sprintf(buffer, "    if (%s) {\n", $3);
        emit(buffer);
    }
;

loop_header:
    LOOP LPAREN condition RPAREN
    {
        char buffer[300];
        sprintf(buffer, "    while (%s) {\n", $3);
        emit(buffer);
    }
;

if_stmt:
      if_header block
        {
            emit("    }\n");
        }
      %prec LOWER_THAN_ELSE

    | if_header block ELSE
        {
            emit("    } else {\n");
        }
      block
        {
            emit("    }\n");
        }
;

loop_stmt:
      loop_header block
        {
            emit("    }\n");
        }
;

condition:
      expression LT expression
        {
            char *temp = malloc(100);
            sprintf(temp, "%s < %s", $1, $3);
            $$ = temp;
        }

    | expression GT expression
        {
            char *temp = malloc(100);
            sprintf(temp, "%s > %s", $1, $3);
            $$ = temp;
        }

    | expression LE expression
        {
            char *temp = malloc(100);
            sprintf(temp, "%s <= %s", $1, $3);
            $$ = temp;
        }

    | expression GE expression
        {
            char *temp = malloc(100);
            sprintf(temp, "%s >= %s", $1, $3);
            $$ = temp;
        }

    | expression IS expression
        {
            char *temp = malloc(100);
            sprintf(temp, "%s == %s", $1, $3);
            $$ = temp;
        }

    | expression ISNOT expression
        {
            char *temp = malloc(100);
            sprintf(temp, "%s != %s", $1, $3);
            $$ = temp;
        }

    | condition AND condition
        {
            char *temp = malloc(200);
            sprintf(temp, "%s && %s", $1, $3);
            $$ = temp;
        }

    | condition OR condition
        {
            char *temp = malloc(200);
            sprintf(temp, "%s || %s", $1, $3);
            $$ = temp;
        }

    | NOT condition
        {
            char *temp = malloc(100);
            sprintf(temp, "!%s", $2);
            $$ = temp;
        }
;

expression:
      expression PLUS expression
        {
            char *temp = new_temp();
            generate(temp, $1, "+", $3);

            char buffer[200];
            sprintf(buffer, "    %s = %s + %s;\n", temp, $1, $3);
            emit(buffer);

            $$ = temp;
        }

    | expression MINUS expression
        {
            char *temp = new_temp();
            generate(temp, $1, "-", $3);

            char buffer[200];
            sprintf(buffer, "    %s = %s - %s;\n", temp, $1, $3);
            emit(buffer);

            $$ = temp;
        }

    | expression MUL expression
        {
            char *temp = new_temp();
            generate(temp, $1, "*", $3);

            char buffer[200];
            sprintf(buffer, "    %s = %s * %s;\n", temp, $1, $3);
            emit(buffer);

            $$ = temp;
        }

    | expression DIV expression
        {
            char *temp = new_temp();
            generate(temp, $1, "/", $3);

            char buffer[200];
            sprintf(buffer, "    %s = %s / %s;\n", temp, $1, $3);
            emit(buffer);

            $$ = temp;
        }

    | expression MOD expression
        {
            char *temp = new_temp();
            generate(temp, $1, "%", $3);

            char buffer[200];
            sprintf(buffer, "    %s = %s %% %s;\n", temp, $1, $3);
            emit(buffer);

            $$ = temp;
        }

    | LPAREN expression RPAREN
        {
            $$ = $2;
        }

    | NUM_LITERAL
        {
            char *temp = malloc(20);
            sprintf(temp, "%d", $1);
            $$ = temp;
        }

    | DEC_LITERAL
        {
            char *temp = malloc(20);
            sprintf(temp, "%f", $1);
            $$ = temp;
        }

    | IDENTIFIER
        {
            if(lookup_symbol($1) == NULL) {
                printf("Semantic Error: Variable '%s' not declared\n", $1);
                exit(1);
            }
            $$ = $1;
        }
;

%%

void yyerror(const char *s) {
    printf("Syntax Error: %s\n", s);
}

int main(int argc, char **argv) {
    if(argc > 1) {
        yyin = fopen(argv[1], "r");
        if(!yyin) {
            printf("Cannot open file %s\n", argv[1]);
            return 1;
        }
    }

    if(yyparse() == 0) {
        optimize_ir();
        generate_c_code();
    }

    return 0;
}
