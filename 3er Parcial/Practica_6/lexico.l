%{
#include "y.tab.h" // Importamos los tokens generados por Yacc
#include <stdlib.h>
%}

%option noyywrap

%%

[0-9]+(\.[0-9]+)?           { return NUMERO; }
[a-zA-Z_][a-zA-Z0-9_]* { return IDENTIFICADOR; }
"=="|"!="|"<="|">="|"<"|">" { return CONDICIONAL; }
"+"                         { return SUMA; }
"-"                         { return RESTA; }
"*"                         { return MULTIPLICACION; }
"/"                         { return DIVISION; }
"("                         { return PARENTESIS_IZQ; }
")"                         { return PARENTESIS_DER; }
\n                          { return SALTO; }
[ \t]+                      { /* Ignoramos espacios en blanco */ }
.                           { return ERROR_LEXICO; }

%%