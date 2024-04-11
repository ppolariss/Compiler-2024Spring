#include "TypeCheck.h"

// global tabels
// typeMap func2retType; // function name to return type

// global token ids to type
typeMap g_token2Type;

// local token ids to type, since func param can override global param
typeMap funcparam_token2Type;
vector<typeMap *> local_token2Type;
typeMap *currScope = &g_token2Type;
std::unordered_set<string> definedFn;

int scopeLevel = -1;
// vector<tc_type> retType;
tc_type retType;

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
    std::cout << "funcparam token2Type:" << std::endl;
    // std::cout << "local token2Type:" << std::endl;
    print_token_map(&funcparam_token2Type);
    std::cout << "local token2Type:" << std::endl;
    for (auto i : local_token2Type)
    {
        print_token_map(i);
    }
    std::cout << "currScope:" << std::endl;
    print_token_map(currScope);
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
        // if (target->u.structType != t->u.structType)
        if (*target->u.structType != *t->u.structType)
        {
            std::cout << "HERE" << *target->u.structType << *t->u.structType << std::endl;
            return false;
        }
    return true;
}

// cannot assign scalar(t) to array(target)
bool comp_tc_type(tc_type target, tc_type t)
{
    if (!target || !t)
        return false;

    // arr kind first
    if (target->isVarArrFunc && t->isVarArrFunc == 0)
        return false;
    // if (target->isVarArrFunc != t->isVarArrFunc)
        // return false;

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
            // notice: distinguish from double def
            string name = *ele->u.fnDef->fnDecl->id;
            if (definedFn.find(name) != definedFn.end())
                error_print(out, ele->u.fnDef->fnDecl->pos, "Function " + name + " is already defined!");
            check_FnDecl(out, ele->u.fnDef->fnDecl);
            definedFn.insert(name);
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

    out << "Typecheck passed!" << std::endl;
    return;
}

void check_VarDecl(std::ostream &out, aA_varDeclStmt vd)
{
    // already omit struct def
    // the struct appears here should be defined
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

            find(out, name, vdecl->pos);
            // let a;
            if (vdecl->u.declScalar->type)
                if (vdecl->u.declScalar->type->type == A_structTypeKind) // can ??
                {
                    if (struct2Members.find(*(vdecl->u.declScalar->type->u.structType)) == struct2Members.end())
                    {
                        error_print(out, vdecl->pos, "This struct is not defined!");
                        return;
                    }
                }
            // whether global or local??
            (*currScope)[name] = tc_Type(vdecl);
            /* fill code here*/
        }
        else if (vdecl->kind == A_varDeclType::A_varDeclArrayKind)
        {
            name = *vdecl->u.declArray->id;
            if (find(out, name, vdecl->pos) != nullptr)
                return;
            if (vdecl->u.declArray->type->type == A_structTypeKind)
            {
                if (struct2Members.find(*(vdecl->u.declArray->type->u.structType)) == struct2Members.end())
                {
                    error_print(out, vdecl->pos, "This struct is not defined!");
                    return;
                }
            }
            tc_type arr_type = tc_Type(vdecl);
            arr_type->arrayLength = vdecl->u.declArray->len;
            (*currScope)[name] = arr_type;
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
            if (find(out, name, vdef->pos) != nullptr)
                return;
            if (vdef->u.defScalar->type)
            {
                if (vdef->u.defScalar->type->type == A_structTypeKind)
                {
                    if (struct2Members.find(*(vdef->u.defScalar->type->u.structType)) == struct2Members.end())
                    {
                        error_print(out, vdef->pos, "This struct is not defined!");
                        return;
                    }
                    (*currScope)[name] = tc_Type(vdef->u.defScalar->type, 0);
                    // check right
                }
                else if (vdef->u.defScalar->type->type == A_nativeTypeKind)
                { // std ::cout << "type is specified!!" << name << std::endl;
                    auto tmp_type = tc_Type(vdef->u.defScalar->type, 0);

                    // std::cout << vdef->u.defScalar->val->kind << vdef->u.defScalar->val->kind;
                    if (vdef->u.defScalar->val->kind == A_arithExprValKind)
                    {
                        if (!comp_tc_type(tmp_type, check_ArithExpr(out, vdef->u.defScalar->val->u.arithExpr)))
                        {
                            error_print(out, vdef->pos, "Type mismatch in varDecl!");
                            return;
                        }
                    }
                    else if (vdef->u.defScalar->val->kind == A_boolExprValKind)
                    {
                        check_BoolExpr(out, vdef->u.defScalar->val->u.boolExpr);
                        if (comp_tc_type(tmp_type, bool_type(vdef->pos)) == false)
                        { // only int
                            error_print(out, vdef->pos, "Type mismatch in varDecl!");
                            return;
                        }
                    }
                    // check type
                    (*currScope)[name] = tmp_type;
                }
                else
                {
                    error_print(out, vdef->pos, "Type mismatch in varDecl!");
                }
            }
            else // let a = 1;
            {
                if (vdef->u.defScalar->val->kind == A_arithExprValKind)
                {
                    // vdef->u.defScalar->type == nullptr;
                    (*currScope)[name] = check_ArithExpr(out, vdef->u.defScalar->val->u.arithExpr);
                }
                else if (vdef->u.defScalar->val->kind == A_boolExprValKind)
                {
                    check_BoolExpr(out, vdef->u.defScalar->val->u.boolExpr);
                    (*currScope)[name] = bool_type(vdef->pos);
                }
                else
                {
                    error_print(out, vdef->pos, "Type mismatch in varDecl!");
                }
            }
            /* fill code here, allow omited type */
        }
        else if (vdef->kind == A_varDefType::A_varDefArrayKind)
        {
            name = *vdef->u.defArray->id;
            if (find(out, name, vdef->pos) != nullptr)
                return;
            if (vdef->u.defArray->type)
            {
                // TODO: let a[2]:int = {0, 1, 2};
                uint len = vdef->u.defArray->len;
                auto tmp_type = tc_Type(vdef->u.defArray->type, 0);
                if (vdef->u.defArray->vals.size() != len)
                {
                    error_print(out, vdef->pos, "Array length mismatch!");
                    return;
                }
                for (const auto &i : vdef->u.defArray->vals)
                {
                    if (i->kind == A_arithExprValKind)
                    {
                        if (!comp_tc_type(tmp_type, check_ArithExpr(out, i->u.arithExpr)))
                        {
                            error_print(out, vdef->pos, "Type mismatch in varDecl!");
                            return;
                        }
                    }
                    else if (i->kind == A_boolExprValKind)
                    {
                        check_BoolExpr(out, i->u.boolExpr);
                        if (comp_tc_type(tmp_type, bool_type(vdef->pos)) == false)
                        { // only int
                            error_print(out, vdef->pos, "Type mismatch in varDecl!");
                            return;
                        }
                    }
                    else
                    {
                        error_print(out, vdef->pos, "Type mismatch in varDecl!");
                    }
                }
                tc_type arr_type = tc_Type(vdef->u.defArray->type, 1);
                arr_type->arrayLength = len;
                (*currScope)[name] = arr_type;
            }
            else
            {
                error_print(out, vdef->pos, "Array type should be specified!");
                return;
                // TODO: let a = {0, 1, 2}; ??
                // g_token2Type[name] = tc_Type(new aA_type_{vdef->pos, A_dataType::A_nativeTypeKind, A_nativeType::A_intTypeKind}, 1);
            }
            // error_print(out, vdef->pos, "Array type should be specified!");
            /* fill code here, allow omited type */
        }
        else
        {
            error_print(out, vdef->pos, "Type mismatch in varDecl!");
        }
    }
    return;
}

void check_StructDef(std::ostream &out, aA_structDef sd)
{
    if (!sd)
        return;
    string name = *sd->id;
    if (find(out, name, sd->pos) != nullptr)
        return;
    // if (struct2Members.find(name) != struct2Members.end())
    //     error_print(out, sd->pos, "This id is already defined!");
    // std::cout << "HERE" << sd->varDecls.size() << std::endl
    //           << std::endl;
    // for (auto i : sd->varDecls)
    // {
    //     std::cout << *i->u.declScalar->id;
    // }
    // std::vector<aA_varDecl> *tmp = new std::vector<aA_varDecl>;
    // for (auto i : sd->varDecls)
    // {
    //     tmp->push_back(i);
    //     std::cout << name;
    // }
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
            error_print(out, fd->pos, "function definition on line " + std::to_string(fd->pos->line) + " doesn't match the declaration on line " + std::to_string(g_token2Type[name]->type->pos->line) + ".");
        if (func2Param[name]->size() != fd->paramDecl->varDecls.size())
            error_print(out, fd->pos, "Function parameter number mismatch!");
        for (int i = 0; i < fd->paramDecl->varDecls.size(); i++)
        {
            if (!comp_tc_type(tc_Type(fd->paramDecl->varDecls[i]), tc_Type(func2Param[name]->at(i))))
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
        string name = *vd->u.declScalar->id;
        if (funcparam_token2Type.find(name) != funcparam_token2Type.end())
            error_print(out, vd->pos, "Function parameter duplicates with other function parameters.");
        funcparam_token2Type[name] = tc_Type(vd);
    }
    /* fill code here */
    retType = tc_Type(fd->fnDecl->type, 2);
    // retType.push_back(g_token2Type[*fd->fnDecl->id]);

    /* fill code here */
    for (aA_codeBlockStmt stmt : fd->stmts)
    {
        check_CodeblockStmt(out, stmt);
        // return value type should match
        /* fill code here */
    }

    funcparam_token2Type.clear();

    return;
}

void check_CodeblockStmt(std::ostream &out, aA_codeBlockStmt cs)
{
    if (!cs)
        return;
    // std::cout << "\nnow it's " << scopeLevel + 1;
    local_token2Type.push_back(new typeMap);
    currScope = local_token2Type[++scopeLevel];
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
    // std::cout << "exit" << std::endl;
    // local_token2Type.pop_back();
    if (--scopeLevel < 0)
        currScope = &g_token2Type;
    currScope = local_token2Type[scopeLevel];
    if (local_token2Type.size() > scopeLevel + 2)
    {
        local_token2Type.pop_back();
    }
    return;
}

void check_AssignStmt(std::ostream &out, aA_assignStmt as)
{
    if (!as)
        return;
    string name;
    tc_type deduced_type; // deduced type if type is omitted at decl

    tc_type actual_type;
    switch (as->leftVal->kind)
    {
    case A_leftValType::A_varValKind:
    {
        name = *as->leftVal->u.id;
        actual_type = find(out, name, as->pos, false);
        if (!actual_type || actual_type->isVarArrFunc == 2)
            error_print(out, as->pos, "cannot assign a value to function " + name + " on line " + std::to_string(as->pos->line) + ", col " + std::to_string(as->pos->col) + ".");
        if (as->rightVal->kind == A_boolExprValKind)
        {
            check_BoolExpr(out, as->rightVal->u.boolExpr);
            if (!actual_type)
            {
                assign_type(name, bool_type(as->pos));
            }
            if (comp_tc_type(bool_type(as->pos), actual_type) == false)
                error_print(out, as->pos, "cannot assign due to type mismatch: " + get_type(actual_type) + "!=" + get_type(bool_type(as->pos)));
        }
        else if (as->rightVal->kind == A_arithExprValKind)
        {
            deduced_type = check_ArithExpr(out, as->rightVal->u.arithExpr);

            if (!actual_type || !actual_type->type)
            {
                assign_type(name, deduced_type);
            }
            else if (comp_tc_type(actual_type, deduced_type) == false)
            {
                error_print(out, as->pos, "cannot assign due to type mismatch: " + get_type(actual_type) + "!=" + get_type(deduced_type));
            }
            // else if (actual_type->isVarArrFunc == 1)
            // {
            //     if (actual_type->arrayLength != deduced_type->arrayLength)
            //         error_print(out, as->pos, "cannot assign due to array length mismatch: " + std::to_string(actual_type->arrayLength) + "!=" + std::to_string(deduced_type->arrayLength));
            // }
        }
        else
        {
            error_print(out, as->pos, "Type mismatch in assignment!");
        }
        /* fill code here */
    }
    break;
    case A_leftValType::A_arrValKind:
    {
        if (as->leftVal->u.arrExpr->arr->kind != A_varValKind)
            error_print(out, as->pos, "Array index should be id!");
        // really?
        name = *as->leftVal->u.arrExpr->arr->u.id;
        check_ArrayExpr(out, as->leftVal->u.arrExpr);

        actual_type = find(out, name, as->pos, false);
        actual_type->isVarArrFunc = 0;

        if (as->rightVal->kind == A_boolExprValKind)
        {
            check_BoolExpr(out, as->rightVal->u.boolExpr);
            if (comp_tc_type(bool_type(as->pos), actual_type) == false)
                error_print(out, as->pos, "cannot assign due to type mismatch: " + get_type(actual_type) + "!=" + get_type(bool_type(as->pos)));
        }
        else if (as->rightVal->kind == A_arithExprValKind)
        {
            deduced_type = check_ArithExpr(out, as->rightVal->u.arithExpr);
            if (comp_tc_type(deduced_type, actual_type) == false)
            {
                error_print(out, as->pos, "cannot assign due to type mismatch: " + get_type(actual_type) + "!=" + get_type(deduced_type));
            }
        }
        else
        {
            error_print(out, as->pos, "Type mismatch in assignment!");
        }
        /* fill code here */
    }
    break;
    case A_leftValType::A_memberValKind:
    {
        actual_type = check_MemberExpr(out, as->leftVal->u.memberExpr);
        if (as->rightVal->kind == A_boolExprValKind)
        {
            check_BoolExpr(out, as->rightVal->u.boolExpr);
            if (comp_tc_type(bool_type(as->pos), actual_type) == false)
                error_print(out, as->pos, "cannot assign due to type mismatch: " + get_type(actual_type) + "!=" + get_type(bool_type(as->pos)));
        }
        else if (as->rightVal->kind == A_arithExprValKind)
        {
            deduced_type = check_ArithExpr(out, as->rightVal->u.arithExpr);
            deduced_type->isVarArrFunc = 0;
            if (comp_tc_type(deduced_type, actual_type) == false)
            {
                error_print(out, as->pos, "cannot assign due to type mismatch: " + get_type(actual_type) + "!=" + get_type(deduced_type));
            }
        }
        else
        {
            error_print(out, as->pos, "Type mismatch in assignment!");
        }
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
    // if ( == nullptr)
    //     error_print(out, ae->pos, "This id is not defined!");

    tc_type arrType = find(out, name, ae->pos, false);
    if (arrType->isVarArrFunc != 1)
        error_print(out, ae->pos, "This id is not an array!");
    /* fill code here */

    // check index
    if (ae->idx->kind == A_numIndexKind)
    {
        if (arrType->arrayLength <= ae->idx->u.num || ae->idx->u.num < 0)
        {
            error_print(out, ae->pos, "Array index out of bound!");
        }
    }
    else if (ae->idx->kind == A_idIndexKind)
    {
        tc_type type = find(out, *ae->idx->u.id, ae->pos, false);
        if (type->isVarArrFunc != 0 ||
            type->type->type != A_dataType::A_nativeTypeKind ||
            type->type->u.nativeType != A_nativeType::A_intTypeKind)
            error_print(out, ae->pos, "Array index should be int!");
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
    // this is not the struct name!!!!!
    string member = *me->memberId;
    // check struct name
    tc_type structType = find(out, name, me->pos, false);
    // if (structType->type->u.nativeType == A_nativeType::A_intTypeKind)
    //     error_print(out, me->pos, "error Here");
    if (structType->type->type != A_dataType::A_structTypeKind)
        error_print(out, me->pos, name + " is not a struct.");
    auto members = struct2Members[*structType->type->u.structType];

    /* fill code here */
    // check member name
    for (const auto &i : *members)
    {
        if (*i->u.declScalar->id == member)
        {
            return tc_Type(i);
        }
    }
    error_print(out, me->pos, "member '" + member + "' is not defined.");
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
        tc_type a = check_ExprUnit(out, bu->u.comExpr->left);
        tc_type b = check_ExprUnit(out, bu->u.comExpr->right);
        if (comp_tc_type(a, b) == false)
        {
            if (a->type->type == A_dataType::A_structTypeKind && b->type->type == A_dataType::A_structTypeKind)
            {
                error_print(out, bu->pos, *a->type->u.structType + " is not comparable with " + *b->type->u.structType + ".");
            }
            else if (a->type->type == A_dataType::A_structTypeKind)
            {
                error_print(out, bu->pos, *a->type->u.structType + " is not comparable with int.");
            }
            else if (b->type->type == A_dataType::A_structTypeKind)
            {
                error_print(out, bu->pos, *b->type->u.structType + " is not comparable with int.");
            }
            else
            {
                error_print(out, bu->pos, "Type mismatch in comparison!");
            }
        }
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
        ret = find(out, name, eu->pos, false);
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
        ret = find(out, *eu->u.callExpr->fn, eu->pos, false);
        /* fill code here */
    }
    break;
    case A_exprUnitType::A_arrayExprKind:
    {
        check_ArrayExpr(out, eu->u.arrayExpr);
        ret = find(out, *eu->u.arrayExpr->arr->u.id, eu->pos, false);
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
    if (fc->vals.size() < params->size())
        error_print(out, fc->pos, "Too few parameters!");
    else if (fc->vals.size() > params->size())
        error_print(out, fc->pos, "Too many parameters!");
    for (int i = 0; i < fc->vals.size(); i++)
    {
        if (fc->vals[i]->kind == A_arithExprValKind)
        {
            if (!comp_tc_type(check_ArithExpr(out, fc->vals[i]->u.arithExpr), tc_Type(params->at(i))))
                error_print(out, fc->pos, "Function parameter type mismatch!");
        }
        else if (fc->vals[i]->kind == A_boolExprValKind)
        {
            check_BoolExpr(out, fc->vals[i]->u.boolExpr);
            if (bool_type(fc->pos) != tc_Type(params->at(i)))
                error_print(out, fc->pos, "Function parameter type mismatch!");
        }
        else
        {
            error_print(out, fc->pos, "Function parameter type mismatch!");
        }
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
    auto ret_type = retType;
    // auto ret_type = retType.back();
    if (rs->retVal->kind == A_arithExprValKind)
    {
        if (!comp_tc_type(check_ArithExpr(out, rs->retVal->u.arithExpr), ret_type))
            error_print(out, rs->pos, "Return type mismatch!");
    }
    else if (rs->retVal->kind == A_boolExprValKind)
    {
        check_BoolExpr(out, rs->retVal->u.boolExpr);
        if (!comp_tc_type(bool_type(rs->pos), ret_type))
            error_print(out, rs->pos, "Return type mismatch!");
    }
    else
    {
        error_print(out, rs->pos, "Return type mismatch!");
    }
    return;
}

tc_type find(std::ostream &out, std::string name, A_pos pos, bool expected_available)
{
    // print_token_maps();
    if (funcparam_token2Type.find(name) == funcparam_token2Type.end())
    {
        if (g_token2Type.find(name) == g_token2Type.end())
        {
            for (int j = 0; j <= scopeLevel; j++)
            {
                auto i = local_token2Type[j];
                if (i->find(name) != i->end())
                {
                    if (expected_available)
                        error_print(out, pos, "local variables duplicates with local variables.");
                    return i->at(name);
                }
            }
            if (!expected_available)
                error_print(out, pos, "var " + name + " on line " + std::to_string(pos->line) + ", col " + std::to_string(pos->col) + " is not defined.");
            return nullptr;
        }
        if (expected_available)
            error_print(out, pos, "local variables duplicates with global variables.");
        return g_token2Type[name];
    }
    if (expected_available)
        error_print(out, pos, "local variables duplicates with function params.");
    return funcparam_token2Type[name];
}

void assign_type(std::string name, tc_type t)
{
    // if (funcparam_token2Type.find(name) == funcparam_token2Type.end())
    // {
    if (g_token2Type.find(name) == g_token2Type.end())
    {
        for (int j = 0; j <= scopeLevel; j++)
        {
            auto i = local_token2Type[j];
            if (i->find(name) != i->end())
            {
                (*i)[name] = t;
                return;
            }
        }
        std::cout << "error in assign!!" << std::endl;
    }
    g_token2Type[name] = t;
    // }
    // funcparam_token2Type[name] = t;
}

tc_type bool_type(A_pos pos)
{
    return tc_Type(new aA_type_{pos, A_dataType::A_nativeTypeKind, A_nativeType::A_intTypeKind}, 0);
}

string get_type(tc_type type)
{
    if (!type || !type->type)
        return "";
    string ret = "";
    switch (type->type->type)
    {
    case A_dataType::A_nativeTypeKind:
        switch (type->type->u.nativeType)
        {
        case A_nativeType::A_intTypeKind:
            ret += "int";
            break;
        default:
            break;
        }
        break;
    case A_dataType::A_structTypeKind:
        ret += *(type->type->u.structType);
        break;
    default:
        break;
    }
    switch (type->isVarArrFunc)
    {
    case 0:
        ret += " scalar";
        break;
    case 1:
        ret += " array";
        break;
    case 2:
        ret += " function";
        break;
    }
    return ret;
}

void print_type(tc_type type)
{
    std::cout << get_type(type) << std::endl;
}