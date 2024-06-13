#include "llvm_ir.h"
#include "asm_arm.h"
#include "temp.h"
#include "llvm2asm.h"
#include "allocReg.h"
#include <queue>
#include <cassert>
#include <iostream>
#include "printASM.h"
#include "printLLVM.h"
#include "register_rules.h"
#include <sstream>
#include <iostream>
using namespace std;
using namespace LLVMIR;
using namespace ASM;

#define INSERT1() printf("%s:%d\n", __FILE__, __LINE__);
static int stack_frame;
static bool alloc_frame = false;
struct StructDef
{
    std::vector<int> offset;
    int size;
    StructDef(std::vector<int> _offset, int _size) : offset(_offset), size(_size) {}
};

static AS_reg *sp = new AS_reg(AS_type::SP, -1);
static unordered_map<int, AS_address *> fpOffset;
static unordered_map<int, AS_relopkind> condMap;
static unordered_map<string, StructDef *> structLayout;
int getMemLength(TempDef &members)
{
    switch (members.kind)
    {
    case TempType::INT_PTR:
        return INT_LENGTH * members.len;
        break;
    case TempType::INT_TEMP:
        return INT_LENGTH;
        break;
    case TempType::STRUCT_PTR:
        return structLayout[members.structname]->size * members.len;
        break;
    case TempType::STRUCT_TEMP:
        return structLayout[members.structname]->size;
        break;
    default:
        assert(0);
    }
}
void structLayoutInit(vector<L_def *> &defs)
{
    for (L_def *def : defs)
    {
        if (def->kind != L_DefKind::SRT)
        {
            continue;
        }
        vector<int> offset;
        int size = 0;
        for (auto &member : def->u.SRT->members)
        {
            offset.push_back(size);
            size += getMemLength(member);
        }
        structLayout[def->u.SRT->name] = new StructDef(offset, size);
    }
    // ToDo:计算结构体各个位置的偏移
}

AS_reg *fuckImm(list<AS_stm *> &as_list, int c)
{
    AS_reg *new_reg = new AS_reg(AS_type::Xn, Temp_newtemp_int()->num);
    assert(c >= 0);
    if (c < 65536)
        as_list.push_back(AS_Mov(new AS_reg(AS_type::IMM, c), new_reg));
    else
    {
        as_list.push_back(AS_Movk(new AS_reg(AS_type::IMM, c & 0xffff), new_reg));
        as_list.push_back(AS_Movz(new AS_reg(AS_type::IMM, c >> 16), new_reg));
    }
    return new_reg;
}

void set_stack(L_func &func)
{
    // SSA
    stack_frame = 0;
    // ToDo:为函数局部变量分配内存，同时记录相对于fp的偏移
    for (const auto &block : func.blocks)
        for (const auto &stm : block->instrs)
        {
            if (stm->type != L_StmKind::T_ALLOCA)
                continue;

            int len = INT_LENGTH;

            assert(stm->u.ALLOCA->dst->kind == OperandKind::TEMP);
            Temp_temp *temp = stm->u.ALLOCA->dst->u.TEMP;
            // continue;
            switch (stm->u.ALLOCA->dst->u.TEMP->type)
            {
            case TempType::INT_PTR:
                len = INT_LENGTH * stm->u.ALLOCA->dst->u.TEMP->len;
                break;
            case TempType ::STRUCT_PTR:
                len = structLayout[stm->u.ALLOCA->dst->u.TEMP->structname]->size * max(stm->u.ALLOCA->dst->u.TEMP->len, 1);
                break;
            default:
                assert(0);
                break;
            }
            assert(len);
            stack_frame += len;
            fpOffset[temp->num] = new AS_address(new AS_reg(AS_type::Xn, XnFP), -stack_frame);
            // if (stm->type != L_StmKind::T_ALLOCA)
            // {
            //     continue;
            // }
            // getMemLength(stm->u.ALLOCA->dst->u.TEMP);
            // getDefReg(stm->u.ALLOCA->dst);
        }
    stack_frame = ((stack_frame + 15) >> 4) << 4;
}

void new_frame(list<AS_stm *> &as_list, L_func &func)
{
    // ToDo:在刚刚进入函数的时候，需要调整sp，并将函数参数移入虚拟寄存器
    // as_list.emplace_back(AS_Stp(new AS_reg(AS_type::Xn, XnFP), new AS_reg(AS_type::Xn, XXnl), sp, -2 * INT_LENGTH));
    // as_list.emplace_back(AS_Mov(sp, new AS_reg(AS_type::Xn, XnFP)));
    for (int i = 0; i < 8 && i < func.args.size(); i++)
    {
        // cout << func.args.size() << endl;
        // TODO
        as_list.push_back(AS_Mov(new AS_reg(AS_type::Xn, paramRegs[i]), new AS_reg(AS_type::Xn, func.args[i]->num)));
    }
}

void free_frame(list<AS_stm *> &as_list)
{
    as_list.emplace_back(AS_Mov(new AS_reg(AS_type::Xn, XnFP), sp));
    // as_list.emplace_back(AS_Ldp(new AS_reg(AS_type::Xn, XnFP), new AS_reg(AS_type::Xn, XXnl), sp, 2 * INT_LENGTH));
}
void llvm2asmBinop(list<AS_stm *> &as_list, L_stm *binop_stm)
{
    // if (fpOffset.find(binop_stm->u.BINOP->dst->u.TEMP->num) == fpOffset.end())
    //     assert(0);
    AS_reg *dst = new AS_reg(AS_type::Xn, binop_stm->u.BINOP->dst->u.TEMP->num);

    AS_reg *left, *right;
    if (binop_stm->u.BINOP->left->kind == OperandKind::ICONST)
        left = fuckImm(as_list, binop_stm->u.BINOP->left->u.ICONST);
    // {
    //     // left = new AS_reg(AS_type::IMM, binop_stm->u.BINOP->left->u.ICONST);
    //     left = new AS_reg(AS_type::Xn, Temp_newtemp_int()->num);
    //     as_list.push_back(AS_Mov(new AS_reg(AS_type::IMM, binop_stm->u.BINOP->left->u.ICONST), left));
    // }
    else if (binop_stm->u.BINOP->left->kind == OperandKind::TEMP)
        left = new AS_reg(AS_type::Xn, binop_stm->u.BINOP->left->u.TEMP->num);
    else
        assert(0);
    if (binop_stm->u.BINOP->right->kind == OperandKind::ICONST)
        right = fuckImm(as_list, binop_stm->u.BINOP->right->u.ICONST);
    // {
    //     // right = new AS_reg(AS_type::IMM, binop_stm->u.BINOP->right->u.ICONST);
    //     right = new AS_reg(AS_type::Xn, Temp_newtemp_int()->num);
    //     as_list.push_back(AS_Mov(new AS_reg(AS_type::IMM, binop_stm->u.BINOP->right->u.ICONST), right));
    // }
    else if (binop_stm->u.BINOP->right->kind == OperandKind::TEMP)
        right = new AS_reg(AS_type::Xn, binop_stm->u.BINOP->right->u.TEMP->num);
    else
        assert(0);

    switch (binop_stm->u.BINOP->op)
    {
    case L_binopKind::T_div:
        as_list.push_back(AS_Binop(AS_binopkind::SDIV_, left, right, dst));
        break;
    case L_binopKind::T_mul:
        as_list.push_back(AS_Binop(AS_binopkind::MUL_, left, right, dst));
        break;
    case L_binopKind::T_minus:
        as_list.push_back(AS_Binop(AS_binopkind::SUB_, left, right, dst));
        break;
    case L_binopKind::T_plus:
        as_list.push_back(AS_Binop(AS_binopkind::ADD_, left, right, dst));
        break;
    default:
        assert(0);
        break;
    }
}

void llvm2asmLoad(list<AS_stm *> &as_list, L_stm *load_stm)
{
    assert(load_stm->u.LOAD->dst->kind == OperandKind::TEMP);
    AS_reg *dst = new AS_reg(AS_type::Xn, load_stm->u.LOAD->dst->u.TEMP->num);
    if (load_stm->u.LOAD->ptr->kind == OperandKind::NAME)
    {
        // AS_reg *new_reg = new AS_reg(AS_type::Xn, Temp_newtemp_int()->num);
        // as_list.push_back(AS_Mov(new AS_reg(AS_type::ADR, 0), new_reg));
        // ptr = new AS_reg(AS_type::ADR, 0);
        as_list.push_back(AS_Adr(new AS_label(load_stm->u.LOAD->ptr->u.NAME->name->name), dst));
        as_list.push_back(AS_Ldr(dst, new AS_reg(AS_type::ADR, new AS_address(dst, 0))));
        return;
    }
    else if (load_stm->u.LOAD->ptr->kind == OperandKind::TEMP)
    {
        // if (fpOffset.find(load_stm->u.LOAD->ptr->u.TEMP->num) == fpOffset.end())
        //     assert(0);
        AS_reg *ptr = new AS_reg(AS_type::ADR, new AS_address(new AS_reg(AS_type::Xn, load_stm->u.LOAD->ptr->u.TEMP->num), 0));
        as_list.push_back(AS_Ldr(dst, ptr));
    }
    else
        assert(0);
}

void llvm2asmStore(list<AS_stm *> &as_list, L_stm *store_stm)
{
    AS_reg *src = nullptr;
    switch (store_stm->u.STORE->src->kind)
    {
    case OperandKind::TEMP:
        src = new AS_reg(AS_type::Xn, store_stm->u.STORE->src->u.TEMP->num);
        break;
    case OperandKind::NAME:
        assert(0);
        // src = new AS_reg(AS_type::Xn, fpOffset[store_stm->u.STORE->src->u.TEMP->num]);
        // as_list.push_back(AS_Adr(new AS_label(store_stm->u.STORE->src->u.NAME->name->name), src));
        break;
    case OperandKind::ICONST:
        src = fuckImm(as_list, store_stm->u.STORE->src->u.ICONST);
        // {
        //     // src = new AS_reg(AS_type::IMM, store_stm->u.STORE->src->u.ICONST);
        //     // TODO
        //     src = new AS_reg(AS_type::Xn, Temp_newtemp_int()->num);
        //     as_list.push_back(AS_Mov(new AS_reg(AS_type::IMM, store_stm->u.STORE->src->u.ICONST), src));
        // }
        break;
    default:
        assert(0);
        break;
    }
    assert(src);
    if (store_stm->u.STORE->ptr->kind == OperandKind::TEMP)
    {
        AS_reg *ptr = new AS_reg(AS_type::ADR, new AS_address(new AS_reg(AS_type::Xn, store_stm->u.STORE->ptr->u.TEMP->num), 0));
        as_list.push_back(AS_Str(src, ptr));
    }
    else if (store_stm->u.STORE->ptr->kind == OperandKind::NAME)
    {
        // TODO
        // assert(0);
        // ptr = new AS_reg(AS_type::ADR, 0);
        AS_reg *new_reg = new AS_reg(AS_type::Xn, Temp_newtemp_int()->num);
        as_list.push_back(AS_Adr(new AS_label(store_stm->u.STORE->ptr->u.NAME->name->name), new_reg));
        // as_list.push_back(AS_Str(src, new AS_reg(AS_type::ADR, new AS_address(new AS_reg(AS_type::Xn, new_reg->u.offset), 0)))); // new_reg->u.add)));
        as_list.push_back(AS_Str(src, new AS_reg(AS_type::ADR, new AS_address(new_reg, 0))));
    }
    else
        assert(0);
}

void llvm2asmCmp(list<AS_stm *> &as_list, L_stm *cmp_stm)
{
    // ATTENTION: maybe too large
    AS_reg *left = nullptr, *right = nullptr;
    if (cmp_stm->u.CMP->left->kind == OperandKind::ICONST)
        left = fuckImm(as_list, cmp_stm->u.CMP->left->u.ICONST);
    // {
    //     left = new AS_reg(AS_type::Xn, Temp_newtemp_int()->num);
    //     as_list.push_back(AS_Mov(new AS_reg(AS_type::IMM, cmp_stm->u.CMP->left->u.ICONST), left));
    // }
    else if (cmp_stm->u.CMP->left->kind == OperandKind::TEMP)
        left = new AS_reg(AS_type::Xn, cmp_stm->u.CMP->left->u.TEMP->num);
    else
        assert(0);
    // if (fpOffset.find(cmp_stm->u.CMP->left->u.TEMP->num) == fpOffset.end())
    //     assert(0);

    if (cmp_stm->u.CMP->right->kind == OperandKind::ICONST)
        right = fuckImm(as_list, cmp_stm->u.CMP->right->u.ICONST);
    else if (cmp_stm->u.CMP->right->kind == OperandKind::TEMP)
        right = new AS_reg(AS_type::Xn, cmp_stm->u.CMP->right->u.TEMP->num);
    else
        assert(0);

    assert(left && right);
    as_list.push_back(AS_Cmp(left, right));

    AS_reg *dst = new AS_reg(AS_type::Xn, cmp_stm->u.CMP->dst->u.TEMP->num);
    // as_list.push_back(AS_Mov(new AS_reg(AS_type::Xn, AS_relopkind), dst));
    assert(cmp_stm->u.CMP->dst->kind == OperandKind::TEMP);
    switch (cmp_stm->u.CMP->op)
    {
    case L_relopKind::T_eq:
        condMap[cmp_stm->u.CMP->dst->u.TEMP->num] = AS_relopkind::EQ_;
        break;
    case L_relopKind::T_ne:
        condMap[cmp_stm->u.CMP->dst->u.TEMP->num] = AS_relopkind::NE_;
        break;
    case L_relopKind::T_lt:
        condMap[cmp_stm->u.CMP->dst->u.TEMP->num] = AS_relopkind::LT_;
        break;
    case L_relopKind::T_gt:
        condMap[cmp_stm->u.CMP->dst->u.TEMP->num] = AS_relopkind::GT_;
        break;
    case L_relopKind::T_ge:
        condMap[cmp_stm->u.CMP->dst->u.TEMP->num] = AS_relopkind::GE_;
        break;
    case L_relopKind::T_le:
        condMap[cmp_stm->u.CMP->dst->u.TEMP->num] = AS_relopkind::LE_;
        break;
    default:
        assert(0);
        break;
    }
}

void llvm2asmMov(list<AS_stm *> &as_list, L_stm *mov_stm)
{
    struct AS_reg *src;
    assert(mov_stm->u.MOVE->dst->kind == OperandKind::TEMP);
    struct AS_reg *dst = new AS_reg(AS_type::Xn, mov_stm->u.MOVE->dst->u.TEMP->num);
    if (mov_stm->u.MOVE->src->kind == OperandKind::ICONST)
        src = fuckImm(as_list, mov_stm->u.MOVE->src->u.ICONST);
    // {
    //     assert(mov_stm->u.MOVE->src->u.ICONST >= 0);
    //     if (mov_stm->u.MOVE->src->u.ICONST < 65536)
    //         src = new AS_reg(AS_type::IMM, mov_stm->u.MOVE->src->u.ICONST);
    //     else
    //     {
    //         src = new AS_reg(AS_type::Xn, Temp_newtemp_int()->num);
    //         as_list.push_back(AS_Movk(new AS_reg(AS_type::IMM, mov_stm->u.MOVE->src->u.ICONST & 0xffff), src));
    //         as_list.push_back(AS_Movk(new AS_reg(AS_type::IMM, mov_stm->u.MOVE->src->u.ICONST >> 16), src));
    //     }
    // }
    else if (mov_stm->u.MOVE->src->kind == OperandKind::TEMP)
        src = new AS_reg(AS_type::Xn, mov_stm->u.MOVE->src->u.TEMP->num);
    else
        assert(0);

    as_list.push_back(AS_Mov(src, dst));
}

void llvm2asmCJmp(list<AS_stm *> &as_list, L_stm *cjmp_stm)
{
    as_list.push_back(AS_BCond(condMap[cjmp_stm->u.CJUMP->dst->u.TEMP->num], new AS_label(cjmp_stm->u.CJUMP->true_label->name)));
    as_list.push_back(AS_B(new AS_label(cjmp_stm->u.CJUMP->false_label->name)));
}

void llvm2asmRet(list<AS_stm *> &as_list, L_stm *ret_stm)
{
    // load_register(as_list);
    // move_result(as_list, ret_stm->u.RETURN->res->u.TEMP->num, XXnret);

    if (ret_stm->u.RETURN->ret)
    {
        AS_reg *res = nullptr;
        switch (ret_stm->u.RETURN->ret->kind)
        {
        case OperandKind::TEMP:
            res = new AS_reg(AS_type::Xn, ret_stm->u.RETURN->ret->u.TEMP->num);
            break;
        case OperandKind::ICONST:
            res = new AS_reg(AS_type::IMM, ret_stm->u.RETURN->ret->u.ICONST);
            break;
        case OperandKind::NAME:
        {
            // res = new AS_reg(AS_type::Xn, 0);
            as_list.push_back(AS_Adr(new AS_label(ret_stm->u.RETURN->ret->u.NAME->name->name), new AS_reg(AS_type::Xn, XXnret)));
            as_list.push_back(AS_Ret());
        }
        break;
        default:
            assert(0);
            break;
        }
        assert(res);
        as_list.push_back(AS_Mov(res, new AS_reg(AS_type::Xn, XXnret)));
    }

    // free_frame(as_list);
    as_list.push_back(AS_Ret());
}

void llvm2asmGep(list<AS_stm *> &as_list, L_stm *gep_stm)
{
    // base_ptr
    AS_reg *base_ptr = new AS_reg(AS_type::Xn, Temp_newtemp_int()->num);
    switch (gep_stm->u.GEP->base_ptr->kind)
    {
    case OperandKind::TEMP:
    {
        AS_address *addr = fpOffset[gep_stm->u.GEP->base_ptr->u.TEMP->num];
        if (addr)
        {
            AS_reg *new_reg = new AS_reg(AS_type::Xn, Temp_newtemp_int()->num);
            as_list.push_back(AS_Mov(new AS_reg(AS_type::IMM, addr->imm), new_reg));
            as_list.push_back(AS_Binop(AS_binopkind::ADD_, new AS_reg(AS_type::Xn, XnFP), new_reg, base_ptr));
        }
        else
            as_list.push_back(AS_Mov(new AS_reg(AS_type::Xn, gep_stm->u.GEP->base_ptr->u.TEMP->num), base_ptr));
    }
    break;
    case OperandKind::NAME:
        as_list.push_back(AS_Adr(new AS_label(gep_stm->u.GEP->base_ptr->u.NAME->name->name), base_ptr));
        break;
    default:
        assert(0);
        break;
    }

    assert(base_ptr);

    // idx
    AS_reg *idx = nullptr;
    int const_idx = 0;
    switch (gep_stm->u.GEP->index->kind)
    {
    case OperandKind::TEMP:
        idx = new AS_reg(AS_type::Xn, gep_stm->u.GEP->index->u.TEMP->num);
        break;
    case OperandKind::NAME:
    {
        idx = new AS_reg(AS_type::Xn, Temp_newtemp_int()->num);
        as_list.push_back(AS_Adr(new AS_label(gep_stm->u.GEP->index->u.NAME->name->name), idx));
    }
    break;
    case OperandKind::ICONST:
    {
        idx = fuckImm(as_list, gep_stm->u.GEP->index->u.ICONST);
        const_idx = gep_stm->u.GEP->index->u.ICONST;
    }
    // {
    //     // idx = new AS_reg(AS_type::IMM, gep_stm->u.GEP->index->u.ICONST);
    //     idx = new AS_reg(AS_type::Xn, Temp_newtemp_int()->num);
    //     as_list.push_back(AS_Mov(new AS_reg(AS_type::IMM, gep_stm->u.GEP->index->u.ICONST), idx));
    // }
    break;
    default:
        assert(0);
        break;
    }
    assert(idx);

    // calculate
    // AS_reg *imm_reg = new AS_reg(AS_type::Xn, Temp_newtemp_int()->num);
    // if (gep_stm->u.GEP->new_ptr->u.TEMP->type == TempType::STRUCT_PTR)
    // {
    //     as_list.push_back(AS_Mov(new AS_reg(AS_type::IMM, structLayout[gep_stm->u.GEP->new_ptr->u.TEMP->structname]->size), imm_reg));
    //     cout << 1 << endl;
    // }
    // else
    // {
    //     as_list.push_back(AS_Mov(new AS_reg(AS_type::IMM, INT_LENGTH), imm_reg));
    //     cout << 2 << endl;
    // }
    // AS_reg *new_reg = new AS_reg(AS_type::Xn, gep_stm->u.GEP->new_ptr->u.TEMP->num);
    // as_list.push_back(AS_Binop(AS_binopkind::MUL_, idx, imm_reg, new_reg));
    // as_list.push_back(AS_Binop(AS_binopkind::ADD_, base_ptr, new_reg, new_reg));
    // assert(gep_stm->u.GEP->base_ptr->kind == OperandKind::TEMP);
    AS_reg *new_reg = new AS_reg(AS_type::Xn, gep_stm->u.GEP->new_ptr->u.TEMP->num);
    if (gep_stm->u.GEP->base_ptr->kind == OperandKind::TEMP && gep_stm->u.GEP->base_ptr->u.TEMP->type == TempType::STRUCT_PTR && gep_stm->u.GEP->base_ptr->u.TEMP->len == 0)
    {
        assert(gep_stm->u.GEP->index->kind == OperandKind::ICONST);
        assert(structLayout[gep_stm->u.GEP->base_ptr->u.TEMP->structname]);
        // auto t = structLayout[gep_stm->u.GEP->base_ptr->u.TEMP->structname];
        // cout << (structLayout[gep_stm->u.GEP->base_ptr->u.TEMP->structname]->offset.size() > const_idx) << endl;
        // cout << int(structLayout[gep_stm->u.GEP->base_ptr->u.TEMP->structname]->offset.size()) << " " << const_idx << endl;
        assert(int(structLayout[gep_stm->u.GEP->base_ptr->u.TEMP->structname]->offset.size()) > const_idx);
        // structLayout[gep_stm->u.GEP->new_ptr->u.TEMP->structname]->size
        as_list.push_back(AS_Mov(new AS_reg(AS_type::IMM, structLayout[gep_stm->u.GEP->base_ptr->u.TEMP->structname]->offset[const_idx]), new_reg));
        cout << 1 << endl;
    }
    else if (gep_stm->u.GEP->base_ptr->kind == OperandKind::NAME && gep_stm->u.GEP->base_ptr->u.NAME->type == TempType::STRUCT_TEMP)
    {
        assert(gep_stm->u.GEP->index->kind == OperandKind::ICONST);
        assert(structLayout[gep_stm->u.GEP->base_ptr->u.NAME->structname]);
        assert(int(structLayout[gep_stm->u.GEP->base_ptr->u.NAME->structname]->offset.size()) > const_idx);
        as_list.push_back(AS_Mov(new AS_reg(AS_type::IMM, structLayout[gep_stm->u.GEP->base_ptr->u.NAME->structname]->offset[const_idx]), new_reg));
        cout << 2 << endl;
    }
    else
    {
        assert(gep_stm->u.GEP->new_ptr->kind == OperandKind::TEMP);
        AS_reg *imm_reg = new AS_reg(AS_type::Xn, Temp_newtemp_int()->num);
        if (gep_stm->u.GEP->new_ptr->u.TEMP->type == TempType::STRUCT_PTR)
            as_list.push_back(AS_Mov(new AS_reg(AS_type::IMM, structLayout[gep_stm->u.GEP->new_ptr->u.TEMP->structname]->size), imm_reg));
        else if (gep_stm->u.GEP->new_ptr->u.TEMP->type == TempType::INT_PTR)
            as_list.push_back(AS_Mov(new AS_reg(AS_type::IMM, INT_LENGTH), imm_reg));
        else
            assert(0);
        as_list.push_back(AS_Binop(AS_binopkind::MUL_, idx, imm_reg, new_reg));
        cout << 3 << endl;
    }
    as_list.push_back(AS_Binop(AS_binopkind::ADD_, base_ptr, new_reg, new_reg));
    // as_list.push_back(AS_Mov(base_ptr, new AS_reg(AS_type::Xn, gep_stm->u.GEP->new_ptr->u.TEMP->num)));
    // as_list.push_back(AS_Ldr(new AS_reg(AS_type::Xn, gep_stm->u.GEP->new_ptr->u.TEMP->num), new AS_reg(AS_type::ADR, new AS_address(base_ptr, 0))));
}

void llvm2asmStm(list<AS_stm *> &as_list, L_stm &stm, L_func &func)
{

    if (!alloc_frame && stm.type != L_StmKind::T_LABEL)
    {
        new_frame(as_list, func);
        alloc_frame = true;
    }

    switch (stm.type)
    {
    case L_StmKind::T_BINOP:
    {
        llvm2asmBinop(as_list, &stm);
        break;
    }
    case L_StmKind::T_LOAD:
    {
        llvm2asmLoad(as_list, &stm);
        break;
    }
    case L_StmKind::T_STORE:
    {
        llvm2asmStore(as_list, &stm);
        break;
    }
    case L_StmKind::T_LABEL:
    {
        auto label = new AS_label(stm.u.LABEL->label->name);
        as_list.push_back(AS_Label(label));
        break;
    }
    case L_StmKind::T_JUMP:
    {
        auto label = new AS_label(stm.u.JUMP->jump->name);
        as_list.push_back(AS_B(label));
        break;
    }
    case L_StmKind::T_CMP:
    {
        llvm2asmCmp(as_list, &stm);
        break;
    }
    case L_StmKind::T_CJUMP:
    {
        llvm2asmCJmp(as_list, &stm);
        break;
    }
    case L_StmKind::T_MOVE:
    {
        llvm2asmMov(as_list, &stm);
        break;
    }
    case L_StmKind::T_CALL:
    {
        llvm2asmCall(as_list, &stm);
        break;
    }
    case L_StmKind::T_VOID_CALL:
    {
        llvm2asmVoidCall(as_list, &stm);
        break;
    }
    case L_StmKind::T_RETURN:
    {
        llvm2asmRet(as_list, &stm);
        break;
    }
    case L_StmKind::T_ALLOCA:
    {
        // Do nothing
        break;
    }
    case L_StmKind::T_GEP:
    {

        llvm2asmGep(as_list, &stm);

        break;
    }
    case L_StmKind::T_PHI:
    {
        // ToDo: 特殊处理
        break;
    }
    case L_StmKind::T_NULL:
    {
        // Do nothing
        break;
    }
    }
    //
}
int save_register(list<AS_stm *> &as_list)
{
    int sub = 0;
    for (auto it = allocateRegs.begin(); it != allocateRegs.end(); ++it)
    {
        // 获取当前元素
        int first = *it;
        ++it; // 移动到下一个元素

        // 检查是否有下一个元素
        if (it != allocateRegs.end())
        {
            int second = *it;
            as_list.push_back(AS_Stp(new AS_reg(AS_type::Xn, first), new AS_reg(AS_type::Xn, second), sp, -2 * INT_LENGTH));
            sub += 2 * INT_LENGTH;
        }
        else
        {
            // 如果`set`中的元素个数是奇数，最后一个元素将单独处理
            as_list.push_back(AS_Str(new AS_reg(AS_type::Xn, first), sp, -INT_LENGTH));
            sub += INT_LENGTH;
            break;
        }
    }
    as_list.push_back(AS_Stp(new AS_reg(AS_type::Xn, XnFP), new AS_reg(AS_type::Xn, XXnl), sp, -2 * INT_LENGTH));
    sub += 2 * INT_LENGTH;
    return sub;
}
void load_register(list<AS_stm *> &as_list)
{
    as_list.push_back(AS_Ldp(new AS_reg(AS_type::Xn, XnFP), new AS_reg(AS_type::Xn, XXnl), sp, 2 * INT_LENGTH));
    // ToDo:从栈中按**顺序**加载保存的寄存器
    auto it = allocateRegs.rbegin();
    if (allocateRegs.size() % 2)
    {
        // 如果`set`中的元素个数是奇数，最后一个元素将单独处理
        as_list.push_back(AS_Ldr(new AS_reg(AS_type::Xn, *allocateRegs.end()), sp, INT_LENGTH));
        it++;
    }

    for (; it != allocateRegs.rend(); ++it)
    {
        // 获取当前元素
        int first = *it;
        ++it; // 移动到下一个元素

        // 检查是否有下一个元素
        if (it != allocateRegs.rend())
        {
            int second = *it;
            as_list.push_back(AS_Ldp(new AS_reg(AS_type::Xn, second), new AS_reg(AS_type::Xn, first), sp, 2 * INT_LENGTH));
        }
        else
        {
            assert(0);
            break;
        }
    }
}
void getCalls(AS_reg *&op_reg, AS_operand *as_operand, list<AS_stm *> &as_list)
{
    op_reg = new AS_reg(AS_type::Xn, Temp_newtemp_int()->num);
    // ToDo:一个工具函数，应该实现将局部变量（这里应该只会出现数组、结构体地址）、全局变量、临时变量加载到目标op_reg等待使用
    switch (as_operand->kind)
    {
    case OperandKind::TEMP:
    {
        AS_address *addr = fpOffset[as_operand->u.TEMP->num];
        if (addr)
            as_list.push_back(AS_Binop(AS_binopkind::ADD_, new AS_reg(AS_type::Xn, XnFP), new AS_reg(AS_type::IMM, addr->imm), op_reg));
        else
            as_list.push_back(AS_Mov(new AS_reg(AS_type::Xn, as_operand->u.TEMP->num), op_reg));
    }
    break;
    case OperandKind::NAME:
        as_list.push_back(AS_Adr(new AS_label(as_operand->u.NAME->name->name), op_reg));
        // as_list.push_back(AS_Ldr(op_reg, new AS_reg(AS_type::ADR, new AS_address(op_reg, 0))));
        break;
    case OperandKind::ICONST:
        as_list.push_back(AS_Mov(new AS_reg(AS_type::IMM, as_operand->u.ICONST), op_reg));
        break;
    default:
        assert(0);
        break;
    }
}
void llvm2asmVoidCall(list<AS_stm *> &as_list, L_stm *call)
{

    for (int i = 0; i < 8 && i < call->u.VOID_CALL->args.size(); i++)
    {
        AS_reg *param;
        getCalls(param, call->u.VOID_CALL->args[i], as_list);
        as_list.emplace_back(AS_Mov(param, new AS_reg(AS_type::Xn, paramRegs[i])));
    }
    vector<AS_reg *> abcd;
    for (int i = 8; i < call->u.VOID_CALL->args.size(); i++)
    {
        printf("没有这个测试用例，不用这种情况考虑。");
        assert(0);
    }
    save_register(as_list);
    as_list.push_back(AS_Mov(sp, new AS_reg(AS_type::Xn, XnFP)));
    as_list.emplace_back(AS_Bl(new AS_label(call->u.VOID_CALL->fun)));
    free_frame(as_list);
    load_register(as_list);
}
void llvm2asmCall(list<AS_stm *> &as_list, L_stm *call)
{
    for (int i = 0; i < 8 && i < call->u.CALL->args.size(); i++)
    {
        AS_reg *param;
        getCalls(param, call->u.CALL->args[i], as_list);

        as_list.emplace_back(AS_Mov(param, new AS_reg(AS_type::Xn, paramRegs[i])));
    }
    if (call->u.CALL->args.size() > 8)
    {
        as_list.push_back(AS_Mov(sp, new AS_reg(AS_type::Xn, XXna)));
        int sub = save_register(as_list);
        as_list.push_back(AS_Mov(new AS_reg(AS_type::Xn, XXna), sp));

        int param_sub = 0;
        for (int i = call->u.CALL->args.size() - 1; i >= 8; i--)
        {
            AS_reg *param;
            getCalls(param, call->u.CALL->args[i], as_list);
            param_sub += INT_LENGTH;
            if (-sub - param_sub < -256)
            {
                auto temp = new AS_reg(AS_type::Xn, XXnb);
                as_list.emplace_back(AS_Mov(new AS_reg(AS_type::IMM, -sub - param_sub), temp));

                as_list.emplace_back(AS_Str(param, new AS_reg(AS_type::ADR, new AS_address(sp, temp))));
            }
            else
            {
                as_list.emplace_back(AS_Str(param, new AS_reg(AS_type::ADR, new AS_address(sp, -sub - param_sub))));
            }
        }
        as_list.emplace_back(AS_Binop(AS_binopkind::SUB_, sp, new AS_reg(AS_type::IMM, sub + param_sub), sp));
    }
    else
    {
        save_register(as_list);
    }
    as_list.push_back(AS_Mov(sp, new AS_reg(AS_type::Xn, XnFP)));

    as_list.emplace_back(AS_Bl(new AS_label(call->u.CALL->fun)));
    if (call->u.CALL->args.size() > 8)
    {
        as_list.emplace_back(AS_Binop(AS_binopkind::ADD_, sp, new AS_reg(AS_type::IMM, (call->u.CALL->args.size() - 8) * INT_LENGTH), sp));
    }
    free_frame(as_list);
    load_register(as_list);
    as_list.emplace_back(AS_Mov(new AS_reg(AS_type::Xn, XXnret), new AS_reg(AS_type::Xn, call->u.CALL->res->u.TEMP->num)));
}

void allocReg(list<AS_stm *> &as_list, L_func &func)
{
    list<InstructionNode *> liveness;

    forwardLivenessAnalysis(liveness, as_list);

    livenessAnalysis(liveness, as_list);
}
struct BLOCKPHI
{
    string label;
    L_stm *phi;
    BLOCKPHI(string _label, L_stm *_phi) : label(_label), phi(_phi) {}
};

AS_func *llvm2asmFunc(L_func &func)
{
    list<AS_stm *> stms;
    list<BLOCKPHI *> phi;
    unordered_map<string, list<AS_stm *>::iterator> block_map;
    auto p = new AS_func(stms);
    auto func_label = new AS_label(func.name);
    p->stms.push_back(AS_Label(func_label));
    for (auto &x : fpOffset)
    {
        std::ostringstream oss;
        oss << x.first << ":" << printAS_add(x.second).c_str() << endl;
        p->stms.push_back(AS_Llvmir(oss.str()));
    }
    AS_reg *new_reg = fuckImm(p->stms, stack_frame);
    p->stms.push_back(AS_Binop(AS_binopkind::SUB_, new AS_reg(AS_type::SP, -1), new_reg, new AS_reg(AS_type::SP, -1)));
    string temp_label = "";
    for (const auto &block : func.blocks)
    {
        for (const auto &instr : block->instrs)
        {
            std::ostringstream oss;
            printL_stm(oss, instr);
            p->stms.push_back(AS_Llvmir(oss.str()));
            llvm2asmStm(p->stms, *instr, func);
            if (instr->type == L_StmKind::T_PHI)
            {
                phi.push_back(new BLOCKPHI(temp_label, instr));
            }
            if (instr->type == L_StmKind::T_LABEL)
            {
                temp_label = instr->u.LABEL->label->name;
            }
            if (temp_label.length() > 0)
            {
                block_map[temp_label] = --p->stms.end();
            }
        }
    }
    // ToDo:处理PHI语句
    for (auto &x : phi)
    {
        L_phi *phi = x->phi->u.PHI;
        // string label = x->label;
        // auto it = block_map.find(label);
        // if (it == block_map.end())
        //     assert(0);
        // // assert(it != )
        // // p->stms.insert(it->second, new AS_label(label));
        // auto block = it->second;
        assert(phi->dst->kind == OperandKind::TEMP);
        int dst_mum = phi->dst->u.TEMP->num;
        for (auto it = phi->phis.begin(); it != phi->phis.end(); ++it)
        {
            AS_operand *operand = (*it).first;
            assert(operand->kind == OperandKind::TEMP);
            Temp_label *temp_label = (*it).second;
            auto insert_it = block_map[temp_label->name];
            while (insert_it != p->stms.begin() && ((*insert_it)->type == AS_stmkind::B ||
                                                    (*insert_it)->type == AS_stmkind::BCOND ||
                                                    (*insert_it)->type == AS_stmkind::RETT))
                insert_it--;

            p->stms.insert(insert_it, AS_Mov(new AS_reg(AS_type::Xn, operand->u.TEMP->num), new AS_reg(AS_type::Xn, dst_mum)));
        }
    }

    allocReg(p->stms, func);
    return p;
}

void llvm2asmDecl(vector<AS_decl *> &decls, L_def &def)
{
    switch (def.kind)
    {
    case L_DefKind::GLOBAL:
    {
        return;
    }
    case L_DefKind::FUNC:
    {
        AS_decl *decl = new AS_decl(def.u.FUNC->name);
        decls.push_back(decl);
        break;
    }
    case L_DefKind::SRT:
    {
        return;
    }
    }
}

void llvm2asmGlobal(vector<AS_global *> &globals, L_def &def)
{
    switch (def.kind)
    {
    case L_DefKind::GLOBAL:
    {
        // ToDo
        switch (def.u.GLOBAL->def.kind)
        {
        case TempType::STRUCT_TEMP:
        {
            StructDef *layout = structLayout[def.u.GLOBAL->def.structname];
            assert(layout);
            // int init = 0;
            // for (int i = 0; i < def.u.GLOBAL->init.size(); i++)
            // {
            // init = init * (1 << layout->offset[i]) + def.u.GLOBAL->init[i];
            // globals.push_back(new AS_global(new AS_label(def.u.GLOBAL->name), def.u.GLOBAL->init[i], INT_LENGTH));
            // }
            globals.push_back(new AS_global(new AS_label(def.u.GLOBAL->name), 0, layout->size));
            // cout << layout->size << endl;
        }
        break;
        case TempType::INT_TEMP:
        {
            int init = 0;
            if (def.u.GLOBAL->init.size() == 1)
                init = def.u.GLOBAL->init[0];
            else if (def.u.GLOBAL->init.size() > 1)
                assert(0);
            globals.push_back(new AS_global(new AS_label(def.u.GLOBAL->name), init, 1));
        }
        break;
        case TempType::STRUCT_PTR:
        {
            StructDef *layout = structLayout[def.u.GLOBAL->def.structname];
            assert(layout);
            globals.push_back(new AS_global(new AS_label(def.u.GLOBAL->name), 0, def.u.GLOBAL->def.len * layout->size));
        }
        break;
        case TempType::INT_PTR:
        {
            assert(def.u.GLOBAL->init.size() == 0);
            globals.push_back(new AS_global(new AS_label(def.u.GLOBAL->name), 0, INT_LENGTH * def.u.GLOBAL->def.len));
        }
        break;
        default:
            assert(0);
            // assert(def.kind == L_DefKind::GLOBAL);
            // assert(def.u.GLOBAL);
            // assert(def.u.GLOBAL->init.size() == 0);
            // assert(def.u.GLOBAL->init[0]);
            // globals.push_back(new AS_global(new AS_label(def.u.GLOBAL->name), 0, INT_LENGTH));
            break;
        }
        break;
    }
    case L_DefKind::FUNC:
    {
        return;
    }
    case L_DefKind::SRT:
    {
        return;
    }
    }
}

AS_prog *llvm2asm(L_prog &prog)
{
    std::vector<AS_global *> globals;
    std::vector<AS_decl *> decls;
    std::vector<AS_func *> func_list;

    auto as_prog = new AS_prog(globals, decls, func_list);

    structLayoutInit(prog.defs);

    // translate function decl
    for (const auto &def : prog.defs)
    {
        llvm2asmDecl(as_prog->decls, *def);
    }

    for (const auto &func : prog.funcs)
    {
        AS_decl *decl = new AS_decl(func->name);
        as_prog->decls.push_back(decl);
    }

    // translate global data
    for (const auto &def : prog.defs)
    {
        llvm2asmGlobal(as_prog->globals, *def);
    }

    // translate each llvm function

    for (const auto &func : prog.funcs)
    {
        alloc_frame = false;

        set_stack(*func);

        as_prog->funcs.push_back(llvm2asmFunc(*func));

        fpOffset.clear();
    }

    return as_prog;
}
