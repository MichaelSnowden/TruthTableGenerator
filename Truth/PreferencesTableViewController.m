//
//  PreferencesTableViewController.m
//  Truth
//
//  Created by Michael Snowden on 9/20/14.
//  Copyright (c) 2014 MichaelSnowden. All rights reserved.
//

#import "PreferencesTableViewController.h"
#import "Preferences.h"
#import "UISegmentedControl+SetSegments.h"
#import "PreferencesTableViewCell.h"

@interface PreferencesTableViewController () <PreferencesTableViewCellDelegate>

@property (nonatomic, strong) NSArray *operatorKeys;

@end

@implementation PreferencesTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
    self.tableView.rowHeight = 44.f;
    
    _operatorKeys = [[[Preferences sharedPreferences] dictionary] allKeys];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PreferencesTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"Cell"];
}

- (void)save {
    [Preferences savePreferences];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_operatorKeys count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PreferencesTableViewCell *cell = (PreferencesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.delegate = self;
    
    UILabel *label = (UILabel *)[cell viewWithTag:100];
    UISegmentedControl *segmentedControl = (UISegmentedControl *)[cell viewWithTag:101];
    
    NSString *operatorKey = _operatorKeys[indexPath.row];
    label.text = operatorKey;
    
    NSArray *operatorSymbols = [[Preferences allOperatorSymbols] objectForKey:operatorKey];
    [segmentedControl setSegments:operatorSymbols];
    NSString *selectedOperator = [[[Preferences sharedPreferences] dictionary] objectForKey:operatorKey];
    NSInteger selectedOperatorIndex = [operatorSymbols indexOfObject:selectedOperator];
    [segmentedControl setSelectedSegmentIndex:selectedOperatorIndex];
    
    
    return cell;
}

#pragma mark - PreferencesTableViewCellDelegate

- (void)preferencesTableViewCell:(PreferencesTableViewCell *)cell didChangeSegmentTo:(NSInteger)segment {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSString *operatorKey = _operatorKeys[indexPath.row];
    NSString *preferredSymbol = [[[Preferences allOperatorSymbols] objectForKey:operatorKey] objectAtIndex:segment];
    [[[Preferences sharedPreferences] dictionary] setObject:preferredSymbol forKey:operatorKey];
}

@end
