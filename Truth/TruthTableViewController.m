//
//  ViewController.m
//  Truth
//
//  Created by Michael Snowden on 9/19/14.
//  Copyright (c) 2014 MichaelSnowden. All rights reserved.
//

#import "TruthTableViewController.h"
#import "TruthTable.h"

@interface TruthTableViewController () < UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *expressions;

@end

@implementation TruthTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _expressions = [NSMutableArray new];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    TruthTable *truthTable = [[TruthTable alloc] initWithString:textField.text];

    [textField resignFirstResponder];
    return YES;
}

@end
