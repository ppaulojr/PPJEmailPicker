//
//  UIColor+Additions.m
//  PPJEmailPickerDemo
//
//  Created by Pedro Paulo Oliveira Junior on 19/05/16.
//  Copyright © 2016 Netfilter. All rights reserved.
//

#import "UIColor+Additions.h"

@implementation UIColor (Additions)

+(UIColor *) backgroudDefaultColor
{
	CGFloat red = 217 / 255.0f;
	CGFloat green = 234 / 255.0f;
	CGFloat blue = 246 / 255.0f;
	return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

+(UIColor *) foregroundDefaultColor
{
	CGFloat red = 0.0f;
	CGFloat green = 73 / 255.0f;
	CGFloat blue = 180  / 255.0f;
	return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}
@end
