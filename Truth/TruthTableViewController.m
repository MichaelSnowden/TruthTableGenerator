//
//  ViewController.m
//  Truth
//
//  Created by Michael Snowden on 9/19/14.
//  Copyright (c) 2014 MichaelSnowden. All rights reserved.
//

#import "TruthTableViewController.h"
#import "TruthTable.h"
#import "TruthTableInputAccessoryView.h"
#import "PreferencesTableViewController.h"
#import "TruthTableFile.h"
#import "UITextField+Shake.h"
#import "UITextField+Cursor.h"
#import <QuickLook/QuickLook.h>

@interface TruthTableViewController () < UITextFieldDelegate, TruthTableDelegate, QLPreviewControllerDataSource, QLPreviewControllerDelegate, TruthTableInputAccessoryViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *expressions;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) TruthTableInputAccessoryView *inputAccessoryView;
@property (strong, nonatomic) TruthTableFile *file;
@property (strong, nonatomic) QLPreviewController *previewController;

@end

@implementation TruthTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _expressions = [NSMutableArray new];
    _inputAccessoryView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TruthTableInputAccessoryView class]) owner:self options:nil][0];
    _inputAccessoryView.truthTableDelegate = self;
    _textField.inputAccessoryView = _inputAccessoryView;
    _previewController = [QLPreviewController new];
    _previewController.delegate   = self;
    _previewController.dataSource = self;
    
    self.navigationItem.leftBarButtonItem.title = @"\u2699";
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:32.0]}
                                          forState:UIControlStateNormal];
    [_textField becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [(TruthTableInputAccessoryView *)_textField.inputAccessoryView loadPreferences];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (_textField.text == nil || _textField.text.length < 2) {
        [textField shake: 6];
        return YES;
    }
    TruthTable *truthTable = [[TruthTable alloc] initWithString:textField.text delegate:self];
    #pragma unused(truthTable)
    
    return YES;
}

#pragma mark - TruthTableDelegate
- (void)truthTable:(TruthTable *)truthTable didCreateFile:(TruthTableFile *)file{
    [TruthTableFile saveFile:file];
    _file = file;
    [_previewController reloadData];
    [self presentViewController:_previewController animated:YES completion:nil];
}

#pragma mark - QLPreviewControllerDataSource
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return 1;
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    NSURL *url = [NSURL fileURLWithPath:_file.filePath];
    return url;
}

#pragma mark - QLPreviewControllerDelegate
- (void)previewControllerWillDismiss:(QLPreviewController *)controller {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Save?" message:@"Do you want to save this file?" delegate:self cancelButtonTitle:@"No" otherButtonTitles: @"Yes", nil];
    alertView.delegate = self;
    [alertView show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertViewCancel:(UIAlertView *)alertView {
    [TruthTableFile deleteFileAtIndex:[[TruthTableFile allFiles] count] - 1];
}

#pragma mark - TruthTableInputAccessoryViewDelegate
- (void)truthTableInputAccessoryView:(TruthTableInputAccessoryView *)inputView didType:(NSString *)string {
    UITextPosition* beginning = _textField.beginningOfDocument;
    
    UITextRange* selectedRange = _textField.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    
    const NSInteger location = [_textField offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [_textField offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    NSRange range = NSMakeRange(location, length);
    _textField.text = [_textField.text stringByReplacingCharactersInRange:range withString:string];
}


#pragma mark - User Interation
- (IBAction)goToPreferences:(id)sender {
    PreferencesTableViewController *preferencesController = [PreferencesTableViewController new];
    [self.navigationController pushViewController:preferencesController animated:YES];
}

@end
