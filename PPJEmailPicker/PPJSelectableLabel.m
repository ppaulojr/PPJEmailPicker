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
		self.layer.backgroundColor = [[UIColor lightGrayColor] CGColor];
	}
	else {
		self.layer.backgroundColor = [[UIColor clearColor] CGColor];
	}
}

-(void) commonInit
{
	[self addTarget:self action:@selector(didTouchButton) forControlEvents:UIControlEventTouchUpInside];
	self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
	self.layer.borderWidth = 1.0f;
	self.layer.cornerRadius = 5.0f;
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
