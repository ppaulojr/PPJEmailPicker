//
//  PPJSelectableLabel.h
//  PPJEmailPickerDemo
//
//  Created by Pedro Paulo Oliveira Junior on 17/05/16.
//  Copyright © 2016 Netfilter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPJSelectableLabel : UIButton
@property (strong) UIColor  *labelBackgroundColor;
@property (strong) UIColor  *labelTextColor;
@property (strong) UIColor  *labelSelectedTextColor;
@property (strong) UIColor  *labelSelectedBackgroundColor;
-(void) deselect;
@end
