//
//  TruthTable.h
//  Truth
//
//  Created by Michael Snowden on 9/19/14.
//  Copyright (c) 2014 MichaelSnowden. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TruthTable;

@protocol TruthTableDelegate

- (void)truthTable:(TruthTable *) truthTable didSaveExcelToFilePath:(NSString *) filePath;

@end

@interface TruthTable : NSObject

- (id)initWithString:(NSString *)s delegate:(id<TruthTableDelegate>) delegate;

@property (nonatomic, strong) id<TruthTableDelegate> delegate;

@end
