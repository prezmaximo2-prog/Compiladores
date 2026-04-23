%{
#include <stdio.h>
#include <stdlib.h>

extern FILE *yyin;
extern int yylex();
void yyerror(const char *s);
int linea = 1;
%}

/* Declaracion de los tokens que nos manda Lex */
%token NUMERO IDENTIFICADOR CONDICIONAL
%token SUMA RESTA MULTIPLICACION DIVISION
%token PARENTESIS_IZQ PARENTESIS_DER
%token SALTO ERROR_LEXICO

/* Definicion de prioridades y asociatividad (Izquierda) */
%left SUMA RESTA
%left MULTIPLICACION DIVISION

%%

/* Gramatica inicial: Permite leer multiples lineas */
entradas:
    /* Vacio */
    | entradas linea_codigo
    ;

linea_codigo:
    SALTO { linea++; }
    | expresion SALTO { printf("[Linea %d] EXITOSO: Expresion Aritmetica Valida.\n", linea); linea++; }
    | error SALTO { yyerrok; printf("[Linea %d] --- ERROR SINTACTICO DETECTADO ---\n", linea); linea++; }
    ;

/* Definicion BNF de una expresion aritmetica */
expresion:
    NUMERO
    | IDENTIFICADOR
    | expresion SUMA expresion
    | expresion RESTA expresion
    | expresion MULTIPLICACION expresion
    | expresion DIVISION expresion
    | PARENTESIS_IZQ expresion PARENTESIS_DER
    ;

%%

/* Funcion para manejar los errores sintacticos */
void yyerror(const char *s) {
    // Yacc entra aqui automaticamente cuando la gramatica se rompe
}

/* Funcion principal en C */
int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *archivo = fopen(argv[1], "r");
        if (!archivo) {
            printf("Error al abrir el archivo %s\n", argv[1]);
            return 1;
        }
        yyin = archivo; // Redirigimos la entrada estandar al archivo
    } else {
        printf("Error: Por favor proporciona un archivo .txt como argumento.\n");
        return 1;
    }

    printf("--- INICIANDO ANALISIS SINTACTICO ---\n");
    yyparse();
    printf("--- ANALISIS FINALIZADO ---\n");

    return 0;
}