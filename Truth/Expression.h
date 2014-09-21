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

bool is_constant(const string &str) {
    return str.find_first_not_of("0123456789TF") == string::npos;
}

bool constant_to_value(const string &s) {
    if (s == "0" || s == "F") {
        return false;
    } else {
        return true;
    }
}

string constant_to_string(const string &s) {
    if (s == "0" || s == "F") {
        return "F";
    } else {
        return "T";
    }
}

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
    
    bool evaluate(map<string, bool> &m, string &s) {
        bool lhs = false;
        bool rhs = false;
        
        if (llink != NULL) {
            lhs = ((Expression *)llink)->evaluate(m, s);
        }
        if (rlink != NULL) {
            rhs = ((Expression *)rlink)->evaluate(m, s);
        }
        if (llink != NULL || rlink != NULL) {
            auto op = Operator(data);
            bool result = op.operation(lhs, rhs);
            
            s.append((result == true) ? "T, " : "F, " );
            return result;
        } else {
            if (is_constant(data)) {
                bool result = constant_to_value(data);
                s.append(constant_to_string(data));
                return result;
            } else {
                return m[data];
            }
        }
    }
};

#endif /* defined(__Balls2__Expression__) */
