//
//  ViewController.m
//  PPJEmailPickerDemo
//
//  Created by Pedro Paulo Oliveira Junior on 17/05/16.
//  Copyright © 2016 Netfilter. All rights reserved.
//

#import "ViewController.h"
#import "PPJEmailPicker.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet PPJEmailPicker *emailPicker;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.emailPicker.possibleStrings = @[@"uuu@uu.com",@"aaa.aa.com",@"abc@cba.com",@"pqpq@ppp.com",@"fak@git.com"];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}
- (IBAction)ShowTable:(id)sender {
	[self.emailPicker showDropDown:3];
	self.emailPicker.selectedEmailList = [@[@"ppaulojr@usp.br", @"abc@google.com",@"ppaulojr@gmail.com",@"ppj@netfilter.com.br",@"sjobs@apple.com"] mutableCopy];
}

@end
