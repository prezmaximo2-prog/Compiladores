%{
#include <stdio.h>
#include <stdlib.h>

extern FILE *yyin;
extern int yylex();
void yyerror(const char *s);
int consulta_num = 1;
%}

%token SELECT FROM WHERE AND OR INSERT INTO VALUES UPDATE SET DELETE
%token IDENTIFICADOR NUMERO CADENA IGUAL OPERADOR_COMP ASTERISCO 
%token COMA PUNTO_COMA PARENTESIS_IZQ PARENTESIS_DER ERROR_LEXICO

%%

consultas:
    /* Vacio */
    | consultas consulta
    ;

consulta:
    instruccion PUNTO_COMA { 
        printf("-> EXITOSO (Consulta %d): Sentencia SQL valida.\n", consulta_num); 
        consulta_num++;
    }
    | error PUNTO_COMA { 
        yyerrok; 
        printf("-> ERROR SINTACTICO (Consulta %d): Consulta SQL mal formada.\n", consulta_num); 
        consulta_num++;
    }
    ;

instruccion:
    instruccion_select
    | instruccion_insert
    | instruccion_update
    | instruccion_delete
    ;

/* SELECT */
instruccion_select:
    SELECT campos FROM tabla
    | SELECT campos FROM tabla WHERE condicion
    ;

campos:
    ASTERISCO
    | lista_identificadores
    ;

/* INSERT */
instruccion_insert:
    INSERT INTO tabla VALUES PARENTESIS_IZQ lista_valores PARENTESIS_DER
    | INSERT INTO tabla PARENTESIS_IZQ lista_identificadores PARENTESIS_DER VALUES PARENTESIS_IZQ lista_valores PARENTESIS_DER
    ;

/* UPDATE */
instruccion_update:
    UPDATE tabla SET lista_asignaciones
    | UPDATE tabla SET lista_asignaciones WHERE condicion
    ;

lista_asignaciones:
    asignacion
    | lista_asignaciones COMA asignacion
    ;

asignacion:
    IDENTIFICADOR IGUAL valor
    ;

/* DELETE */
instruccion_delete:
    DELETE FROM tabla
    | DELETE FROM tabla WHERE condicion
    ;

tabla:
    IDENTIFICADOR
    ;

lista_identificadores:
    IDENTIFICADOR
    | lista_identificadores COMA IDENTIFICADOR
    ;

lista_valores:
    valor
    | lista_valores COMA valor
    ;

condicion:
    expresion
    | condicion AND expresion
    | condicion OR expresion
    ;

expresion:
    IDENTIFICADOR IGUAL valor
    | IDENTIFICADOR OPERADOR_COMP valor
    ;

valor:
    NUMERO
    | CADENA
    ;

%%

void yyerror(const char *s) {
    
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
        printf("Por favor proporciona un archivo .sql de prueba.\n");
        return 1;
    }

    printf("--- INICIANDO MOTOR SINTACTICO SQL (CRUD) ---\n");
    yyparse();
    printf("--- ANALISIS FINALIZADO ---\n");

    return 0;
}