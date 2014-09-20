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
#include <assert.h>
#include <string>
#include <map>
#include <functional>
#include "Expression.h"
#include "BinaryTree.h"
#include "Operator.h"

using namespace std;

class BinaryExpressionTree : public BinaryTree<Expression *> {
public:
    BinaryExpressionTree() : BinaryTree<Expression *>() {}
    BinaryExpressionTree(string s) : BinaryTree<Expression *>() {
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
        
        // Parse it
        auto expression = tokens;
        cout << "Original expression: " << endl;
        copy(expression.begin(), expression.end(), ostream_iterator<string>(cout, " "));
        cout << endl;
        
        stack<string> operators;
        stack<Expression *> operands;
        subexpressions.clear();
        
        auto isoperand  = [](string s) { return isalpha(s[0]) || isdigit(s[0]); };
        auto isoperator = [](string s) { return operatorMap.find(s) != operatorMap.end(); };
        auto operator2comesfirst = [](Operator op1, Operator op2) {
            return (op2.precedence == op1.precedence && op1.associativity == LeftRight) || op2.precedence < op1.precedence;
        };
        auto eatoperator = [&]( function<void (string subexpression)> handleSubexpression) {
            
            auto op = Operator(operators.top());
            auto expression = new Expression(operators.top());
            operators.pop();
            
            switch (op.arity) {
                case Unary: {
                    assert(operands.size() >= 1);
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
                    operand->parent = expression;
                    break;
                }
                case Binary: {
                    assert(operands.size() >= 2);
                    
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
            string subexpression = expression->express();
            subexpressions.push_back(subexpression);
            handleSubexpression(expression->express());
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
                        
                        eatoperator( [](string subexpression) -> void { cout << "sub: " << subexpression << endl; });
                        
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
                    eatoperator( [&operators](string subexpression) -> void { cout <<  "sub: "  << subexpression << endl; });
                }
                operands.top()->isParenthesized = true;
                operators.pop();
            }
            else {
                cout << "Fucked: " << token << endl;
                assert(0);
            }
        }
        
        while (!operators.empty()) {
            eatoperator( [](string subexpression) -> void { cout << "sub: " << subexpression << endl; });
        }
        
        cout << "Expression tree: " << endl;
    }
    vector<string> subexpressions;
};

#endif
