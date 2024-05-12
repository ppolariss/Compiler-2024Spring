#include "ssa.h"
#include <cassert>
#include <iostream>
#include <list>
#include <stack>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>
#include <bitset>
#include "bg_llvm.h"
#include "graph.hpp"
#include "liveness.h"
#include "printLLVM.h"

using namespace std;
using namespace LLVMIR;
using namespace GRAPH;
struct imm_Dominator
{
    LLVMIR::L_block *pred;
    unordered_set<LLVMIR::L_block *> succs;
};

const int bitN = 1000;
bitset<bitN> dom[bitN];
unordered_map<int, vector<int>> dominators_int;
unordered_map<L_block *, unordered_set<L_block *>> dominators;
unordered_map<L_block *, imm_Dominator> tree_dominators;
unordered_map<L_block *, unordered_set<L_block *>> DF_array;
unordered_map<L_block *, Node<LLVMIR::L_block *> *> revers_graph;
unordered_map<Temp_temp *, AS_operand *> temp2ASoper;

static void init_table()
{
    dominators.clear();
    tree_dominators.clear();
    DF_array.clear();
    revers_graph.clear();
    temp2ASoper.clear();
}

LLVMIR::L_prog *SSA(LLVMIR::L_prog *prog)
{
    for (auto &fun : prog->funcs)
    {
        // cout << fun->name << endl;
        // continue;
        init_table();
        combine_addr(fun);
        mem2reg(fun);
        auto RA_bg = Create_bg(fun->blocks);
        SingleSourceGraph(RA_bg.mynodes[0], RA_bg, fun);
        // Show_graph(stdout,RA_bg);
        Liveness(RA_bg.mynodes[0], RA_bg, fun->args);
        // Show_Liveness(stdout, RA_bg);
        Dominators(RA_bg);
        // printf_domi();
        tree_Dominators(RA_bg);
        // printf_D_tree();
        // 默认0是入口block
        computeDF(RA_bg, RA_bg.mynodes[0]);
        // printf_DF();
        Place_phi_fu(RA_bg, fun);
        Rename(RA_bg);
        combine_addr(fun);
    }
    return prog;
}

static bool is_mem_variable(L_stm *stm)
{
    return stm->type == L_StmKind::T_ALLOCA && stm->u.ALLOCA->dst->kind == OperandKind::TEMP && stm->u.ALLOCA->dst->u.TEMP->type == TempType::INT_PTR && stm->u.ALLOCA->dst->u.TEMP->len == 0;
}

// 保证相同的AS_operand,地址一样 。常量除外
void combine_addr(LLVMIR::L_func *fun)
{
    unordered_map<Temp_temp *, unordered_set<AS_operand **>> temp_set;
    unordered_map<Name_name *, unordered_set<AS_operand **>> name_set;
    for (auto &block : fun->blocks)
    {
        for (auto &stm : block->instrs)
        {
            auto AS_operand_list = get_all_AS_operand(stm);
            for (auto AS_op : AS_operand_list)
            {
                if ((*AS_op)->kind == OperandKind::TEMP)
                {
                    temp_set[(*AS_op)->u.TEMP].insert(AS_op);
                }
                else if ((*AS_op)->kind == OperandKind::NAME)
                {
                    name_set[(*AS_op)->u.NAME].insert(AS_op);
                }
            }
        }
    }
    for (auto temp : temp_set)
    {
        AS_operand *fi_AS_op = **temp.second.begin();
        for (auto AS_op : temp.second)
        {
            *AS_op = fi_AS_op;
        }
    }
    for (auto name : name_set)
    {
        AS_operand *fi_AS_op = **name.second.begin();
        for (auto AS_op : name.second)
        {
            *AS_op = fi_AS_op;
        }
    }
}

void mem2reg(LLVMIR::L_func *fun)
{
    for (auto &block : fun->blocks)
    {
        for (auto &stm : block->instrs)
        {
            if (is_mem_variable(stm))
            {
                auto temp = stm->u.ALLOCA->dst->u.TEMP;
                // auto AS_op = temp2ASoper[temp];
                // if (AS_op == nullptr)
                auto var = AS_Operand_Temp(temp);
                auto zero = AS_Operand_Const(0);
                // auto var_ptr  = &var;
                // var_ptr = &zero;
                temp2ASoper[temp] = zero;
                // ),AS_op
                stm = L_Move(zero, var);
            }
            // else
            // {
            //     auto list = get_def_operand(stm);
            //     for (auto AS_op : list)
            //     {
            //         auto temp = (*AS_op)->u.TEMP;
            //         if (temp2ASoper[temp] == nullptr)
            //         {
            //             temp2ASoper[temp] = AS_Operand_Temp(temp);
            //         }
            //         *AS_op = temp2ASoper[temp];
            //     }
            // }
        }
    }

    for (auto &block : fun->blocks)
    {
        // block->instrs.remove_if([](L_stm *stm)
        //                         { return stm->type == L_StmKind::T_LOAD; });
        //  || stm->type == L_StmKind::T_STORE;
        for (auto it = block->instrs.begin(); it != block->instrs.end();)
        {
            if ((*it)->type == L_StmKind::T_LOAD && (*it)->u.LOAD->ptr->kind == OperandKind::TEMP)
            {
                auto ptr_operand = temp2ASoper[(*it)->u.LOAD->ptr->u.TEMP];
                if (ptr_operand)
                {
                    // *it = L_Move(ptr_operand, (*it)->u.LOAD->dst);
                    it = block->instrs.erase(it);
                    continue;
                }
            }
            if ((*it)->type == L_StmKind::T_STORE && (*it)->u.STORE->ptr->kind == OperandKind::TEMP)
            {
                auto store = (*it)->u.STORE;
                if (store->src->kind == OperandKind::ICONST)
                {
                    auto const_operand = store->src;
                    auto ptr_operand = temp2ASoper[store->ptr->u.TEMP];
                    if (ptr_operand)
                    {
                        *it = L_Move(const_operand, store->ptr);
                    }
                }
                else if (store->src->kind == OperandKind::TEMP)
                {
                    auto ptr_operand = temp2ASoper[store->ptr->u.TEMP];
                    if (ptr_operand)
                    {
                        *it = L_Move(store->src, store->ptr);
                    }
                }
                else if (store->src->kind == OperandKind::NAME)
                {
                    auto ptr_operand = temp2ASoper[store->ptr->u.TEMP];
                    if (ptr_operand)
                    {
                        *it = L_Move(store->src, store->ptr);
                    }
                }
            }
            it++;
        }
        // if (stm->type == L_StmKind::T_STORE)
        // {
        //     if (stm->u.STORE->src->kind == OperandKind::ICONST)
        //     {
        //         auto const_operand = stm->u.STORE->src;
        //         // temp2ASoper[stm->u.STORE->ptr->u.TEMP] = const_operand;
        //         stm = L_Move(const_operand, stm->u.STORE->ptr);
        //         // block->instrs.remove(stm);
        //     }
        //     else if (stm->u.STORE->src->kind == OperandKind::TEMP)
        //     {
        //         if (stm->u.STORE->ptr->kind == OperandKind::TEMP)
        //         {
        //             // temp2ASoper[stm->u.STORE->ptr->u.TEMP] = stm->u.STORE->src;
        //             auto ptr_operand = temp2ASoper[stm->u.STORE->ptr->u.TEMP];
        //             if (ptr_operand)
        //                 stm = L_Move(stm->u.STORE->src, stm->u.STORE->ptr);
        //         }
        //     }
        //     else if (stm->u.STORE->src->kind == OperandKind::NAME)
        //     {
        //         if (stm->u.STORE->ptr->kind == OperandKind::TEMP)
        //         {
        //             // temp2ASoper[stm->u.STORE->ptr->u.TEMP] = stm->u.STORE->src;
        //             auto ptr_operand = temp2ASoper[stm->u.STORE->ptr->u.TEMP];
        //             if (ptr_operand)
        //                 stm = L_Move(stm->u.STORE->src, stm->u.STORE->ptr);
        //         }
        //     }
        // }
    }
    //   Todo
}

void Dominators(GRAPH::Graph<LLVMIR::L_block *> &bg)
{
    // compute reverse graph
    for (auto node : bg.mynodes)
        revers_graph[node.second->info] = node.second;

    int size = bg.nodecount;
    // revers_graph
    list<GRAPH::Node<LLVMIR::L_block *> *> ord = DFS(bg.mynodes[0], bg);
    // unordered_map<int, vector<int>> pre;
    // bool flag = true;
    // while (flag)
    // {
    //     flag = false;
    //     for (auto node : ord)
    //     {
    //         vector<int> p;
    //         for (auto i : *node->pred())
    //         {
    //             p.push_back(i);
    //         }
    //         // while()
    //     }
    // }

    bool flag = true;
    for (int i = 0; i < size; i++)
    {
        for (int j = 0; j < size; j++)
        {
            dom[i][j] = true;
        }
    }
    // cout << bg.mynodes[0]->info->label->name << endl;
    while (flag)
    {
        flag = false;
        for (auto node : ord)
        {
            // if (node->info->label->name == "bb27")
            // {
            //     for (auto i : *node->pred())
            //     {
            //         cout << bg.mynodes[i]->info->label->name << " ";
            //         cout << dom[bg.mynodes[i]->mykey] << endl;
            //     }
            //     // cout << dom[node->mykey] << endl;
            // }
            bitset<bitN> temp;
            if (node->pred()->size())
                for (int i = 0; i < size; i++)
                {
                    temp[i] = true;
                }
            for (auto i : *node->pred())
            {
                temp &= dom[i];
            }
            temp[node->mykey] = true;
            if (temp != dom[node->mykey])
            {
                dom[node->mykey] = temp;
                flag = true;
            }
        }
        // flag = false;
        // for (int u : ord)
        // {
        //     std::bitset<N> tmp;
        //     tmp[u] = true;
        //     for (int v : pre[u])
        //     {
        //         tmp &= dom[v];
        //     }
        //     if (tmp != dom[u])
        //     {
        //         dom[u] = tmp;
        //         flag = true;
        //     }
        // }
    }
    for (int i = 0; i < size; i++)
    {
        // cout << dom[i] << endl;
        for (int j = 0; j < size; j++)
        {
            if (dom[i][j])
            {
                dominators[bg.mynodes[i]->info].insert(bg.mynodes[j]->info);
                dominators_int[i].push_back(j);
            }
        }
    }
    // for (auto dom : dominators)
    // {
    //     cout << dom.first->label->name << endl;
    //     for (auto dom2 : dom.second)
    //     {
    //         cout << dom2->label->name << " ";
    //     }
    //     cout << endl;
    // }
    //   Todo
}

void printf_domi()
{
    printf("Dominator:\n");
    for (auto x : dominators)
    {
        printf("%s :\n", x.first->label->name.c_str());
        for (auto t : x.second)
        {
            printf("%s ", t->label->name.c_str());
        }
        printf("\n\n");
    }
}

void printf_D_tree()
{
    printf("dominator tree:\n");
    for (auto x : tree_dominators)
    {
        printf("%s :\n", x.first->label->name.c_str());
        for (auto t : x.second.succs)
        {
            printf("%s ", t->label->name.c_str());
        }
        printf("\n\n");
    }
}
void printf_DF()
{
    printf("DF:\n");
    for (auto x : DF_array)
    {
        printf("%s :\n", x.first->label->name.c_str());
        for (auto t : x.second)
        {
            printf("%s ", t->label->name.c_str());
        }
        printf("\n\n");
    }
}

void tree_Dominators(GRAPH::Graph<LLVMIR::L_block *> &bg)
{
    int size = bg.nodecount;
    for (auto node : bg.mynodes)
    {
        // revers_graph[node.second->info] = node.second;
        tree_dominators[node.second->info].pred = nullptr;
        tree_dominators[node.second->info].succs = unordered_set<L_block *>();
    }
    vector<int> idom(size, 0);

    for (int u = 1; u < size; ++u)
    {
        for (auto v : dominators_int[u])
        {
            std::bitset<bitN> tmp = (dom[v] & dom[u]) ^ dom[u];
            if (tmp.count() == 1 and tmp[u])
            {
                idom[u] = v;
                break;
            }
        }
    }
    for (int u = 1; u < size; ++u)
    {
        int v = idom[u];
        tree_dominators[bg.mynodes[v]->info].succs.insert(bg.mynodes[u]->info);
        tree_dominators[bg.mynodes[u]->info].pred = bg.mynodes[v]->info;
        // e[idom[u]].push_back(u);
    }

    //   Todo
    // for (auto node : bg.mynodes)
    // {
    //     tree_dominators[node.second->info].pred = bg.mynodes[node.second->info->preds[0]]->info;
    //     tree_dominators[node.second->info].succs = dominators[node.second->info];
    // }

    // for (auto i : tree_dominators)
    // {
    //     cout << i.first->label->name << " ";
    //     cout << "pred:";
    //     if (i.second.pred)
    //         cout << i.second.pred->label->name << " ";
    //     cout << endl
    //          << "succs:";
    //     for (auto j : i.second.succs)
    //     {
    //         cout << j->label->name << " ";
    //     }
    //     cout << endl;
    // }
}

void computeDF(GRAPH::Graph<LLVMIR::L_block *> &bg, GRAPH::Node<LLVMIR::L_block *> *r)
{
    //   Todo
    // for (auto node : bg.mynodes)
    auto DF = unordered_set<L_block *>();
    // DF local
    for (auto succ : *r->succ())
    {
        auto succNode = bg.mynodes[succ];
        // succNode == r ||
        if (dominators[succNode->info].find(r->info) == dominators[succNode->info].end())
        {
            DF.insert(succNode->info);
        }
    }
    // for(auto succ : tree_dominators[node.second->info].succs)
    // {
    //     if(tree_dominators[succ].pred != node.second->info)
    //     {
    //         DF.insert(succ);
    //     }
    // }
    // DF up
    for (auto child : tree_dominators[r->info].succs)
    {
        if (DF_array.find(child) == DF_array.end())
        {
            computeDF(bg, revers_graph[child]);
        }
        for (auto child_up : DF_array[child])
        {
            // 严格必经节点不在n的直接必经节点中
            // child_up中，child 直接必经节点 不是 child_up 严格必经节点
            unordered_set<L_block *> strictlyNecessaryNode = dominators[child_up];
            strictlyNecessaryNode.erase(child_up);
            L_block *directlyNecessaryNode = tree_dominators[child].pred;
            if (strictlyNecessaryNode.find(directlyNecessaryNode) == strictlyNecessaryNode.end())
                DF.insert(child_up);
            // tree_dominators[child].succs;
            // if (r->info->label->name == "bb27")
            // {
            //     cout << "bb27" << endl;
            //     cout << "strictlyNecessaryNode: ";
            //     for (auto i : strictlyNecessaryNode)
            //     {
            //         cout << i->label->name << " ";
            //     }
            //     cout << "directlyNecessaryNode: ";
            //     for (auto i : directlyNecessaryNode)
            //     {
            //         cout << i->label->name << " ";
            //     }
            // }
            // auto intersection = set_intersection(directlyNecessaryNode, strictlyNecessaryNode);
            // // ) || (intersection.size() == 1 && intersection.find(child) != intersection.end())
            // if (intersection.empty())
        }
    }
    DF_array[r->info] = DF;
}

template <typename T>
unordered_set<T> set_intersection(unordered_set<T> &a, unordered_set<T> &b)
{
    unordered_set<T> ret;
    for (auto i : a)
    {
        if (b.find(i) != b.end())
        {
            ret.insert(i);
        }
    }
    return ret;
}

template <typename T>
unordered_set<T> set_intersection(T &a, unordered_set<T> &b)
{
    unordered_set<T> ret;
    if (b.find(a) != b.end())
    {
        ret.insert(a);
    }
    return ret;
}

// 只对标量做
void Place_phi_fu(GRAPH::Graph<LLVMIR::L_block *> &bg, L_func *fun)
{
    //   Todo
}

static list<AS_operand **> get_def_int_operand(LLVMIR::L_stm *stm)
{
    list<AS_operand **> ret1 = get_def_operand(stm), ret2;
    for (auto AS_op : ret1)
    {
        if ((**AS_op).u.TEMP->type == TempType::INT_TEMP)
        {
            ret2.push_back(AS_op);
        }
    }
    return ret2;
}

static list<AS_operand **> get_use_int_operand(LLVMIR::L_stm *stm)
{
    list<AS_operand **> ret1 = get_use_operand(stm), ret2;
    for (auto AS_op : ret1)
    {
        if ((**AS_op).u.TEMP->type == TempType::INT_TEMP)
        {
            ret2.push_back(AS_op);
        }
    }
    return ret2;
}

static void Rename_temp(GRAPH::Graph<LLVMIR::L_block *> &bg, GRAPH::Node<LLVMIR::L_block *> *n, unordered_map<Temp_temp *, stack<Temp_temp *>> &Stack)
{
    //   Todo
}

void Rename(GRAPH::Graph<LLVMIR::L_block *> &bg)
{
    //   Todo
}