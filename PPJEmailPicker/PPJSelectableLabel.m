//
//  PPJSelectableLabel.m
//  PPJEmailPickerDemo
//
//  Created by Pedro Paulo Oliveira Junior on 17/05/16.
//  Copyright © 2016 Netfilter. All rights reserved.
//

#import "PPJSelectableLabel.h"
#import "PPJCommon.h"

@interface PPJSelectableLabel ()
@property (assign, nonatomic) BOOL isSelectedUI;
@end

@implementation PPJSelectableLabel

- (instancetype)init
{
	self = [super init];
	if (self) {
		[self commonInit];
	}
	return self;
}

-(void) setIsSelectedUI:(BOOL)isSelectedUI
{
	_isSelectedUI = isSelectedUI;
	if (isSelectedUI) {
		self.layer.backgroundColor = (self.labelSelectedBackgroundColor).CGColor;
		[super setTitleColor:self.labelSelectedTextColor forState:UIControlStateNormal];
	}
	else {
		self.layer.backgroundColor = (self.labelBackgroundColor).CGColor;
		[super setTitleColor:self.labelTextColor forState:UIControlStateNormal];
	}
}


-(void) setLabelTextColor:(UIColor *)labelTextColor
{
	_labelTextColor = labelTextColor;
	self.titleLabel.textColor = _labelTextColor;
}

-(void) setLabelBackgroundColor:(UIColor *)labelBackgroundColor
{
	_labelBackgroundColor = labelBackgroundColor;
	self.layer.backgroundColor = [_labelBackgroundColor CGColor];
}

-(void) commonInit
{
	[self addTarget:self action:@selector(didTouchButton) forControlEvents:UIControlEventTouchUpInside];
	self.layer.cornerRadius = 3.0f;
	self.labelBackgroundColor = [UIColor backgroudDefaultColor];
	self.labelTextColor = [UIColor foregroundDefaultColor];
	self.labelSelectedTextColor = [UIColor backgroudDefaultColor];
	self.labelSelectedBackgroundColor = [UIColor foregroundDefaultColor];
	self.titleLabel.font = [UIFont systemFontOfSize:13.0f];
	self.contentEdgeInsets = UIEdgeInsetsMake(1.0, 5.0, 1.0, 5.0);
}

-(void) layoutSubviews
{
	[super layoutSubviews];
}

- (CGSize)intrinsicContentSize {
	//
	CGSize size;
	
	self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x,
            self.titleLabel.frame.origin.y,
            self.frame.size.width - self.contentEdgeInsets.left - self.contentEdgeInsets.right - self.titleEdgeInsets.left - self.titleEdgeInsets.right,
            0);
	size = [self.titleLabel sizeThatFits:self.titleLabel.frame.size];
	size = CGSizeMake(size.width, size.height + 20);
	
	return size;
}


-(void) didTouchButton
{
	if (!_isSelectedUI) {
		[[NSNotificationCenter defaultCenter] postNotificationName:kPPJSelectableLabelNotification object:self];
		self.isSelectedUI = YES;
	}
	else {
		[[NSNotificationCenter defaultCenter] postNotificationName:kPPJUnSelectableLabelNotification object:self];
		self.isSelectedUI = NO;

	}
}

-(void) deselect
{
	self.isSelectedUI = NO;
}

@end
