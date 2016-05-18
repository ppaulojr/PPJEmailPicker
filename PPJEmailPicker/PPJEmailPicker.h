//
//  PPJEmailPicker.h
//  PPJEmailPickerDemo
//
//  Created by Pedro Paulo Oliveira Junior on 17/05/16.
//  Copyright © 2016 Netfilter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPJSelectableLabel.h"
#

@interface PPJEmailPicker : UITextField <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (strong, readonly, nonatomic) UITableView *emailPickerTableView;
@property (assign, nonatomic) BOOL emailPickerTableViewHidden;
@property (assign, nonatomic) CGRect emailPickerTableViewFrame;
@property (assign, nonatomic) CGFloat tableHeight;
@property (copy, nonatomic) NSMutableArray *selectedEmailList;
@property (assign, nonatomic) id<UITextFieldDelegate> originalDelegate;

-(void) showDropDown;

@end
