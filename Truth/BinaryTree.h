//
//  Tree.h
//  Truth
//
//  Created by Michael Snowden on 9/19/14.
//  Copyright (c) 2014 MichaelSnowden. All rights reserved.
//

#ifndef Truth_Tree_h
#define Truth_Tree_h

#include <iostream>
#include <vector>
#include <functional>

template<class T>
class BinaryTree {
public:
    BinaryTree() : root(NULL) {}
    BinaryTree(Node<T> *p_root) : root(p_root) {}
    
    Node<T> *root = NULL;
    void inOrder(function<void (Node<T>)> lambda);
};


#endif
