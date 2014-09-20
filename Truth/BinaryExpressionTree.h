//
//  BinaryExpressionTree.h
//  Truth
//
//  Created by Michael Snowden on 9/19/14.
//  Copyright (c) 2014 MichaelSnowden. All rights reserved.
//

#ifndef Truth_BinaryExpressionTree_h
#define Truth_BinaryExpressionTree_h

#include <iostream>
#include <algorithm>
#include <vector>
#include <stack>
#include <string>
#include <map>
#include <functional>
#include <exception>

#include "Expression.h"
#include "BinaryTree.h"
#include "Operator.h"

using namespace std;

bool isoperand(string s) {
    return isalpha(s[0]) || isdigit(s[0]);
}

bool isoperator(string s) {
    return operatorMap.find(s) != operatorMap.end(); 
}

class BinaryExpressionTreeException : public runtime_error {
public:
    BinaryExpressionTreeException(const string &s) : runtime_error(s) {}
};

class BinaryExpressionTree : public BinaryTree<string> {
public:
    BinaryExpressionTree() : BinaryTree<string>() {}
    BinaryExpressionTree(string s) : BinaryTree<string>() {
        // Tokenize everything
        vector<string> tokens;
        
        // Remove whitespace
        s.erase(remove_if(s.begin(), s.end(), ::isspace), s.end());
        
        // Insert tokens
        for (auto it = s.begin(); it != s.end(); ++it) {
            char token = *it;
            if (isalpha(token) && tokens.size() > 0 && isalpha(tokens.back()[0])) {
                tokens.push_back("*");
            }
            tokens.push_back(string(1, token));
        }
        
        // Build the tree from the tokens
        auto expression = tokens;
        
        stack<string> operators;
        stack<Expression *> operands;
        subexpressions.clear();
        
        auto operator2comesfirst = [](Operator op1, Operator op2) {
            return (op2.precedence == op1.precedence && op1.associativity == LeftRight) || op2.precedence < op1.precedence;
        };
        auto eatoperator = [&]() {
            
            auto op = Operator(operators.top());
            auto expression = new Expression(operators.top());
            operators.pop();
            
            switch (op.arity) {
                case Unary: {
                    if (operands.size() < 1) {
                        throw BinaryExpressionTreeException("Invalid syntax");
                    }
                    auto operand = operands.top();
                    operands.pop();
                    
                    switch (op.associativity) {
                        case LeftRight:
                            expression->llink = operand;
                            
                            break;
                        case RightLeft:
                            expression->rlink = operand;
                            break;
                    }
                    expression->isUnary = true;
                    operand->parent = expression;
                    break;
                }
                case Binary: {
                    if (operands.size() < 2) {
                        throw BinaryExpressionTreeException("Invalid syntax");
                    }
                    
                    auto operand1 = operands.top();
                    operands.pop();
                    auto operand2 = operands.top();
                    operands.pop();
                    
                    expression->rlink = operand1;
                    operand1->parent = expression;
                    expression->llink = operand2;
                    operand2->parent = expression;
                    
                    break;
                }
            }
            subexpressions.push_back(expression);
            string subexpression = expression->express();
            operands.push(expression);
        };
        
        for (auto it = expression.begin(); it != expression.end(); ++it) {
            
            string token = *it;
            
            if (isoperand(token)) {
                auto operand = new Expression(token);
                operands.push(operand);
            }
            else if(isoperator(token)) {
                
                while (!operators.empty() && isoperator(operators.top())) {
                    
                    auto op1 = Operator(token);
                    auto op2 = Operator(operators.top());
                    
                    if (operator2comesfirst(op1, op2)) {
                        
                        eatoperator();
                        
                    } else {
                        break;
                    }
                }
                
                operators.push(token);
            }
            else if (token[0] == '(') {
                operators.push(token);
            }
            else if (token[0] == ')') {
                while (!operators.empty() && operators.top() != "(") {
                    eatoperator();
                }
                operands.top()->isParenthesized = true;
                operators.pop();
            }
            else {
                string s = "Invalid symbol: ";
                s.append(token);
                throw BinaryExpressionTreeException(s);
            }
        }
        
        while (!operators.empty()) {
            eatoperator();
        }
        
        root = operands.top();
    }
    
    vector<Expression *> subexpressions;
};

#endif
