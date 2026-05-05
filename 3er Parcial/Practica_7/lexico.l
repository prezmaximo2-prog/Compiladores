%{
#include "y.tab.h"
#include <stdlib.h>
%}

%option noyywrap

%%

"if"                        { return IF; }
[0-9]+(\.[0-9]+)?           { return NUMERO; }
[a-zA-Z_][a-zA-Z0-9_]*      { return IDENTIFICADOR; }
"=="|"!="|"<="|">="|"<"|">" { return OPERADOR_RELACIONAL; }
"="                         { return ASIGNACION; }
":"                         { return DOS_PUNTOS; }
"("                         { return PARENTESIS_IZQ; }
")"                         { return PARENTESIS_DER; }
\n                          { return SALTO; }
\r                          { /* Ignoramos el retorno de Windows */ }
[ \t]+                      { /* Ignoramos espacios y sangrias */ }
.                           { return ERROR_LEXICO; }

%%