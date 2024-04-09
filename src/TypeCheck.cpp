#include "TypeCheck.h"

// global tabels
// typeMap func2retType; // function name to return type

// global token ids to type
typeMap g_token2Type;

// local token ids to type, since func param can override global param
typeMap funcparam_token2Type;
vector<typeMap *> local_token2Type;

paramMemberMap func2Param;
paramMemberMap struct2Members;

// private util functions
void error_print(std::ostream &out, A_pos p, string info)
{
    out << "Typecheck error in line " << p->line << ", col " << p->col << ": " << info << std::endl;
    exit(0);
}

void print_token_map(typeMap *map)
{
    for (auto it = map->begin(); it != map->end(); it++)
    {
        std::cout << it->first << " : ";
        switch (it->second->type->type)
        {
        case A_dataType::A_nativeTypeKind:
            switch (it->second->type->u.nativeType)
            {
            case A_nativeType::A_intTypeKind:
                std::cout << "int";
                break;
            default:
                break;
            }
            break;
        case A_dataType::A_structTypeKind:
            std::cout << *(it->second->type->u.structType);
            break;
        default:
            break;
        }
        switch (it->second->isVarArrFunc)
        {
        case 0:
            std::cout << " scalar";
            break;
        case 1:
            std::cout << " array";
            break;
        case 2:
            std::cout << " function";
            break;
        }
        std::cout << std::endl;
    }
}

void print_token_maps()
{
    std::cout << "global token2Type:" << std::endl;
    print_token_map(&g_token2Type);
    std::cout << "local token2Type:" << std::endl;
    print_token_map(&funcparam_token2Type);
}

bool comp_aA_type(aA_type target, aA_type t)
{
    if (!target || !t)
        return false;
    if (target->type != t->type)
        return false;
    if (target->type == A_dataType::A_nativeTypeKind)
        if (target->u.nativeType != t->u.nativeType)
            return false;
    if (target->type == A_dataType::A_structTypeKind)
        if (target->u.structType != t->u.structType)
            return false;
    return true;
}

bool comp_tc_type(tc_type target, tc_type t)
{
    if (!target || !t)
        return false;

    // arr kind first
    if (target->isVarArrFunc && t->isVarArrFunc == 0)
        return false;

    // if target type is nullptr, alwayse ok
    return comp_aA_type(target->type, t->type);
}

tc_type tc_Type(aA_type t, uint isVarArrFunc)
{
    tc_type ret = new tc_type_;
    ret->type = t;
    ret->isVarArrFunc = isVarArrFunc;
    return ret;
}

tc_type tc_Type(aA_varDecl vd)
{
    if (vd->kind == A_varDeclType::A_varDeclScalarKind)
        return tc_Type(vd->u.declScalar->type, 0);
    else if (vd->kind == A_varDeclType::A_varDeclArrayKind)
        return tc_Type(vd->u.declArray->type, 1);
    return nullptr;
}

// public functions
void check_Prog(std::ostream &out, aA_program p)
{
    for (auto ele : p->programElements)
    {
        if (ele->kind == A_programVarDeclStmtKind)
        {
            check_VarDecl(out, ele->u.varDeclStmt);
            print_token_maps();
        }
        else if (ele->kind == A_programStructDefKind)
        {
            check_StructDef(out, ele->u.structDef);
        }
    }

    for (auto ele : p->programElements)
    {
        if (ele->kind == A_programFnDeclStmtKind)
        {
            check_FnDeclStmt(out, ele->u.fnDeclStmt);
        }
        else if (ele->kind == A_programFnDefKind)
        {
            check_FnDecl(out, ele->u.fnDef->fnDecl);
        }
    }

    for (auto ele : p->programElements)
    {
        if (ele->kind == A_programFnDefKind)
        {
            check_FnDef(out, ele->u.fnDef);
        }
        else if (ele->kind == A_programNullStmtKind)
        {
            // do nothing
        }
    }
    // print_token_maps();

    out << "Typecheck passed!" << std::endl;
    return;
}

void check_VarDecl(std::ostream &out, aA_varDeclStmt vd)
{
    if (!vd)
        return;
    string name;
    if (vd->kind == A_varDeclStmtType::A_varDeclKind)
    {
        // decl only
        aA_varDecl vdecl = vd->u.varDecl;
        if (vdecl->kind == A_varDeclType::A_varDeclScalarKind)
        {
            name = *vdecl->u.declScalar->id;
            if (g_token2Type.find(name) != g_token2Type.end())
                error_print(out, vdecl->pos, "This id is already defined!");
            // if (!vdecl->u.declScalar->type)
            // {
            //     std::cout << name << " type is rightValue" << std::endl;
            //     // let a;
            //     g_token2Type[name] = tc_Type(vdecl);
            //     return;
            // }
            if (vdecl->u.declScalar->type->type == A_structTypeKind)
            {
                if (struct2Members.find(*(vdecl->u.declScalar->type->u.structType)) == struct2Members.end())
                    error_print(out, vdecl->pos, "This struct is not defined!");
            }
            // weather global or local??
            g_token2Type[name] = tc_Type(vdecl);
            /* fill code here*/
        }
        else if (vdecl->kind == A_varDeclType::A_varDeclArrayKind)
        {
            name = *vdecl->u.declArray->id;
            if (g_token2Type.find(name) != g_token2Type.end())
                error_print(out, vdecl->pos, "This id is already defined!");
            if (vdecl->u.declArray->type->type == A_structTypeKind)
            {
                if (struct2Members.find(*(vdecl->u.declArray->type->u.structType)) == struct2Members.end())
                    error_print(out, vdecl->pos, "This struct is not defined!");
            }
            g_token2Type[name] = tc_Type(vdecl);
            /* fill code here*/
        }
    }
    else if (vd->kind == A_varDeclStmtType::A_varDefKind)
    {
        // decl and def
        aA_varDef vdef = vd->u.varDef;
        if (vdef->kind == A_varDefType::A_varDefScalarKind)
        {
            name = *vdef->u.defScalar->id;
            if (g_token2Type.find(name) != g_token2Type.end())
                error_print(out, vdef->pos, "This id is already defined!");
            if (vdef->u.defScalar->type)
            {
                // std ::cout << "type is specified!!" << name << std::endl;
                auto tmp_type = tc_Type(vdef->u.defScalar->type, 0);

                // std::cout << vdef->u.defScalar->val->kind << vdef->u.defScalar->val->kind;
                if (vdef->u.defScalar->val->kind == A_arithExprValKind)
                {
                    if (tmp_type != check_ArithExpr(out, vdef->u.defScalar->val->u.arithExpr))
                        error_print(out, vdef->pos, "Type mismatch!");
                }
                else if (vdef->u.defScalar->val->kind == A_boolExprValKind)
                {
                    check_BoolExpr(out, vdef->u.defScalar->val->u.boolExpr);
                    if (tmp_type->type->type != A_dataType::A_nativeTypeKind || tmp_type->type->u.nativeType != A_nativeType::A_intTypeKind)
                        // only int
                        error_print(out, vdef->pos, "Type mismatch!");
                }
                // check type
                g_token2Type[name] = tmp_type;
            }
            else
            {
                if (vdef->u.defScalar->val->kind == A_arithExprValKind)
                {
                    // vdef->u.defScalar->type == nullptr;
                    g_token2Type[name] = check_ArithExpr(out, vdef->u.defScalar->val->u.arithExpr);
                }
                else if (vdef->u.defScalar->val->kind == A_boolExprValKind)
                {
                    check_BoolExpr(out, vdef->u.defScalar->val->u.boolExpr);
                    g_token2Type[name] = tc_Type(new aA_type_{vdef->pos, A_dataType::A_nativeTypeKind, A_nativeType::A_intTypeKind}, 0);
                }
                else
                {
                    error_print(out, vdef->pos, "Type mismatch!");
                }
            }
            /* fill code here, allow omited type */
        }
        else if (vdef->kind == A_varDefType::A_varDefArrayKind)
        {
            name = *vdef->u.defArray->id;
            if (g_token2Type.find(name) != g_token2Type.end())
                error_print(out, vdef->pos, "This id is already defined!");
            if (vdef->u.defArray->type)
            {
                // TODO: let a[2]:int = {0, 1, 2};
                auto tmp_type = tc_Type(vdef->u.defArray->type, 1);

                // check_ArrayExpr(out, vdef->u.defArray);
                // TODO let a[]int = {struct}
                // if (tmp_type != )
                //     error_print(out, vdef->pos, "Type mismatch!");
                // check
                g_token2Type[name] = tmp_type;
            }
            else
            {
                g_token2Type[name] = tc_Type(new aA_type_{vdef->pos, A_dataType::A_nativeTypeKind, A_nativeType::A_intTypeKind}, 1);
            }
            // error_print(out, vdef->pos, "Array type should be specified!");
            /* fill code here, allow omited type */
        }
    }
    return;
}

void check_StructDef(std::ostream &out, aA_structDef sd)
{
    if (!sd)
        return;
    string name = *sd->id;
    if (struct2Members.find(name) != struct2Members.end())
        error_print(out, sd->pos, "This id is already defined!");
    struct2Members[name] = &(sd->varDecls);
    return;
}

void check_FnDecl(std::ostream &out, aA_fnDecl fd)
{
    if (!fd)
        return;
    string name = *fd->id;

    // if already declared, should match
    if (func2Param.find(name) != func2Param.end())
    {
        if (comp_aA_type(g_token2Type[name]->type, fd->type) == false)
            error_print(out, fd->pos, "Function return type mismatch!");
        if (func2Param[name]->size() != fd->paramDecl->varDecls.size())
            error_print(out, fd->pos, "Function parameter number mismatch!");
        for (int i = 0; i < fd->paramDecl->varDecls.size(); i++)
        {
            if (comp_tc_type(tc_Type(fd->paramDecl->varDecls[i]), tc_Type(func2Param[name]->at(i))) == false)
                error_print(out, fd->pos, "Function parameter type mismatch!");
        }
        // is function ret val matches
        /* fill code here */
        // is function params matches decl
        /* fill code here */
    }
    else
    {
        func2Param[name] = &(fd->paramDecl->varDecls);
        g_token2Type[name] = tc_Type(fd->type, 2);
        // if not defined
        /* filled code here */
    }
    return;
}

void check_FnDeclStmt(std::ostream &out, aA_fnDeclStmt fd)
{
    if (!fd)
        return;
    check_FnDecl(out, fd->fnDecl);
    return;
}

void check_FnDef(std::ostream &out, aA_fnDef fd)
{
    if (!fd)
        return;
    // should match if declared
    check_FnDecl(out, fd->fnDecl);
    // add params to local tokenmap, func params override global ones
    for (aA_varDecl vd : fd->fnDecl->paramDecl->varDecls)
    {
        /* fill code here */
    }

    /* fill code here */
    for (aA_codeBlockStmt stmt : fd->stmts)
    {
        check_CodeblockStmt(out, stmt);
        // return value type should match
        /* fill code here */
    }

    return;
}

void check_CodeblockStmt(std::ostream &out, aA_codeBlockStmt cs)
{
    if (!cs)
        return;
    // variables declared in a code block should not duplicate with outer ones.
    switch (cs->kind)
    {
    case A_codeBlockStmtType::A_varDeclStmtKind:
        check_VarDecl(out, cs->u.varDeclStmt);
        break;
    case A_codeBlockStmtType::A_assignStmtKind:
        check_AssignStmt(out, cs->u.assignStmt);
        break;
    case A_codeBlockStmtType::A_ifStmtKind:
        check_IfStmt(out, cs->u.ifStmt);
        break;
    case A_codeBlockStmtType::A_whileStmtKind:
        check_WhileStmt(out, cs->u.whileStmt);
        break;
    case A_codeBlockStmtType::A_callStmtKind:
        check_CallStmt(out, cs->u.callStmt);
        break;
    case A_codeBlockStmtType::A_returnStmtKind:
        check_ReturnStmt(out, cs->u.returnStmt);
        break;
    default:
        break;
    }
    return;
}

void check_AssignStmt(std::ostream &out, aA_assignStmt as)
{
    if (!as)
        return;
    string name;
    tc_type deduced_type; // deduced type if type is omitted at decl
    switch (as->leftVal->kind)
    {
    case A_leftValType::A_varValKind:
    {
        name = *as->leftVal->u.id;
        /* fill code here */
    }
    break;
    case A_leftValType::A_arrValKind:
    {
        name = *as->leftVal->u.arrExpr->arr->u.id;
        /* fill code here */
    }
    break;
    case A_leftValType::A_memberValKind:
    {
        /* fill code here */
    }
    break;
    }
    return;
}

void check_ArrayExpr(std::ostream &out, aA_arrayExpr ae)
{
    if (!ae)
        return;
    string name = *ae->arr->u.id;
    // check array name
    if (g_token2Type.find(name) == g_token2Type.end())
        error_print(out, ae->pos, "This id is not defined!");
    tc_type arrType = g_token2Type[name];
    if (arrType->isVarArrFunc != 1)
        error_print(out, ae->pos, "This id is not an array!");
    /* fill code here */

    // check index
    if (ae->idx->kind == A_numIndexKind)
    {
        if (arrType->arrayLength <= ae->idx->u.num && ae->idx->u.num < 0)
        {
            error_print(out, ae->pos, "Array index out of bound!");
        }
    }
    else if (ae->idx->kind == A_idIndexKind)
    {
        auto type = find(*ae->idx->u.id);
        if (type == nullptr)
            error_print(out, ae->pos, "This id is not defined!");
        if (type->type->type != A_dataType::A_nativeTypeKind || type->type->u.nativeType != A_nativeType::A_intTypeKind)
            error_print(out, ae->pos, "Array index should be int!");
        if (arrType->arrayLength <= 0)
            error_print(out, ae->pos, "Array index out of bound!");
    }

    /* filling code here */
    return;
}

tc_type check_MemberExpr(std::ostream &out, aA_memberExpr me)
{
    // check if the member exists and return the tyep of the member
    if (!me)
        return nullptr;
    string name = *me->structId->u.id;
    // check struct name
    find(name);
    tc_type structType = g_token2Type[name];
    /* fill code here */

    // check member name
    /* fill code here */

    return nullptr;
}

void check_IfStmt(std::ostream &out, aA_ifStmt is)
{
    if (!is)
        return;
    check_BoolExpr(out, is->boolExpr);
    /* fill code here, take care of variable scope */

    for (aA_codeBlockStmt s : is->ifStmts)
    {
        check_CodeblockStmt(out, s);
    }

    /* fill code here */
    for (aA_codeBlockStmt s : is->elseStmts)
    {
        check_CodeblockStmt(out, s);
    }
    /* fill code here */
    return;
}

void check_BoolExpr(std::ostream &out, aA_boolExpr be)
{
    if (!be)
        return;
    switch (be->kind)
    {
    case A_boolExprType::A_boolBiOpExprKind:
        check_BoolExpr(out, be->u.boolBiOpExpr->left);
        check_BoolExpr(out, be->u.boolBiOpExpr->right);
        break;
    case A_boolExprType::A_boolUnitKind:
        check_BoolUnit(out, be->u.boolUnit);
        break;
    default:
        break;
    }
    return;
}

void check_BoolUnit(std::ostream &out, aA_boolUnit bu)
{
    if (!bu)
        return;
    switch (bu->kind)
    {
    case A_boolUnitType::A_comOpExprKind:
    {
        /* fill code here */
    }
    break;
    case A_boolUnitType::A_boolExprKind:
        check_BoolExpr(out, bu->u.boolExpr);
        break;
    case A_boolUnitType::A_boolUOpExprKind:
        check_BoolUnit(out, bu->u.boolUOpExpr->cond);
        break;
    default:
        break;
    }
    return;
}

tc_type check_ExprUnit(std::ostream &out, aA_exprUnit eu)
{
    // return the aA_type of expr eu
    if (!eu)
        return nullptr;
    tc_type ret;
    switch (eu->kind)
    {
    case A_exprUnitType::A_idExprKind:
    {
        string name = *eu->u.id;
        if (g_token2Type.find(name) == g_token2Type.end())
            error_print(out, eu->pos, "This id is not defined!");
        ret = g_token2Type[name];
        /* filled code here */
    }
    break;
    case A_exprUnitType::A_numExprKind:
    {
        aA_type numt = new aA_type_;
        numt->pos = eu->pos;
        numt->type = A_dataType::A_nativeTypeKind;
        numt->u.nativeType = A_nativeType::A_intTypeKind;
        ret = tc_Type(numt, 0);
    }
    break;
    case A_exprUnitType::A_fnCallKind:
    {
        check_FuncCall(out, eu->u.callExpr);
        // check_FuncCall will check if the function is defined
        /* fill code here */
    }
    break;
    case A_exprUnitType::A_arrayExprKind:
    {
        check_ArrayExpr(out, eu->u.arrayExpr);

        /* fill code here */
    }
    break;
    case A_exprUnitType::A_memberExprKind:
    {
        ret = check_MemberExpr(out, eu->u.memberExpr);
    }
    break;
    case A_exprUnitType::A_arithExprKind:
    {
        ret = check_ArithExpr(out, eu->u.arithExpr);
    }
    break;
    case A_exprUnitType::A_arithUExprKind:
    {
        ret = check_ExprUnit(out, eu->u.arithUExpr->expr);
    }
    break;
    }
    return ret;
}

tc_type check_ArithExpr(std::ostream &out, aA_arithExpr ae)
{
    if (!ae)
        return nullptr;
    tc_type ret;
    switch (ae->kind)
    {
    case A_arithExprType::A_arithBiOpExprKind:
    {
        ret = check_ArithExpr(out, ae->u.arithBiOpExpr->left);
        tc_type rightTyep = check_ArithExpr(out, ae->u.arithBiOpExpr->right);
        if (ret->type->type > 0 || ret->type->type != A_dataType::A_nativeTypeKind || ret->type->u.nativeType != A_nativeType::A_intTypeKind ||
            rightTyep->type->type > 0 || rightTyep->type->type != A_dataType::A_nativeTypeKind || rightTyep->type->u.nativeType != A_nativeType::A_intTypeKind)
            error_print(out, ae->pos, "Only int can be arithmetic expression operation values!");
    }
    break;
    case A_arithExprType::A_exprUnitKind:
        ret = check_ExprUnit(out, ae->u.exprUnit);
        break;
    }
    return ret;
}

void check_FuncCall(std::ostream &out, aA_fnCall fc)
{
    if (!fc)
        return;
    // check if function defined
    string func_name = *fc->fn;
    if (func2Param.find(func_name) == func2Param.end())
        error_print(out, fc->pos, "This function is not defined!");
    vector<aA_varDecl> *params = func2Param[func_name];
    /* fill code here */

    // check if parameter list matches
    for (int i = 0; i < fc->vals.size(); i++)
    {
        if (i >= params->size())
            error_print(out, fc->pos, "Too many parameters!");
        // if (params->at(i)->kind != A_varDeclType::A_varDeclScalarKind)
        //     error_print(out, fc->pos, "Only scalar can be function parameters!");
        // if (params->at(i)->kind != A_varDeclType::A_varDeclScalarKind)
        //     error_print(out, fc->pos, "Only scalar can be function parameters!");
        /* fill code here */
    }
    return;
}

void check_WhileStmt(std::ostream &out, aA_whileStmt ws)
{
    if (!ws)
        return;
    check_BoolExpr(out, ws->boolExpr);
    /* fill code here, take care of variable scope */

    for (aA_codeBlockStmt s : ws->whileStmts)
    {
        check_CodeblockStmt(out, s);
    }
    /* fill code here */

    return;
}

void check_CallStmt(std::ostream &out, aA_callStmt cs)
{
    if (!cs)
        return;
    check_FuncCall(out, cs->fnCall);
    return;
}

void check_ReturnStmt(std::ostream &out, aA_returnStmt rs)
{
    if (!rs)
        return;
    return;
}

tc_type find(std::string name)
{
    if (g_token2Type.find(name) == g_token2Type.end())
    {
        if (funcparam_token2Type.find(name) == funcparam_token2Type.end())
        {
            for (auto i : local_token2Type)
                if (i->find(name) != i->end())
                    return i->at(name);
            return nullptr;
        }
        return funcparam_token2Type[name];
    }
    return g_token2Type[name];
}
