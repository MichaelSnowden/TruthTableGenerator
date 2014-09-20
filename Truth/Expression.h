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

using namespace std;

class Expression : public Node<string> {
    
public:
    
    Expression(string s) : Node<string>(s) {}
    bool isParenthesized = false;
    string express() {
        // We will use in-order tree traversal for this
        string expression;
        
        // go left
        auto has_llink = llink != NULL;
        auto has_rlink = rlink != NULL;
        if (isParenthesized) {
            expression.append("(");
        }
        if (has_llink) {
            expression.append(((Expression *)llink)->express());
        }
        // visit
        expression.append(data);
        // go right
        if (has_rlink) {
            expression.append(((Expression *)rlink)->express());
        }
        if (isParenthesized) {
            expression.append(")");
        }
        
        return expression;
    };
};

#endif /* defined(__Balls2__Expression__) */
