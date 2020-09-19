/* A Bison parser, made by GNU Bison 3.5.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_MYANALYZER_TAB_H_INCLUDED
# define YY_YY_MYANALYZER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    IDENT = 258,
    STRING = 259,
    NUMBER = 260,
    KW_NUMBER = 261,
    KW_BOOLEAN = 262,
    KW_STRING = 263,
    KW_VOID = 264,
    KW_VAR = 265,
    KW_CONST = 266,
    KW_IF = 267,
    KW_ELSE = 268,
    KW_FOR = 269,
    KW_WHILE = 270,
    KW_FUNCTION = 271,
    KW_BREAK = 272,
    KW_CONTINUE = 273,
    OP_NOT = 274,
    OP_AND = 275,
    OP_OR = 276,
    OP_EXP = 277,
    KW_RETURN = 278,
    KW_NULL = 279,
    KW_START = 280,
    BOOLEAN_TRUE = 281,
    BOOLEAN_FALSE = 282,
    OP_ASSIGN = 283,
    DELIM_SEMICOLON = 284,
    DELIM_COMMA = 285,
    DELIM_CURLY_RIGHT_BRACKET = 286,
    DELIM_CURLY_LEFT_BRACKET = 287,
    DELIM_COLON = 288,
    DELIM_RIGHT_BRACKET = 289,
    DELIM_LEFT_BRACKET = 290,
    DELIM_RIGHT_PARANTHESIS = 291,
    DELIM_LEFT_PARANTHESIS = 292,
    PREFIX = 293,
    OP_MUL = 294,
    OP_DIV = 295,
    OP_MOD = 296,
    OP_ADD = 297,
    OP_SUB = 298,
    OP_EQUAL = 299,
    OP_NOT_EQUAL = 300,
    OP_GREATER_THAN = 301,
    OP_GREATER_EQUAL_THAN = 302,
    OP_LESS_EQUAL_THAN = 303
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 13 "myanalyzer.y"

	char* crepr;

#line 110 "myanalyzer.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_MYANALYZER_TAB_H_INCLUDED  */
