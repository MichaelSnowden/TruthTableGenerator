//
//  Operator.h
//  Truth
//
//  Created by Michael Snowden on 9/19/14.
//  Copyright (c) 2014 MichaelSnowden. All rights reserved.
//

#ifndef Truth_Operator_h
#define Truth_Operator_h

#include <iostream>
#include <vector>
#include <string>
#include <map>
#include <functional>

using namespace std;

enum Arity {
    Unary,
    Binary
};

enum Associativity {
    LeftRight,
    RightLeft
};

template<class T>
class Node;

typedef function<bool (bool lhs, bool rhs)> LogicalOperation;
typedef function<void (Node<string> *)> TraversalLambda;
typedef int Precedence;

class Operator {
    
public:
    Operator(Precedence p, Arity ar, Associativity as, LogicalOperation op) :
    precedence(p), arity(ar), associativity(as), operation(op) {};
    Operator(string s);
    
    const Precedence precedence;
    const Arity arity;
    const Associativity associativity;
    const LogicalOperation operation;
    const string stringRepresentation;
    
private:
    
};

const static Operator  NOT_PREFIX(1,  Unary, RightLeft, [](bool lhs, bool rhs) -> bool { return !rhs;           });
const static Operator NOT_POSTFIX(1,  Unary, LeftRight, [](bool lhs, bool rhs) -> bool { return !lhs;           });
const static Operator         AND(2, Binary, LeftRight, [](bool lhs, bool rhs) -> bool { return lhs && rhs;     });
const static Operator        NAND(2, Binary, LeftRight, [](bool lhs, bool rhs) -> bool { return !(lhs && rhs);  });
const static Operator          OR(3, Binary, LeftRight, [](bool lhs, bool rhs) -> bool { return lhs || rhs;     });
const static Operator         NOR(3, Binary, LeftRight, [](bool lhs, bool rhs) -> bool { return !(lhs || rhs);  });
const static Operator         XOR(3, Binary, LeftRight, [](bool lhs, bool rhs) -> bool { return lhs != rhs;     });
const static Operator          IF(4, Binary, LeftRight, [](bool lhs, bool rhs) -> bool { return !lhs || rhs;    });
const static Operator         IFF(5, Binary, LeftRight, [](bool lhs, bool rhs) -> bool { return lhs == rhs;     });

const static map<string, Operator> operatorMap = {
    {"!", NOT_PREFIX}, {"~", NOT_PREFIX}, {"¬", NOT_PREFIX},
    {"'", NOT_POSTFIX},
    {"^", AND}, {"∧", AND}, {"&", AND}, {"*", AND}, {"•", AND},
    {"|", NAND}, {"⊼", NAND},
    {"+", OR}, {"∨", OR},
    {"↓", NOR}, {"⊽", NOR},
    {"⊕", XOR}, {"⊻", XOR},
    {"⇒", IF}, {"→", IF}, {"⊃", IF},
    {"⇔", IFF}, {"≡", IFF}, {"=", IFF}
};

Operator::Operator(string s) : precedence(operatorMap.at(s).precedence), arity(operatorMap.at(s).arity), associativity(operatorMap.at(s).associativity), operation(operatorMap.at(s).operation), stringRepresentation(s) {}

#endif
