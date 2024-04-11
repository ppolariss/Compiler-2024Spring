/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
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
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

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

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_Y_TAB_HPP_INCLUDED
# define YY_YY_Y_TAB_HPP_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    ADD = 258,                     /* ADD  */
    SUB = 259,                     /* SUB  */
    MUL = 260,                     /* MUL  */
    DIV = 261,                     /* DIV  */
    SEMICOLON = 262,               /* SEMICOLON  */
    STRUCT = 263,                  /* STRUCT  */
    LET = 264,                     /* LET  */
    INT = 265,                     /* INT  */
    IF = 266,                      /* IF  */
    RET = 267,                     /* RET  */
    ELSE = 268,                    /* ELSE  */
    WHILE = 269,                   /* WHILE  */
    BREAK = 270,                   /* BREAK  */
    CONTINUE = 271,                /* CONTINUE  */
    FN = 272,                      /* FN  */
    LT = 273,                      /* LT  */
    GT = 274,                      /* GT  */
    GE = 275,                      /* GE  */
    LE = 276,                      /* LE  */
    EQ = 277,                      /* EQ  */
    NE = 278,                      /* NE  */
    AND = 279,                     /* AND  */
    OR = 280,                      /* OR  */
    NOT = 281,                     /* NOT  */
    LPAREN = 282,                  /* LPAREN  */
    RPAREN = 283,                  /* RPAREN  */
    ASSIGN = 284,                  /* ASSIGN  */
    LBRACKET = 285,                /* LBRACKET  */
    RBRACKET = 286,                /* RBRACKET  */
    LBRACE = 287,                  /* LBRACE  */
    RBRACE = 288,                  /* RBRACE  */
    COMMA = 289,                   /* COMMA  */
    COLON = 290,                   /* COLON  */
    ARROW = 291,                   /* ARROW  */
    DOT = 292,                     /* DOT  */
    NUM = 293,                     /* NUM  */
    ID = 294,                      /* ID  */
    UMINUS = 295                   /* UMINUS  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif
/* Token kinds.  */
#define YYEMPTY -2
#define YYEOF 0
#define YYerror 256
#define YYUNDEF 257
#define ADD 258
#define SUB 259
#define MUL 260
#define DIV 261
#define SEMICOLON 262
#define STRUCT 263
#define LET 264
#define INT 265
#define IF 266
#define RET 267
#define ELSE 268
#define WHILE 269
#define BREAK 270
#define CONTINUE 271
#define FN 272
#define LT 273
#define GT 274
#define GE 275
#define LE 276
#define EQ 277
#define NE 278
#define AND 279
#define OR 280
#define NOT 281
#define LPAREN 282
#define RPAREN 283
#define ASSIGN 284
#define LBRACKET 285
#define RBRACKET 286
#define LBRACE 287
#define RBRACE 288
#define COMMA 289
#define COLON 290
#define ARROW 291
#define DOT 292
#define NUM 293
#define ID 294
#define UMINUS 295

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 19 "parser.yacc"

  A_pos pos;
  A_program program;
  A_programElementList programElementList;
  A_programElement programElement;
  A_arithExpr arithExpr;
  A_exprUnit exprUnit;
  A_structDef structDef;
  A_varDeclStmt varDeclStmt;
  A_fnDeclStmt fnDeclStmt;
  A_fnDef fnDef;
  A_boolExpr boolExpr;
  A_fnDecl fnDecl;
  A_type type;
  A_paramDecl paramDecl;
  A_boolBiOpExpr boolBiOpExpr;
  A_boolUnit boolUnit;
  A_assignStmt assignStmt;
  A_leftVal leftVal;
  A_rightVal rightVal;
  A_fnCall fnCall;
  A_varDecl varDecl;
  A_varDef varDef;
  A_codeBlockStmt codeBlockStmt;
  A_whileStmt whileStmt;
  A_returnStmt returnStmt;
  // A_continueStmt continueStmt;
  // A_breakStmt breakStmt;
  A_ifStmt ifStmt;
  A_callStmt callStmt;
  A_arrayExpr arrayExpr;
  A_memberExpr memberExpr;
  A_varDeclList varDeclList;
  A_codeBlockStmtList codeBlockStmtList;
  A_rightValList rightValList;
  A_tokenId tokenId;
  A_tokenNum tokenNum;
  A_arithBiOpExpr arithBiOpExpr;

#line 187 "y.tab.hpp"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_Y_TAB_HPP_INCLUDED  */
