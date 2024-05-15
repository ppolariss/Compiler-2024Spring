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
        clear_bb(fun);
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
    unordered_map<AS_operand *, AS_operand *> alloca_map;

    for (auto &block : fun->blocks)
    {
        list<LLVMIR::L_stm *> new_list;
        for (auto &stm : block->instrs)
        {
            switch (stm->type)
            {
            case L_StmKind::T_ALLOCA:
            {
                if (is_mem_variable(stm))
                {
                    auto var = stm->u.ALLOCA->dst;
                    auto zero = AS_Operand_Temp(Temp_newtemp_int());
                    // AS_Operand_Const(0);
                    alloca_map[var] = zero;
                    new_list.push_back(L_Move(AS_Operand_Const(0), zero));
                    // new_list.push_back(L_Move(zero, var));
                    continue;
                }
            }
            break;
            case L_StmKind::T_LOAD:
            {
                if (stm->u.LOAD->ptr->kind == OperandKind::TEMP)
                {
                    assert(stm->u.LOAD->dst->kind == OperandKind::TEMP);
                    assert(stm->u.LOAD->ptr->kind == OperandKind::TEMP);
                    assert(stm->u.LOAD->ptr->u.TEMP->type == TempType::INT_PTR);
                    assert(stm->u.LOAD->ptr->u.TEMP->len == 0);
                    auto var = alloca_map[stm->u.LOAD->ptr];
                    // assert(var);
                    if (var)
                    {
                        alloca_map[stm->u.LOAD->dst] = var;
                        continue;
                    }
                }
            }
            break;
            case L_StmKind::T_STORE:
            {
                if (stm->u.STORE->ptr->kind == OperandKind::TEMP)
                {
                    assert(stm->u.STORE->ptr->u.TEMP->type == TempType::INT_PTR);
                    assert(stm->u.STORE->ptr->u.TEMP->len == 0);
                    auto ptr_operand = alloca_map[stm->u.STORE->ptr];
                    // assert(ptr_operand);
                    if (ptr_operand)
                    {
                        auto src = alloca_map[stm->u.STORE->src];
                        if (src == nullptr)
                            new_list.push_back(L_Move(stm->u.STORE->src, ptr_operand));
                        else
                            new_list.push_back(L_Move(src, ptr_operand));
                        continue;
                    }
                }
            }
            break;
            default:
                break;
            }

            auto list = get_all_AS_operand(stm);
            for (auto AS_op : list)
            {
                if ((*AS_op)->kind == OperandKind::TEMP && (*AS_op)->u.TEMP->type == TempType::INT_TEMP)
                {
                    if (alloca_map.find(*AS_op) != alloca_map.end())
                    {
                        *AS_op = alloca_map[*AS_op];
                    }
                }
            }
            new_list.push_back(stm);
        }
        block->instrs = new_list;
    }
}

static void compute_reverse_graph(GRAPH::Graph<LLVMIR::L_block *> bg)
{
    for (auto node : bg.mynodes)
        revers_graph[node.second->info] = node.second;
}

void Dominators(GRAPH::Graph<LLVMIR::L_block *> &bg)
{
    compute_reverse_graph(bg);
    int size = bg.nodecount;
    // assert(bg.nodecount == bg.mynodes.size());
    if (size > 1000)
        assert(0);
    // revers_graph
    list<GRAPH::Node<LLVMIR::L_block *> *> ord = DFS(bg.mynodes[0], bg);

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
            bitset<bitN> temp;
            if (node->pred()->size())
            {
                for (int i = 0; i < size; i++)
                {
                    temp[i] = true;
                }
                for (auto i : *node->pred())
                {
                    temp &= dom[i];
                }
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
    // for (int i = 0; i <= size; i++)
    for (auto i_node : bg.mynodes)
    {
        int i = i_node.first;
        // for (int j = 0; j <= size; j++)
        for (auto j_node : bg.mynodes)
        {
            int j = j_node.first;
            if (dom[i][j])
            {
                assert(bg.mynodes[i]);
                assert(bg.mynodes[j]);
                assert(bg.mynodes[j]->info);
                assert(bg.mynodes[i]->info);
                if (!dominators.count(bg.mynodes[i]->info))
                    dominators[bg.mynodes[i]->info] = unordered_set<L_block *>();
                dominators[bg.mynodes[i]->info].insert(bg.mynodes[j]->info);
                dominators_int[i].push_back(j);
            }
        }
    }
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
            if (tmp.count() == 1 && dom[u][v])
            {
                idom[u] = v;
                break;
            }
        }
    }
    for (int u = 1; u < size; ++u)
    {
        if (!bg.mynodes[u])
            continue;
        int v = idom[u];
        if (!bg.mynodes[v])
            continue;
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

static list<AS_operand **> get_def_int_operand(LLVMIR::L_stm *stm)
{
    list<AS_operand **> ret1 = get_def_operand(stm), ret2;
    for (auto AS_op : ret1)
    {
        assert((**AS_op).kind == OperandKind::TEMP);
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
        if ((**AS_op).kind != OperandKind::TEMP)
            continue;
        // assert((**AS_op).kind == OperandKind::TEMP);
        if ((**AS_op).u.TEMP->type == TempType::INT_TEMP)
        {
            ret2.push_back(AS_op);
        }
    }
    return ret2;
}

unordered_map<AS_operand *, unordered_set<GRAPH::Node<LLVMIR::L_block *> *>> def_sites;

// 只对标量做
void Place_phi_fu(GRAPH::Graph<LLVMIR::L_block *> &bg, L_func *fun)
{
    //   Todo
    unordered_map<GRAPH::Node<LLVMIR::L_block *> *, unordered_set<AS_operand *>> A_orig;
    // calculate def_sites and A_orig
    for (auto &block : fun->blocks)
    {
        unordered_set<AS_operand *> temp;
        auto node = revers_graph[block];
        assert(node);
        for (auto &stm : block->instrs)
        {
            auto def_operand = get_def_int_operand(stm);
            for (auto def : def_operand)
            {
                if ((*def)->kind == OperandKind::TEMP)
                {
                    def_sites[*def].insert(node);
                    temp.insert(*def);
                }
            }
        }
        A_orig[node] = temp;
    }

    unordered_map<GRAPH::Node<LLVMIR::L_block *> *, unordered_set<AS_operand *>> A_phi;
    for (auto def_site : def_sites)
    {
        AS_operand *a = def_site.first;
        auto w = def_site.second;
        while (!w.empty())
        {
            auto n = *w.begin();
            w.erase(w.begin());
            // if (A_phi.find(n) == A_phi.end())
            //     A_phi[n] = unordered_set<AS_operand *>();
            for (auto y : DF_array[n->info])
            {
                auto y_node = revers_graph[y];
                assert(a->kind == OperandKind::TEMP);
                auto in = FG_In(y_node);
                if (in.find(a->u.TEMP) == in.end())
                    continue;
                if (A_phi[y_node].find(a) == A_phi[y_node].end())
                {
                    std::vector<std::pair<AS_operand *, Temp_label *>> phis;
                    for (int z : *y_node->pred())
                    {
                        if (!bg.mynodes[z] || !bg.mynodes[z]->info)
                            continue;
                        // assert(bg.mynodes[z]);
                        auto label = bg.mynodes[z]->info->label;
                        phis.push_back(make_pair(a, label));
                    }
                    y->instrs.insert(++y->instrs.begin(), L_Phi(a, phis));
                    // y->instrs.push_front(L_Phi(a, phis));
                    A_phi[y_node].insert(a);
                    // auto debug = A_orig[y_node];
                    if (A_orig[y_node].find(a) == A_orig[y_node].end())
                    {
                        w.insert(revers_graph[y]);
                    }
                }
            }
        }
    }
}

// unordered_map<AS_operand *, int> AScount;
// unordered_map<Temp_temp *, stack<Temp_temp *>> &Stack
static void Rename_temp(GRAPH::Graph<LLVMIR::L_block *> &bg, GRAPH::Node<LLVMIR::L_block *> *n, unordered_map<Temp_temp *, stack<Temp_temp *>> &Stack)
{
    unordered_map<L_stm *, list<AS_operand **>> def_operand_map;
    // vector<Temp_temp *> push_temp;
    unordered_map<Temp_temp *, int> push_times;
    //   Todo
    for (auto &stm : n->info->instrs)
    {
        if (stm->type != L_StmKind::T_PHI)
        {
            auto use_operand = get_use_int_operand(stm);
            for (auto use_x : use_operand)
            {
                // assert(Stack[(*use_x)->u.TEMP].size());
                if (Stack[(*use_x)->u.TEMP].size())
                {
                    auto top = Stack[(*use_x)->u.TEMP].top();
                    assert(top);
                    *use_x = AS_Operand_Temp(top);
                }
            }
        }
        auto def_operand = get_def_int_operand(stm);
        for (auto def_x : def_operand)
        {
            push_times[(*def_x)->u.TEMP]++;
            // push_temp.push_back((*def_x)->u.TEMP);
            // AScount[*def_x]++;
            auto i = Temp_newtemp_int();
            Stack[(*def_x)->u.TEMP].push(i);
            *def_x = AS_Operand_Temp(i);
        }
    }

    for (auto succ : *n->succ())
    {
        int order = 0;
        for (auto pred : *bg.mynodes[succ]->pred())
        {
            if (pred == n->mykey)
                break;
            order++;
        }
        for (auto &stm : bg.mynodes[succ]->info->instrs)
        {
            if (stm->type == L_StmKind::T_PHI)
            {
                auto phi = stm->u.PHI->phis[order];
                stm->u.PHI->phis[order] = make_pair(AS_Operand_Temp(Stack[phi.first->u.TEMP].top()), phi.second);
            }
            else if (stm->type == L_StmKind::T_LABEL)
                continue;
            else
                break;
        }
        // for (auto &stm : bg.mynodes[succ]->info->instrs)
        // {
        //     if (stm->type == L_StmKind::T_PHI)
        //     {
        //         auto temp = stm->u.PHI->phis;
        //         for (int i = 0; i < temp.size(); i++)
        //         {
        //             auto phi = temp[i];
        //             auto j = phi.second;
        //             if (j->name == n->info->label->name)
        //             {
        //                 auto as_temp = Stack[phi.first->u.TEMP].top();
        //                 // phi.first->u.TEMP = as_temp;
        //                 stm->u.PHI->phis[i] = make_pair(AS_Operand_Temp(as_temp), j);
        //                 break;
        //             }
        //         }
        //     }
        // }
    }

    for (auto son : tree_dominators[n->info].succs)
        Rename_temp(bg, revers_graph[son], Stack);

    // for (auto m : push_temp)
    // {
    //     Stack[m].pop();
    // }
    for (auto m : push_times)
    {
        for (int i = 0; i < m.second; i++)
        {
            Stack[m.first].pop();
        }
    }
}

void Rename(GRAPH::Graph<LLVMIR::L_block *> &bg)
{
    unordered_map<Temp_temp *, stack<Temp_temp *>> ASstack;
    //   Todo
    // for (auto arg : fun->args)
    // {
    //     assert(arg);
    //     ASstack[arg].push(arg);
    // }
    for (auto def_site : def_sites)
    {
        if (def_site.first->kind != OperandKind::TEMP)
            continue;
        auto temp = def_site.first->u.TEMP;
        assert(temp);
        // ASstack[temp] = stack<Temp_temp *>();
        // AScount[def_site.first] = 0;
        ASstack[temp].push(temp);
    }
    Rename_temp(bg, bg.mynodes[0], ASstack);
}