%{
#include <stdio.h>
#include "TeaplAst.h"

extern A_pos pos;
extern A_program root;

extern int yylex(void);
extern "C"{
extern void yyerror(char *s); 
extern int  yywrap();
}

%}

// TODO:
// your parser

%union {
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
}

%token <pos> ADD
%token <pos> SUB
%token <pos> MUL
%token <pos> DIV
%token <pos> SEMICOLON // ;


%token <pos> STRUCT
%token <pos> LET
%token <pos> INT
%token <pos> IF
%token <pos> RET
%token <pos> ELSE
%token <pos> WHILE
// %token <pos> FOR
%token <pos> BREAK
%token <pos> CONTINUE
%token <pos> FN


%token <pos> LT
%token <pos> GT
%token <pos> GE
%token <pos> LE
%token <pos> EQ
%token <pos> NE

%token <pos> AND
%token <pos> OR
%token <pos> NOT

%token <pos> LPAREN
%token <pos> RPAREN
%token <pos> ASSIGN

%token <pos> LBRACKET
%token <pos> RBRACKET
%token <pos> LBRACE
%token <pos> RBRACE
%token <pos> COMMA
%token <pos> COLON
%token <pos> ARROW
%token <pos> DOT

%token <tokenNum> NUM
%token <tokenId> ID

%type <program> Program
%type <arithExpr> ArithExpr
%type <programElementList> ProgramElementList
%type <programElement> ProgramElement
%type <exprUnit> ExprUnit
%type <structDef> StructDef
%type <varDeclStmt> VarDeclStmt
%type <fnDeclStmt> FnDeclStmt
%type <fnDef> FnDef

%type <boolExpr> BoolExpr
%type <fnDecl> FnDecl
%type <type> Type

%type <paramDecl> ParamDecl
// %type <boolBiOpExpr> BoolBiOpExpr
%type <boolUnit> BoolUnit
%type <assignStmt> AssignStmt
%type <leftVal> LeftVal
%type <rightVal> RightVal
%type <fnCall> FnCall
%type <varDecl> VarDecl
%type <varDef> VarDef

%type <codeBlockStmt> CodeBlockStmt
%type <whileStmt> WhileStmt
%type <returnStmt> ReturnStmt
// %type <continueStmt> ContinueStmt
// %type <breakStmt> BreakStmt
%type <ifStmt> IfStmt

%type <callStmt> CallStmt
%type <arrayExpr> ArrayExpr
// %type <memberExpr> MemberExpr

%type <varDeclList> VarDeclList
%type <codeBlockStmtList> CodeBlockStmtList
%type <rightValList> RightValList

// ArithBiOpExpr
%type <arithBiOpExpr> ArithBiOpExpr

%right ASSIGN

%left OR

%left AND

%left EQ NE

%left LT GT GE LE

%left ADD SUB

%left MUL DIV

%right NOT UMINUS

%left DOT
// %left ARROW


%start Program

%%                   /* beginning of rules section */

Program: ProgramElementList 
{  
  root = A_Program($1);
  $$ = A_Program($1);
}
;

ProgramElementList: ProgramElement ProgramElementList
{
  $$ = A_ProgramElementList($1, $2);
}
|
{
  $$ = nullptr;
}
;

ProgramElement: VarDeclStmt
{
  $$ = A_ProgramVarDeclStmt($1->pos, $1);
}
| StructDef
{
  $$ = A_ProgramStructDef($1->pos, $1);
}
| FnDeclStmt
{
  $$ = A_ProgramFnDeclStmt($1->pos, $1);
}
| FnDef
{
  $$ = A_ProgramFnDef($1->pos, $1);
}
| SEMICOLON
{
  $$ = A_ProgramNullStmt($1);
}
;


// ArithExpr: ArithExpr ADD ArithExpr
// {
//   $$ = A_ArithBiOp_Expr($1->pos, A_ArithBiOpExpr($1->pos, A_add, $1, $3));
// }
// | ArithExpr SUB ArithExpr
// {
//   $$ = A_ArithBiOp_Expr($1->pos, A_ArithBiOpExpr($1->pos, A_sub, $1, $3));
// }
// | ArithExpr MUL ArithExpr
// {
//   $$ = A_ArithBiOp_Expr($1->pos, A_ArithBiOpExpr($1->pos, A_mul, $1, $3));
// }
// | ArithExpr DIV ArithExpr
// {
//   $$ = A_ArithBiOp_Expr($1->pos, A_ArithBiOpExpr($1->pos, A_div, $1, $3));
// }
// | ExprUnit
// {
//   $$ = A_ExprUnit($1->pos, $1);
// }
// ;

ArithExpr: ArithBiOpExpr
{
  $$ = A_ArithBiOp_Expr($1->pos, $1);
}
| ExprUnit
{
  $$ = A_ExprUnit($1->pos, $1);
}
;

ArithBiOpExpr: ArithExpr ADD ArithExpr
{
  $$ = A_ArithBiOpExpr($1->pos, A_add, $1, $3);
}
| ArithExpr SUB ArithExpr
{
  $$ = A_ArithBiOpExpr($1->pos, A_sub, $1, $3);
}
| ArithExpr MUL ArithExpr
{
  $$ = A_ArithBiOpExpr($1->pos, A_mul, $1, $3);
}
| ArithExpr DIV ArithExpr
{
  $$ = A_ArithBiOpExpr($1->pos, A_div, $1, $3);
}
;

ExprUnit: NUM
{
  $$ = A_NumExprUnit($1->pos, $1->num);
}
| ID
{
  $$ = A_IdExprUnit($1->pos, $1->id);
}
| LPAREN ArithExpr RPAREN
{
  $$ = A_ArithExprUnit($1, $2);
}
| FnCall 
{
  $$ = A_CallExprUnit($1->pos, $1);
} 
| ArrayExpr
{
  $$ = A_ArrayExprUnit($1->pos, $1);
}
| LeftVal DOT ID
{
  $$ = A_MemberExprUnit($1->pos, A_MemberExpr($1->pos, $1, $3->id));
} 
| SUB ExprUnit %prec UMINUS
{
  $$ = A_ArithUExprUnit($1, A_ArithUExpr($1, A_neg, $2));
}
;

ArrayExpr: LeftVal LBRACKET NUM RBRACKET
{
  $$ = A_ArrayExpr($1->pos, $1, A_NumIndexExpr($3->pos, $3->num));
}
| LeftVal LBRACKET ID RBRACKET
{
  $$ = A_ArrayExpr($1->pos, $1, A_IdIndexExpr($3->pos, $3->id));
}
;

BoolExpr: BoolExpr AND BoolExpr
{
  $$ = A_BoolBiOp_Expr($1->pos, A_BoolBiOpExpr($1->pos, A_and, $1, $3));
}
| BoolExpr OR BoolExpr
{
  $$ = A_BoolBiOp_Expr($1->pos, A_BoolBiOpExpr($1->pos, A_or, $1, $3));
} 
| BoolUnit
{
  $$ = A_BoolExpr($1->pos, $1);
}
;

BoolUnit: ExprUnit LT ExprUnit
{
  $$ = A_ComExprUnit($1->pos, A_ComExpr($1->pos, A_lt, $1, $3));
}
| ExprUnit GT ExprUnit
{
  $$ = A_ComExprUnit($1->pos, A_ComExpr($1->pos, A_gt, $1, $3));
}
| ExprUnit GE ExprUnit
{
  $$ = A_ComExprUnit($1->pos, A_ComExpr($1->pos, A_ge, $1, $3));
}
| ExprUnit LE ExprUnit
{
  $$ = A_ComExprUnit($1->pos, A_ComExpr($1->pos, A_le, $1, $3));
}
| ExprUnit EQ ExprUnit
{
  $$ = A_ComExprUnit($1->pos, A_ComExpr($1->pos, A_eq, $1, $3));
}
| ExprUnit NE ExprUnit
{
  $$ = A_ComExprUnit($1->pos, A_ComExpr($1->pos, A_ne, $1, $3));
}
| LPAREN BoolExpr RPAREN
{
  $$ = A_BoolExprUnit($1, $2);
}
| NOT BoolUnit
{
  $$ = A_BoolUOpExprUnit($1, A_BoolUOpExpr($1, A_not, $2));
}
;

AssignStmt: LeftVal ASSIGN RightVal SEMICOLON
{
  $$ = A_AssignStmt($1->pos, $1, $3);
}
;

LeftVal: ID
{
  $$ = A_IdExprLVal($1->pos, $1->id);
}
| ArrayExpr
{
  $$ = A_ArrExprLVal($1->pos, $1);
}
| LeftVal DOT ID
{
  $$ = A_MemberExprLVal($1->pos, A_MemberExpr($1->pos, $1, $3->id));
}
;

RightVal: ArithExpr
{
  $$ = A_ArithExprRVal($1->pos, $1);
}
| BoolExpr
{
  $$ = A_BoolExprRVal($1->pos, $1);
}
;

FnCall: ID LPAREN RightValList RPAREN
{
  $$ = A_FnCall($1->pos, $1->id, $3);
}
;

RightValList: RightVal COMMA RightValList
{
  $$ = A_RightValList($1, $3);
}
| RightVal
{
  $$ = A_RightValList($1, nullptr);
}
| 
{
  $$ = nullptr;
}
;

VarDeclStmt: LET VarDef SEMICOLON
{
  $$ = A_VarDefStmt($1, $2);
}
| LET VarDecl SEMICOLON
{
  $$ = A_VarDeclStmt($1, $2);
}
;

VarDecl: ID COLON Type
{
  $$ = A_VarDecl_Scalar($1->pos, A_VarDeclScalar($1->pos, $1->id, $3));
}
| ID LBRACKET NUM RBRACKET COLON Type
{
  $$ = A_VarDecl_Array($1->pos, A_VarDeclArray($1->pos, $1->id, $3->num, $6));
}
| ID
{
  $$ = A_VarDecl_Scalar($1->pos, A_VarDeclScalar($1->pos, $1->id, nullptr));
}
| ID LBRACKET NUM RBRACKET
{
  $$ = A_VarDecl_Array($1->pos, A_VarDeclArray($1->pos, $1->id, $3->num, nullptr));
}
;


VarDef: ID COLON Type ASSIGN RightVal
{
  $$ = A_VarDef_Scalar($1->pos, A_VarDefScalar($1->pos, $1->id, $3, $5));
}
| ID ASSIGN RightVal
{
  $$ = A_VarDef_Scalar($1->pos, A_VarDefScalar($1->pos, $1->id, nullptr, $3));
}
| ID LBRACKET NUM RBRACKET COLON Type ASSIGN LBRACE RightValList RBRACE
{
  $$ = A_VarDef_Array($1->pos, A_VarDefArray($1->pos, $1->id, $3->num, $6, $9));
}
| ID LBRACKET NUM RBRACKET ASSIGN LBRACE RightValList RBRACE
{
  $$ = A_VarDef_Array($1->pos, A_VarDefArray($1->pos, $1->id, $3->num, nullptr, $7));
}
;

Type: INT
{
  $$ = A_NativeType($1, A_intTypeKind);
}
| ID
{
  $$ = A_StructType($1->pos, $1->id);
}
;


StructDef: STRUCT ID LBRACE VarDeclList RBRACE
{
  $$ = A_StructDef($1, $2->id, $4);
}
;

VarDeclList: VarDecl COMMA VarDeclList
{
  $$ = A_VarDeclList($1, $3);
}
| VarDecl
{
  $$ = A_VarDeclList($1, nullptr);
}
|
{
  $$ = nullptr;
}
;


FnDeclStmt: FnDecl SEMICOLON
{
  $$ = A_FnDeclStmt($1->pos, $1);
}
;

FnDecl: FN ID LPAREN ParamDecl RPAREN ARROW Type
{
  $$ = A_FnDecl($1, $2->id, $4, $7);
}
| FN ID LPAREN ParamDecl RPAREN
{
  $$ = A_FnDecl($1, $2->id, $4, nullptr);
}
;

ParamDecl: VarDeclList
{
  $$ = A_ParamDecl($1);
}
;

FnDef: FnDecl LBRACE CodeBlockStmtList RBRACE
{
  $$ = A_FnDef($1->pos, $1, $3);
}
;

CodeBlockStmtList:  CodeBlockStmt 
{
  $$ = A_CodeBlockStmtList($1, nullptr);
}
| CodeBlockStmt CodeBlockStmtList
{
  $$ = A_CodeBlockStmtList($1, $2);
}
;

CodeBlockStmt: VarDeclStmt
{
  $$ = A_BlockVarDeclStmt($1->pos, $1);
}
| AssignStmt
{
  $$ = A_BlockAssignStmt($1->pos, $1);
}
| CallStmt
{
  $$ = A_BlockCallStmt($1->pos, $1);
}
| IfStmt
{
  $$ = A_BlockIfStmt($1->pos, $1);
}
| WhileStmt
{
  $$ = A_BlockWhileStmt($1->pos, $1);
}
| ReturnStmt
{
  $$ = A_BlockReturnStmt($1->pos, $1);
}
| CONTINUE SEMICOLON
{
  $$ = A_BlockContinueStmt($1);
}
| BREAK SEMICOLON
{
  $$ = A_BlockBreakStmt($1);
}
| SEMICOLON
{
  $$ = A_BlockNullStmt($1);
}
;

ReturnStmt: RET RightVal SEMICOLON
{
  $$ = A_ReturnStmt($1, $2);
}
| RET SEMICOLON
{
  $$ = A_ReturnStmt($1, nullptr);
}
;

CallStmt: FnCall SEMICOLON
{
  $$ = A_CallStmt($1->pos, $1);
}
;

IfStmt: IF LPAREN BoolExpr RPAREN LBRACE CodeBlockStmtList RBRACE
{
  $$ = A_IfStmt($1, $3, $6, nullptr);
}
| IF LPAREN BoolExpr RPAREN LBRACE CodeBlockStmtList RBRACE ELSE LBRACE CodeBlockStmtList RBRACE
{
  $$ = A_IfStmt($1, $3, $6, $10);
}
;

WhileStmt: WHILE LPAREN BoolExpr RPAREN LBRACE CodeBlockStmtList RBRACE
{
  $$ = A_WhileStmt($1, $3, $6);
}
;

%%

extern "C"{
void yyerror(char * s)
{
  fprintf(stderr, "%s\n",s);
}
int yywrap()
{
  return(1);
}
}


