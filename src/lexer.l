%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "parser.tab.h"
%}

%option noyywrap

DIGIT      [0-9]
LETTER     [a-zA-Z_]

%%

"num"                   { return NUM_TYPE; }
"dec"                   { return DEC_TYPE; }
"flag"                  { return FLAG_TYPE; }
"text"                  { return TEXT_TYPE; }

"if"                    { return IF; }
"else"                  { return ELSE; }
"loop"                  { return LOOP; }

"show"                  { return SHOW; }
"ask"                   { return ASK; }

"and"                   { return AND; }
"or"                    { return OR; }
"not"                   { return NOT; }

"is not"                { return ISNOT; }
"is"                    { return IS; }

"<="                    { return LE; }
">="                    { return GE; }
"<"                     { return LT; }
">"                     { return GT; }

"+"                     { return PLUS; }
"-"                     { return MINUS; }
"*"                     { return MUL; }
"/"                     { return DIV; }
"%"                     { return MOD; }

"="                     { return ASSIGN; }

";"                     { return SEMICOLON; }
","                     { return COMMA; }

"("                     { return LPAREN; }
")"                     { return RPAREN; }

"{"                     { return LBRACE; }
"}"                     { return RBRACE; }

\"[^\"]*\"              { yylval.str = strdup(yytext); return STRING_LITERAL; }

{DIGIT}+"."{DIGIT}+     { yylval.dec_val = atof(yytext); return DEC_LITERAL; }

{DIGIT}+                { yylval.num_val = atoi(yytext); return NUM_LITERAL; }

"#".*                   { }

{LETTER}({LETTER}|{DIGIT})* { yylval.str = strdup(yytext); return IDENTIFIER; }

[ \t\r\n]+              { }

.                       { printf("Unknown character: %s\n", yytext); }

%% 
