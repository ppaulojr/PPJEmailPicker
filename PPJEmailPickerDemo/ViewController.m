//
//  ViewController.m
//  PPJEmailPickerDemo
//
//  Created by Pedro Paulo Oliveira Junior on 17/05/16.
//  Copyright © 2016 Netfilter. All rights reserved.
//

#import "ViewController.h"
#import "PPJEmailPicker.h"
#import "ListOfEmails.h"

@interface ViewController () <PPJEmailPickerDelegate>
@property (weak, nonatomic) IBOutlet PPJEmailPicker *emailPicker;
@property (weak, nonatomic) IBOutlet UITextView *emailResults;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.emailPicker.possibleStrings = [ListOfEmails emails];
	self.emailPicker.pickerDelegate = self;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


-(void) picker:(PPJEmailPicker *)picker haveArrayOfEmails:(NSArray *)emails
{
	NSString * strFinal = @"";
	for (NSString *str in emails) {
		strFinal = [strFinal stringByAppendingString:@"\n"];
		strFinal = [strFinal stringByAppendingString:str];
	}
	self.emailResults.text = strFinal;
}

@end
