//
//  PPJEmailPicker.h
//  PPJEmailPickerDemo
//
//  Created by Pedro Paulo Oliveira Junior on 17/05/16.
//  Copyright © 2016 Netfilter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPJSelectableLabel.h"

@protocol PPJEmailPickerDelegate;

@interface PPJEmailPicker : UITextField <UITableViewDelegate, UITableViewDataSource>

@property (assign, nonatomic) id<PPJEmailPickerDelegate>   pickerDelegate;
@property (strong, readonly ) UITableView                 *emailPickerTableView;
@property (assign, nonatomic) BOOL                         emailPickerTableViewHidden;
@property (assign, nonatomic) BOOL                         makeTextFieldDropShadowWithAutoCompleteTableOpen;
@property (assign, nonatomic) CGRect                       emailPickerTableViewFrame;
@property (copy,  nonatomic ) NSMutableArray              *selectedEmailList;
@property (copy,  nonatomic ) NSArray                     *possibleStrings;
@property (assign, nonatomic) CGFloat                      minimumHeight;
@property (assign, nonatomic) CGFloat                      autoCompleteRowHeight;
@property (assign, nonatomic) NSInteger                    numberOfAutocompleteRows;
@property (strong, nonatomic) UIColor                     *autoCompleteTableCellTextColor;
@property (strong, nonatomic) UIColor                     *autoCompleteTableCellBackgroundColor;
@property (strong, nonatomic) UIColor                     *pickerBackgroundColor;
@property (strong, nonatomic) UIColor                     *pickerTextColor;
@property (strong, nonatomic) UIColor                     *pickerSelectedTextColor;
@property (strong, nonatomic) UIColor                     *pickerSelectedBackgroundColor;
@property (strong, nonatomic) UIFont                      *autoCompleteTextFont;
@property (assign, nonatomic) BOOL                         showPlaceholderWhileEditing;


//
- (BOOL)PPJ_TextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
- (BOOL)PPJ_textFieldShouldReturn:(UITextField *)txtField;
- (BOOL)PPJ_textFieldShouldEndEditing:(UITextField *)txtField;


-(void) showDropDown:(NSInteger)numberOfRows;
-(void) renderList;

@end


@protocol PPJEmailPickerDelegate <NSObject>

@optional
-(void) picker:(PPJEmailPicker *)picker changedHeight:(CGFloat)height;
-(void) picker:(PPJEmailPicker *)picker displayCompletionStateChange:(BOOL)visible;
-(void) picker:(PPJEmailPicker *)picker haveArrayOfEmails:(NSArray *)emails;

@end