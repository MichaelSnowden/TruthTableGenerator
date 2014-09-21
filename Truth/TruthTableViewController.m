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
#import "UITextField+Shake.h"
#import "UITextField+Cursor.h"
#import <QuickLook/QuickLook.h>

@interface TruthTableViewController () < UITextFieldDelegate, TruthTableDelegate, QLPreviewControllerDataSource, TruthTableInputAccessoryViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *expressions;
@property (strong, nonatomic) NSString *filePath;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) TruthTableInputAccessoryView *inputAccessoryView;

@end

@implementation TruthTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _expressions = [NSMutableArray new];
    _inputAccessoryView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TruthTableInputAccessoryView class]) owner:self options:nil][0];
    _inputAccessoryView.truthTableDelegate = self;
    _textField.inputAccessoryView = _inputAccessoryView;
}

- (void)viewWillAppear:(BOOL)animated {
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (_textField.text == nil || _textField.text.length < 1) {
        [textField shake: 6];
        return YES;
    }
    TruthTable *truthTable = [[TruthTable alloc] initWithString:textField.text delegate:self];
    #pragma unused(truthTable)
    
    return YES;
}

#pragma mark - TruthTableDelegate
- (void)truthTable:(TruthTable *)truthTable didSaveExcelToFilePath:(NSString *)filePath {
    _filePath = filePath;
    
    QLPreviewController *previewController = [[QLPreviewController alloc] init];
    previewController.dataSource = self;
    [previewController setCurrentPreviewItemIndex:0];
    
    [self presentViewController:previewController animated:true completion:nil];
}

#pragma mark - QLPreviewControllerDataSource
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return 1;
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    NSURL *url = [NSURL fileURLWithPath:_filePath];
    return url;
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
