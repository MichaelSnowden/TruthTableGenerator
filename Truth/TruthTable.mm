//
//  TruthTable.m
//  Truth
//
//  Created by Michael Snowden on 9/19/14.
//  Copyright (c) 2014 MichaelSnowden. All rights reserved.
//

#import "TruthTable.h"
#include "BinaryExpressionTree.h"

@interface TruthTable()

@property (nonatomic, assign) BinaryExpressionTree *tree;

@end

@implementation TruthTable

- (id)initWithString:(NSString *)s {
    if (self = [super init]) {
        auto expression = string([s UTF8String]);
        _tree = new BinaryExpressionTree(expression);
    }
    return self;
}

- (NSArray *)subexpressions {
    NSMutableArray *subexpressions = [NSMutableArray arrayWithCapacity:_tree->subexpressions.size()];
    for (auto it = _tree->subexpressions.begin(); it != _tree->subexpressions.end(); ++it) {
        string expression = *it;
        [subexpressions addObject:[NSString stringWithCString:expression.c_str() encoding:NSUTF8StringEncoding]];
    }
    return subexpressions;
}

@end
