//
//  PPJSelectableLabel.h
//  PPJEmailPickerDemo
//
//  Created by Pedro Paulo Oliveira Junior on 17/05/16.
//  Copyright © 2016 Netfilter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPJSelectableLabel : UIButton
@property (nonatomic, strong) UIColor  *labelBackgroundColor;
@property (nonatomic, strong) UIColor  *labelTextColor;
@property (nonatomic, strong) UIColor  *labelSelectedTextColor;
@property (nonatomic, strong) UIColor  *labelSelectedBackgroundColor;
-(void) deselect;
@end
