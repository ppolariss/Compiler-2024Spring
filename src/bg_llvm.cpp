#include "bg_llvm.h"
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <unordered_map>
#include "graph.hpp"
#include "printLLVM.h"
#include "temp.h"
/* graph on AS_ basic blocks. This is useful to find dominance
   relations, etc. */

using namespace std;
using namespace LLVMIR;
using namespace GRAPH;

static Graph<L_block *> RA_bg;
static unordered_map<Temp_label *, L_block *> block_env;

Graph<L_block *> &Bg_graph()
{
    return RA_bg;
}
unordered_map<Temp_label *, L_block *> &Bg_block_env()
{
    return block_env;
}

Node<L_block *> *Look_bg(L_block *b)
{
    Node<L_block *> *n1 = nullptr;
    for (auto n : *RA_bg.nodes())
    {
        if (n.second->nodeInfo() == b)
        {
            n1 = n.second;
            break;
        }
    }
    if (n1 == nullptr)
        return RA_bg.addNode(b);
    else
        return n1;
}

static void Enter_bg(L_block *b1, L_block *b2)
{
    Node<L_block *> *n1 = Look_bg(b1);
    Node<L_block *> *n2 = Look_bg(b2);
    RA_bg.addEdge(n1, n2);
    return;
}

void clear_bb(LLVMIR::L_func *fun)
//   unordered_set<L_block *> &deleted_blocks
{
    // clear bb
    auto blocks = fun->blocks;
    unordered_map<Temp_label *, Temp_label *> block_map;
    unordered_set<L_block *> block_set;
    for (auto &block : blocks)
    {
        if (block->instrs.size() == 2 && block->instrs.back()->type == L_StmKind::T_JUMP)
        {
            block_map[block->label] = block->instrs.back()->u.JUMP->jump;
            block_set.insert(block);
        }
    }
    if (!block_set.size())
        return;

    // for (auto block : block_set)
    //     deleted_blocks.insert(block);
    for (auto m : block_map)
    {
        auto block = m.second;
        while (block_map.find(block) != block_map.end())
        {
            block = block_map[block];
        }
        block_map[m.first] = block;
    }
    // list<L_block *> new_blocks;
    fun->blocks.clear();
    // for (auto block : blocks)
    // {
    //     if (!block && block_set.find(block) == block_set.end())
    //         block_env.insert({block->label, block});
    // }
    for (auto &block : blocks)
    {
        // if(bloc)
        if (block_set.find(block) != block_set.end() && block != blocks.front())
            continue;
        if (!block)
            continue;

        // for (auto stm : block->instrs)
        // {
        auto stm = block->instrs.back();
        if (stm->type == L_StmKind::T_JUMP)
        {
            auto jump_label = stm->u.JUMP->jump;
            if (block_map.find(jump_label) != block_map.end())
            {
                stm->u.JUMP->jump = block_map[jump_label];
                block->succs = *new unordered_set<Temp_label *>;
                block->succs.insert(block_map[jump_label]);
            }
        }
        else if (stm->type == L_StmKind::T_CJUMP)
        {
            block->succs = *new unordered_set<Temp_label *>;
            auto jump_label = stm->u.CJUMP->true_label;
            if (block_map.find(jump_label) != block_map.end())
            {
                stm->u.CJUMP->true_label = block_map[jump_label];
                block->succs.insert(block_map[jump_label]);
            }
            else
                block->succs.insert(jump_label);
            jump_label = stm->u.CJUMP->false_label;
            if (block_map.find(jump_label) != block_map.end())
            {
                stm->u.CJUMP->false_label = block_map[jump_label];
                block->succs.insert(block_map[jump_label]);
            }
            else
                block->succs.insert(jump_label);
        }
        // }
        fun->blocks.push_back(block);
    }
    // fun->blocks = new_blocks;
}

/* input LLVMIR::L_block* *List after instruction selection for each block,
    generate a graph on the basic blocks */

Graph<L_block *> &Create_bg(list<L_block *> &bl)
{
    RA_bg = Graph<L_block *>();
    block_env = unordered_map<Temp_label *, L_block *>();

    // list<L_block *> &bl = fun->blocks;

    // unordered_map<L_block *, Node<LLVMIR::L_block *> *> revers_graph;
    // for (auto node : bg.mynodes)
    //     revers_graph[node.second->info] = node.second;
    // clear_bb(fun, deleted_blocks);
    // for (auto block : deleted_blocks)
    //     deleted_nodes.insert(revers_graph[block]);

    for (auto block : bl)
    {
        if (!block)
            continue;
        block_env.insert({block->label, block});
        RA_bg.addNode(block);
    }

    for (auto block : bl)
    {
        if (!block)
            continue;
        unordered_set<Temp_label *> succs = block->succs;
        for (auto label : succs)
        {
            Enter_bg(block, block_env[label]);
        }
    }
    return RA_bg;
}

static void dfs(Node<L_block *> *r, Graph<L_block *> &bg, unordered_set<Node<L_block *> *> &visited, list<Node<L_block *> *> &visited_list)
{
    if (visited.find(r) != visited.end())
    {
        return;
    }
    visited.insert(r);
    for (auto succ : *r->succ())
    {
        dfs(bg.mynodes[succ], bg, visited, visited_list);
    }
    visited_list.push_back(r);
}

// maybe useful
list<Node<L_block *> *> DFS(Node<L_block *> *r, Graph<L_block *> &bg)
{
    unordered_set<Node<L_block *> *> visited = unordered_set<Node<L_block *> *>();
    list<Node<L_block *> *> visited_list = list<Node<L_block *> *>();
    // list<Node<L_block *> *> worklist;
    // worklist.push_back(r);
    // while (!worklist.empty())
    // {
    //     Node<L_block *> *n = worklist.front();
    //     worklist.pop_front();
    //     for (auto visited_node : visited)
    //     {
    //         if (visited_node == n)
    //             continue;
    //     }
    //     for (auto succ : *n->succ())
    //     {
    //         worklist.push_back(bg.mynodes[succ]);
    //     }
    //     visited.push_back(n);
    // }
    dfs(r, bg, visited, visited_list);
    visited_list.reverse();
    return visited_list;
}

void SingleSourceGraph(Node<L_block *> *r, Graph<L_block *> &bg, L_func *fun)
{
    if (r->inDegree())
        assert(0);
    unordered_set<Node<L_block *> *> visited;
    list<Node<L_block *> *> worklist;
    worklist.push_back(r);
    while (!worklist.empty())
    {
        Node<L_block *> *n = worklist.front();
        worklist.pop_front();
        if (visited.find(n) != visited.end())
            continue;
        visited.insert(n);
        for (auto succ : *n->succ())
        {
            worklist.push_back(bg.mynodes[succ]);
        }
    }

    unordered_set<Node<L_block *> *> deleted_nodes;
    unordered_set<L_block *> deleted_blocks;

    for (auto it = bg.mynodes.begin(); it != bg.mynodes.end();)
    {
        if (visited.find(it->second) == visited.end())
        {
            deleted_nodes.insert(it->second);
            deleted_blocks.insert(it->second->info);
            // it = it->second->mygraph->mynodes.erase(it);
        }
        // else
        it++;
    }

    if (deleted_nodes.size())
    {
        list<L_block *> new_blocks;
        for (auto block : fun->blocks)
            if (deleted_blocks.find(block) == deleted_blocks.end())
                new_blocks.push_back(block);
        fun->blocks = new_blocks;
        // Create_bg(fun->blocks);
        for (auto node : deleted_nodes)
        {
            node->succs.clear();
            node->preds.clear();
            bg.rmNode(node);
        }
        // bg.nodecount = bg.mynodes.size();

        // double free or corruption
        for (auto node : bg.mynodes)
        {
            for (auto it = node.second->preds.begin(); it != node.second->preds.end();)
            {
                if (deleted_nodes.find(bg.mynodes[*it]) != deleted_nodes.end())
                {
                    it = bg.mynodes[node.first]->preds.erase(it);
                }
                else
                    it++;
            }
        }
    }

    // // print bg
    // Show_graph(stdout, bg);
    //   Todo
}

void Show_graph(FILE *out, GRAPH::Graph<LLVMIR::L_block *> &bg)
{
    for (auto block_node : bg.mynodes)
    {
        auto block = block_node.second->info;
        fprintf(out, "%s \n", block->label->name.c_str());
        fprintf(out, "pred  %zu  ", block_node.second->preds.size());
        for (auto pred : block_node.second->preds)
        {
            fprintf(out, "%s  ", bg.mynodes[pred]->info->label->name.c_str());
        }
        fprintf(out, "\n");
        fprintf(out, "succ  %zu  ", block_node.second->succs.size());
        for (auto succ : block_node.second->succs)
        {
            fprintf(out, "%s  ", bg.mynodes[succ]->info->label->name.c_str());
        }
        fprintf(out, "\n");
    }
}