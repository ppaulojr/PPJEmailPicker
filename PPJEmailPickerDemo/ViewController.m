//
//  ViewController.m
//  PPJEmailPickerDemo
//
//  Created by Pedro Paulo Oliveira Junior on 17/05/16.
//  Copyright © 2016 Netfilter. All rights reserved.
//

#import "ViewController.h"
#import "PPJEmailPicker.h"

@interface ViewController () <PPJEmailPickerDelegate>
@property (weak, nonatomic) IBOutlet PPJEmailPicker *emailPicker;
@property (weak, nonatomic) IBOutlet UITextView *emailResults;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.emailPicker.possibleStrings = @[@"uuu@uu.com",@"aaa.aa.com",@"abc@cba.com",@"pqpq@ppp.com",@"fak@git.com"];
	self.emailPicker.pickerDelegate = self;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}
- (IBAction)ShowTable:(id)sender {
	[self.emailPicker showDropDown:3];
	self.emailPicker.selectedEmailList = [@[@"ppaulojr@usp.br", @"abc@google.com",@"ppaulojr@gmail.com",@"ppj@netfilter.com.br",@"sjobs@apple.com"] mutableCopy];
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
