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

// if void aA_type != null
// aA_type.type == null
tc_type retType;
bool returned = false;

paramMemberMap func2Param;
paramMemberMap struct2Members;

// private util functions
void error_print(std::ostream &out, A_pos p, string info) {
  if (!p) {
    std::cout << "pos error: " << info << std::endl;
    exit(0);
  }
  out << "Typecheck error in line " << p->line << ", col " << p->col << ": "
      << info << std::endl;
  exit(0);
}

void print_token_map(typeMap *map) {
  for (auto it = map->begin(); it != map->end(); it++) {
    std::cout << it->first << " : ";
    if (!it->second->type) {
      std::cout << "null" << std::endl;
      continue;
    }
    switch (it->second->type->type) {
    case A_dataType::A_nativeTypeKind:
      switch (it->second->type->u.nativeType) {
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
    switch (it->second->isVarArrFunc) {
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

void print_token_maps() {
  std::cout << "global token2Type:" << std::endl;
  print_token_map(&g_token2Type);
  std::cout << "funcparam token2Type:" << std::endl;
  // std::cout << "local token2Type:" << std::endl;
  print_token_map(&funcparam_token2Type);
  std::cout << "local token2Type:" << std::endl;
  for (const auto &i : local_token2Type) {
    print_token_map(i);
  }
  std::cout << "currScope:" << std::endl;
  // if (currScope)
  print_token_map(currScope);
  std::cout << std::endl;
}

bool comp_aA_type(aA_type target, aA_type t) {
  if (!target || !t)
    return false;
  if (target->type != t->type)
    return false;
  if (target->type == A_dataType::A_nativeTypeKind)
    if (target->u.nativeType != t->u.nativeType)
      return false;
  if (target->type == A_dataType::A_structTypeKind)
    // if (target->u.structType != t->u.structType)
    if (!target->u.structType || !t->u.structType ||
        *target->u.structType != *t->u.structType) {
      // std::cout << "HERE" << *target->u.structType << *t->u.structType <<
      // std::endl;
      return false;
    }
  return true;
}

// unstrict equality: scalar(target) scalar/array/fucntion(t)
// strict equality: array/fucntion(target) != scalar(t)
bool comp_tc_type(tc_type target, tc_type t) {
  // void = void
  // if ((!target || !target->type) && (!t || !t->type))
  //     return true;
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

tc_type tc_Type(aA_type t, uint isVarArrFunc, uint arrayLength = 0) {
  tc_type ret = new tc_type_;
  ret->type = t;
  ret->isVarArrFunc = isVarArrFunc;
  ret->arrayLength = arrayLength;
  return ret;
}

tc_type tc_Type(aA_varDecl vd) {
  if (vd->kind == A_varDeclType::A_varDeclScalarKind)
    return tc_Type(vd->u.declScalar->type, 0);
  else if (vd->kind == A_varDeclType::A_varDeclArrayKind)
    return tc_Type(vd->u.declArray->type, 1, vd->u.declArray->len);
  return nullptr;
}

// public functions
void check_Prog(std::ostream &out, aA_program p) {
  for (auto ele : p->programElements) {
    if (ele->kind == A_programVarDeclStmtKind) {
      check_VarDecl(out, ele->u.varDeclStmt);
    } else if (ele->kind == A_programStructDefKind) {
      check_StructDef(out, ele->u.structDef);
    }
  }

  for (auto ele : p->programElements) {
    if (ele->kind == A_programFnDeclStmtKind) {
      check_FnDeclStmt(out, ele->u.fnDeclStmt);
    } else if (ele->kind == A_programFnDefKind) {
      // notice: distinguish from double def
      if (!ele->u.fnDef->fnDecl || !ele->u.fnDef->fnDecl->id)
        error_print(out, ele->u.fnDef->fnDecl->pos, "Function id is null!");
      string name = *ele->u.fnDef->fnDecl->id;
      if (definedFn.find(name) != definedFn.end())
        error_print(out, ele->u.fnDef->fnDecl->pos,
                    "Function " + name + " is already defined!");
      check_FnDecl(out, ele->u.fnDef->fnDecl);
      definedFn.insert(name);
    }
  }

  for (auto ele : p->programElements) {
    if (ele->kind == A_programFnDefKind) {
      check_FnDef(out, ele->u.fnDef);
    } else if (ele->kind == A_programNullStmtKind) {
      // do nothing
    }
  }

  out << "Typecheck passed!" << std::endl;
  return;
}

void check_VarDecl(std::ostream &out, aA_varDeclStmt vd) {
  // already omit struct def
  // the struct appears here should be defined
  if (!vd)
    return;
  string name;
  if (vd->kind == A_varDeclStmtType::A_varDeclKind) {
    aA_varDecl vdecl = vd->u.varDecl;
    if (!vdecl)
      error_print(out, vd->pos, "aA_varDeclStmt->u.varDecl is null");
    switch (vdecl->kind) {
    case A_varDeclType::A_varDeclScalarKind: {
      // let a
      // decl only
      if (!vdecl->u.declScalar->id)
        error_print(out, vdecl->pos, "vdecl->u.declScalar->id is null");
      name = *vdecl->u.declScalar->id;
      find(out, name, vdecl->pos);

      check_struct_defined(out, vdecl->pos, vdecl->u.declScalar->type,
                           "undefined struct type in var decl!");

      (*currScope)[name] = tc_Type(vdecl);
      /* fill code here*/
    } break;
    case A_varDeclType::A_varDeclArrayKind: {
      if (!vdecl->u.declArray->id)
        error_print(out, vdecl->pos, "vdecl->u.declArray->id is null");
      name = *vdecl->u.declArray->id;
      find(out, name, vdecl->pos);

      // important: var a[10];
      check_struct_defined(out, vdecl->pos, vdecl->u.declArray->type,
                           "struct type in arr decl!");

      tc_type arr_type = tc_Type(vdecl);
      arr_type->arrayLength = vdecl->u.declArray->len;
      (*currScope)[name] = arr_type;
      /* fill code here*/
    } break;
    default:
      error_print(out, vdecl->pos, "vdecl->kind is null");
      break;
    }

  } else if (vd->kind == A_varDeclStmtType::A_varDefKind) {
    if (!vd->u.varDef)
      error_print(out, vd->pos, "aA_varDeclStmt->u.varDef is null");
    // decl and def
    aA_varDef vdef = vd->u.varDef;
    switch (vdef->kind) {
    case A_varDefType::A_varDefScalarKind: {
      if (!vdef->u.defScalar)
        error_print(out, vdef->pos, "vdef->u.defScalar is null");
      if (!vdef->u.defScalar->id)
        error_print(out, vdef->pos, "vdef->u.defScalar->id is null");
      if (!vdef->u.defScalar->val)
        error_print(out, vdef->pos, "vdef->u.defScalar->val is null");
      name = *vdef->u.defScalar->id;
      find(out, name, vdef->pos);

      if (vdef->u.defScalar->type) {
        tc_type left_type = tc_Type(vdef->u.defScalar->type, 0);
        switch (vdef->u.defScalar->type->type) {
        case A_structTypeKind: {
          check_struct_defined(
              out, vdef->pos, vdef->u.defScalar->type,
              "struct type in varDecl! (decl and def mismatch)");

          // check right type
          if (vdef->u.defScalar->val->kind != A_arithExprValKind)
            error_print(out, vdef->pos,
                        "there is no right struct value in varDecl!");
        } break;
        case A_nativeTypeKind: {
          // doesn't need // only int
          if (vdef->u.defScalar->val->kind == A_boolExprValKind) {
            check_BoolExpr(out, vdef->u.defScalar->val->u.boolExpr);
            if (comp_tc_type(left_type, bool_type(vdef->pos)) == false)
              error_print(out, vdef->pos, "Type mismatch in varDecl!");
          } else if (vdef->u.defScalar->val->kind != A_arithExprValKind)
            error_print(out, vdef->pos, "Type mismatch in varDecl!");
        } break;
        default:
          error_print(out, vdef->pos, "Type mismatch in varDecl!");
          break;
        }

        tc_type right_type =
            check_ArithExpr(out, vdef->u.defScalar->val->u.arithExpr);

        if (empty_type(right_type))
          error_print(out, vdef->pos, "Type mismatch in varDecl!");
        if (!comp_tc_type(left_type, right_type))
          error_print(out, vdef->pos,
                      "struct type in varDecl! (decl and def mismatch)");

        (*currScope)[name] = left_type;
        return;
      }

      // let a = 1;
      // vdef->u.defScalar->type == null
      // doesn't need
      switch (vdef->u.defScalar->val->kind) {
      case A_boolExprValKind: {
        check_BoolExpr(out, vdef->u.defScalar->val->u.boolExpr);
        tc_type tmp_type = bool_type(vdef->pos);
        if (empty_type(tmp_type))
          error_print(out, vdef->pos,
                      "type mismatch in varDecl! (right: bool expr)");
        (*currScope)[name] = tmp_type;
      } break;
      case A_arithExprValKind: {
        tc_type tmp_type =
            check_ArithExpr(out, vdef->u.defScalar->val->u.arithExpr);
        if (empty_type(tmp_type))
          error_print(out, vdef->pos,
                      "cannot assign void value to variable " + name +
                          " on line " + std::to_string(vdef->pos->line) +
                          ", col " + std::to_string(vdef->pos->col) + ".");
        if (tmp_type->isVarArrFunc == 2)
          error_print(out, vdef->pos,
                      "cannot assign a function to variable " + name +
                          " on line " + std::to_string(vdef->pos->line) +
                          ", col " + std::to_string(vdef->pos->col) + ".");
        (*currScope)[name] = tmp_type;
      } break;
      default:
        error_print(out, vdef->pos, "Type mismatch in varDecl!");
        break;
      }
      /* fill code here, allow omited type */
    } break;
    case A_varDefType::A_varDefArrayKind: {
      // no: let a = {0, 1, 2};
      // yes: let a[3] = {0, 1, 2};
      if (!vdef->u.defArray)
        error_print(out, vdef->pos, "vdef->u.defArray is null");
      if (!vdef->u.defArray->id)
        error_print(out, vdef->pos, "vdef->u.defArray->id is null");
      name = *vdef->u.defArray->id;
      find(out, name, vdef->pos);

      int len = vdef->u.defArray->len;
      if (len < 0)
        error_print(out, vdef->pos, "Array length should be positive!");
      if (vdef->u.defArray->vals.size() != len)
        error_print(out, vdef->pos, "Array length mismatch!");

      if (empty_type(vdef->u.defArray->type)) {
        tc_type left_type = NULL;
        for (const auto &i : vdef->u.defArray->vals) {
          if (i->kind == A_boolExprValKind) {
            check_BoolExpr(out, i->u.boolExpr);
            if (!left_type) {
              left_type = bool_type(vdef->pos);
              continue;
            }
            // only int<-bool
            if (comp_tc_type(left_type, bool_type(vdef->pos)) == false)
              error_print(out, vdef->pos,
                          "value type aren't consistent in array declaration!");
          } else if (i->kind == A_arithExprValKind) {
            tc_type right_type = check_ArithExpr(out, i->u.arithExpr);
            if (!left_type) {
              left_type = right_type;
              continue;
            }
            if (!comp_tc_type(left_type, right_type))
              error_print(out, vdef->pos,
                          "value type aren't consistent in array declaration!");
          } else
            error_print(out, vdef->pos, "Type mismatch in varDecl!");
        }

        tc_type arr_type = tc_Type(vdef->u.defArray->type, 1);
        arr_type->arrayLength = len;
        (*currScope)[name] = arr_type;
        return;
      }

      tc_type left_type = tc_Type(vdef->u.defArray->type, 0); // not null
      for (const auto &i : vdef->u.defArray->vals) {
        if (i->kind == A_boolExprValKind) {
          check_BoolExpr(out, i->u.boolExpr);
          if (comp_tc_type(left_type, bool_type(vdef->pos)) == false)
            error_print(out, vdef->pos,
                        "array element type conflict with array type!");
        } else if (i->kind == A_arithExprValKind) {
          if (!comp_tc_type(left_type, check_ArithExpr(out, i->u.arithExpr)))
            error_print(out, vdef->pos,
                        "array element type conflict with array type!");
        } else
          error_print(out, vdef->pos, "Type mismatch in varDecl!");
      }
      tc_type arr_type = tc_Type(vdef->u.defArray->type, 1);
      arr_type->arrayLength = len;
      (*currScope)[name] = arr_type;
      return;
      /* fill code here, allow omited type */
    } break;
    default:
      error_print(out, vdef->pos, "Type mismatch in varDecl!");
      break;
    }
  }
  return;
}

void check_StructDef(std::ostream &out, aA_structDef sd) {
  if (!sd)
    return;
  if (!sd->id)
    error_print(out, sd->pos, "no struct id in struct def");
  string name = *sd->id;
  // if (find(out, name, sd->pos) != nullptr)
  //     return;
  if (struct2Members.find(name) != struct2Members.end())
    error_print(out, sd->pos, "struct id duplicates with other struct ids.");
  // checl if each varDecl has type
  for (const auto &i : sd->varDecls) {
    switch (i->kind) {
    case A_varDeclScalarKind:
      if (!i->u.declScalar || !i->u.declScalar->type)
        error_print(out, i->pos, "struct member type is null!");
      break;
    case A_varDeclArrayKind:
      if (!i->u.declArray || !i->u.declArray->type)
        error_print(out, i->pos, "struct member type is null!");
      check_struct_defined(out, i->pos, i->u.declArray->type,
                           "struct member's array type is not defined!");
      break;
    default:
      error_print(out, i->pos, "struct member type is null!");
      break;
    }
  }
  struct2Members[name] = &(sd->varDecls);
  return;
}

void check_FnDecl(std::ostream &out, aA_fnDecl fd) {
  if (!fd)
    return;
  if (!fd->id)
    error_print(out, fd->pos, "no function id in function declaration");
  string name = *fd->id;

  // check function param name duplicates
  if (!fd->paramDecl)
    error_print(out, fd->pos, "fd->paramDecl is null");
  std::unordered_set<string> paramSet;
  for (aA_varDecl vd : fd->paramDecl->varDecls) {
    if (!vd || !vd->u.declScalar || !vd->u.declScalar->id)
      error_print(out, fd->pos, "Function parameter is null.");

    string name = *vd->u.declScalar->id;
    if (paramSet.find(name) != paramSet.end())
      error_print(
          out, vd->pos,
          "Function parameter duplicates with other function parameters.");
    paramSet.insert(name);
  }
  paramSet.clear();

  // if already declared, should match
  if (func2Param.find(name) != func2Param.end()) {
    // declared before
    tc_type declaredType = g_token2Type[name];

    if (!declaredType)
      error_print(out, fd->pos, "Function declared?");

    // is function ret val matches
    /* fill code here */
    if (empty_type(declaredType) && empty_type(fd->type))
      ;
    else if (empty_type(declaredType))
      error_print(out, fd->pos,
                  "void function(in declaration) " + name +
                      " should not have return value.");
    else if (empty_type(fd->type)) {
      // error_print(out, fd->pos, "Function " + name + " should have return
      // value."); error printing maybe encounter segmenation fault just for
      // print error below
      if (declaredType && declaredType->type && declaredType->type->pos)
        error_print(out, fd->pos,
                    "void function definition on line " +
                        std::to_string(fd->pos->line) +
                        " doesn't match the declaration on line " +
                        std::to_string(g_token2Type[name]->type->pos->line) +
                        ".");
      else
        error_print(out, fd->pos,
                    "void function definition on line " +
                        std::to_string(fd->pos->line) +
                        " doesn't match the declaration on line ?.");
    } else if (!comp_tc_type(declaredType, tc_Type(fd->type, 2))) {
      // just for print error below
      if (declaredType && declaredType->type && declaredType->type->pos)
        error_print(out, fd->pos,
                    "Function definition on line " +
                        std::to_string(fd->pos->line) +
                        " doesn't match the declaration on line " +
                        std::to_string(declaredType->type->pos->line) + ".");
      else
        error_print(out, fd->pos,
                    "Function definition on line " +
                        std::to_string(fd->pos->line) +
                        " doesn't match the declaration on line ?.");
    }

    // is function params matches decl
    /* fill code here */
    if (!fd->paramDecl)
      error_print(out, fd->pos, "Function parameter number mismatch!");
    if (func2Param[name]->size() != fd->paramDecl->varDecls.size())
      error_print(out, fd->pos, "Function parameter number mismatch!");
    for (int i = 0; i < fd->paramDecl->varDecls.size(); i++) {
      tc_type decl_type = tc_Type(fd->paramDecl->varDecls[i]);
      tc_type func_type = tc_Type(func2Param[name]->at(i));
      if (empty_type(decl_type) || empty_type(func_type))
        error_print(out, fd->pos,
                    "function parameter type should not be void!");
      if (!comp_tc_type(decl_type, func_type))
        error_print(out, fd->pos,
                    "function parameter type mismatch with declaration!");
    }
  } else {
    find(out, name, fd->pos);
    // if not defined
    /* filled code here */

    // check struct type
    for (const auto &i : fd->paramDecl->varDecls) {
      switch (i->kind) {
      case A_varDeclScalarKind: {
        if (!i->u.declScalar || !i->u.declScalar->type)
          error_print(out, i->pos, "Function parameter type is null!");
        if (i->kind == A_varDeclScalarKind && i->u.declScalar)
          check_struct_defined(
              out, i->pos, i->u.declScalar->type,
              "function parameter's struct type is not defined!");
      } break;
      case A_varDeclArrayKind: {
        if (!i->u.declArray || !i->u.declArray->type)
          error_print(out, i->pos, "Function parameter type is null!");
        if (i->kind == A_varDeclArrayKind && i->u.declArray)
          check_struct_defined(
              out, i->pos, i->u.declArray->type,
              "function parameter's struct type is not defined!");
      } break;
      default:
        error_print(out, i->pos, "Function parameter type is null!");
        break;
      }
    }
    if (!empty_type(fd->type))
      check_struct_defined(
          out, fd->pos, fd->type,
          "function return type's struct type is not defined!");

    func2Param[name] = &(fd->paramDecl->varDecls);
    g_token2Type[name] = tc_Type(fd->type, 2);
  }
  return;
}

void check_FnDeclStmt(std::ostream &out, aA_fnDeclStmt fd) {
  if (!fd)
    return;
  check_FnDecl(out, fd->fnDecl);
  return;
}

void check_FnDef(std::ostream &out, aA_fnDef fd) {
  if (!fd)
    return;
  // should match if declared
  check_FnDecl(out, fd->fnDecl);
  // add params to local tokenmap, func params override global ones
  /* fill code here */
  if (!fd->fnDecl->paramDecl)
    error_print(out, fd->pos, "fd->fnDecl->paramDecl is null");
  for (aA_varDecl vd : fd->fnDecl->paramDecl->varDecls) {
    if (!vd || !vd->u.declScalar || !vd->u.declScalar->id)
      error_print(out, fd->pos, "Function parameter is null.");

    string name = *vd->u.declScalar->id;
    if (funcparam_token2Type.find(name) != funcparam_token2Type.end())
      error_print(
          out, vd->pos,
          "Function parameter duplicates with other function parameters.");
    funcparam_token2Type[name] = tc_Type(vd);
  }

  if (!fd->fnDecl->type)
    retType = nullptr;
  else
    // retType = tc_Type(fd->fnDecl->type, 2);
    retType = tc_Type(fd->fnDecl->type, 0);
  // retType.push_back(g_token2Type[*fd->fnDecl->id]);

  /* fill code here */
  enterScope();
  returned = false;
  for (aA_codeBlockStmt stmt : fd->stmts) {
    check_CodeblockStmt(out, stmt);
    // return value type should match
    /* fill code here */
    // todo: why?
  }
  if (!returned && !empty_type(retType))
    error_print(out, fd->pos,
                "Function " + *fd->fnDecl->id + " should have return value.");
  exitScope();

  funcparam_token2Type.clear();

  return;
}

void check_CodeblockStmt(std::ostream &out, aA_codeBlockStmt cs) {
  if (!cs)
    return;

  // variables declared in a code block should not duplicate with outer ones.
  switch (cs->kind) {
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

void check_AssignStmt(std::ostream &out, aA_assignStmt as) {
  if (!as)
    return;
  string name;
  tc_type deduced_type; // right
  tc_type actual_type;  // left
  if (!as->leftVal)
    error_print(out, as->pos, "no leftVal in assignment");
  if (!as->rightVal)
    error_print(out, as->pos, "no rightVal in assignment");
  switch (as->leftVal->kind) {
  case A_leftValType::A_varValKind: {
    if (!as->leftVal->u.id)
      error_print(out, as->pos, "no id in leftVal");
    name = *as->leftVal->u.id;

    actual_type = find(out, name, as->pos, false);
    if (actual_type->isVarArrFunc == 2)
      error_print(out, as->pos,
                  "cannot assign a value to function " + name + " on line " +
                      std::to_string(as->pos->line) + ", col " +
                      std::to_string(as->pos->col) + ".");

    switch (as->rightVal->kind) {
    case A_boolExprValKind: {
      check_BoolExpr(out, as->rightVal->u.boolExpr);
      deduced_type = bool_type(as->pos);
      if (empty_type(actual_type)) {
        if (actual_type && actual_type->isVarArrFunc == 1)
          error_print(out, as->pos,
                      "cannot assign a value to array " + name + " on line " +
                          std::to_string(as->pos->line) + ", col " +
                          std::to_string(as->pos->col) + ".");
        assign_type(name, deduced_type);
      }
      if (comp_tc_type(deduced_type, actual_type) == false)
        error_print(out, as->pos,
                    "cannot assign due to type mismatch: " +
                        get_type(actual_type) + "!=" + get_type(deduced_type));
    } break;
    case A_arithExprValKind: {
      deduced_type = check_ArithExpr(out, as->rightVal->u.arithExpr);
      if (empty_type(deduced_type))
        error_print(out, as->pos,
                    "cannot assign void value to variable " + name +
                        " on line " + std::to_string(as->pos->line) + ", col " +
                        std::to_string(as->pos->col) + ".");
      if (deduced_type->isVarArrFunc == 2)
        error_print(out, as->pos,
                    "cannot assign a function " + name + " on line " +
                        std::to_string(as->pos->line) + ", col " +
                        std::to_string(as->pos->col) + ".");
      if (empty_type(actual_type) && actual_type) {
        if (actual_type->isVarArrFunc != deduced_type->isVarArrFunc)
          error_print(out, as->pos,
                      "cannot assign a value to " + name + " on line " +
                          std::to_string(as->pos->line) + ", col " +
                          std::to_string(as->pos->col) +
                          " due to isVarArrFunc mismatch.");
        // check array length if you want
        assign_type(name, deduced_type);
      } else if (comp_tc_type(actual_type, deduced_type) == false) {
        error_print(out, as->pos,
                    "cannot assign due to type mismatch: " +
                        get_type(actual_type) + "!=" + get_type(deduced_type));
      }
      // else if (actual_type->isVarArrFunc == 1)
      // {
      //     if (actual_type->arrayLength != deduced_type->arrayLength)
      //         error_print(out, as->pos, "cannot assign due to array length
      //         mismatch: " + std::to_string(actual_type->arrayLength) + "!=" +
      //         std::to_string(deduced_type->arrayLength));
      // }
    } break;
    default:
      error_print(out, as->pos, "Type mismatch in assignment!");
      break;
    }
    /* fill code here */
  } break;
  case A_leftValType::A_arrValKind: {
    // let b[1] = {1};
    // a=b;
    // a.a=b;
    if (!as->leftVal->u.arrExpr || !as->leftVal->u.arrExpr->arr ||
        !as->leftVal->u.arrExpr->idx)
      error_print(out, as->pos, "arrExpr error in leftVal");

    aA_type arrType = check_ArrayExpr(out, as->leftVal->u.arrExpr);
    actual_type = tc_Type(arrType, 0);
    switch (as->rightVal->kind) {
    case A_boolExprValKind:
      check_BoolExpr(out, as->rightVal->u.boolExpr);
      deduced_type = bool_type(as->pos);
      if (comp_tc_type(deduced_type, actual_type) == false)
        error_print(out, as->pos,
                    "cannot assign due to array type mismatch: " +
                        get_type(actual_type) + "!=" + get_type(deduced_type));
      break;
    case A_arithExprValKind:
      deduced_type = check_ArithExpr(out, as->rightVal->u.arithExpr);
      if (comp_tc_type(deduced_type, actual_type) == false)
        error_print(out, as->pos,
                    "cannot assign due to array type mismatch: " +
                        get_type(actual_type) + "!=" + get_type(deduced_type));
      break;
    default:
      error_print(out, as->pos, "Type mismatch in assignment!");
      break;
    }
    /* fill code here */
  } break;
  case A_leftValType::A_memberValKind: {
    // a.b = 1
    actual_type = check_MemberExpr(out, as->leftVal->u.memberExpr);
    switch (as->rightVal->kind) {
    case A_boolExprValKind: {
      check_BoolExpr(out, as->rightVal->u.boolExpr);
      deduced_type = bool_type(as->pos);
      if (comp_tc_type(deduced_type, actual_type) == false)
        error_print(out, as->pos,
                    "cannot assign due to type mismatch: " +
                        get_type(actual_type) + "!=" + get_type(deduced_type));
    } break;

    case A_arithExprValKind: {
      deduced_type = check_ArithExpr(out, as->rightVal->u.arithExpr);
      // check array length if you want
      if (comp_tc_type(actual_type, deduced_type) == false)
        error_print(out, as->pos,
                    "cannot assign due to type mismatch: " +
                        get_type(actual_type) + "!=" + get_type(deduced_type));
    } break;

    default:
      error_print(out, as->pos, "Type mismatch in assignment!");
      break;
    }
    /* fill code here */
  } break;
  }
  return;
}

// there is no 2D array and function array in teapl
// so the return type is always scalar
aA_type check_ArrayExpr(std::ostream &out, aA_arrayExpr ae) {
  if (!ae)
    return nullptr;
  if (!ae->arr || !ae->idx)
    error_print(out, ae->pos, "no arr or idx in arrayExpr");
  // check array name
  /* fill code here */
  tc_type arrType;
  switch (ae->arr->kind) {
  case A_varValKind: {
    if (!ae->arr->u.id)
      error_print(out, ae->pos, "no id in arrayExpr");
    string name = *ae->arr->u.id;
    arrType = find(out, name, ae->pos, false);
  } break;
  case A_memberValKind: {
    if (!ae->arr->u.memberExpr)
      error_print(out, ae->pos, "no memberExpr in arrayExpr");
    arrType = check_MemberExpr(out, ae->arr->u.memberExpr);
    // a.arr[1] = 0;
  } break;
  default:
    error_print(out, ae->pos, "there is no 2D array in teapl!");
    break;
  }

  if (arrType->isVarArrFunc != 1)
    error_print(out, ae->pos, "This member is not an array!");

  // check index
  /* filling code here */
  switch (ae->idx->kind) {
  case A_numIndexKind: {
    if (arrType->arrayLength <= ae->idx->u.num || ae->idx->u.num < 0)
      error_print(out, ae->pos, "Array index out of bound!");
  } break;
  case A_idIndexKind: {
    if (!ae->idx->u.id)
      error_print(out, ae->pos, "no id in arrayExpr's idx");
    tc_type type = find(out, *ae->idx->u.id, ae->pos, false);
    if (type->isVarArrFunc != 0 || !type->type ||
        type->type->type != A_dataType::A_nativeTypeKind ||
        type->type->u.nativeType != A_nativeType::A_intTypeKind)
      error_print(out, ae->pos, "Array index should be int scalar!");
  }
  default:
    error_print(out, ae->pos, "Array index should be int!");
    break;
  }

  return arrType->type;
}

tc_type check_MemberExpr(std::ostream &out, aA_memberExpr me) {
  // check if the member exists and return the type of the member
  if (!me)
    return nullptr;
  if (!me->structId || !me->memberId || !me->structId)
    error_print(out, me->pos, "no structId in memberExpr");

  tc_type structType = nullptr;
  switch (me->structId->kind) {
  case A_varValKind: {
    if (!me->structId->u.id)
      error_print(out, me->pos, "no id in memberExpr");
    // this is not the struct name!!!!!
    string name = *me->structId->u.id;
    structType = find(out, name, me->pos, false);
  } break;

  case A_arrValKind:
    structType = tc_Type(check_ArrayExpr(out, me->structId->u.arrExpr), 0);
    break;

  case A_memberValKind:
    structType = check_MemberExpr(out, me->structId->u.memberExpr);
    break;

  default:
    error_print(out, me->pos, "error in memberExpr");
    break;
  }
  // check struct name
  /* fill code here */
  if (empty_type(structType) ||
      structType->type->type != A_dataType::A_structTypeKind)
    error_print(out, me->pos, "this is not a struct.");
  if (!structType->type->u.structType)
    error_print(out, me->pos,
                "it is a struct indeed but struct's not defined.");

  auto members = struct2Members[*structType->type->u.structType];
  if (!members)
    error_print(out, me->pos, "members is null");
  string member = *me->memberId;

  // check member name
  /* fill code here */
  for (const auto &i : *members) {
    if (!i || !i->u.declScalar || !i->u.declScalar->id)
      error_print(out, me->pos, "member is null");
    if (*i->u.declScalar->id == member)
      return tc_Type(i);
  }
  error_print(out, me->pos, "member '" + member + "' is not defined.");

  return nullptr;
}

void check_IfStmt(std::ostream &out, aA_ifStmt is) {
  if (!is)
    return;
  if (!is->boolExpr)
    error_print(out, is->pos, "no boolExpr in ifStmt");
  check_BoolExpr(out, is->boolExpr);
  /* fill code here, take care of variable scope */
  enterScope();
  for (aA_codeBlockStmt s : is->ifStmts) {
    check_CodeblockStmt(out, s);
  }
  exitScope();
  enterScope();
  /* fill code here */
  for (aA_codeBlockStmt s : is->elseStmts) {
    check_CodeblockStmt(out, s);
  }
  exitScope();
  /* fill code here */
  return;
}

void check_BoolExpr(std::ostream &out, aA_boolExpr be) {
  if (!be)
    return;
  switch (be->kind) {
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

void check_BoolUnit(std::ostream &out, aA_boolUnit bu) {
  if (!bu)
    return;
  switch (bu->kind) {
  case A_boolUnitType::A_comOpExprKind: {
    if (!bu->u.comExpr || !bu->u.comExpr->left || !bu->u.comExpr->right)
      error_print(out, bu->pos, "no comExpr in boolUnit");
    tc_type a = check_ExprUnit(out, bu->u.comExpr->left);
    tc_type b = check_ExprUnit(out, bu->u.comExpr->right);
    if (empty_type(a) || empty_type(b))
      error_print(out, bu->pos, "void value in comparison!");
    if (a->isVarArrFunc != b->isVarArrFunc)
      error_print(out, bu->pos, "different types in comparison!");
    if (comp_tc_type(a, b) == false) {
      // just for error printing
      if (a->type->type == A_dataType::A_structTypeKind &&
          b->type->type == A_dataType::A_structTypeKind)
        error_print(out, bu->pos,
                    get_type(a) + " is not comparable with " + get_type(b) +
                        ".");
      else if (a->type->type == A_dataType::A_structTypeKind)
        error_print(out, bu->pos, get_type(a) + " is not comparable with int.");
      else if (b->type->type == A_dataType::A_structTypeKind)
        error_print(out, bu->pos, get_type(b) + " is not comparable with int.");
      else
        error_print(out, bu->pos, "different types in comparison!");
    }
    /* fill code here */
  } break;
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

tc_type check_ExprUnit(std::ostream &out, aA_exprUnit eu) {
  // return the aA_type of expr eu
  if (!eu)
    return nullptr;
  tc_type ret;
  switch (eu->kind) {
  case A_exprUnitType::A_idExprKind: {
    if (!eu->u.id)
      error_print(out, eu->pos, "no id in exprUnit");
    string name = *eu->u.id;
    ret = find(out, name, eu->pos, false);
    /* filled code here */
  } break;
  case A_exprUnitType::A_numExprKind: {
    aA_type numt = new aA_type_;
    numt->pos = eu->pos;
    numt->type = A_dataType::A_nativeTypeKind;
    numt->u.nativeType = A_nativeType::A_intTypeKind;
    ret = tc_Type(numt, 0);
  } break;
  case A_exprUnitType::A_fnCallKind: {
    check_FuncCall(out, eu->u.callExpr);
    // check_FuncCall will check if the function is defined
    ret = find(out, *eu->u.callExpr->fn, eu->pos, false);
    /* fill code here */
  } break;
  case A_exprUnitType::A_arrayExprKind: {
    ret = tc_Type(check_ArrayExpr(out, eu->u.arrayExpr), 0);
    /* fill code here */
  } break;
  case A_exprUnitType::A_memberExprKind: {
    ret = check_MemberExpr(out, eu->u.memberExpr);
  } break;
  case A_exprUnitType::A_arithExprKind: {
    ret = check_ArithExpr(out, eu->u.arithExpr);
  } break;
  case A_exprUnitType::A_arithUExprKind: {
    ret = check_ExprUnit(out, eu->u.arithUExpr->expr);
  } break;
  }
  return ret;
}

tc_type check_ArithExpr(std::ostream &out, aA_arithExpr ae) {
  if (!ae)
    return nullptr;
  tc_type ret;
  switch (ae->kind) {
  case A_arithExprType::A_arithBiOpExprKind: {
    ret = check_ArithExpr(out, ae->u.arithBiOpExpr->left);
    tc_type rightTyep = check_ArithExpr(out, ae->u.arithBiOpExpr->right);
    if (ret->type->type > 0 ||
        ret->type->type != A_dataType::A_nativeTypeKind ||
        ret->type->u.nativeType != A_nativeType::A_intTypeKind ||
        rightTyep->type->type > 0 ||
        rightTyep->type->type != A_dataType::A_nativeTypeKind ||
        rightTyep->type->u.nativeType != A_nativeType::A_intTypeKind)
      error_print(out, ae->pos,
                  "Only int can be arithmetic expression operation values!");
  } break;
  case A_arithExprType::A_exprUnitKind:
    ret = check_ExprUnit(out, ae->u.exprUnit);
    break;
  }
  return ret;
}

void check_FuncCall(std::ostream &out, aA_fnCall fc) {
  if (!fc)
    return;
  // check if function defined
  if (!fc->fn)
    error_print(out, fc->pos, "Function name is null!");
  string func_name = *fc->fn;
  if (func2Param.find(func_name) == func2Param.end())
    error_print(out, fc->pos, "This function is not defined!");
  vector<aA_varDecl> *params = func2Param[func_name];
  if (!params)
    error_print(out, fc->pos, "params is null");
  /* fill code here */

  // check if parameter list matches
  if (fc->vals.size() < params->size())
    error_print(out, fc->pos, "Too few parameters in function call!");
  else if (fc->vals.size() > params->size())
    error_print(out, fc->pos, "Too many parameters in function call!");

  for (int i = 0; i < fc->vals.size(); i++) {
    tc_type expect_type = tc_Type(params->at(i));
    if (fc->vals[i]->kind == A_arithExprValKind) {
      tc_type actual_type = check_ArithExpr(out, fc->vals[i]->u.arithExpr);
      if (expect_type->isVarArrFunc != actual_type->isVarArrFunc)
        error_print(out, fc->pos,
                    "Function parameter type mismatch in function call!");
      if (!comp_tc_type(actual_type, expect_type))
        error_print(out, fc->pos,
                    "Function parameter type mismatch in function call!");
    } else if (fc->vals[i]->kind == A_boolExprValKind) {
      tc_type actual_type = bool_type(fc->pos);
      check_BoolExpr(out, fc->vals[i]->u.boolExpr);
      if (expect_type->isVarArrFunc != actual_type->isVarArrFunc)
        error_print(out, fc->pos,
                    "Function parameter type mismatch in function call!");
      if (!comp_tc_type(actual_type, expect_type))
        error_print(out, fc->pos,
                    "Function parameter type mismatch in function call!");
    } else
      error_print(out, fc->pos, "Function parameter type mismatch!");
    /* fill code here */
  }
  return;
}

void check_WhileStmt(std::ostream &out, aA_whileStmt ws) {
  if (!ws)
    return;
  check_BoolExpr(out, ws->boolExpr);
  /* fill code here, take care of variable scope */
  enterScope();
  for (aA_codeBlockStmt s : ws->whileStmts) {
    check_CodeblockStmt(out, s);
  }
  /* fill code here */
  exitScope();

  return;
}

void check_CallStmt(std::ostream &out, aA_callStmt cs) {
  if (!cs)
    return;
  check_FuncCall(out, cs->fnCall);
  return;
}

void check_ReturnStmt(std::ostream &out, aA_returnStmt rs) {
  if (!rs)
    return;
  tc_type ret_type = retType;
  returned = true;
  // auto ret_type = retType.back();
  if (!ret_type && !rs->retVal)
    return;
  else if (!ret_type && rs->retVal)
    error_print(
        out, rs->pos,
        "Return type mismatch! void function should not have return value.");
  else if (ret_type && !rs->retVal)
    error_print(
        out, rs->pos,
        "Return type mismatch! non-void function should have return value.");

  tc_type tmp_type = nullptr;
  switch (rs->retVal->kind) {
  case A_boolExprValKind:
    check_BoolExpr(out, rs->retVal->u.boolExpr);
    tmp_type = bool_type(rs->pos);
    break;
  case A_arithExprValKind:
    tmp_type = check_ArithExpr(out, rs->retVal->u.arithExpr);
    break;
  default:
    error_print(out, rs->pos, "Return type mismatch!");
    break;
  }

  if ((tmp_type->isVarArrFunc == 1) ^ (ret_type->isVarArrFunc == 1))
    error_print(out, rs->pos,
                "Return type mismatch, there is an array in return value!");
  if (!comp_tc_type(ret_type, tmp_type))
    error_print(out, rs->pos, "Return type mismatch!");
}

tc_type find(std::ostream &out, std::string name, A_pos pos,
             bool expected_available) {
  // print_token_maps();
  if (funcparam_token2Type.find(name) == funcparam_token2Type.end()) {
    if (g_token2Type.find(name) == g_token2Type.end()) {
      for (int j = 0; j <= scopeLevel; j++) {
        auto i = local_token2Type[j];
        if (i->find(name) != i->end()) {
          if (expected_available)
            error_print(out, pos,
                        "local variables duplicates with local variables.");
          return i->at(name);
        }
      }
      if (!expected_available) {
        if (!pos)
          error_print(out, pos, "pos error");
        error_print(out, pos,
                    "var " + name + " on line " + std::to_string(pos->line) +
                        ", col " + std::to_string(pos->col) +
                        " is not defined.");
      }
      return nullptr;
    }
    if (expected_available)
      error_print(out, pos,
                  "local variables duplicates with global variables.");
    return g_token2Type[name];
  }
  if (expected_available)
    error_print(out, pos, "local variables duplicates with function params.");
  return funcparam_token2Type[name];
}

void assign_type(std::string name, tc_type t) {
  // only occurs in global and local scope
  // if (funcparam_token2Type.find(name) == funcparam_token2Type.end())
  // {
  if (g_token2Type.find(name) == g_token2Type.end()) {
    for (int j = 0; j <= scopeLevel; j++) {
      auto i = local_token2Type[j];
      if (i->find(name) != i->end()) {
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

tc_type bool_type(A_pos pos) {
  return tc_Type(new aA_type_{pos, A_dataType::A_nativeTypeKind,
                              A_nativeType::A_intTypeKind},
                 0);
}

string get_type(tc_type type) {
  if (!type || !type->type)
    return "";
  string ret = "";
  switch (type->type->type) {
  case A_dataType::A_nativeTypeKind:
    switch (type->type->u.nativeType) {
    case A_nativeType::A_intTypeKind:
      ret += "int";
      break;
    default:
      break;
    }
    break;
  case A_dataType::A_structTypeKind: {
    if (!type->type->u.structType)
      error_print(std::cout, type->type->pos, "struct type is null");
    ret += *(type->type->u.structType);
  } break;
  default:
    break;
  }
  switch (type->isVarArrFunc) {
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

void print_type(tc_type type) { std::cout << get_type(type) << std::endl; }

bool empty_type(tc_type type) {
  return !type || !type->type;
  //  if (type->type->type == A_structTypeKind && !type->type->u.structType)
  // return true;
}

bool empty_type(aA_type type) { return !type; }

void check_struct_defined(std::ostream &out, A_pos pos, aA_type type,
                          string error_msg) {
  if (type && type->type == A_structTypeKind)
    if (!type->u.structType ||
        struct2Members.find(*type->u.structType) == struct2Members.end())
      error_print(out, pos, error_msg);
}

void enterScope() {
  // std::cout << "\nnow it's " << scopeLevel + 1;
  local_token2Type.push_back(new typeMap);
  currScope = local_token2Type[++scopeLevel];
}

void exitScope() {
  // local_token2Type.pop_back();
  if (--scopeLevel < 0)
    currScope = &g_token2Type;
  else
    currScope = local_token2Type[scopeLevel];
  if (local_token2Type.size() > scopeLevel + 1) {
    local_token2Type.pop_back();
  }
}