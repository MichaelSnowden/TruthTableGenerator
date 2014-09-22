//
//  TruthTableFile.h
//  Truth
//
//  Created by Michael Snowden on 9/21/14.
//  Copyright (c) 2014 MichaelSnowden. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TruthTableFile : NSObject <NSCoding>

@property (nonatomic, readonly) NSString *contingency;
@property (nonatomic, strong)   NSString *filePath;
@property (nonatomic, strong)   NSString *expression;
@property (nonatomic, assign)   NSUInteger numTruths;
@property (nonatomic, assign)   NSUInteger numPropositions;
@property (nonatomic, strong)   NSString *csv;
@property (nonatomic, strong)   NSDate *date;

- (id)initWithExpression:(NSString *)expression CSV:(NSString *)csv numTruths:(NSUInteger) numTruths numPropositions: (NSUInteger) numPropositions;
+ (void)saveFile:(TruthTableFile *)file;
+ (void)deleteFileAtIndex:(NSUInteger) index;
+ (NSArray *)allFiles;

@end
