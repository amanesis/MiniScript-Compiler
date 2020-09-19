%{
#include <assert.h>
#include <stdio.h>
#include <string.h>
#include "myanalyzer.tab.h"
#include "cgen.h"

int line_num = 1;
#define DEBUG 0


  // void showError();


%}

/* Basic Rules */
IDENT [a-zA-Z_][0-9a-zA-Z_]*
DIGIT  [0-9]
NUM  {DIGIT}{DIGIT}*
DECIMAL ("."{NUM})|({NUM}("."{NUM}?)?)
STRING  '[^'\n]*'

%x multiple_line_comments

%%

    /* 1. Keywords */
number                  { if(DEBUG){ printf("token KW_NUMBER: %s\n", yytext);}      return KW_NUMBER;}
boolean                 { if(DEBUG){ printf("token KW_BOOLEAN: %s\n", yytext);}     return KW_BOOLEAN;}
string                  { if(DEBUG){ printf("token KW_STRING: %s\n", yytext);}      return KW_STRING;}
void                    { if(DEBUG){ printf("token KW_VOID: %s\n", yytext);}        return KW_VOID;} 
true 		            { if(DEBUG){ printf("token BOOLEAN_TRUE: %s\n",yytext);}    return BOOLEAN_TRUE;}
false 		            { if(DEBUG){ printf("token BOOLEAN_FALSE: %s\n",yytext);}   return BOOLEAN_FALSE;}
var						{ if(DEBUG){ printf("token KW_VAR: %s\n", yytext);}         return KW_VAR;}
const                   { if(DEBUG){ printf("token KW_CONST: %s\n", yytext);}       return KW_CONST;}
if                      { if(DEBUG){ printf("token KW_IF: %s\n", yytext);}          return KW_IF;}
else                    { if(DEBUG){ printf("token KW_ELSE: %s\n", yytext);}        return KW_ELSE;}
for                     { if(DEBUG){ printf("token KW_FOR: %s\n", yytext);}         return KW_FOR;}
while                   { if(DEBUG){ printf("token KW_WHILE: %s\n", yytext);}       return KW_WHILE;}
function                { if(DEBUG){ printf("token KW_FUNCTION: %s\n", yytext);}    return KW_FUNCTION;}
break                   { if(DEBUG){ printf("token KW_BREAK: %s\n", yytext);}       return KW_BREAK;}
continue                { if(DEBUG){ printf("token KW_CONTINUE: %s\n", yytext);}    return KW_CONTINUE;}
not	                    { if(DEBUG){ printf("token OP_NOT: %s\n",yytext);}          return OP_NOT;}
and	                    { if(DEBUG){ printf("token OP_AND: %s\n",yytext);}          return OP_AND;}
or	                    { if(DEBUG){ printf("token OP_OR: %s\n",yytext);}           return OP_OR;}
return                  { if(DEBUG){ printf("token KW_RETURN: %s\n", yytext);}      return KW_RETURN;}
null                    { if(DEBUG){ printf("token KW_NULL: %s\n", yytext);}        return KW_NULL;}
start                   { if(DEBUG){ printf("token KW_START: %s\n", yytext);}       return KW_START;}

    /* 2. Identifiers*/

{IDENT} 		        { if(DEBUG){ printf("token IDENTIFIER: %s\n",yytext);}          yylval.crepr = strdup(yytext); return IDENT;}

    /* 3. Number Constants */

{NUM}                { if(DEBUG){ printf("token NUMBER: %s\n",yytext);}       yylval.crepr = strdup(yytext); return NUMBER;}


    /* 4. Boolean Constants */

    /* 5. Constant Strings */

{STRING}                { if(DEBUG){ printf("token STRING: %s\n",yytext);}              yylval.crepr = strdup(yytext);  return STRING ; }


    /* 6. Operators */

"+"	                { if(DEBUG){ printf("token OP_ADD: %s\n",yytext);}                       return OP_ADD;}
"-"	                { if(DEBUG){ printf("token OP_SUB: %s\n",yytext);}                       return OP_SUB;}
"*"	                { if(DEBUG){ printf("token OP_MUL: %s\n",yytext);}                       return OP_MUL;}
"/"	                { if(DEBUG){ printf("token OP_DIV: %s\n",yytext);}                       return OP_DIV;}
"%"	                { if(DEBUG){ printf("token OP_MOD: %s\n",yytext);}                       return OP_MOD;}
"="	                { if(DEBUG){ printf("token OP_EQUAL: %s\n",yytext);}                     return OP_EQUAL;}
"**"                { if(DEBUG){ printf("token OP_EXP: %s\n",yytext);}                       return OP_EXP;}
"=="	            { if(DEBUG){ printf("token OP_EQUAL: %s\n",yytext);}                     return OP_EQUAL;}
"!="	            { if(DEBUG){ printf("token OP_NOT_EQUAL: %s\n",yytext);}                 return OP_NOT_EQUAL;}
"<"	                { if(DEBUG){ printf("token OP_GREATER_THAN: %s\n",yytext);}              return OP_GREATER_THAN;}
"<="	            { if(DEBUG){ printf("token OP_GREATER_EQUAL_THAN: %s\n",yytext);}        return OP_GREATER_EQUAL_THAN;}     
"="	                { if(DEBUG){ printf("token OP_ASSIGN: %s\n",yytext);}                    return OP_ASSIGN;}
    /*7. Delimiters */

";"                 { if(DEBUG){ printf("token DELIM_SEMICOLON: %s\n",yytext);}              return DELIM_SEMICOLON;}
"("                 { if(DEBUG){ printf("token DELIM_RIGHT_PARANTHESIS: %s\n",yytext);}      return DELIM_RIGHT_PARANTHESIS;}
")"                 { if(DEBUG){ printf("token DELIM_LEFT_PARANTHESIS: %s\n",yytext);}       return DELIM_LEFT_PARANTHESIS;}
","                 { if(DEBUG){ printf("token DELIM_COMMA: %s\n",yytext);}                  return DELIM_COMMA;}
"["                 { if(DEBUG){ printf("token DELIM_RIGHT_BRACKET: %s\n",yytext);}          return DELIM_RIGHT_BRACKET;}
"]"                 { if(DEBUG){ printf("token DELIM_LEFT_BRACKET: %s\n",yytext);}           return DELIM_LEFT_BRACKET;}
"{"                 { if(DEBUG){ printf("token DELIM_CURLY_RIGHT_BRACKET: %s\n",yytext);}    return DELIM_CURLY_RIGHT_BRACKET;}
"}"                 { if(DEBUG){ printf("token DELIM_CURLY_LEFT_BRACKET: %s\n",yytext);}     return DELIM_CURLY_LEFT_BRACKET;}
":"                 { if(DEBUG){ printf("token DELIM_COLON: %s\n",yytext);}                  return DELIM_COLON;}
    
    /* 8. White Spaces */

[ \r\t]+		/* skip whitespace */

    /* 9. Multiple Line Comments */

"(*"                                   { BEGIN(multiple_line_comments); if(DEBUG){printf("comment started at line: %d\n", line_num);} }
<multiple_line_comments>[^*\n]*        /* eat anything that's not a '*' */
<multiple_line_comments>"*"+[^*)\n]*   /* eat up '*'s not followed by '/'s */
<multiple_line_comments>\n             ++line_num;
<multiple_line_comments>"*"+")"        { BEGIN(INITIAL); if(DEBUG){printf("comment ended at line: %d\n", line_num);} }	

    /* 10. Line Comments */

"//"[^\n]*                             { if(DEBUG){printf("Line %d: line comment: %s\n", line_num, yytext);}} /* eat line comments */

\n 		   ++line_num;
<<EOF>> 	   return EOF;
.                  { printf("Line %d: Error %s\n", line_num, yytext); }


%%
/*void showError(){
  //printf("Line %d Lexical Error: Unrecognized literal %s\n", lineNum, yytext); 
  printf("Line %d Lexical Error: Unrecognized literal %s\n" , line_num, yytext); 
  exit(-100);
}

int main ()
{
   int token;
   while ( (token = yylex()) != EOF ){

      printf("\tLine %d Token %d: %s\n", line_num, token, yytext);
   }

  printf("Your program is syntactically correct\n");
}
*/
