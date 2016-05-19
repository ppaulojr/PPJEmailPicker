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
		self.layer.backgroundColor = [[UIColor foregroundDefaultColor] CGColor];
		[super setTitleColor:[UIColor backgroudDefaultColor] forState:UIControlStateNormal];
	}
	else {
		self.layer.backgroundColor = [[UIColor backgroudDefaultColor] CGColor];
		[super setTitleColor:[UIColor foregroundDefaultColor] forState:UIControlStateNormal];
	}
}

-(void) commonInit
{
	[self addTarget:self action:@selector(didTouchButton) forControlEvents:UIControlEventTouchUpInside];
	self.layer.cornerRadius = 3.0f;
	self.layer.backgroundColor = [[UIColor backgroudDefaultColor] CGColor];
	self.titleLabel.textColor = [UIColor foregroundDefaultColor];
	
}

-(void) layoutSubviews
{
	[super layoutSubviews];
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
