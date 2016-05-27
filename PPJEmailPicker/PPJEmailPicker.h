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

@property (assign          ) id<PPJEmailPickerDelegate>   pickerDelegate;
@property (strong, readonly) UITableView                 *emailPickerTableView;
@property (assign          ) BOOL                         emailPickerTableViewHidden;
@property (assign          ) BOOL                         makeTextFieldDropShadowWithAutoCompleteTableOpen;
@property (assign          ) CGRect                       emailPickerTableViewFrame;
@property (assign          ) CGFloat                      tableHeight;
@property (copy, nonatomic ) NSMutableArray              *selectedEmailList;
@property (copy, nonatomic ) NSArray                     *possibleStrings;
@property (assign          ) CGFloat                      minimumHeight;
@property (assign          ) CGFloat                      autoCompleteRowHeight;
@property (assign          ) NSInteger                    numberOfAutocompleteRows;
@property (strong          ) UIColor					 *autoCompleteTableCellTextColor;
@property (strong          ) UIColor					 *autoCompleteTableCellBackgroundColor;
@property (strong          ) UIColor					 *pickerBackgroundColor;
@property (strong          ) UIColor					 *pickerTextColor;
@property (strong          ) UIColor					 *pickerSelectedTextColor;
@property (strong          ) UIColor					 *pickerSelectedBackgroundColor;









//@property NSString * autoCompleteRegularFontName = HelveticaNeue;
//@property CGFloat autoCompleteFontSize = 13.0;
//
- (BOOL)PPJ_TextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
- (BOOL)PPJ_textFieldShouldReturn:(UITextField *)txtField;


-(void) showDropDown:(NSInteger)numberOfRows;


@end


@protocol PPJEmailPickerDelegate <NSObject>

@optional
-(void) picker:(PPJEmailPicker *)picker changedHeight:(CGFloat)height;
-(void) picker:(PPJEmailPicker *)picker displayCompletionStateChange:(BOOL)visible;
-(void) picker:(PPJEmailPicker *)picker haveArrayOfEmails:(NSArray *)emails;

@end