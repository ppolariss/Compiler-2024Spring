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

/* input LLVMIR::L_block* *List after instruction selection for each block,
    generate a graph on the basic blocks */

Graph<L_block *> &Create_bg(list<L_block *> &bl)
{
    RA_bg = Graph<L_block *>();
    block_env = unordered_map<Temp_label *, L_block *>();

    for (auto block : bl)
    {
        block_env.insert({block->label, block});
        RA_bg.addNode(block);
    }

    for (auto block : bl)
    {
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

    for (auto it = bg.mynodes.begin(); it != bg.mynodes.end();)
    {
        if (visited.find(it->second) == visited.end())
        {
            for (auto block : fun->blocks)
                if (block == it->second->info)
                {
                    fun->blocks.remove(block);
                    break;
                }
            it = bg.mynodes.erase(it);
        }
        else
            it++;
    }
    bg.nodecount = bg.mynodes.size();
    // for (auto block_node : bg.mynodes)
    // {
    //     if (visited.find(block_node.second) == visited.end())
    //     {
    //         bg.mynodes.erase(block_node.first);
    //     }
    // }

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