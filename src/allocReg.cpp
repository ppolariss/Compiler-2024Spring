#include "allocReg.h"
using namespace std;
using namespace ASM;
#include <cassert>
#include <stack>
using namespace GRAPH;
#include "printASM.h"
#include "register_rules.h"
#include <sstream>
#include <iostream>
#include "printASM.h"
stack<Node<RegInfo> *> reg_stack;
const int k = allocateRegs.size(); // 8-15
const int START_REG = 8;

int nextXXn = XXn1;
int getNextXXn()
{
    int temp = nextXXn;
    if (nextXXn == XXn4)
        nextXXn = XXn1;
    else
        nextXXn++;
    return temp;
}
// int getNextColor(int color)
// {
//     return color == START_REG + k - 1 ? START_REG : color + 1;
// }

void getAllRegs(AS_stm *stm, vector<AS_reg *> &defs, vector<AS_reg *> &uses)
{
    switch (stm->type)
    {
    case AS_stmkind::BINOP:
        getDefReg(stm->u.BINOP->dst, defs);
        getUseReg(stm->u.BINOP->left, uses);
        getUseReg(stm->u.BINOP->right, uses);
        break;
    case AS_stmkind::MOV:
        getDefReg(stm->u.MOV->dst, defs);
        getUseReg(stm->u.MOV->src, uses);
        break;
    case AS_stmkind::LDR:
        getDefReg(stm->u.LDR->dst, defs);
        getUseReg(stm->u.LDR->ptr, uses);
        break;
    case AS_stmkind::STR:
        getUseReg(stm->u.STR->src, uses);
        getUseReg(stm->u.STR->ptr, uses);
        break;
    case AS_stmkind::CMP:
        getUseReg(stm->u.CMP->left, uses);
        getUseReg(stm->u.CMP->right, uses);
        break;
    case AS_stmkind::ADR:
        getDefReg(stm->u.ADR->reg, defs);
        break;
    default:
        break;
    }
}

void getDefReg(AS_reg *reg, vector<AS_reg *> &defs)
{
    if (!reg)
    {
        return;
    }
    switch (reg->type)
    {
    case AS_type::Xn:
    {
        defs.push_back(reg);
        break;
    }
    case AS_type::ADR:
    {
        assert(0);
    }

    default:
        break;
    }
}
void getUseReg(AS_reg *reg, vector<AS_reg *> &uses)
{
    if (!reg)
    {
        return;
    }
    switch (reg->type)
    {
    case AS_type::Xn:
    {
        uses.push_back(reg);
        break;
    }
    case AS_type::ADR:
    {
        assert(reg);
        assert(reg->u.add);
        assert(reg->u.add->base);
        assert(reg->u.add->base->type);
        if (reg->u.add->base->type == AS_type::Xn)
        {
            uses.push_back(reg->u.add->base);
        }
        if (reg->u.add->reg)
        {
            uses.push_back(reg->u.add->reg);
        }
        break;
    }

    default:
        break;
    }
}
void vreg_map(AS_reg *reg, unordered_map<int, Node<RegInfo> *> &regNodes)
{
    switch (reg->type)
    {
    case AS_type::Xn:
    {
        int regNo = reg->u.offset;
        if (regNo < 100)
            return;
        reg->u.offset = regNodes[regNo]->info.color;
        break;
    }
    case AS_type::ADR:
    {
        assert(0);
    }
    default:
        break;
    }
};
void forwardLivenessAnalysis(std::list<InstructionNode *> &liveness, std::list<AS_stm *> &as_list)
{
    unordered_map<string, InstructionNode *> blocks;
    for (const auto &stm : as_list)
    {
        InstructionNode *node = new InstructionNode(stm, {}, {}, {}, {});
        liveness.push_back(node);
        vector<AS_reg *> defs;
        vector<AS_reg *> uses;

        switch (stm->type)
        {
        case AS_stmkind::LABEL:
            blocks.emplace(stm->u.LABEL->name, node);
        default:
            getAllRegs(stm, defs, uses);
            break;
        }

        for (auto &x : defs)
        {
            if (x->u.offset >= 100)
            {
                node->def.emplace(x->u.offset);
            }
            assert(x->type != AS_type::ADR);
        }

        for (auto &x : uses)
        {
            if (x->u.offset >= 100)
            {
                node->use.emplace(x->u.offset);
            }
            assert(x->type != AS_type::ADR);
        }
    }

    setControlFlowDiagram(liveness, blocks);
}
void setControlFlowDiagram(std::list<InstructionNode *> &nodes, unordered_map<string, InstructionNode *> &blocks)
{
    for (auto it = nodes.begin(); it != nodes.end(); ++it)
    {
        InstructionNode *currentNode = *it; // 当前节点
        InstructionNode *nextNode = nullptr;
        auto nextIt = std::next(it); // 获取下一个元素的迭代器
        if (nextIt != nodes.end())
        {
            nextNode = *nextIt; // 如果存在下一个节点，则获取它
        }
        switch (currentNode->raw->type)
        {
        case AS_stmkind::RETT:

            break;
        case AS_stmkind::B:
            currentNode->sucessor.emplace(blocks[currentNode->raw->u.B->jump->name]);
            break;
        case AS_stmkind::BCOND:
            currentNode->sucessor.emplace(blocks[currentNode->raw->u.BCOND->jump->name]);
            if (nextNode)
            {
                currentNode->sucessor.emplace(nextNode);
            }
            break;
        default:
            if (nextNode)
            {
                currentNode->sucessor.emplace(nextNode);
            }
            break;
        }
    }
}
void init(std::list<InstructionNode *> &nodes, unordered_map<int, Node<RegInfo> *> &regNodes, Graph<RegInfo> &interferenceGraph, std::list<ASM::AS_stm *> &as_list)
{
    assert(reg_stack.empty());
    bool changed;

    int set_size = 0;
    do
    {
        changed = false;
        for (auto it = nodes.rbegin(); it != nodes.rend(); ++it)
        {
            InstructionNode *n = *it;
            n->previous_in = n->in;
            n->previous_out = n->out;

            if (n->sucessor.size())
                for (InstructionNode *s : n->sucessor)
                {
                    n->out.insert(s->in.begin(), s->in.end());
                }
            n->in.clear();
            std::set_difference(n->out.begin(), n->out.end(), n->def.begin(), n->def.end(), std::inserter(n->in, n->in.end()));
            n->in.insert(n->use.begin(), n->use.end());
            set_size += n->in.size();
            if (n->in != n->previous_in || n->out != n->previous_out)
            {
                changed = true;
            }
        }

    } while (changed);
    set<int> regs;
    set<int> defs;
    set<int> uses;

    for (auto &x : nodes)
    {
        defs.insert(x->def.begin(), x->def.end());
        uses.insert(x->use.begin(), x->use.end());
    }

    regs.insert(defs.begin(), defs.end());
    regs.insert(uses.begin(), uses.end());
    int ijj = 0;
    for (auto x : regs)
    {
        regNodes.insert({x, interferenceGraph.addNode({x, x, 0, 0, 0})});
    }

    for (auto x : nodes)
    {
        std::vector<int> vec(x->in.begin(), x->in.end());
        for (int i = 0; i < vec.size(); i++)
        {
            for (int j = i + 1; j < vec.size(); j++)
            {
                interferenceGraph.addEdge(regNodes[vec[i]], regNodes[vec[j]]);
                interferenceGraph.addEdge(regNodes[vec[j]], regNodes[vec[i]]);
            }
        }
    }

    // 打印干扰图的边,并设置节点度数
    // std::cerr << "Interference Graph Edges:" << std::endl;
    auto nodes_ = interferenceGraph.nodes();
    for (auto &nodePair : *nodes_)
    {
        Node<RegInfo> *node = nodePair.second;
        NodeSet *successors = node->succ();
        node->info.degree = successors->size();

        // std::cerr << "Reg " << node->nodeInfo().regNum << " interferes with " << successors->size() << " Regs: ";
        // if (successors->size())
        // {
        //     for (int succKey : *successors)
        //     {
        //         std::cerr << interferenceGraph.mynodes[succKey]->info.regNum << " ";
        //     }
        // }

        // std::cerr << std::endl;
    }
    // 删除不使用的指令
    std::set<int> to_delete;
    std::set_difference(defs.begin(), defs.end(), uses.begin(), uses.end(), std::inserter(to_delete, to_delete.end()));

    for (auto &x : nodes)
        delete x;

    for (auto it = as_list.begin(); it != as_list.end();)
    {
        vector<AS_reg *> defs;
        vector<AS_reg *> uses;
        getAllRegs(*it, defs, uses);
        int n = 0;
        if (defs.size() > 0)
        {
            int regNo = defs.front()->u.offset;
            if (to_delete.find(regNo) != to_delete.end())
            {
                it = as_list.erase(it);
                continue;
            }
        }
        it++;
    }
}

void replaceInAUse(ASM::AS_stm *list, int old, AS_reg *new_reg)
{
    switch (list->type)
    {
    case AS_stmkind::BINOP:
        if (list->u.BINOP->left->u.offset == old)
        {
            list->u.BINOP->left = new_reg;
        }
        if (list->u.BINOP->right->u.offset == old)
        {
            list->u.BINOP->right = new_reg;
        }
        break;
    case AS_stmkind::MOV:
        if (list->u.MOV->src->u.offset == old)
        {
            list->u.MOV->src = new_reg;
        }
        break;
    case AS_stmkind::LDR:
    {
        if (list->u.LDR->ptr->u.offset == old)
        {
            list->u.LDR->ptr = new_reg;
        }
        if (list->u.LDR->ptr->type == AS_type::ADR)
        {
            if (list->u.LDR->ptr->u.add->base->u.offset == old)
            {
                list->u.LDR->ptr->u.add->base = new_reg;
            }
        }
    }
    break;
    case AS_stmkind::STR:
    {
        if (list->u.STR->src->u.offset == old)
        {
            list->u.STR->src = new_reg;
        }
        if (list->u.STR->ptr->u.offset == old)
        {
            list->u.STR->ptr = new_reg;
        }
        if (list->u.STR->ptr->type == AS_type::ADR)
        {
            if (list->u.STR->ptr->u.add->base->u.offset == old)
            {
                list->u.STR->ptr->u.add->base = new_reg;
            }
            //         // if (list->u.STR->ptr->u.add->reg->u.offset == old)
            //         // {
            //         //     list->u.STR->ptr->u.add->reg = new_reg;
            //         // }
        }
    }
    break;
    case AS_stmkind::CMP:
        if (list->u.CMP->left->u.offset == old)
        {
            list->u.CMP->left = new_reg;
        }
        if (list->u.CMP->right->u.offset == old)
        {
            list->u.CMP->right = new_reg;
        }
        break;
    case AS_stmkind::ADR:
        break;
    default:
        break;
    }
}

void replaceInADef(ASM::AS_stm *list, int old, AS_reg *new_reg)
{
    switch (list->type)
    {
    case AS_stmkind::BINOP:
        if (list->u.BINOP->dst->u.offset == old)
        {
            list->u.BINOP->dst = new_reg;
        }
        break;
    case AS_stmkind::MOV:
        if (list->u.MOV->dst->u.offset == old)
        {
            list->u.MOV->dst = new_reg;
        }
        break;
    case AS_stmkind::LDR:
        if (list->u.LDR->dst->u.offset == old)
        {
            list->u.LDR->dst = new_reg;
        }
        break;
    case AS_stmkind::STR:
        break;
    case AS_stmkind::CMP:
        break;
    case AS_stmkind::ADR:
        if (list->u.ADR->reg->u.offset == old)
        {
            list->u.ADR->reg = new_reg;
        }
        break;
    default:
        break;
    }
}

void livenessAnalysis(std::list<InstructionNode *> &nodes, std::list<ASM::AS_stm *> &as_list)
{
    Graph<RegInfo> interferenceGraph;
    unordered_map<int, Node<RegInfo> *> regNodes; // 虚拟器寄存器根据编号到干扰图上的映射
    init(nodes, regNodes, interferenceGraph, as_list);

    // 寄存器分配
    // unordered_set
    stack<Node<RegInfo> *> spill_stack;
    bool changed = true;
    while (changed)
    {
        changed = false;
        for (auto it = interferenceGraph.nodes()->begin(); it != interferenceGraph.nodes()->end(); ++it)
        {
            auto pair = *it;
            int id = pair.first;
            Node<RegInfo> *info = pair.second;
            // if (id < 100)
            //     continue;
            if (!info)
                continue;
            if (info->info.bit_map || info->info.is_spill)
                continue;
            if (info->info.degree >= k)
                continue;

            changed = true;
            reg_stack.push(info);
            info->info.bit_map = true;
            GRAPH::NodeSet *nodeSet = info->succ();
            for (auto it = nodeSet->begin(); it != nodeSet->end(); ++it)
                interferenceGraph.mynodes[*it]->info.degree--;
            // if (regNodes[*it])
            //     regNodes[*it]->info.degree--;

            // nodeSet = info->pred();

            // interferenceGraph.mynodes[id]->info.degree
        }
        if (changed)
            continue;

        // for (auto pair : regNodes)
        for (auto it = interferenceGraph.nodes()->begin(); it != interferenceGraph.nodes()->end(); ++it)
        {
            auto pair = *it;
            int id = pair.first;
            Node<RegInfo> *info = pair.second;
            // if (id < 100)
            //     continue;
            if (!info)
                continue;
            if (info->info.bit_map || info->info.is_spill)
                continue;
            assert(info->info.degree >= k);

            changed = true;
            // info->info.is_spill = true;
            info->info.bit_map = true;
            // reg_stack.push(info);
            spill_stack.push(info);
            GRAPH::NodeSet *nodeSet = info->succ();
            for (auto it = nodeSet->begin(); it != nodeSet->end(); ++it)
                interferenceGraph.mynodes[*it]->info.degree--;
            // if (regNodes[*it])
            //     regNodes[*it]->info.degree--;
            break;
            // nodeSet = info->pred();

            // interferenceGraph.mynodes[id]->info.degree
        }
    }

    // cout << "reg_stack" << reg_stack.size() << endl;
    // cout << "spill_stack" << spill_stack.size() << endl;

    unordered_set<int> spill_reg = unordered_set<int>();

    while (!reg_stack.empty())
    {
        Node<RegInfo> *info = reg_stack.top();
        reg_stack.pop();
        GRAPH::NodeSet *nodeSet = info->succ();
        int colour = START_REG;
        bool conflict = true;
        while (conflict)
        {
            conflict = false;
            for (auto it = nodeSet->begin(); it != nodeSet->end(); ++it)
            {
                // cout << *it << " " << colour << " " << regNodes[*it] << " " << endl;
                // if (regNodes[*it])
                //     cout << "regNodes[*it]->info.color" << endl;
                if (interferenceGraph.mynodes[*it] && interferenceGraph.mynodes[*it]->info.color == colour)
                {
                    colour++;
                    conflict = true;
                    break;
                }
                // if (regNodes[*it] && regNodes[*it]->info.color == colour)
                // {
                //     cout << *it << " " << colour << endl;
                //     cout << "yes" << endl;
                //     colour++;
                //     conflict = true;
                //     break;
                // }
            }
        }
        assert(colour < START_REG + k);
        info->info.color = colour;
    }
    while (!spill_stack.empty())
    {
        Node<RegInfo> *info = spill_stack.top();
        spill_stack.pop();
        GRAPH::NodeSet *nodeSet = info->succ();
        int colour = START_REG;
        bool conflict = true;
        while (conflict)
        {
            conflict = false;
            for (auto it = nodeSet->begin(); it != nodeSet->end(); ++it)
            {
                // cout << *it << " " << colour << " " << regNodes[*it] << " " << endl;
                // if (regNodes[*it])
                //     cout << "regNodes[*it]->info.color" << endl;
                if (interferenceGraph.mynodes[*it] && interferenceGraph.mynodes[*it]->info.color == colour)
                {
                    colour++;
                    conflict = true;
                    break;
                }
            }
        }
        if (colour >= START_REG + k)
        {
            spill_reg.insert(info->info.regNum);
            info->info.is_spill = true;
            info->info.color = -1;
            // info->info.regNum = -1;
        }
        else
        {
            info->info.color = colour;
            // info->info.regNum = colour;
        }
        // info->info.color = info->color % k;

        //         regNodes[*it]->info.color++;
    }
    // cout << "spill_reg" << spill_reg.size() << endl;

    int totalOffset = spill_reg.size() * INT_LENGTH;
    unordered_map<int, AS_address *> spillOffset;
    int currOffset = totalOffset - INT_LENGTH;
    for (auto reg : spill_reg)
    {
        spillOffset[reg] = new AS_address(new AS_reg(AS_type::SP, 0), currOffset);
        currOffset -= INT_LENGTH;
    }
    assert(currOffset == -INT_LENGTH);
    if (totalOffset)
    {
        for (auto it = as_list.begin(); it != as_list.end(); it++)
        {
            if ((*it)->type == AS_stmkind::LABEL)
            {
                as_list.insert(next(it), AS_Binop(AS_binopkind::SUB_, new AS_reg(AS_type::SP, -1), new AS_reg(AS_type::IMM, totalOffset), new AS_reg(AS_type::SP, -1)));
                break;
            }
        }
    }

    // cout << "regNodes.size():" << regNodes.size() << endl;
    for (auto it = as_list.begin(); it != as_list.end(); it++)
    // AS_stm *list : as_list)
    {
        auto list = *it;
        vector<AS_reg *> defs;
        // defs.clear();
        vector<AS_reg *> uses;
        // uses.clear();
        getAllRegs(list, defs, uses);
        for (AS_reg *def : defs)
        {
            if (def->type == AS_type::Xn && def->u.offset >= 100)
            {
                if (spill_reg.find(def->u.offset) != spill_reg.end())
                {
                    int originOffset = def->u.offset;
                    int xxn = getNextXXn();
                    // def->u.offset = xxn;
                    // spill
                    as_list.insert(next(it), AS_Str(new AS_reg(AS_type::Xn, xxn), new AS_reg(AS_type::ADR, spillOffset[originOffset])));
                    replaceInADef(list, originOffset, new AS_reg(AS_type::Xn, xxn));
                }
                else
                {
                    // not spill
                    // Node<RegInfo> *node = interferenceGraph.mynodes[def->u.offset];
                    Node<RegInfo> *node = regNodes[def->u.offset];
                    assert(node);
                    def->u.offset = node->info.color;
                }
            }
        }
        for (AS_reg *use : uses)
        {
            if (use->type == AS_type::Xn && use->u.offset >= 100)
            {
                if (spill_reg.find(use->u.offset) != spill_reg.end())
                {
                    int originOffset = use->u.offset;
                    int xxn = getNextXXn();
                    // use->u.offset = xxn;
                    as_list.insert(it, AS_Ldr(new AS_reg(AS_type::Xn, xxn), new AS_reg(AS_type::ADR, spillOffset[originOffset])));
                    replaceInAUse(list, originOffset, new AS_reg(AS_type::Xn, xxn));
                }
                else
                {
                    // Node<RegInfo> *node = interferenceGraph.mynodes[use->u.offset];
                    Node<RegInfo> *node = regNodes[use->u.offset];
                    assert(node);
                    use->u.offset = node->info.color;
                }
            }
        }
    }
}
