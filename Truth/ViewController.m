//
//  ViewController.m
//  Truth
//
//  Created by Michael Snowden on 9/19/14.
//  Copyright (c) 2014 MichaelSnowden. All rights reserved.
//

#import "ViewController.h"
#import "TruthTable.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *expressions;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _expressions = [NSMutableArray new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _expressions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    
    cell.textLabel.text = _expressions[indexPath.row];
    
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    TruthTable *truthTable = [[TruthTable alloc] initWithString:textField.text];
    _expressions = [[truthTable subexpressions] mutableCopy];
    [self.tableView reloadData];

    [textField resignFirstResponder];
    return YES;
}

@end
