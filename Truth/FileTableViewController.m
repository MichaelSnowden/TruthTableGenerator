//
//  FileTableViewController.m
//  Truth
//
//  Created by Michael Snowden on 9/21/14.
//  Copyright (c) 2014 MichaelSnowden. All rights reserved.
//

#import "FileTableViewController.h"
#import "TruthTableFile.h"
#import "FileTableViewCell.h"
#import <QuickLook/QuickLook.h>

@interface FileTableViewController () <QLPreviewControllerDataSource>

@property (nonatomic, strong) NSMutableArray *files;
@property (nonatomic, strong) QLPreviewController *previewController;

@end

@implementation FileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    _files = [[TruthTableFile allFiles] mutableCopy];
    _previewController = [QLPreviewController new];
    _previewController.dataSource = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit)];
}

- (void)edit {
    if (self.tableView.editing) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit)];
        [self.tableView setEditing:NO animated:YES];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(edit)];
        [self.tableView setEditing:YES animated:YES];
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_files count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FileTableViewCell *cell = (FileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    TruthTableFile *file = [NSKeyedUnarchiver unarchiveObjectWithData: _files[indexPath.row]];
    [cell loadFile:file];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        
        [_files removeObjectAtIndex:indexPath.row];
        [TruthTableFile deleteFileAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [_previewController setCurrentPreviewItemIndex:indexPath.row];
    [self presentViewController:_previewController animated:YES completion:nil];
    
}

#pragma mark - QLPreviewControllerDataSource

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    TruthTableFile *file = [NSKeyedUnarchiver unarchiveObjectWithData:_files[index]];
    return [NSURL fileURLWithPath: file.filePath];
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return [_files count];
}

@end
