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
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}
- (IBAction)ShowTable:(id)sender {
	[self.emailPicker showDropDown];
	self.emailPicker.selectedEmailList = [@[@"ppaulojr@usp.br", @"abc@google.com",@"ppaulojr@gmail.com",@"ppj@netfilter.com.br",@"sjobs@apple.com"] mutableCopy];
}

@end
