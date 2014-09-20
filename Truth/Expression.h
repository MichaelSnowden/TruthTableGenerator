//
//  Expression.h
//  Balls2
//
//  Created by Michael Snowden on 9/19/14.
//  Copyright (c) 2014 MichaelSnowden. All rights reserved.
//

#ifndef __Balls2__Expression__
#define __Balls2__Expression__

#include <stdio.h>
#include <string>
#include "Node.h"
#include "Operator.h"
#include <iomanip>

using namespace std;

class Expression : public Node<string> {
    
public:
    
    Expression(string s) : Node<string>(s) {}
    bool isParenthesized = false;
    bool isUnary = false;
    string express() {
        // We will use in-order tree traversal for this
        string expression;
        
        auto has_llink = llink != NULL;
        auto has_rlink = rlink != NULL;
        if (isParenthesized) {
            expression.append("(");
        }
        if (has_llink) {
            expression.append(((Expression *)llink)->express());
            if (!isUnary) {
                expression.append(" ");
            }
        }
        expression.append(data);
        if (has_rlink) {
            if (!isUnary) {
                expression.append(" ");
            }
            expression.append(((Expression *)rlink)->express());
        }
        if (isParenthesized) {
            expression.append(")");
        }
        
        return expression;
    };
    
    void preOrder(function<void (Expression *)> lambda) {
        lambda(this);
        if (llink != NULL) {
            ((Expression *)llink)->preOrder(lambda);
        }
        if (rlink != NULL) {
            ((Expression *)rlink)->preOrder(lambda);
        }
    }
    void inOrder(function<void (Expression *)> lambda) {
        if (llink != NULL) {
            ((Expression *)llink)->inOrder(lambda);
        }
        lambda(this);
        if (rlink != NULL) {
            ((Expression *)rlink)->inOrder(lambda);
        }
    }
    void postOrder(function<void (Expression *)> lambda) {
        if (llink != NULL) {
            ((Expression *)llink)->postOrder(lambda);
        }
        if (rlink != NULL) {
            ((Expression *)rlink)->postOrder(lambda);
        }
        lambda(this);
    }
    
    bool evaluate(map<string, bool> &m) {
        bool lhs = false;
        bool rhs = false;
        
        if (llink != NULL) {
            lhs = ((Expression *)llink)->evaluate(m);
        }
        if (rlink != NULL) {
            rhs = ((Expression *)rlink)->evaluate(m);
        }
        if (llink != NULL || rlink != NULL) {
            auto op = Operator(data);
            bool operands[2] = {lhs, rhs};
            bool result = op.operation(operands);
            int len = express().length() + 2;   // The 2 is for ", "
            int l1 = len / 2;
            int l2 = len - l1;
            
            cout << setw(l1) << result << setw(l2) << " ";
            return result;
        } else {
            return m[data];
        }
        
        return false;
    }
};

#endif /* defined(__Balls2__Expression__) */
