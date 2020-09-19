%{
#include <stdlib.h>
#include <stdarg.h>
#include <stdio.h>
#include <string.h>		
#include "cgen.h"

extern int yylex(void);
extern int line_num;
%}

%union
{
	char* crepr;
}


%error-verbose
%token <crepr> IDENT
%token <crepr> STRING
%token <crepr> NUMBER

%token KW_NUMBER
%token KW_BOOLEAN
%token KW_STRING
%token KW_VOID
%token KW_VAR
%token KW_CONST
%token KW_IF
%token KW_ELSE
%token KW_FOR
%token KW_WHILE
%token KW_FUNCTION
%token KW_BREAK
%token KW_CONTINUE
%token OP_NOT
%token OP_AND
%token OP_OR
%token OP_EXP
%token KW_RETURN
%token KW_NULL
%token KW_START

%token BOOLEAN_TRUE
%token BOOLEAN_FALSE

%token OP_ASSIGN
%token DELIM_SEMICOLON
%token DELIM_COMMA
%token DELIM_CURLY_RIGHT_BRACKET
%token DELIM_CURLY_LEFT_BRACKET
%token DELIM_COLON
%token DELIM_RIGHT_BRACKET  DELIM_LEFT_BRACKET
%token DELIM_RIGHT_PARANTHESIS  DELIM_LEFT_PARANTHESIS
%start program

	/* Declarations */

	/* Variable Declarations */

%type <crepr> decl_list  decl type_spec const_rule parameter_decl_list_main parameter_decl_id_main parameter_decl_init_main
%type <crepr> var_decl_body var_decl_list var_decl_init var_decl_id
%type <crepr> const_decl_body const_decl_list const_decl_init 
%type <crepr> parameter_decl_list parameter_decl_init parameter_decl_id
%type <crepr> expr statements if_statement body epilogue const_decl_id type_spec_main

 /* Position-Priorities */

%left OP_NOT
%left PREFIX
%left OP_MUL OP_DIV OP_MOD
%left OP_ADD OP_SUB
%left OP_EQUAL OP_NOT_EQUAL OP_GREATER_THAN OP_GREATER_EQUAL_THAN OP_LESS_EQUAL_THAN
%left OP_AND OP_OR
%right OP_EXP
%%
            
program: decl_list KW_FUNCTION KW_START DELIM_RIGHT_PARANTHESIS parameter_decl_list_main DELIM_LEFT_PARANTHESIS DELIM_COLON type_spec DELIM_CURLY_RIGHT_BRACKET body DELIM_CURLY_LEFT_BRACKET{
	if(yyerror_count==0) {
    // include the teaclib.h file
	  puts(c_prologue); 
	  printf("/* program */ \n\n");
	  printf("%s\n\n", $1);
	
	  printf("%s main(%s) {\n%s\n} \n",$8,$5,$10);
	}
}
;

	/**** BODY ****/

body: body statements  { $$ = template("%s\n%s",$1,$2);}
|statements { $$ = $1; }

;
statements:
KW_VAR var_decl_body { $$ = template("%s", $2); }
|IDENT OP_ASSIGN expr DELIM_SEMICOLON		     { $$ = template("%s = %s;", $1,$3); }
|expr DELIM_SEMICOLON { $$ = template("%s;", $1); }
|KW_WHILE expr DELIM_CURLY_RIGHT_BRACKET body DELIM_CURLY_LEFT_BRACKET DELIM_SEMICOLON  { $$ = template("while (%s) {\n%s}", $2,$4); }
|if_statement { $$ = $1; } 
|epilogue { $$ = $1; }
;
if_statement: 
KW_IF expr body KW_ELSE DELIM_CURLY_RIGHT_BRACKET body DELIM_CURLY_LEFT_BRACKET DELIM_SEMICOLON { $$ = template("if (%s){\n%s\n}\nelse{\n%s\n}", $2,$3,$6); } 
|KW_IF expr DELIM_CURLY_RIGHT_BRACKET body DELIM_CURLY_LEFT_BRACKET DELIM_SEMICOLON { $$ = template("if (%s){\n%s\n}", $2,$4); } 
;
epilogue: KW_RETURN DELIM_SEMICOLON		     { $$ = template("return;");	}
|KW_RETURN expr DELIM_SEMICOLON		             { $$ = template("return %s;",$2);	}
; 

/* Variable Declaration */

decl_list: decl_list decl { $$ = template("%s\n%s", $1, $2); }
| decl { $$ = $1; }
;

/*Variable as parameter of function main*/

parameter_decl_list_main: %empty			     { $$ = "";}
|parameter_decl_init_main DELIM_COMMA parameter_decl_init_main { $$ = template("%s, %s", $1, $3 );}
|parameter_decl_init_main { $$ = $1; }
;
parameter_decl_init_main: parameter_decl_id_main DELIM_COLON type_spec_main { $$ = template("%s %s", $3, $1 );}
;
parameter_decl_id_main: IDENT { $$ = $1; } 
| IDENT DELIM_RIGHT_BRACKET  DELIM_LEFT_BRACKET { $$ = template("%s[]",$1); }
;
type_spec_main: 
KW_NUMBER { $$ = "int"; }
|KW_STRING { $$ = "char **"; }

/*Variable as parameter of function*/

parameter_decl_list: %empty			     { $$ = "";}
|parameter_decl_list DELIM_COMMA parameter_decl_init { $$ = template("%s, %s", $1, $3 );}
|parameter_decl_init { $$ = $1; }
;
parameter_decl_init: parameter_decl_id DELIM_COLON type_spec { $$ = template("%s  %s", $3, $1 );}
;
parameter_decl_id: IDENT { $$ = $1; } 
| IDENT DELIM_RIGHT_BRACKET  DELIM_LEFT_BRACKET { $$ = template("%s[]",$1); }
;


/*Constant Variable rules*/

decl: KW_VAR var_decl_body { $$ = template("%s", $2); }
|KW_FUNCTION const_decl_body  { $$ = template("%s", $2); }
;

/*
const_decl_body : const_decl_list DELIM_COLON type_spec DELIM_SEMICOLON {  $$ = template("%s %s;", $3, $1); }
|const_decl_init{ $$ = $1; }
;

const_decl_list: const_decl_list DELIM_COMMA const_decl_init  { $$ = template("%s, %s", $1, $3 );}
| const_decl_init { $$ = $1; }
;
const_decl_init: const_decl_id OP_ASSIGN  const_rule { $$ = template("%s %s", $1, $3); }
|const_rule { $$ = template("%s", $1); }
;
const_rule:
expr { $$ = template("=%s", $1);}
|const_decl_id OP_ASSIGN DELIM_RIGHT_PARANTHESIS parameter_decl_list DELIM_LEFT_PARANTHESIS DELIM_COLON type_spec OP_LESS_EQUAL_THAN DELIM_CURLY_RIGHT_BRACKET body  DELIM_CURLY_LEFT_BRACKET DELIM_SEMICOLON{ $$ = template("%s %s (%s){\n%s\n};",$7,$1,$4,$10);}

;
const_decl_id: IDENT { $$ = $1; } 
| IDENT DELIM_RIGHT_BRACKET expr DELIM_LEFT_BRACKET { $$ = template("%s", $1,$3); }
| IDENT DELIM_RIGHT_BRACKET  DELIM_LEFT_BRACKET { $$ = template("%s", $1); }
;



/*Var rules*/


var_decl_body: var_decl_list DELIM_COLON type_spec DELIM_SEMICOLON {  $$ = template("%s %s;", $3, $1); }
;
var_decl_list: var_decl_list DELIM_COMMA var_decl_init { $$ = template("%s, %s", $1, $3 );}
| var_decl_init { $$ = $1; }
;
var_decl_init: var_decl_id { $$ = $1; }
| var_decl_id OP_ASSIGN expr { $$ = template("%s=%s", $1, $3); 
}
; 
var_decl_id: IDENT { $$ = $1; } 
| IDENT DELIM_RIGHT_BRACKET expr DELIM_LEFT_BRACKET { $$ = template("%s", $1,$3); }
| IDENT DELIM_RIGHT_BRACKET  DELIM_LEFT_BRACKET { $$ = template("%s", $1); }
;
type_spec:  KW_NUMBER { $$ = "double"; }
| KW_BOOLEAN { $$ = "int"; }
| KW_STRING { $$ = "char *"; }
| KW_VOID { $$ = "void"; }
;

expr: NUMBER						{ $$ = template("%s",$1);}
| IDENT                                        	       { $$ = template("%s",$1);}
| STRING                                        	{ $$ = template("%s",$1);}
| IDENT DELIM_RIGHT_BRACKET expr DELIM_LEFT_BRACKET   	{ $$ = template("%s[%s]",$1, $3); }
| DELIM_RIGHT_PARANTHESIS expr DELIM_LEFT_PARANTHESIS   { $$ = template("(%s)", $2); }
| IDENT DELIM_RIGHT_PARANTHESIS expr DELIM_LEFT_PARANTHESIS   { $$ = template("%s(%s)",$1,$3); }
| IDENT DELIM_RIGHT_PARANTHESIS expr DELIM_COMMA expr DELIM_LEFT_PARANTHESIS   { $$ = template("%s(%s,%s)",$1,$3,$5); }
| IDENT DELIM_RIGHT_PARANTHESIS DELIM_LEFT_PARANTHESIS   { $$ = template("%s()",$1); }
| BOOLEAN_TRUE						 { $$ = template("1"); }
| BOOLEAN_FALSE						 { $$ = template("0"); }
| expr OP_MUL expr 					{ $$ = template ("%s * %s",$1,$3);}
| expr OP_DIV expr 					{ $$ = template ("%s / %s",$1,$3);}
| expr OP_MOD expr 					{ $$ = template ("%s %% %s",$1,$3);}
| expr OP_ADD expr 					{ $$ = template ("%s + %s",$1,$3);}
| expr OP_SUB expr 					{ $$ = template ("%s - %s",$1,$3);}
| OP_ADD expr %prec PREFIX                      	{ $$ = template("+%s",$2); }
| OP_SUB expr %prec PREFIX                      	{ $$ = template("-%s",$2); }  
| OP_NOT expr                                   	{ $$ = template("!%s",$2); }
| expr OP_EQUAL expr					{ $$ = template ("%s == %s",$1,$3);}
| expr OP_NOT_EQUAL expr				{ $$ = template ("%s != %s",$1,$3);}
| expr OP_GREATER_THAN expr				{ $$ = template ("%s < %s",$1,$3);}
| expr OP_GREATER_EQUAL_THAN expr			{ $$ = template ("%s <= %s",$1,$3);}
| expr OP_LESS_EQUAL_THAN expr				{ $$ = template ("%s => %s",$1,$3);}
| expr OP_AND expr					{ $$ = template ("%s && %s",$1,$3);}
| expr OP_OR expr					{ $$ = template ("%s || %s",$1,$3);}

;





%%
int main () {
	
  if ( yyparse() != 0 )
    printf("Rejected!\n");
}
