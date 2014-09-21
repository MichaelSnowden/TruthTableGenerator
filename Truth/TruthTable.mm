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
#include <string>

using namespace std;

@interface TruthTable()

@property (nonatomic, assign) BinaryExpressionTree *tree;

@end

@implementation TruthTable

- (id)initWithString:(NSString *)s delegate:(id<TruthTableDelegate>)delegate {
    if (self = [super init]) {
        _delegate = delegate;
        
        s = [s stringByReplacingOccurrencesOfString:@" " withString:@""];
        auto expression = string([s UTF8String]);
        
        try {
            vector<string> expression;
            for (int i = 0; i < [s length]; ++i) {
                NSRange rangeOfCharacter = [s rangeOfComposedCharacterSequenceAtIndex:i];
                NSString *character = [s substringWithRange:rangeOfCharacter];
                expression.push_back([character cStringUsingEncoding:NSUTF8StringEncoding]);
            }
            _tree = new BinaryExpressionTree(expression);
        } catch (BinaryExpressionTreeException ex) {
            NSString *message = [NSString stringWithCString:ex.what() encoding:NSUTF8StringEncoding];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            return self;
        }
        
        
        NSMutableString *csv = [NSMutableString new];
        // Get the variables
        set<string> variables;
        ((Expression *)_tree->root)->inOrder([&variables](Expression *expression) -> void {
            if (expression->isLeaf()) {
                if (isconstant(expression->data)) {
                    
                } else {
                    variables.insert(expression->data);
                }
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
        
        // Print out the first row
        for (auto it = sortedVariables.begin(); it != sortedVariables.end(); ++it) {
            [csv appendString:[NSString stringWithCString:it->c_str() encoding:NSUTF8StringEncoding]];
            [csv appendString:@", "];
        }
        for (NSString *string in subexpressions) {
            [csv appendString:string];
            [csv appendString:@", "];
        }
        if (csv.length >= 2) {
            [csv deleteCharactersInRange:NSMakeRange(csv.length - 2, 2)];
            [csv appendString:@"\n"];
        }
        int n = 0;
        for (int i = 0; i < numRows; ++i) {
            // Print out the variable values
            const int numbits = 32;
            bitset<numbits> bits(n);
            NSString *s = [NSString stringWithCString:bits.to_string<char,string::traits_type,string::allocator_type>().c_str() encoding:NSUTF8StringEncoding];
            ++n;
            NSString *substring = [s substringWithRange:NSMakeRange(numbits - sortedVariables.size(), sortedVariables.size())];
            map<string, bool> m;
            
            int k = 0;
            for (auto it = sortedVariables.begin(); it != sortedVariables.end(); ++it) {
                string variable = *it;
                m[variable] = ([substring characterAtIndex:k] == '1') ? true : false;
                ++k;
            }
            
            for (int j = 0; j < sortedVariables.size(); ++j) {
                [csv appendFormat:@"%c, ", [substring characterAtIndex:j]];
            }
            // This line will print out all the subexpression values
            string s2 = "";
            ((Expression *)_tree->root)->evaluate(m, s2);
            [csv appendString:[NSString stringWithCString:s2.c_str() encoding:NSUTF8StringEncoding]];
            if (s2.size() >= 2) {
                [csv deleteCharactersInRange:NSMakeRange(csv.length - 2, 2)];
                [csv appendString:@"\n"];
            }
        }
        
        
        NSString *documentPath =
        [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filePath = [documentPath stringByAppendingPathComponent:@"TruthTable.csv"];
        
        NSError *error;
        [csv writeToFile:filePath atomically:NO encoding:NSUTF8StringEncoding error:nil];
        if (error != nil) {
            NSLog(@"Error: %@", error);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error saving file" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        } else {
            [_delegate truthTable:self didSaveExcelToFilePath:filePath];
        }
    }
    return self;
}

@end
