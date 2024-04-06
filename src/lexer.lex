%{
#include <stdio.h>
#include <string.h>
#include "TeaplAst.h"
#include "y.tab.hpp"
extern int line, col;
int c;
int calc(char *s, int len);
%}
%start COMMENT1  COMMENT2

/* // TODO:
// your lexer */

%%
<INITIAL>"let" { yylval.pos = A_Pos(line, col); col+=3; return LET; }
<INITIAL>"fn" { yylval.pos = A_Pos(line, col); col+=2;  return FN; }
<INITIAL>"struct" { yylval.pos = A_Pos(line, col); col+=6; return STRUCT; }
<INITIAL>"ret" { yylval.pos = A_Pos(line, col); col+=6; return RET; }
<INITIAL>"if" { yylval.pos = A_Pos(line, col); col+=2; return IF; }
<INITIAL>"else" { yylval.pos = A_Pos(line, col); col+=4; return ELSE; }
<INITIAL>"while" { yylval.pos = A_Pos(line, col); col+=5; return WHILE; }
<INITIAL>"break" { yylval.pos = A_Pos(line, col); col+=5; return BREAK; }
<INITIAL>"continue" { yylval.pos = A_Pos(line, col); col+=8; return CONTINUE; }
<INITIAL>"int" { yylval.pos = A_Pos(line, col); col+=3;  return INT; }

<INITIAL>"\t" { col+=4; }
<INITIAL>"\n" { ++line; col=1; }
<COMMENT1>"\n" { ++line; col=1; BEGIN INITIAL; }
<COMMENT2>"\n" { ++line; col=1; }
<INITIAL>" " { ++col; }

<INITIAL>"+" { yylval.pos = A_Pos(line, col); ++col; return ADD; }
<INITIAL>"-" { yylval.pos = A_Pos(line, col); ++col; return SUB; }
<INITIAL>"*" { yylval.pos = A_Pos(line, col); ++col; return MUL; }
<INITIAL>"/" { yylval.pos = A_Pos(line, col); ++col; return DIV; }

<INITIAL>"<" { yylval.pos = A_Pos(line, col); ++col; return LT; }
<INITIAL>">" { yylval.pos = A_Pos(line, col); ++col; return GT; }
<INITIAL>">=" { yylval.pos = A_Pos(line, col); col+=2; return GE; }
<INITIAL>"<=" { yylval.pos = A_Pos(line, col); col+=2; return LE; }
<INITIAL>"==" { yylval.pos = A_Pos(line, col); col+=2; return EQ; }
<INITIAL>"!=" { yylval.pos = A_Pos(line, col); col+=2; return NE; }

<INITIAL>"&&" { yylval.pos = A_Pos(line, col); col+=2; return AND; }
<INITIAL>"||" { yylval.pos = A_Pos(line, col); col+=2; return OR; }
<INITIAL>"!" { yylval.pos = A_Pos(line, col); ++col; return NOT; }

<INITIAL>"(" { yylval.pos = A_Pos(line, col); ++col;   return LPAREN; }
<INITIAL>")" { yylval.pos = A_Pos(line, col); ++col;  return RPAREN; }
<INITIAL>"=" { yylval.pos = A_Pos(line, col); ++col; return ASSIGN; }



<INITIAL>"[" { yylval.pos = A_Pos(line, col); ++col; return LBRACKET; }
<INITIAL>"]" { yylval.pos = A_Pos(line, col); ++col; return RBRACKET; }
<INITIAL>"{" { yylval.pos = A_Pos(line, col); ++col; return LBRACE; }
<INITIAL>"}" { yylval.pos = A_Pos(line, col); ++col; return RBRACE; }
<INITIAL>"," { yylval.pos = A_Pos(line, col); ++col; return COMMA; }
<INITIAL>"." { yylval.pos = A_Pos(line, col); ++col; return DOT; }
<INITIAL>":" { yylval.pos = A_Pos(line, col); ++col; return COLON; }
<INITIAL>";" { yylval.pos = A_Pos(line, col); ++col; return SEMICOLON; }
<INITIAL>"->" { yylval.pos = A_Pos(line, col); col+=2;  return ARROW; }


<INITIAL>"//" { col+=2; BEGIN COMMENT1; }
<INITIAL>"/\*" { col+=2; BEGIN COMMENT2; }
<COMMENT2>"\*/" { col+=2; BEGIN INITIAL; }



<INITIAL>[1-9][0-9]* {
    yylval.tokenNum = A_TokenNum(A_Pos(line, col), calc(yytext, yyleng));
    col+=yyleng;
    return NUM;
}
<INITIAL>0 {
    yylval.tokenNum = A_TokenNum(A_Pos(line, col), 0);
    ++col;
    return NUM;
}
<INITIAL>[a-zA-Z_][a-zA-Z0-9_]* {
    yylval.tokenId = A_TokenId(A_Pos(line, col), strdup(yytext));
    col+=yyleng;
    // printf("ID: %s\n", yytext);
    // for(int i = 0; i < 200; i++)
    //     printf("%c", (yytext-50)[i]);
    // printf("\n");
    // printf("ID: %p\n", yytext);
    // *yytext = 0;
    return ID;
}

<COMMENT1>. { ++col; }
<COMMENT2>. { ++col; }

<INITIAL>. { printf("Error: Unrecognized character '%c' at line %d, column %d\n", yytext[0], line, col); ++col; }
%%

// This function takes a string of digits and its length as input, and returns the integer value of the string.
int calc(char *s, int len) {
    int ret = 0;
    for(int i = 0; i < len; i++)
        ret = ret * 10 + (s[i] - '0');
    return ret;
}
