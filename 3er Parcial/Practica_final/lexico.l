%{
#include "y.tab.h"
#include <stdlib.h>
%}

%option noyywrap
%option case-insensitive

%%

"SELECT"                    { return SELECT; }
"FROM"                      { return FROM; }
"WHERE"                     { return WHERE; }
"AND"                       { return AND; }
"OR"                        { return OR; }
"INSERT"                    { return INSERT; }
"INTO"                      { return INTO; }
"VALUES"                    { return VALUES; }
"UPDATE"                    { return UPDATE; }
"SET"                       { return SET; }
"DELETE"                    { return DELETE; }

[a-zA-Z_][a-zA-Z0-9_]* { return IDENTIFICADOR; }
[0-9]+(\.[0-9]+)?           { return NUMERO; }
"'"[^'\n]*"'"               { return CADENA; }

"="                         { return IGUAL; }
">"|"<"|">="|"<="|"!="      { return OPERADOR_COMP; }
"*"                         { return ASTERISCO; }
","                         { return COMA; }
";"                         { return PUNTO_COMA; }
"("                         { return PARENTESIS_IZQ; }
")"                         { return PARENTESIS_DER; }

\n                          { /* Ignoramos saltos de linea */ }
\r                          { /* Ignoramos el retorno de Windows */ }
[ \t]+                      { /* Ignoramos espacios */ }
.                           { return ERROR_LEXICO; }

%%