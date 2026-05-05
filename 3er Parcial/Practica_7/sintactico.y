%{
#include <stdio.h>
#include <stdlib.h>

extern FILE *yyin;
extern int yylex();
void yyerror(const char *s);
int linea = 1;
%}

%token IF NUMERO IDENTIFICADOR OPERADOR_RELACIONAL ASIGNACION
%token DOS_PUNTOS PARENTESIS_IZQ PARENTESIS_DER SALTO ERROR_LEXICO

%%

programa:
    /* Vacio */
    | programa linea_codigo
    | programa estructura_if
    ;

linea_codigo:
    SALTO { linea++; }
    | instruccion SALTO { linea++; }
    ;

estructura_if:
    IF condicion DOS_PUNTOS SALTO bloque_instrucciones { 
        printf("-> EXITOSO (Linea %d): Estructura 'if' de Python valida.\n", linea); 
    }
    | error SALTO { 
        yyerrok; 
        printf("-> ERROR SINTACTICO (Linea %d): Condicion 'if' o instruccion mal formada.\n", linea); 
        linea++;
    }
    ;

condicion:
    valor OPERADOR_RELACIONAL valor
    | PARENTESIS_IZQ valor OPERADOR_RELACIONAL valor PARENTESIS_DER
    ;

valor:
    IDENTIFICADOR
    | NUMERO
    ;

bloque_instrucciones:
    instruccion SALTO { linea++; }
    | bloque_instrucciones instruccion SALTO { linea++; }
    | instruccion { /* Acepta la ultima instruccion si el archivo acaba de golpe */ }
    | bloque_instrucciones instruccion { }
    ;

instruccion:
    IDENTIFICADOR ASIGNACION valor
    ;

%%

void yyerror(const char *s) {
    // Manejado por Yacc
}

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *archivo = fopen(argv[1], "r");
        if (!archivo) {
            printf("Error al abrir el archivo.\n");
            return 1;
        }
        yyin = archivo;
    } else {
        printf("Por favor proporciona un archivo .txt de prueba.\n");
        return 1;
    }

    printf("--- INICIANDO ANALISIS SINTACTICO PYTHON (IF) ---\n");
    yyparse();
    printf("--- ANALISIS FINALIZADO ---\n");

    return 0;
}