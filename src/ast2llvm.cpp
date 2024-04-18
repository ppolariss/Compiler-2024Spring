#include "ast2llvm.h"
#include <vector>
#include <unordered_map>
#include <string>
#include <cassert>
#include <list>

using namespace std;
using namespace LLVMIR;

static unordered_map<string, FuncType> funcReturnMap;
static unordered_map<string, StructInfo> structInfoMap;
static unordered_map<string, Name_name *> globalVarMap;
static unordered_map<string, Temp_temp *> localVarMap;
static list<L_stm *> emit_irs;

LLVMIR::L_prog *ast2llvm(aA_program p)
{
    // 全局变量，结构体和函数声明
    auto defs = ast2llvmProg_first(p);
    // 函数实现中的llvm ir代码
    auto funcs = ast2llvmProg_second(p);
    vector<L_func *> funcs_block;
    // 将llvm ir从列表转换为基本块的形式
    for (const auto &f : funcs)
    {
        funcs_block.push_back(ast2llvmFuncBlock(f));
    }
    // 将所有的alloca语句移动到第一个基本块中
    for (auto &f : funcs_block)
    {
        ast2llvm_moveAlloca(f);
    }
    return new L_prog(defs, funcs_block);
}

int ast2llvmRightVal_first(aA_rightVal r)
{
    if (r == nullptr)
    {
        return 0;
    }
    switch (r->kind)
    {
    case A_arithExprValKind:
    {
        return ast2llvmArithExpr_first(r->u.arithExpr);
        break;
    }
    case A_boolExprValKind:
    {
        return ast2llvmBoolExpr_first(r->u.boolExpr);
        break;
    }
    default:
        break;
    }
    return 0;
}

int ast2llvmBoolExpr_first(aA_boolExpr b)
{
    switch (b->kind)
    {
    case A_boolBiOpExprKind:
    {
        return ast2llvmBoolBiOpExpr_first(b->u.boolBiOpExpr);
        break;
    }
    case A_boolUnitKind:
    {
        return ast2llvmBoolUnit_first(b->u.boolUnit);
        break;
    }
    default:
        break;
    }
    return 0;
}

int ast2llvmBoolBiOpExpr_first(aA_boolBiOpExpr b)
{
    int l = ast2llvmBoolExpr_first(b->left);
    int r = ast2llvmBoolExpr_first(b->right);
    if (b->op == A_and)
    {
        return l && r;
    }
    else
    {
        return l || r;
    }
}

int ast2llvmBoolUOpExpr_first(aA_boolUOpExpr b)
{
    if (b->op == A_not)
    {
        return !ast2llvmBoolUnit_first(b->cond);
    }
    return 0;
}

int ast2llvmBoolUnit_first(aA_boolUnit b)
{
    switch (b->kind)
    {
    case A_comOpExprKind:
    {
        return ast2llvmComOpExpr_first(b->u.comExpr);
        break;
    }
    case A_boolExprKind:
    {
        return ast2llvmBoolExpr_first(b->u.boolExpr);
        break;
    }
    case A_boolUOpExprKind:
    {
        return ast2llvmBoolUOpExpr_first(b->u.boolUOpExpr);
        break;
    }
    default:
        break;
    }
    return 0;
}

int ast2llvmComOpExpr_first(aA_comExpr c)
{
    auto l = ast2llvmExprUnit_first(c->left);
    auto r = ast2llvmExprUnit_first(c->right);
    switch (c->op)
    {
    case A_lt:
    {
        return l < r;
        break;
    }
    case A_le:
    {
        return l <= r;
        break;
    }
    case A_gt:
    {
        return l > r;
        break;
    }
    case A_ge:
    {
        return l >= r;
        break;
    }
    case A_eq:
    {
        return l == r;
        break;
    }
    case A_ne:
    {
        return l != r;
        break;
    }
    default:
        break;
    }
    return 0;
}

int ast2llvmArithBiOpExpr_first(aA_arithBiOpExpr a)
{
    auto l = ast2llvmArithExpr_first(a->left);
    auto r = ast2llvmArithExpr_first(a->right);
    switch (a->op)
    {
    case A_add:
    {
        return l + r;
        break;
    }
    case A_sub:
    {
        return l - r;
        break;
    }
    case A_mul:
    {
        return l * r;
        break;
    }
    case A_div:
    {
        return l / r;
        break;
    }
    default:
        break;
    }
    return 0;
}

int ast2llvmArithUExpr_first(aA_arithUExpr a)
{
    if (a->op == A_neg)
    {
        return -ast2llvmExprUnit_first(a->expr);
    }
    return 0;
}

int ast2llvmArithExpr_first(aA_arithExpr a)
{
    switch (a->kind)
    {
    case A_arithBiOpExprKind:
    {
        return ast2llvmArithBiOpExpr_first(a->u.arithBiOpExpr);
        break;
    }
    case A_exprUnitKind:
    {
        return ast2llvmExprUnit_first(a->u.exprUnit);
        break;
    }
    default:
        assert(0);
        break;
    }
    return 0;
}

int ast2llvmExprUnit_first(aA_exprUnit e)
{
    if (e->kind == A_numExprKind)
    {
        return e->u.num;
    }
    else if (e->kind == A_arithExprKind)
    {
        return ast2llvmArithExpr_first(e->u.arithExpr);
    }
    else if (e->kind == A_arithUExprKind)
    {
        return ast2llvmArithUExpr_first(e->u.arithUExpr);
    }
    else
    {
        assert(0);
    }
    return 0;
}

std::vector<LLVMIR::L_def *> ast2llvmProg_first(aA_program p)
{
    vector<L_def *> defs;
    defs.push_back(L_Funcdecl("getch", vector<TempDef>(), FuncType(ReturnType::INT_TYPE)));
    defs.push_back(L_Funcdecl("getint", vector<TempDef>(), FuncType(ReturnType::INT_TYPE)));
    defs.push_back(L_Funcdecl("putch", vector<TempDef>{TempDef(TempType::INT_TEMP)}, FuncType(ReturnType::VOID_TYPE)));
    defs.push_back(L_Funcdecl("putint", vector<TempDef>{TempDef(TempType::INT_TEMP)}, FuncType(ReturnType::VOID_TYPE)));
    defs.push_back(L_Funcdecl("putarray", vector<TempDef>{TempDef(TempType::INT_TEMP), TempDef(TempType::INT_PTR, -1)}, FuncType(ReturnType::VOID_TYPE)));
    defs.push_back(L_Funcdecl("_sysy_starttime", vector<TempDef>{TempDef(TempType::INT_TEMP)}, FuncType(ReturnType::VOID_TYPE)));
    defs.push_back(L_Funcdecl("_sysy_stoptime", vector<TempDef>{TempDef(TempType::INT_TEMP)}, FuncType(ReturnType::VOID_TYPE)));
    for (const auto &v : p->programElements)
    {
        switch (v->kind)
        {
        case A_programNullStmtKind:
        {
            break;
        }
        case A_programVarDeclStmtKind:
        {
            if (v->u.varDeclStmt->kind == A_varDeclKind)
            {
                if (v->u.varDeclStmt->u.varDecl->kind == A_varDeclScalarKind)
                {
                    if (v->u.varDeclStmt->u.varDecl->u.declScalar->type->type == A_structTypeKind)
                    {
                        globalVarMap.emplace(*v->u.varDeclStmt->u.varDecl->u.declScalar->id,
                                             Name_newname_struct(Temp_newlabel_named(*v->u.varDeclStmt->u.varDecl->u.declScalar->id), *v->u.varDeclStmt->u.varDecl->u.declScalar->type->u.structType));
                        TempDef def(TempType::STRUCT_TEMP, 0, *v->u.varDeclStmt->u.varDecl->u.declScalar->type->u.structType);
                        defs.push_back(L_Globaldef(*v->u.varDeclStmt->u.varDecl->u.declScalar->id, def, vector<int>()));
                    }
                    else
                    {
                        globalVarMap.emplace(*v->u.varDeclStmt->u.varDecl->u.declScalar->id,
                                             Name_newname_int(Temp_newlabel_named(*v->u.varDeclStmt->u.varDecl->u.declScalar->id)));
                        TempDef def(TempType::INT_TEMP, 0);
                        defs.push_back(L_Globaldef(*v->u.varDeclStmt->u.varDecl->u.declScalar->id, def, vector<int>()));
                    }
                }
                else if (v->u.varDeclStmt->u.varDecl->kind == A_varDeclArrayKind)
                {
                    if (v->u.varDeclStmt->u.varDecl->u.declArray->type->type == A_structTypeKind)
                    {
                        globalVarMap.emplace(*v->u.varDeclStmt->u.varDecl->u.declArray->id,
                                             Name_newname_struct_ptr(Temp_newlabel_named(*v->u.varDeclStmt->u.varDecl->u.declArray->id), v->u.varDeclStmt->u.varDecl->u.declArray->len, *v->u.varDeclStmt->u.varDecl->u.declArray->type->u.structType));
                        TempDef def(TempType::STRUCT_PTR, v->u.varDeclStmt->u.varDecl->u.declArray->len, *v->u.varDeclStmt->u.varDecl->u.declArray->type->u.structType);
                        defs.push_back(L_Globaldef(*v->u.varDeclStmt->u.varDecl->u.declArray->id, def, vector<int>()));
                    }
                    else
                    {
                        globalVarMap.emplace(*v->u.varDeclStmt->u.varDecl->u.declArray->id,
                                             Name_newname_int_ptr(Temp_newlabel_named(*v->u.varDeclStmt->u.varDecl->u.declArray->id), v->u.varDeclStmt->u.varDecl->u.declArray->len));
                        TempDef def(TempType::INT_PTR, v->u.varDeclStmt->u.varDecl->u.declArray->len);
                        defs.push_back(L_Globaldef(*v->u.varDeclStmt->u.varDecl->u.declArray->id, def, vector<int>()));
                    }
                }
                else
                {
                    assert(0);
                }
            }
            else if (v->u.varDeclStmt->kind == A_varDefKind)
            {
                if (v->u.varDeclStmt->u.varDef->kind == A_varDefScalarKind)
                {
                    if (v->u.varDeclStmt->u.varDef->u.defScalar->type->type == A_structTypeKind)
                    {
                        globalVarMap.emplace(*v->u.varDeclStmt->u.varDef->u.defScalar->id,
                                             Name_newname_struct(Temp_newlabel_named(*v->u.varDeclStmt->u.varDef->u.defScalar->id), *v->u.varDeclStmt->u.varDef->u.defScalar->type->u.structType));
                        TempDef def(TempType::STRUCT_TEMP, 0, *v->u.varDeclStmt->u.varDef->u.defScalar->type->u.structType);
                        defs.push_back(L_Globaldef(*v->u.varDeclStmt->u.varDef->u.defScalar->id, def, vector<int>()));
                    }
                    else
                    {
                        globalVarMap.emplace(*v->u.varDeclStmt->u.varDef->u.defScalar->id,
                                             Name_newname_int(Temp_newlabel_named(*v->u.varDeclStmt->u.varDef->u.defScalar->id)));
                        TempDef def(TempType::INT_TEMP, 0);
                        vector<int> init;
                        init.push_back(ast2llvmRightVal_first(v->u.varDeclStmt->u.varDef->u.defScalar->val));
                        defs.push_back(L_Globaldef(*v->u.varDeclStmt->u.varDef->u.defScalar->id, def, init));
                    }
                }
                else if (v->u.varDeclStmt->u.varDef->kind == A_varDefArrayKind)
                {
                    if (v->u.varDeclStmt->u.varDef->u.defArray->type->type == A_structTypeKind)
                    {
                        globalVarMap.emplace(*v->u.varDeclStmt->u.varDef->u.defArray->id,
                                             Name_newname_struct_ptr(Temp_newlabel_named(*v->u.varDeclStmt->u.varDef->u.defArray->id), v->u.varDeclStmt->u.varDef->u.defArray->len, *v->u.varDeclStmt->u.varDef->u.defArray->type->u.structType));
                        TempDef def(TempType::STRUCT_PTR, v->u.varDeclStmt->u.varDef->u.defArray->len, *v->u.varDeclStmt->u.varDef->u.defArray->type->u.structType);
                        defs.push_back(L_Globaldef(*v->u.varDeclStmt->u.varDef->u.defArray->id, def, vector<int>()));
                    }
                    else
                    {
                        globalVarMap.emplace(*v->u.varDeclStmt->u.varDef->u.defArray->id,
                                             Name_newname_int_ptr(Temp_newlabel_named(*v->u.varDeclStmt->u.varDef->u.defArray->id), v->u.varDeclStmt->u.varDef->u.defArray->len));
                        TempDef def(TempType::INT_PTR, v->u.varDeclStmt->u.varDef->u.defArray->len);
                        vector<int> init;
                        for (auto &el : v->u.varDeclStmt->u.varDef->u.defArray->vals)
                        {
                            init.push_back(ast2llvmRightVal_first(el));
                        }
                        defs.push_back(L_Globaldef(*v->u.varDeclStmt->u.varDef->u.defArray->id, def, init));
                    }
                }
                else
                {
                    assert(0);
                }
            }
            else
            {
                assert(0);
            }
            break;
        }
        case A_programStructDefKind:
        {
            StructInfo si;
            int off = 0;
            vector<TempDef> members;
            for (const auto &decl : v->u.structDef->varDecls)
            {
                if (decl->kind == A_varDeclScalarKind)
                {
                    if (decl->u.declScalar->type->type == A_structTypeKind)
                    {
                        TempDef def(TempType::STRUCT_TEMP, 0, *decl->u.declScalar->type->u.structType);
                        MemberInfo info(off++, def);
                        si.memberinfos.emplace(*decl->u.declScalar->id, info);
                        members.push_back(def);
                    }
                    else
                    {
                        TempDef def(TempType::INT_TEMP, 0);
                        MemberInfo info(off++, def);
                        si.memberinfos.emplace(*decl->u.declScalar->id, info);
                        members.push_back(def);
                    }
                }
                else if (decl->kind == A_varDeclArrayKind)
                {
                    if (decl->u.declArray->type->type == A_structTypeKind)
                    {
                        TempDef def(TempType::STRUCT_PTR, decl->u.declArray->len, *decl->u.declArray->type->u.structType);
                        MemberInfo info(off++, def);
                        si.memberinfos.emplace(*decl->u.declArray->id, info);
                        members.push_back(def);
                    }
                    else
                    {
                        TempDef def(TempType::INT_PTR, decl->u.declArray->len);
                        MemberInfo info(off++, def);
                        si.memberinfos.emplace(*decl->u.declArray->id, info);
                        members.push_back(def);
                    }
                }
                else
                {
                    assert(0);
                }
            }
            structInfoMap.emplace(*v->u.structDef->id, std::move(si));
            defs.push_back(L_Structdef(*v->u.structDef->id, members));
            break;
        }
        case A_programFnDeclStmtKind:
        {
            FuncType type;
            if (v->u.fnDeclStmt->fnDecl->type == nullptr)
            {
                type.type = ReturnType::VOID_TYPE;
            }
            else if (v->u.fnDeclStmt->fnDecl->type->type == A_nativeTypeKind)
            {
                type.type = ReturnType::INT_TYPE;
            }
            else if (v->u.fnDeclStmt->fnDecl->type->type == A_structTypeKind)
            {
                type.type = ReturnType::STRUCT_TYPE;
                type.structname = *v->u.fnDeclStmt->fnDecl->type->u.structType;
            }
            else
            {
                assert(0);
            }
            if (funcReturnMap.find(*v->u.fnDeclStmt->fnDecl->id) == funcReturnMap.end())
                funcReturnMap.emplace(*v->u.fnDeclStmt->fnDecl->id, std::move(type));
            vector<TempDef> args;
            for (const auto &decl : v->u.fnDeclStmt->fnDecl->paramDecl->varDecls)
            {
                if (decl->kind == A_varDeclScalarKind)
                {
                    if (decl->u.declScalar->type->type == A_structTypeKind)
                    {
                        TempDef def(TempType::STRUCT_PTR, 0, *decl->u.declScalar->type->u.structType);
                        args.push_back(def);
                    }
                    else
                    {
                        TempDef def(TempType::INT_TEMP, 0);
                        args.push_back(def);
                    }
                }
                else if (decl->kind == A_varDeclArrayKind)
                {
                    if (decl->u.declArray->type->type == A_structTypeKind)
                    {
                        TempDef def(TempType::STRUCT_PTR, -1, *decl->u.declArray->type->u.structType);
                        args.push_back(def);
                    }
                    else
                    {
                        TempDef def(TempType::INT_PTR, -1);
                        args.push_back(def);
                    }
                }
                else
                {
                    assert(0);
                }
            }
            defs.push_back(L_Funcdecl(*v->u.fnDeclStmt->fnDecl->id, args, type));
            break;
        }
        case A_programFnDefKind:
        {
            if (funcReturnMap.find(*v->u.fnDef->fnDecl->id) == funcReturnMap.end())
            {
                FuncType type;
                if (v->u.fnDef->fnDecl->type == nullptr)
                {
                    type.type = ReturnType::VOID_TYPE;
                }
                else if (v->u.fnDef->fnDecl->type->type == A_nativeTypeKind)
                {
                    type.type = ReturnType::INT_TYPE;
                }
                else if (v->u.fnDef->fnDecl->type->type == A_structTypeKind)
                {
                    type.type = ReturnType::STRUCT_TYPE;
                    type.structname = *v->u.fnDef->fnDecl->type->u.structType;
                }
                else
                {
                    assert(0);
                }
                funcReturnMap.emplace(*v->u.fnDef->fnDecl->id, std::move(type));
            }
            break;
        }
        default:
            assert(0);
            break;
        }
    }
    return defs;
}

std::vector<Func_local *> ast2llvmProg_second(aA_program p)
{
    vector<Func_local *> funcs;
    for (const auto &v : p->programElements)
    {
        switch (v->kind)
        {
        case A_programNullStmtKind:
        {
            break;
        }
        case A_programVarDeclStmtKind:
        {
            break;
        }
        case A_programStructDefKind:
        {
            break;
        }
        case A_programFnDeclStmtKind:
        {
            break;
        }
        case A_programFnDefKind:
        {
            funcs.push_back(ast2llvmFunc(v->u.fnDef));
            break;
        }
        default:
            assert(0);
            break;
        }
    }
    return funcs;
}

Func_local *ast2llvmFunc(aA_fnDef f)
{
    emit_irs.clear();
    // emit_irs = list<L_stm *>();
    vector<Temp_temp *> args;
    // list<L_stm *> irs;
    for (const auto &decl : f->fnDecl->paramDecl->varDecls)
    {
        switch (decl->kind)
        {
        case A_varDeclScalarKind:
        {
            switch (decl->u.declScalar->type->type)
            {
            case A_nativeTypeKind:
                args.push_back(Temp_newtemp_int());
                break;
            case A_structTypeKind:
                args.push_back(Temp_newtemp_struct(*decl->u.declScalar->id));
                break;
            default:
                assert(0);
                break;
            }
        }
        break;
        case A_varDeclArrayKind:
        {
            switch (decl->u.declArray->type->type)
            {
            case A_nativeTypeKind:
                args.push_back(Temp_newtemp_int_ptr(decl->u.declArray->len));
                break;
            case A_structTypeKind:
                args.push_back(Temp_newtemp_struct_ptr(decl->u.declArray->len, *decl->u.declArray->id));
                break;
            default:
                assert(0);
                break;
            }
        }
        break;
        default:
            assert(0);
            break;
        }
    }

    for (aA_codeBlockStmt codeBlockStmt : f->stmts)
    {
        // Temp_label *con_label = Temp_newlabel();
        // Temp_label *bre_label = Temp_newlabel();
        // ast2llvmBlock(codeBlockStmt, con_label, bre_label);
        switch (codeBlockStmt->kind)
        {
        case A_nullStmtKind:
            break;
        case A_varDeclStmtKind:
        {
            if (codeBlockStmt->u.varDeclStmt->kind == A_varDeclKind)
            {
                switch (codeBlockStmt->u.varDeclStmt->u.varDecl->kind)
                {
                case A_varDeclScalarKind:
                {
                    if (codeBlockStmt->u.varDeclStmt->u.varDecl->u.declScalar->type->type == A_structTypeKind)
                    {
                        localVarMap.emplace(*codeBlockStmt->u.varDeclStmt->u.varDecl->u.declScalar->id,
                                            Temp_newtemp_struct(*codeBlockStmt->u.varDeclStmt->u.varDecl->u.declScalar->id));
                    }
                    else
                    {
                        localVarMap.emplace(*codeBlockStmt->u.varDeclStmt->u.varDecl->u.declScalar->id,
                                            Temp_newtemp_int());
                    }
                }
                break;
                case A_varDeclArrayKind:
                {
                    if (codeBlockStmt->u.varDeclStmt->u.varDecl->u.declArray->type->type == A_structTypeKind)
                    {
                        localVarMap.emplace(*codeBlockStmt->u.varDeclStmt->u.varDecl->u.declArray->id,
                                            Temp_newtemp_struct_ptr(codeBlockStmt->u.varDeclStmt->u.varDecl->u.declArray->len, *codeBlockStmt->u.varDeclStmt->u.varDecl->u.declArray->id));
                    }
                    else
                    {
                        localVarMap.emplace(*codeBlockStmt->u.varDeclStmt->u.varDecl->u.declArray->id,
                                            Temp_newtemp_int_ptr(codeBlockStmt->u.varDeclStmt->u.varDecl->u.declArray->len));
                    }
                }
                break;
                default:
                    assert(0);
                    break;
                }
            }
            else if (codeBlockStmt->u.varDeclStmt->kind == A_varDefKind)
            {
                switch (codeBlockStmt->u.varDeclStmt->u.varDef->kind)
                {
                case A_varDefScalarKind:
                {
                    switch (codeBlockStmt->u.varDeclStmt->u.varDef->u.defScalar->type->type)
                    {
                    case A_structTypeKind:
                    {
                        localVarMap.emplace(*codeBlockStmt->u.varDeclStmt->u.varDef->u.defScalar->id,
                                            Temp_newtemp_struct(*codeBlockStmt->u.varDeclStmt->u.varDef->u.defScalar->id));
                        emit_irs.push_back(L_Move(AS_Operand_Temp(localVarMap[*codeBlockStmt->u.varDeclStmt->u.varDef->u.defScalar->id]),
                                                  ast2llvmRightVal(codeBlockStmt->u.varDeclStmt->u.varDef->u.defScalar->val)));
                    }
                    break;
                    case A_nativeTypeKind:
                    {
                        localVarMap.emplace(*codeBlockStmt->u.varDeclStmt->u.varDef->u.defScalar->id,
                                            Temp_newtemp_int());
                        emit_irs.push_back(L_Move(AS_Operand_Temp(localVarMap[*codeBlockStmt->u.varDeclStmt->u.varDef->u.defScalar->id]),
                                                  ast2llvmRightVal(codeBlockStmt->u.varDeclStmt->u.varDef->u.defScalar->val)));
                    }
                    break;
                    default:
                        assert(0);
                        break;
                    }
                }
                break;
                case A_varDefArrayKind:
                {
                    switch (codeBlockStmt->u.varDeclStmt->u.varDef->u.defArray->type->type)
                    {
                    case A_structTypeKind:
                    {
                        localVarMap.emplace(*codeBlockStmt->u.varDeclStmt->u.varDef->u.defArray->id,
                                            Temp_newtemp_struct_ptr(codeBlockStmt->u.varDeclStmt->u.varDef->u.defArray->len, *codeBlockStmt->u.varDeclStmt->u.varDef->u.defArray->id));
                        emit_irs.push_back(L_Move(AS_Operand_Temp(localVarMap[*codeBlockStmt->u.varDeclStmt->u.varDef->u.defArray->id]),
                                                  ast2llvmRightVal(codeBlockStmt->u.varDeclStmt->u.varDef->u.defArray->vals.front())));
                    }
                    break;
                    case A_nativeTypeKind:
                    {
                        localVarMap.emplace(*codeBlockStmt->u.varDeclStmt->u.varDef->u.defArray->id,
                                            Temp_newtemp_int_ptr(codeBlockStmt->u.varDeclStmt->u.varDef->u.defArray->len));
                        emit_irs.push_back(L_Move(AS_Operand_Temp(localVarMap[*codeBlockStmt->u.varDeclStmt->u.varDef->u.defArray->id]),
                                                  ast2llvmRightVal(codeBlockStmt->u.varDeclStmt->u.varDef->u.defArray->vals.front())));
                    }
                    break;
                    default:
                        break;
                    }
                }
                break;
                default:
                    assert(0);
                    break;
                }
            }
        }
        break;
        case A_assignStmtKind:
        {
            emit_irs.push_back(L_Move(ast2llvmRightVal(codeBlockStmt->u.assignStmt->rightVal),
                                      ast2llvmLeftVal(codeBlockStmt->u.assignStmt->leftVal)));
        }
        break;
        case A_callStmtKind:
        {
            // AS_operand *res = AS_Operand_Temp(Temp_newtemp_int());
            vector<AS_operand *> args;
            for (const auto &arg : codeBlockStmt->u.callStmt->fnCall->vals)
            {
                args.push_back(ast2llvmRightVal(arg));
            }
            emit_irs.push_back(L_Voidcall(*codeBlockStmt->u.callStmt->fnCall->fn, args));
        }
        break;
        case A_ifStmtKind:
        {
            // L_Block
            // L_Cmp;
            // codeBlockStmt->u.ifStmt->boolExpr
        }
        break;
        case A_whileStmtKind:
        {
        }
        break;
        case A_returnStmtKind:
        {
            emit_irs.push_back(L_Ret(AS_Operand_Temp(localVarMap[*f->fnDecl->id])));
        }
        break;
        case A_continueStmtKind:
        {
        }
        break;
        case A_breakStmtKind:
        {
        }
        break;
        default:
            break;
        }
    }
    // in order not to clear? TODO
    return new Func_local(*f->fnDecl->id, funcReturnMap[*f->fnDecl->id], args, *new list<L_stm *>(emit_irs));
}

void ast2llvmBlock(aA_codeBlockStmt b, Temp_label *con_label, Temp_label *bre_label)
{
    // switch (b->kind)
    // {
    // case A_nullStmtKind:
    //     break;
    // case A_varDeclStmtKind:
    //     break;
    // case A_assignStmtKind:
    //     break;
    // case A_callStmtKind:
    //     break;
    // case A_ifStmtKind:
    //     break;
    // case A_whileStmtKind:
    //     break;
    // case A_returnStmtKind:
    //     break;
    // case A_continueStmtKind:
    //     break;
    // case A_breakStmtKind:
    //     break;
    // default:
    //     break;
    // }
}

AS_operand *ast2llvmRightVal(aA_rightVal r)
{
    switch (r->kind)
    {
    case A_arithExprValKind:
    {
        return ast2llvmArithExpr(r->u.arithExpr);
    }
    break;
    case A_boolExprValKind:
    {
        // TODO
        return ast2llvmBoolExpr(r->u.boolExpr, nullptr, nullptr);
    }
    break;
    default:
        break;
    }
}

AS_operand *ast2llvmLeftVal(aA_leftVal l)
{
    switch (l->kind)
    {
    case A_varValKind:
    {
        return AS_Operand_Temp(localVarMap[*l->u.id]);
    }
    break;
    case A_arrValKind:
    {
        AS_operand *new_ptr;
        auto leftval = ast2llvmLeftVal(l->u.arrExpr->arr);
        switch (leftval->kind)
        {
        case OperandKind::TEMP:
        {
            switch (leftval->u.TEMP->type)
            {
            case TempType::INT_PTR:
                new_ptr = AS_Operand_Temp(Temp_newtemp_int_ptr(0));
                break;
            case TempType::STRUCT_PTR:
                new_ptr = AS_Operand_Temp(Temp_newtemp_struct_ptr(0, leftval->u.TEMP->structname));
                break;
            default:
                assert(0);
                break;
            }
        }
        break;
        case OperandKind::NAME:
        {
            switch (leftval->u.NAME->type)
            {
            case TempType::INT_PTR:
                new_ptr = AS_Operand_Temp(Temp_newtemp_int_ptr(0));
                break;
            case TempType::STRUCT_PTR:
                new_ptr = AS_Operand_Temp(Temp_newtemp_struct_ptr(0, leftval->u.NAME->structname));
                break;
            default:
                assert(0);
                break;
            }
        }
        break;
        default:
            assert(0);
            break;
        }

        emit_irs.push_back(L_Gep(new_ptr, leftval, ast2llvmIndexExpr(l->u.arrExpr->idx)));
        return new_ptr;
    }
    break;
    case A_memberValKind:
    {
        auto leftval = ast2llvmLeftVal(l->u.memberExpr->structId);
        string name;
        AS_operand *new_ptr;
        switch (leftval->kind)
        {
        case OperandKind::TEMP:
        {
            if (leftval->u.TEMP->type != TempType::STRUCT_PTR)
                assert(0);
            name = leftval->u.TEMP->structname;
        }
        break;
        case OperandKind::NAME:
        {
            if (leftval->u.NAME->type != TempType::STRUCT_PTR)
                assert(0);
            name = leftval->u.NAME->structname;
        }
        break;
        default:
            assert(0);
            break;
        }
        int offset = structInfoMap[name].memberinfos[*l->u.memberExpr->memberId].offset;
        new_ptr = AS_Operand_Temp(Temp_newtemp_struct_ptr(0, name));
        emit_irs.push_back(L_Gep(new_ptr, leftval, AS_Operand_Const(offset)));
        return new_ptr;
    }
    break;
    default:
        assert(0);
        break;
    }
}

AS_operand *ast2llvmIndexExpr(aA_indexExpr index)
{
    return ast2llvmIndexExpr(index);
}

AS_operand *ast2llvmBoolExpr(aA_boolExpr b, Temp_label *true_label, Temp_label *false_label)
{
    switch (b->kind)
    {
    case A_boolBiOpExprKind:
    {
        ast2llvmBoolBiOpExpr(b->u.boolBiOpExpr, true_label, false_label);
        return nullptr;
    }
    break;
    case A_boolUnitKind:
    {
        ast2llvmBoolUnit(b->u.boolUnit, true_label, false_label);
        return nullptr;
    }
    break;
    default:
        break;
    }
}

void ast2llvmBoolBiOpExpr(aA_boolBiOpExpr b, Temp_label *true_label, Temp_label *false_label)
{
    auto l = ast2llvmBoolExpr(b->left, true_label, false_label);
    auto r = ast2llvmBoolExpr(b->right, true_label, false_label);
    switch (b->op)
    {
    case A_and:
    {
        // emit_irs.push_back(L_CJump(L_relopKind::T_eq, l, AS_Operand_Const(1), true_label, false_label));
        // emit_irs.push_back(L_CJump(L_relopKind::T_eq, r, AS_Operand_Const(1), true_label, false_label));
    }
    break;
    case A_or:
    {
        // emit_irs.push_back(L_CJump(L_relopKind::T_eq, l, AS_Operand_Const(1), true_label, false_label));
        // emit_irs.push_back(L_CJump(L_relopKind::T_eq, r, AS_Operand_Const(1), true_label, false_label));
    }
    break;
    default:
        assert(0);
        break;
    }
}

void ast2llvmBoolUnit(aA_boolUnit b, Temp_label *true_label, Temp_label *false_label)
{
    switch (b->kind)
    {
    case A_comOpExprKind:
    {
        // a > b
        return ast2llvmComOpExpr(b->u.comExpr, true_label, false_label);
    }
    break;
    case A_boolExprKind:
    {
        // TODO
        ast2llvmBoolExpr(b->u.boolExpr, true_label, false_label);
        return;
        // b->u.boolExpr
    }
    break;
    case A_boolUOpExprKind:
    {
        // !a
        return ast2llvmBoolUOpExpr(b->u.boolUOpExpr, true_label, false_label);
    }
    break;
    default:
        assert(0);
        break;
    }
}

void ast2llvmBoolUOpExpr(aA_boolUOpExpr b, Temp_label *true_label, Temp_label *false_label)
{
    switch (b->op)
    {
    case A_not:
    {
        // emit_irs.push_back(L_CJump(L_relopKind::T_eq, ast2llvmBoolUnit(b->boolUnit, true_label, false_label), AS_Operand_Const(0), true_label, false_label));
    }
    break;
    default:
        assert(0);
        break;
    }
}

void ast2llvmComOpExpr(aA_comExpr c, Temp_label *true_label, Temp_label *false_label)
{
    LLVMIR::L_relopKind kind;
    switch (c->op)
    {
    case A_lt:
        kind = L_relopKind::T_lt;
        break;
    case A_le:
        kind = L_relopKind::T_lt;
        break;
    case A_gt:
        kind = L_relopKind::T_lt;
        break;
    case A_ge:
        kind = L_relopKind::T_lt;
        break;
    case A_eq:
        kind = L_relopKind::T_lt;
        break;
    case A_ne:
        kind = L_relopKind::T_lt;
        break;
    default:
        assert(0);
        break;
    }
    emit_irs.push_back(L_Cmp(kind, ast2llvmExprUnit(c->left), ast2llvmExprUnit(c->right), AS_Operand_Temp(Temp_newtemp_int())));
}

AS_operand *ast2llvmArithBiOpExpr(aA_arithBiOpExpr a)
{
    auto l = ast2llvmArithExpr(a->left);
    auto r = ast2llvmArithExpr(a->right);
    LLVMIR::L_binopKind op;
    switch (a->op)
    {
    case A_add:
        op = L_binopKind::T_plus;
        break;
    case A_sub:
        op = L_binopKind::T_minus;
        break;
    case A_mul:
        op = L_binopKind::T_mul;
        break;
    case A_div:
        op = L_binopKind::T_div;
        break;
    default:
        assert(0);
        break;
    }
    AS_operand *res = AS_Operand_Temp(Temp_newtemp_int());
    emit_irs.push_back(L_Binop(op, l, r, res));
    return res;
}

AS_operand *ast2llvmArithUExpr(aA_arithUExpr a)
{
    return ast2llvmArithUExpr(a);
}

AS_operand *ast2llvmArithExpr(aA_arithExpr a)
{
    switch (a->kind)
    {
    case A_arithBiOpExprKind:
    {
        return ast2llvmArithBiOpExpr(a->u.arithBiOpExpr);
    }
    break;
    case A_exprUnitKind:
    {
        return ast2llvmExprUnit(a->u.exprUnit);
    }
    break;
    default:
        assert(0);
        break;
    }
}

AS_operand *ast2llvmExprUnit(aA_exprUnit e)
{
    // TODO load
    switch (e->kind)
    {
    case A_numExprKind:
    {
        return AS_Operand_Const(e->u.num);
    }
    break;
    case A_idExprKind:
    {
        return AS_Operand_Temp(localVarMap[*e->u.id]);
    }
    break;
    case A_arithExprKind:
    {
        return ast2llvmArithExpr(e->u.arithExpr);
    }
    break;
    case A_fnCallKind:
    {
        AS_operand *res;
        switch (funcReturnMap[*e->u.callExpr->fn].type)
        {
        case ReturnType::INT_TYPE:
            res = AS_Operand_Temp(Temp_newtemp_int());
            break;
        case ReturnType::STRUCT_TYPE:
            res = AS_Operand_Temp(Temp_newtemp_struct(funcReturnMap[*e->u.callExpr->fn].structname));
            break;
        default:
            assert(0);
            break;
        }
        vector<AS_operand *> args;
        for (const auto &arg : e->u.callExpr->vals)
        {
            args.push_back(ast2llvmRightVal(arg));
        }
        emit_irs.push_back(L_Call(*e->u.callExpr->fn, res, args));
        return res;
    }
    break;
    case A_arrayExprKind:
    {
        return getArray(e->u.arrayExpr);
    }
    break;
    case A_memberExprKind:
    {
        return getMember(e->u.memberExpr);
    }
    break;
    case A_arithUExprKind:
    {
        return ast2llvmArithUExpr(e->u.arithUExpr);
    }
    break;
    default:
        assert(0);
        break;
    }
}

LLVMIR::L_func *ast2llvmFuncBlock(Func_local *f)
{
    list<L_block *> blocks;
    list<L_stm *> irs;
    for (const auto &block : f->irs)
    {
        if (block->type == L_StmKind::T_LABEL)
        {
            if (!irs.empty())
                blocks.push_back(L_Block(irs));
            irs.clear();
        }
        irs.push_back(block);
        // switch (block->type)
        // {
        //     if
        // case L_StmKind::T_LABEL:
        // {
        //     if (!irs.empty())
        //         blocks.push_back(L_Block(irs));
        //     irs.clear();
        // }
        // break;
        // default:
        //     break;
        // }
    }
    return new L_func(f->name, f->ret, f->args, blocks);
}

void ast2llvm_moveAlloca(LLVMIR::L_func *f)
{
    auto first_block = f->blocks.front();
    for (auto i = ++f->blocks.begin(); i != f->blocks.end(); ++i)
    {
        for (auto it = (*i)->instrs.begin(); it != (*i)->instrs.end();)
        {
            if ((*it)->type == L_StmKind::T_ALLOCA)
            {
                first_block->instrs.insert(++first_block->instrs.begin(), *it);
                it = (*i)->instrs.erase(it);
            }
            else
            {
                ++it;
            }
        }
    }
}

AS_operand *getArray(aA_arrayExpr arrExpr)
{
    AS_operand *new_ptr;
    auto leftval = ast2llvmLeftVal(arrExpr->arr);
    switch (leftval->kind)
    {
    case OperandKind::TEMP:
    {
        switch (leftval->u.TEMP->type)
        {
        case TempType::INT_PTR:
            new_ptr = AS_Operand_Temp(Temp_newtemp_int_ptr(0));
            break;
        case TempType::STRUCT_PTR:
            new_ptr = AS_Operand_Temp(Temp_newtemp_struct_ptr(0, leftval->u.TEMP->structname));
            break;
        default:
            assert(0);
            break;
        }
    }
    break;
    case OperandKind::NAME:
    {
        switch (leftval->u.NAME->type)
        {
        case TempType::INT_PTR:
            new_ptr = AS_Operand_Temp(Temp_newtemp_int_ptr(0));
            break;
        case TempType::STRUCT_PTR:
            new_ptr = AS_Operand_Temp(Temp_newtemp_struct_ptr(0, leftval->u.NAME->structname));
            break;
        default:
            assert(0);
            break;
        }
    }
    break;
    default:
        assert(0);
        break;
    }
    emit_irs.push_back(L_Gep(new_ptr, leftval, ast2llvmIndexExpr(arrExpr->idx)));
    return new_ptr;
}

AS_operand *getMember(aA_memberExpr memberExpr)
{
    auto leftval = ast2llvmLeftVal(memberExpr->structId);
    string name;
    AS_operand *new_ptr;
    switch (leftval->kind)
    {
    case OperandKind::TEMP:
    {
        if (leftval->u.TEMP->type != TempType::STRUCT_PTR)
            assert(0);
        name = leftval->u.TEMP->structname;
    }
    break;
    case OperandKind::NAME:
    {
        if (leftval->u.NAME->type != TempType::STRUCT_PTR)
            assert(0);
        name = leftval->u.NAME->structname;
    }
    break;
    default:
        assert(0);
        break;
    }
    int offset = structInfoMap[name].memberinfos[*memberExpr->memberId].offset;
    new_ptr = AS_Operand_Temp(Temp_newtemp_struct_ptr(0, name));
    emit_irs.push_back(L_Gep(new_ptr, leftval, AS_Operand_Const(offset)));
    return new_ptr;
}