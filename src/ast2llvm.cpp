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
                    if (!v->u.varDeclStmt->u.varDecl->u.declScalar->type)
                    {
                        assert(0);
                        // Temp_temp *temp = nullptr;
                        // globalVarMap.emplace(*v->u.varDeclStmt->u.varDecl->u.declScalar->id, Name_newname_int(temp));
                    }
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
    localVarMap.clear();
    emit_irs.clear();
    emit_irs.push_back(L_Label(Temp_newlabel_named(*f->fnDecl->id)));
    // emit_irs = list<L_stm *>();
    vector<Temp_temp *> args;
    for (const auto &decl : f->fnDecl->paramDecl->varDecls)
    {
        // there's no need to alloc in decl ?
        // each var in localmap is pointer
        switch (decl->kind)
        {
        case A_varDeclScalarKind:
        {
            if (!decl->u.declScalar->type)
                assert(0);
            switch (decl->u.declScalar->type->type)
            {
            case A_nativeTypeKind:
            {
                Temp_temp *temp = Temp_newtemp_int();
                Temp_temp *temp_ptr = Temp_newtemp_int_ptr(0);
                args.push_back(temp);
                emit_irs.push_back(L_Alloca(AS_Operand_Temp(temp_ptr)));
                emit_irs.push_back(L_Store(AS_Operand_Temp(temp), AS_Operand_Temp(temp_ptr)));
                localVarMap[*decl->u.declScalar->id] = temp_ptr;
                // localVarMap.emplace(*decl->u.declScalar->id, temp_ptr);
            }
            break;
            case A_structTypeKind:
            {
                Temp_temp *temp = Temp_newtemp_struct_ptr(0, *decl->u.declScalar->type->u.structType);
                args.push_back(temp);
                localVarMap[*decl->u.declScalar->id] = temp;
                // localVarMap.emplace(*decl->u.declScalar->id, temp);
            }
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
            {
                // decl->u.declArray->len
                Temp_temp *temp = Temp_newtemp_int_ptr(-1);
                args.push_back(temp);
                localVarMap[*decl->u.declArray->id] = temp;
                // localVarMap.emplace(*decl->u.declArray->id, temp);
            }
            break;
            case A_structTypeKind:
            {
                // struct array exist!
                Temp_temp *temp = Temp_newtemp_struct_ptr(-1, *decl->u.declArray->type->u.structType);
                args.push_back(temp);
                localVarMap[*decl->u.declArray->id] = temp;
                // localVarMap.emplace(*decl->u.declArray->id, temp);
            }
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

    // printf("fnname: %s\n", f->fnDecl->id->c_str());
    ast2llvmBlock(f->stmts, nullptr, nullptr);
    // TODO
    // only in order to avoid one label in the end
    LLVMIR::FuncType retType = funcReturnMap[*f->fnDecl->id];
    switch (retType.type)
    {
    case ReturnType::VOID_TYPE:
        emit_irs.push_back(L_Ret(nullptr));
        break;
    case ReturnType::INT_TYPE:
        emit_irs.push_back(L_Ret(AS_Operand_Const(0)));
        break;
    case ReturnType::STRUCT_TYPE:
        // 悬垂指针
        // emit_irs.push_back(L_Ret(AS_Operand_Temp(Temp_newtemp_struct_ptr(0, retType.structname))));
        // assert(0);
        break;
    default:
        assert(0);
        break;
    }

    // in order not to clear? TODO
    return new Func_local(*f->fnDecl->id, retType, args, *new list<L_stm *>(emit_irs));
}

void ast2llvmBlock(vector<aA_codeBlockStmt> stmts, Temp_label *con_label, Temp_label *bre_label)
{
    // void getCodeBlockStmts(vector<aA_codeBlockStmt> stmts, string *fnname)
    for (aA_codeBlockStmt codeBlockStmt : stmts)
    {
        if (!codeBlockStmt)
            continue;
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
                    if (localVarMap.find(*codeBlockStmt->u.varDeclStmt->u.varDecl->u.declScalar->id) != localVarMap.end())
                        assert(0);
                    // no type
                    if (!codeBlockStmt->u.varDeclStmt->u.varDecl->u.declScalar->type)
                    {
                        assert(0);
                        // Mention! no type scalar
                        Temp_temp *temp = nullptr;
                        localVarMap[*codeBlockStmt->u.varDeclStmt->u.varDecl->u.declScalar->id] = temp;
                        // localVarMap.emplace(*codeBlockStmt->u.varDeclStmt->u.varDecl->u.declScalar->id, temp);
                        continue;
                    }

                    if (codeBlockStmt->u.varDeclStmt->u.varDecl->u.declScalar->type->type == A_structTypeKind)
                    {
                        // pointer
                        // Temp_temp *temp = Temp_newtemp_struct(*codeBlockStmt->u.varDeclStmt->u.varDecl->u.declScalar->id);
                        Temp_temp *temp = Temp_newtemp_struct_ptr(0, *codeBlockStmt->u.varDeclStmt->u.varDecl->u.declScalar->type->u.structType);
                        emit_irs.push_back(L_Alloca(AS_Operand_Temp(temp)));
                        localVarMap[*codeBlockStmt->u.varDeclStmt->u.varDecl->u.declScalar->id] = temp;
                        // localVarMap.emplace(*codeBlockStmt->u.varDeclStmt->u.varDecl->u.declScalar->id, temp);
                    }
                    else
                    {
                        // store 0 automatically
                        Temp_temp *temp = Temp_newtemp_int_ptr(0);
                        emit_irs.push_back(L_Alloca(AS_Operand_Temp(temp)));
                        localVarMap[*codeBlockStmt->u.varDeclStmt->u.varDecl->u.declScalar->id] = temp;
                        // localVarMap.emplace(*codeBlockStmt->u.varDeclStmt->u.varDecl->u.declScalar->id, temp);
                    }
                }
                break;
                case A_varDeclArrayKind:
                {
                    if (localVarMap.find(*codeBlockStmt->u.varDeclStmt->u.varDecl->u.declArray->id) != localVarMap.end())
                        assert(0);
                    if (!codeBlockStmt->u.varDeclStmt->u.varDecl->u.declArray->type)
                    {
                        assert(0);
                        // no type array
                        Temp_temp *temp = nullptr;
                        localVarMap[*codeBlockStmt->u.varDeclStmt->u.varDecl->u.declArray->id] = temp;
                        // localVarMap.emplace(*codeBlockStmt->u.varDeclStmt->u.varDecl->u.declScalar->id, temp);
                        continue;
                    }
                    if (codeBlockStmt->u.varDeclStmt->u.varDecl->u.declArray->type->type == A_structTypeKind)
                    {
                        Temp_temp *temp = Temp_newtemp_struct_ptr(codeBlockStmt->u.varDeclStmt->u.varDecl->u.declArray->len, *codeBlockStmt->u.varDeclStmt->u.varDecl->u.declArray->type->u.structType);
                        localVarMap[*codeBlockStmt->u.varDeclStmt->u.varDecl->u.declArray->id] = temp;
                        // localVarMap.emplace(*codeBlockStmt->u.varDeclStmt->u.varDecl->u.declScalar->id, temp);
                        emit_irs.push_back(L_Alloca(AS_Operand_Temp(temp)));
                    }
                    else
                    {
                        Temp_temp *temp = Temp_newtemp_int_ptr(codeBlockStmt->u.varDeclStmt->u.varDecl->u.declArray->len);
                        localVarMap[*codeBlockStmt->u.varDeclStmt->u.varDecl->u.declArray->id] = temp;
                        // localVarMap.emplace(*codeBlockStmt->u.varDeclStmt->u.varDecl->u.declScalar->id, temp);
                        emit_irs.push_back(L_Alloca(AS_Operand_Temp(temp)));
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
                    AS_operand *right = loadPtr(ast2llvmRightVal(codeBlockStmt->u.varDeclStmt->u.varDef->u.defScalar->val));
                    Temp_temp *new_var;
                    if (!codeBlockStmt->u.varDeclStmt->u.varDef->u.defScalar->type)
                    {
                        switch (right->kind)
                        {
                        case OperandKind::TEMP:
                        {
                            switch (right->u.TEMP->type)
                            {
                            // 我们的语言没有结构体和数组的直接赋值
                            case TempType::INT_TEMP:
                            {
                                new_var = Temp_newtemp_int_ptr(0);
                                localVarMap[*codeBlockStmt->u.varDeclStmt->u.varDef->u.defScalar->id] = new_var;
                                // localVarMap.emplace(*codeBlockStmt->u.varDeclStmt->u.varDef->u.defScalar->id, new_var);
                                emit_irs.push_back(L_Alloca(AS_Operand_Temp(new_var)));
                                emit_irs.push_back(L_Store(right, AS_Operand_Temp(new_var)));
                            }
                            break;
                            case TempType::INT_PTR:
                            {
                                assert(0);
                                // get the load content or get head pointer?
                                // new_var = Temp_newtemp_int_ptr(0);
                                // Temp_temp *temp = Temp_newtemp_int();
                                // localVarMap.emplace(*codeBlockStmt->u.varDeclStmt->u.varDef->u.defScalar->id, new_var);
                                // // i think it can run
                                // emit_irs.push_back(L_Load(AS_Operand_Temp(temp), right));
                                // emit_irs.push_back(L_Alloca(AS_Operand_Temp(new_var)));
                                // emit_irs.push_back(L_Store(AS_Operand_Temp(temp), AS_Operand_Temp(new_var)));
                                // // emit_irs.push_back(L_Store(right, AS_Operand_Temp(new_var)));
                            }
                            break;
                            case TempType::STRUCT_TEMP:
                            {
                                assert(0);
                                // get the load content or get head pointer?
                                // // let a struct;
                                // // let b = a;
                                // new_var = Temp_newtemp_struct(*codeBlockStmt->u.varDeclStmt->u.varDef->u.defScalar->id);
                                // // Temp_temp *temp = Temp_newtemp_struct(*codeBlockStmt->u.varDeclStmt->u.varDef->u.defScalar->id);
                                // localVarMap.emplace(*codeBlockStmt->u.varDeclStmt->u.varDef->u.defScalar->id, new_var);
                                // // emit_irs.push_back(L_Load(AS_Operand_Temp(new_var), right));
                                // emit_irs.push_back(L_Alloca(AS_Operand_Temp(new_var)));
                                // emit_irs.push_back(L_Store(right, AS_Operand_Temp(new_var)));
                            }
                            break;
                            case TempType::STRUCT_PTR:
                            {
                                assert(0);
                                // new_var = Temp_newtemp_struct(*codeBlockStmt->u.varDeclStmt->u.varDef->u.defScalar->id);
                                // Temp_temp *temp = Temp_newtemp_struct_ptr(right->u.TEMP->len, *codeBlockStmt->u.varDeclStmt->u.varDef->u.defScalar->id);
                                // localVarMap.emplace(*codeBlockStmt->u.varDeclStmt->u.varDef->u.defScalar->id, new_var);
                                // emit_irs.push_back(L_Load(AS_Operand_Temp(temp), right));
                                // emit_irs.push_back(L_Alloca(AS_Operand_Temp(new_var)));
                                // emit_irs.push_back(L_Store(AS_Operand_Temp(temp), AS_Operand_Temp(new_var)));
                                // // new_var = Temp_newtemp_struct_ptr(right->u.TEMP->len, *codeBlockStmt->u.varDeclStmt->u.varDef->u.defScalar->id);
                                // // localVarMap.emplace(*codeBlockStmt->u.varDeclStmt->u.varDef->u.defScalar->id, new_var);
                                // // emit_irs.push_back(L_Load(AS_Operand_Temp(new_var), right));
                                // // emit_irs.push_back(L_Alloca(AS_Operand_Temp(new_var)));
                                // // emit_irs.push_back(L_Store(right, AS_Operand_Temp(new_var)));
                            }
                            break;
                            default:
                                assert(0);
                                break;
                            }
                        }
                        break;
                        case OperandKind::NAME:
                        {
                            switch (right->u.NAME->type)
                            {
                            case TempType::INT_TEMP:
                                assert(0);
                                break;
                            case TempType::INT_PTR:
                            {
                                if (right->u.NAME->len != 0)
                                    assert(0);
                                Temp_temp *temp = Temp_newtemp_int();
                                new_var = Temp_newtemp_int_ptr(right->u.NAME->len);
                                localVarMap[*codeBlockStmt->u.varDeclStmt->u.varDef->u.defScalar->id] = new_var;
                                // localVarMap.emplace(*codeBlockStmt->u.varDeclStmt->u.varDef->u.defScalar->id, new_var);
                                emit_irs.push_back(L_Load(AS_Operand_Temp(temp), right));
                                emit_irs.push_back(L_Alloca(AS_Operand_Temp(new_var)));
                                emit_irs.push_back(L_Store(AS_Operand_Temp(temp), AS_Operand_Temp(new_var)));
                            }
                            break;
                            case TempType::STRUCT_TEMP:
                            {
                                assert(0);
                                // new_var = Temp_newtemp_struct(*codeBlockStmt->u.varDeclStmt->u.varDef->u.defScalar->id);
                                // localVarMap.emplace(*codeBlockStmt->u.varDeclStmt->u.varDef->u.defScalar->id, new_var);
                                // // emit_irs.push_back(L_Alloca(AS_Operand_Temp(new_var)));
                                // emit_irs.push_back(L_Store(right, AS_Operand_Temp(new_var)));
                            }
                            break;
                            case TempType::STRUCT_PTR:
                            {
                                assert(0);
                                // new_var = Temp_newtemp_struct_ptr(0, *codeBlockStmt->u.varDeclStmt->u.varDef->u.defScalar->id);
                                // localVarMap.emplace(*codeBlockStmt->u.varDeclStmt->u.varDef->u.defScalar->id, new_var);
                                // // emit_irs.push_back(L_Alloca(AS_Operand_Temp(new_var)));
                                // emit_irs.push_back(L_Store(right, AS_Operand_Temp(new_var)));
                            }
                            break;
                            default:
                                assert(0);
                                break;
                            }
                        }
                        break;
                        case OperandKind::ICONST:
                        {
                            new_var = Temp_newtemp_int_ptr(0);
                            emit_irs.push_back(L_Alloca(AS_Operand_Temp(new_var)));
                            emit_irs.push_back(L_Store(right, AS_Operand_Temp(new_var)));
                            localVarMap[*codeBlockStmt->u.varDeclStmt->u.varDef->u.defScalar->id] = new_var;
                            // localVarMap.emplace(*codeBlockStmt->u.varDeclStmt->u.varDef->u.defScalar->id, new_var);
                        }
                        break;
                        default:
                            assert(0);
                            break;
                        }

                        continue;
                    }

                    switch (codeBlockStmt->u.varDeclStmt->u.varDef->u.defScalar->type->type)
                    {
                    case A_structTypeKind:
                    {
                        assert(0);
                        // AS_operand *right = ast2llvmRightVal(codeBlockStmt->u.varDeclStmt->u.varDef->u.defScalar->val);
                        // Temp_temp *temp = Temp_newtemp_struct_ptr(0, *codeBlockStmt->u.varDeclStmt->u.varDef->u.defScalar->id);
                        // localVarMap.emplace(*codeBlockStmt->u.varDeclStmt->u.varDef->u.defScalar->id, temp);
                        // emit_irs.push_back(L_Alloca(AS_Operand_Temp(temp)));
                        // emit_irs.push_back(L_Store(loadPtr(right), AS_Operand_Temp(temp)));
                    }
                    break;
                    case A_nativeTypeKind:
                    {
                        Temp_temp *temp = Temp_newtemp_int_ptr(0);
                        localVarMap[*codeBlockStmt->u.varDeclStmt->u.varDef->u.defScalar->id] = temp;
                        // localVarMap.emplace(*codeBlockStmt->u.varDeclStmt->u.varDef->u.defScalar->id, temp);
                        emit_irs.push_back(L_Alloca(AS_Operand_Temp(temp)));
                        emit_irs.push_back(L_Store(right, AS_Operand_Temp(temp)));
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
                    Temp_temp *new_arr;
                    auto vals = codeBlockStmt->u.varDeclStmt->u.varDef->u.defArray->vals;
                    int len = codeBlockStmt->u.varDeclStmt->u.varDef->u.defArray->len;
                    string id = *codeBlockStmt->u.varDeclStmt->u.varDef->u.defArray->id;
                    string structType = "";
                    if (vals.size() > len)
                        assert(0); // really? typecheck

                    if (!codeBlockStmt->u.varDeclStmt->u.varDef->u.defArray->type)
                    {
                        AS_operand *first = loadPtr(ast2llvmRightVal(vals[0]));
                        switch (first->kind)
                        {
                        case OperandKind::TEMP:
                        {
                            switch (first->u.TEMP->type)
                            {
                            case TempType::INT_TEMP:
                                new_arr = Temp_newtemp_int_ptr(len);
                                break;
                            case TempType::STRUCT_TEMP:
                            case TempType::STRUCT_PTR:
                                // assert(0);
                                structType = *codeBlockStmt->u.varDeclStmt->u.varDef->u.defArray->type->u.structType;
                                new_arr = Temp_newtemp_struct_ptr(len, structType);
                                break;
                            // no struct assign to arr as well?
                            default:
                                assert(0);
                                break;
                            }
                        }
                        break;
                        case OperandKind::ICONST:
                            new_arr = Temp_newtemp_int_ptr(len);
                            break;
                        default:
                            assert(0);
                            break;
                        }
                        localVarMap[id] = new_arr;
                        // localVarMap.emplace(id, new_arr);
                        emit_irs.push_back(L_Alloca(AS_Operand_Temp(new_arr)));
                        put_right_vals_into_array(new_arr, vals, len, new_arr->type, structType);
                        continue;
                    }

                    switch (codeBlockStmt->u.varDeclStmt->u.varDef->u.defArray->type->type)
                    {
                    case A_structTypeKind:
                    {
                        // assert(0);
                        structType = *codeBlockStmt->u.varDeclStmt->u.varDef->u.defArray->type->u.structType;
                        new_arr = Temp_newtemp_struct_ptr(len, structType);
                        localVarMap[id] = new_arr;
                        // localVarMap.emplace(id, new_arr);
                        emit_irs.push_back(L_Alloca(AS_Operand_Temp(new_arr)));
                        put_right_vals_into_array(new_arr, vals, len, TempType::STRUCT_PTR, structType);
                    }
                    break;
                    case A_nativeTypeKind:
                    {
                        new_arr = Temp_newtemp_int_ptr(len);
                        localVarMap[id] = new_arr;
                        // localVarMap.emplace(id, new_arr);
                        emit_irs.push_back(L_Alloca(AS_Operand_Temp(new_arr)));
                        put_right_vals_into_array(new_arr, vals, len, TempType::INT_PTR);
                    }
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
        }
        break;
        case A_assignStmtKind:
        {
            auto left = ast2llvmLeftVal(codeBlockStmt->u.assignStmt->leftVal);
            if (left)
                emit_irs.push_back(L_Store(loadPtr(ast2llvmRightVal(codeBlockStmt->u.assignStmt->rightVal)), left));
            else
            {
                assert(0);
                // update type
            }
        }
        break;
        case A_callStmtKind:
        {
            vector<AS_operand *> args;
            for (const auto &arg : codeBlockStmt->u.callStmt->fnCall->vals)
            {
                AS_operand *res = loadPtr(ast2llvmRightVal(arg));
                args.push_back(res);
            }
            emit_irs.push_back(L_Voidcall(*codeBlockStmt->u.callStmt->fnCall->fn, args));
        }
        break;

        case A_ifStmtKind:
        {
            Temp_label *true_label = Temp_newlabel();
            Temp_label *false_label = Temp_newlabel();
            Temp_label *next_label = Temp_newlabel();
            ast2llvmBoolExpr(codeBlockStmt->u.ifStmt->boolExpr, true_label, false_label);
            emit_irs.push_back(L_Label(true_label));
            ast2llvmBlock(codeBlockStmt->u.ifStmt->ifStmts, con_label, bre_label);
            emit_irs.push_back(L_Jump(next_label));

            emit_irs.push_back(L_Label(false_label));
            ast2llvmBlock(codeBlockStmt->u.ifStmt->elseStmts, con_label, bre_label);
            emit_irs.push_back(L_Jump(next_label));

            emit_irs.push_back(L_Label(next_label));
        }
        break;
        case A_whileStmtKind:
        {
            // condition
            con_label = Temp_newlabel();
            Temp_label *body_label = Temp_newlabel();
            // next
            bre_label = Temp_newlabel();

            emit_irs.push_back(L_Jump(con_label));
            emit_irs.push_back(L_Label(con_label));
            ast2llvmBoolExpr(codeBlockStmt->u.whileStmt->boolExpr, body_label, bre_label);

            emit_irs.push_back(L_Label(body_label));
            ast2llvmBlock(codeBlockStmt->u.whileStmt->whileStmts, con_label, bre_label);
            emit_irs.push_back(L_Jump(con_label));

            emit_irs.push_back(L_Label(bre_label));
        }
        break;
        case A_returnStmtKind:
        {
            if (!codeBlockStmt->u.returnStmt->retVal)
                emit_irs.push_back(L_Ret(nullptr));
            else // empty type?
                emit_irs.push_back(L_Ret(loadPtr(ast2llvmRightVal(codeBlockStmt->u.returnStmt->retVal))));
        }
        break;
        case A_continueStmtKind:
        {
            if (!con_label)
                assert(0);
            emit_irs.push_back(L_Jump(con_label));
        }
        break;
        case A_breakStmtKind:
        {
            if (!bre_label)
                assert(0);
            emit_irs.push_back(L_Jump(bre_label));
        }
        break;
        default:
            assert(0);
            break;
        }
    }
}

AS_operand *ast2llvmRightVal(aA_rightVal r)
{
    if (!r)
        assert(0);
    switch (r->kind)
    {
    case A_arithExprValKind:
    {
        return ast2llvmArithExpr(r->u.arithExpr);
    }
    break;
    case A_boolExprValKind:
    {
        return ast2llvmBoolExpr(r->u.boolExpr, nullptr, nullptr, true);
    }
    break;
    default:
        assert(0);
        break;
    }
}

AS_operand *ast2llvmLeftVal(aA_leftVal l)
{
    switch (l->kind)
    {
    case A_varValKind:
    {
        Temp_temp *temp = localVarMap[*l->u.id];
        if (temp)
            return AS_Operand_Temp(temp);
        Name_name *name = globalVarMap[*l->u.id];
        // TODO!
        if (name)
            return AS_Operand_Name(name);
        // both nullptr
        // global doesn't allow null type
        if (globalVarMap.find(*l->u.id) == globalVarMap.end())
            if (localVarMap.find(*l->u.id) == localVarMap.end())
                assert(0);
        return nullptr;
    }
    break;
    case A_arrValKind:
        return getArray(l->u.arrExpr);
        break;
    case A_memberValKind:
        return getMember(l->u.memberExpr);
        break;
    default:
        assert(0);
        break;
    }
}

AS_operand *ast2llvmIndexExpr(aA_indexExpr index)
{
    switch (index->kind)
    {
    case A_indexExprKind::A_idIndexKind:
    {
        Temp_temp *idx = Temp_newtemp_int();
        Temp_temp *temp = localVarMap[*index->u.id];
        if (temp)
            emit_irs.push_back(L_Load(AS_Operand_Temp(idx), AS_Operand_Temp(temp)));
        else
        {
            Name_name *name = globalVarMap[*index->u.id];
            if (name)
                emit_irs.push_back(L_Load(AS_Operand_Temp(idx), AS_Operand_Name(name)));
            else
                assert(0);
        }
        return AS_Operand_Temp(idx);
    }
    break;
    case A_indexExprKind::A_numIndexKind:
    {
        return AS_Operand_Const(index->u.num);
    }
    break;
    default:
        assert(0);
        break;
    }
}

AS_operand *ast2llvmBoolExpr(aA_boolExpr b, Temp_label *true_label, Temp_label *false_label, bool want_i32)
{
    if (!true_label && !false_label)
    {
        Temp_label *true_label = Temp_newlabel();
        Temp_label *false_label = Temp_newlabel();
        Temp_label *next_label = Temp_newlabel();
        Temp_temp *new_var = Temp_newtemp_int_ptr(0);
        emit_irs.push_back(L_Alloca(AS_Operand_Temp(new_var)));

        switch (b->kind)
        {
        case A_boolBiOpExprKind:
            ast2llvmBoolBiOpExpr(b->u.boolBiOpExpr, true_label, false_label);
            break;
        case A_boolUnitKind:
            ast2llvmBoolUnit(b->u.boolUnit, true_label, false_label);
            break;
        default:
            assert(0);
            break;
        }

        emit_irs.push_back(L_Label(true_label));
        emit_irs.push_back(L_Store(AS_Operand_Const(1), AS_Operand_Temp(new_var)));
        emit_irs.push_back(L_Jump(next_label));

        emit_irs.push_back(L_Label(false_label));
        emit_irs.push_back(L_Store(AS_Operand_Const(0), AS_Operand_Temp(new_var)));
        emit_irs.push_back(L_Jump(next_label));

        emit_irs.push_back(L_Label(next_label));

        Temp_temp *val = Temp_newtemp_int();
        emit_irs.push_back(L_Load(AS_Operand_Temp(val), AS_Operand_Temp(new_var)));
        if (want_i32)
            return AS_Operand_Temp(val);
        Temp_temp *ret = Temp_newtemp_int();
        emit_irs.push_back(L_Cmp(LLVMIR::L_relopKind::T_ne, AS_Operand_Temp(val), AS_Operand_Const(0), AS_Operand_Temp(ret)));
        return AS_Operand_Temp(ret);
    }
    else if (!true_label || !false_label)
        assert(0);

    // if nullptr return value
    // else br
    switch (b->kind)
    {
    case A_boolBiOpExprKind:
        ast2llvmBoolBiOpExpr(b->u.boolBiOpExpr, true_label, false_label);
        return nullptr;
        break;
    case A_boolUnitKind:
        ast2llvmBoolUnit(b->u.boolUnit, true_label, false_label);
        return nullptr;
        break;
    default:
        assert(0);
        break;
    }
}

void ast2llvmBoolBiOpExpr(aA_boolBiOpExpr b, Temp_label *true_label, Temp_label *false_label)
{
    AS_operand *l = ast2llvmBoolExpr(b->left, nullptr, nullptr);
    Temp_label *temp_label = Temp_newlabel();
    switch (b->op)
    {
    case A_and:
    {
        if (true_label && false_label)
        {
            emit_irs.push_back(L_Cjump(l, temp_label, false_label));

            emit_irs.push_back(L_Label(temp_label));
            auto r = ast2llvmBoolExpr(b->right, nullptr, nullptr);
            emit_irs.push_back(L_Cjump(r, true_label, false_label));
            return;
        }
        else
        {
            assert(0);
            return;
            // // is rightval rather than br
            // // return var rather than ptr
            // Temp_temp *res = Temp_newtemp_int_ptr(0);
            // Temp_label *next_label = Temp_newlabel();
            // true_label = Temp_newlabel();

            // emit_irs.push_back(L_Alloca(AS_Operand_Temp(res)));
            // emit_irs.push_back(L_Store(AS_Operand_Const(0), AS_Operand_Temp(res)));

            // emit_irs.push_back(L_Cjump(l, temp_label, next_label));

            // emit_irs.push_back(L_Label(temp_label));
            // auto r = ast2llvmBoolExpr(b->right, nullptr, nullptr);
            // emit_irs.push_back(L_Cjump(r, true_label, next_label));
            // // both true
            // emit_irs.push_back(L_Label(true_label));
            // emit_irs.push_back(L_Store(AS_Operand_Const(1), AS_Operand_Temp(res)));
            // emit_irs.push_back(L_Jump(next_label));

            // emit_irs.push_back(L_Label(next_label));

            // Temp_temp *ret = Temp_newtemp_int();
            // emit_irs.push_back(L_Load(AS_Operand_Temp(ret), AS_Operand_Temp(res)));
            // return AS_Operand_Temp(ret);
        }
    }
    break;
    case A_or:
    {
        if (true_label && false_label)
        {
            emit_irs.push_back(L_Cjump(l, true_label, temp_label));

            emit_irs.push_back(L_Label(temp_label));
            auto r = ast2llvmBoolExpr(b->right, nullptr, nullptr);
            emit_irs.push_back(L_Cjump(r, true_label, false_label));
            return;
        }
        else
        {
            assert(0);
            return;
            // Temp_temp *res = Temp_newtemp_int_ptr(0);
            // Temp_label *next_label = Temp_newlabel();
            // false_label = Temp_newlabel();

            // emit_irs.push_back(L_Alloca(AS_Operand_Temp(res)));
            // emit_irs.push_back(L_Store(AS_Operand_Const(1), AS_Operand_Temp(res)));
            // emit_irs.push_back(L_Cjump(l, next_label, temp_label));

            // emit_irs.push_back(L_Label(temp_label));
            // auto r = ast2llvmBoolExpr(b->right, nullptr, nullptr);
            // emit_irs.push_back(L_Cjump(r, next_label, false_label));

            // emit_irs.push_back(L_Label(false_label));
            // emit_irs.push_back(L_Store(AS_Operand_Const(0), AS_Operand_Temp(res)));
            // emit_irs.push_back(L_Jump(next_label));

            // emit_irs.push_back(L_Label(next_label));

            // Temp_temp *ret = Temp_newtemp_int();
            // emit_irs.push_back(L_Load(AS_Operand_Temp(ret), AS_Operand_Temp(res)));
            // return AS_Operand_Temp(ret);
        }
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
        ast2llvmComOpExpr(b->u.comExpr, true_label, false_label);
        return;
    }
    break;
    case A_boolExprKind:
    {
        ast2llvmBoolExpr(b->u.boolExpr, true_label, false_label);
        return;
    }
    break;
    case A_boolUOpExprKind:
    {
        // !a
        ast2llvmBoolUOpExpr(b->u.boolUOpExpr, true_label, false_label);
        return;
    }
    break;
    default:
        assert(0);
        break;
    }
    assert(0);
    return;
}

void ast2llvmBoolUOpExpr(aA_boolUOpExpr b, Temp_label *true_label, Temp_label *false_label)
{
    switch (b->op)
    {
    case A_not:
    {
        return ast2llvmBoolUnit(b->cond, false_label, true_label);
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
        kind = L_relopKind::T_le;
        break;
    case A_gt:
        kind = L_relopKind::T_gt;
        break;
    case A_ge:
        kind = L_relopKind::T_ge;
        break;
    case A_eq:
        kind = L_relopKind::T_eq;
        break;
    case A_ne:
        kind = L_relopKind::T_ne;
        break;
    default:
        assert(0);
        break;
    }
    Temp_temp *res = Temp_newtemp_int();
    auto left = loadPtr(ast2llvmExprUnit(c->left));
    auto right = loadPtr(ast2llvmExprUnit(c->right));
    if (!left || !right)
        assert(0);
    emit_irs.push_back(L_Cmp(kind, left, right, AS_Operand_Temp(res)));
    if (true_label && false_label)
        emit_irs.push_back(L_Cjump(AS_Operand_Temp(res), true_label, false_label));
    else
    {
        assert(0);
        // true_label = Temp_newlabel();
        // false_label = Temp_newlabel();
        // emit_irs.push_back(L_Cjump(AS_Operand_Temp(res), true_label, false_label));
        // emit_irs.push_back(L_Label(true_label));
    }

    AS_Operand_Temp(res);
}

AS_operand *ast2llvmArithBiOpExpr(aA_arithBiOpExpr a)
{
    auto l = ast2llvmArithExpr(a->left);
    auto r = ast2llvmArithExpr(a->right);
    if (!l || !r)
        assert(0);
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
    emit_irs.push_back(L_Binop(op, loadPtr(l), loadPtr(r), res));
    return res;
}

AS_operand *ast2llvmArithUExpr(aA_arithUExpr a)
{
    AS_operand *postive = ast2llvmExprUnit(a->expr);
    Temp_temp *new_var = Temp_newtemp_int();
    emit_irs.push_back(L_Binop(L_binopKind::T_minus, AS_Operand_Const(0), loadPtr(postive), AS_Operand_Temp(new_var)));
    return AS_Operand_Temp(new_var);
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
    switch (e->kind)
    {
    case A_numExprKind:
    {
        return AS_Operand_Const(e->u.num);
    }
    break;
    case A_idExprKind:
    {
        Temp_temp *temp_var = localVarMap[*e->u.id];
        if (temp_var)
            return AS_Operand_Temp(temp_var);
        Name_name *name_var = globalVarMap[*e->u.id];
        if (name_var)
            return AS_Operand_Name(name_var);
        // empty type?
        assert(0);
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
            args.push_back(loadPtr(ast2llvmRightVal(arg)));
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
    list<L_stm *> irs = list<L_stm *>();
    for (const auto &block : f->irs)
    {
        if (block->type == L_StmKind::T_LABEL)
        {
            if (!irs.empty())
            {
                blocks.push_back(L_Block(irs));
                irs.clear();
            }
        }
        irs.push_back(block);
    }
    if (!irs.empty())
    {
        blocks.push_back(L_Block(irs));
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
    AS_operand *leftval = ast2llvmLeftVal(arrExpr->arr);
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
    AS_operand *leftval = ast2llvmLeftVal(memberExpr->structId);
    string name;
    AS_operand *new_ptr;
    switch (leftval->kind)
    {
    case OperandKind::TEMP:
    {
        // && leftval->u.TEMP->type != TempType::STRUCT_TEMP
        if (leftval->u.TEMP->type != TempType::STRUCT_PTR)
            assert(0);
        name = leftval->u.TEMP->structname;
    }
    break;
    case OperandKind::NAME:
    {
        if (leftval->u.NAME->type != TempType::STRUCT_PTR && leftval->u.NAME->type != TempType::STRUCT_TEMP)
            assert(0);
        name = leftval->u.NAME->structname;
    }
    break;
    default:
        assert(0);
        break;
    }
    auto member = structInfoMap[name].memberinfos[*memberExpr->memberId];
    int offset = member.offset;
    switch (member.def.kind)
    {
    case TempType::INT_TEMP:
        new_ptr = AS_Operand_Temp(Temp_newtemp_int_ptr(0));
        break;
    case TempType::INT_PTR:
        new_ptr = AS_Operand_Temp(Temp_newtemp_int_ptr(member.def.len));
        break;
    case TempType::STRUCT_TEMP:
        new_ptr = AS_Operand_Temp(Temp_newtemp_struct_ptr(0, member.def.structname));
        break;
    case TempType::STRUCT_PTR:
        new_ptr = AS_Operand_Temp(Temp_newtemp_struct_ptr(member.def.len, member.def.structname));
        break;
    default:
        assert(0);
        break;
    }

    emit_irs.push_back(L_Gep(new_ptr, leftval, AS_Operand_Const(offset)));
    return new_ptr;
    // printf("member: %s\n", memberExpr->memberId->c_str());
    // printf("%d\n", member.def.kind);
    // printf("member: %s\n", l->u.memberExpr->memberId->c_str());
    //  printf("%d\n", member.def.kind);
    //  printf("%d\n", member.def.len);
    // printf("%d\n", new_ptr->u.TEMP->len);
    // printf("%d\n", new_ptr->u.TEMP->type);
    // return member type rather than struct type
}

// if ptr->ret val
// else ret self
AS_operand *loadPtr(AS_operand *res)
{
    switch (res->kind)
    {
    case OperandKind::TEMP:
    {
        switch (res->u.TEMP->type)
        {
        case TempType::INT_PTR:
        {
            if (res->u.TEMP->len == 0)
            {
                Temp_temp *temp = Temp_newtemp_int();
                emit_irs.push_back(L_Load(AS_Operand_Temp(temp), res));
                return AS_Operand_Temp(temp);
            }
            else
            {
                Temp_temp *temp = Temp_newtemp_int_ptr(0);
                emit_irs.push_back(L_Gep(AS_Operand_Temp(temp), res, AS_Operand_Const(0)));
                temp->len = -1;
                return AS_Operand_Temp(temp);
            }
        }
        break;
        case TempType::STRUCT_PTR:
        {
            if (res->u.TEMP->len == 0)
            {
                // Temp_temp *temp = Temp_newtemp_struct(res->u.TEMP->structname);
                // emit_irs.push_back(L_Load(AS_Operand_Temp(temp), res));
                // return AS_Operand_Temp(temp);
            }
            else
            {
                Temp_temp *temp = Temp_newtemp_struct_ptr(0, res->u.TEMP->structname);
                emit_irs.push_back(L_Gep(AS_Operand_Temp(temp), res, AS_Operand_Const(0)));
                temp->len = -1;
                return AS_Operand_Temp(temp);
            }
        }
        break;
        case TempType::INT_TEMP:
            break;
        case TempType::STRUCT_TEMP:
            break;
        default:
            assert(0);
            break;
        }

        return res;
    }
    break;
    case OperandKind::NAME:
    {
        switch (res->u.NAME->type)
        {
        case TempType::INT_PTR:
        {
            if (res->u.NAME->len == 0)
            {
                Temp_temp *temp = Temp_newtemp_int();
                emit_irs.push_back(L_Load(AS_Operand_Temp(temp), res));
                return AS_Operand_Temp(temp);
            }
            else
            {
                Temp_temp *temp = Temp_newtemp_int_ptr(0);
                emit_irs.push_back(L_Gep(AS_Operand_Temp(temp), res, AS_Operand_Const(0)));
                temp->len = -1;
                return AS_Operand_Temp(temp);
            }
        }
        break;
        case TempType::INT_TEMP:
        {
            // NAME::INT_TEMP is a pointer
            Temp_temp *temp = Temp_newtemp_int();
            emit_irs.push_back(L_Load(AS_Operand_Temp(temp), res));
            return AS_Operand_Temp(temp);
        }
        break;
        case TempType::STRUCT_TEMP:
        {
            // try to return a struct ptr but NAME::STRUCT_TEMP is already a struct ptr
            // load only for i32!!
            // Temp_temp *temp = Temp_newtemp_struct(res->u.NAME->structname);
            // emit_irs.push_back(L_Load(AS_Operand_Temp(temp), res));
            // return AS_Operand_Temp(temp);
        }
        break;
        case TempType::STRUCT_PTR:
        {
            if (res->u.NAME->len == 0)
            {
                // Temp_temp *temp = Temp_newtemp_struct(res->u.TEMP->structname);
                // emit_irs.push_back(L_Load(AS_Operand_Temp(temp), res));
                // return AS_Operand_Temp(temp);
            }
            else
            {
                Temp_temp *temp = Temp_newtemp_struct_ptr(0, res->u.NAME->structname);
                emit_irs.push_back(L_Gep(AS_Operand_Temp(temp), res, AS_Operand_Const(0)));
                temp->len = -1;
                return AS_Operand_Temp(temp);
            }
        }
        break;
        default:
            assert(0);
            break;
        }
        return res;
    }
    break;
    case OperandKind::ICONST:
        return res;
        break;
    default:
        assert(0);
        break;
    }
}

void put_right_vals_into_array(Temp_temp *new_arr, vector<aA_rightVal> vals, int len, TempType type, string structname)
{
    int size = vals.size();
    if (size > len)
        assert(0);
    switch (type)
    {
    case TempType::INT_PTR:
    {
        for (int i = 0; i < size; i++)
        {
            Temp_temp *int_ptr = Temp_newtemp_int_ptr(0);
            emit_irs.push_back(L_Gep(AS_Operand_Temp(int_ptr), AS_Operand_Temp(new_arr), AS_Operand_Const(i)));

            AS_operand *temp = loadPtr(ast2llvmRightVal(vals[i]));
            switch (temp->kind)
            {
            case OperandKind::TEMP:
                if (temp->u.TEMP->type != TempType::INT_TEMP)
                    assert(0);
                break;
            case OperandKind::ICONST:
                break;
            default:
                assert(0);
                break;
            }
            emit_irs.push_back(L_Store(temp, AS_Operand_Temp(int_ptr)));
        }
        if (size < len)
        {
            for (int i = size; i < len; i++)
            {
                Temp_temp *int_ptr = Temp_newtemp_int_ptr(0);
                emit_irs.push_back(L_Gep(AS_Operand_Temp(int_ptr), AS_Operand_Temp(new_arr), AS_Operand_Const(i)));
                emit_irs.push_back(L_Store(AS_Operand_Const(0), AS_Operand_Temp(int_ptr)));
            }
        }
    }
    break;
    case TempType::STRUCT_PTR:
    {
        // assert(0);
        if (size != len)
            assert(0);
        for (int i = 0; i < len; i++)
        {
            Temp_temp *struct_ptr = Temp_newtemp_struct_ptr(0, structname);
            emit_irs.push_back(L_Gep(AS_Operand_Temp(struct_ptr), AS_Operand_Temp(new_arr), AS_Operand_Const(i)));
            AS_operand *temp = loadPtr(ast2llvmRightVal(vals[i]));
            if (temp->kind != OperandKind::TEMP || temp->u.TEMP->type != TempType::STRUCT_TEMP)
                assert(0);
            emit_irs.push_back(L_Store(temp, AS_Operand_Temp(struct_ptr)));
        }
    }
    break;
    default:
        assert(0);
        break;
    }
}