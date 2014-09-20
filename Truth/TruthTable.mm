//
//  TruthTable.m
//  Truth
//
//  Created by Michael Snowden on 9/19/14.
//  Copyright (c) 2014 MichaelSnowden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TruthTable.h"
#import "Node.h"
#include "BinaryExpressionTree.h"
#include <algorithm>
#include <string>
#include <set>

using namespace std;

@interface TruthTable()

@property (nonatomic, assign) BinaryExpressionTree *tree;

@end

@implementation TruthTable

- (id)initWithString:(NSString *)s {
    if (self = [super init]) {
        auto expression = string([s UTF8String]);
        
        try {
            _tree = new BinaryExpressionTree(expression);
        } catch (BinaryExpressionTreeException ex) {
            NSString *message = [NSString stringWithCString:ex.what() encoding:NSUTF8StringEncoding];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            return self;
        }
        
        
        // Get the variables
        set<string> variables;
        ((Expression *)_tree->root)->inOrder([&variables](Expression *expression) -> void {
            if (expression->isLeaf()) {
                variables.insert(expression->data);
            }
        });
        vector<string> sortedVariables;
        copy(variables.begin(), variables.end(), back_inserter(sortedVariables));
        sort(sortedVariables.begin(), sortedVariables.end());
        
        // Get the subexpressions
        NSMutableArray *subexpressions = [NSMutableArray arrayWithCapacity:_tree->subexpressions.size()];
        for (auto it = _tree->subexpressions.begin(); it != _tree->subexpressions.end(); ++it) {
            string expression = (*it)->express();
            [subexpressions addObject:[NSString stringWithCString:expression.c_str() encoding:NSUTF8StringEncoding]];
        }
        
        // Start organizing the table
        int numRows = pow(2, sortedVariables.size());
        
        for (auto it = sortedVariables.begin(); it != sortedVariables.end(); ++it) {
            cout << *it << " ";
        }
        for (NSString *string in subexpressions) {
            cout << [string cStringUsingEncoding:NSUTF8StringEncoding] << ", ";
        }
        cout << endl;
        int n = 0;
        for (int i = 0; i < numRows; ++i) {
            // Print out the variable values
            const int numbits = 32;
            bitset<numbits> bits(n);
            string s = bits.to_string<char,string::traits_type,string::allocator_type>();
            ++n;
            string substring = s.substr(numbits - sortedVariables.size(), sortedVariables.size());
            map<string, bool> m;
            
            int k = 0;
            for (auto it = sortedVariables.begin(); it != sortedVariables.end(); ++it) {
                string variable = *it;
                m[variable] = (substring[k] == '1') ? true : false;
                ++k;
            }
            
            for (int j = 0; j < sortedVariables.size(); ++j) {
                cout << substring[j] << ' ';
            }
            ((Expression *)_tree->root)->evaluate(m);
            cout << endl;
        }

    }
    return self;
}

@end
