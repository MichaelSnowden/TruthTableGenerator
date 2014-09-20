//
//  Node.h
//  Balls2
//
//  Created by Michael Snowden on 9/19/14.
//  Copyright (c) 2014 MichaelSnowden. All rights reserved.
//

#ifndef __Balls2__Node__
#define __Balls2__Node__

#include <iostream>
#include <stdio.h>
#include <functional>

using namespace std;

template<class T>
class Node;

template<class T>
class Node {
public:
    Node<T>(T p_data) : data(p_data) {}
    T data;
    Node<T> *parent = NULL;
    Node<T> *llink  = NULL;
    Node<T> *rlink  = NULL;
    Node<T> *getRoot() {
        auto mover = this;
        while (mover->parent != NULL) {
            mover = mover->parent;
        }
        return mover;
    }
    bool isLeaf() {
        return llink == NULL && rlink == NULL;
    }
};

#endif /* defined(__Balls2__Node__) */
