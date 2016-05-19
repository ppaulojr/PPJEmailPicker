//
//  TableViewControllerDemo.m
//  PPJEmailPickerDemo
//
//  Created by Pedro Paulo Oliveira Junior on 19/05/16.
//  Copyright © 2016 Netfilter. All rights reserved.
//

#import "TableViewControllerDemo.h"
#import "PPJEmailPicker.h"

@interface TableViewControllerDemo() <PPJEmailPickerDelegate>
@property (assign, nonatomic) CGFloat autocompleteHeight;
@end

@implementation TableViewControllerDemo

-(PPJEmailPicker *) createAutoCompleteFieldWithFrame:(CGRect)frame
{
	PPJEmailPicker * actf = [[PPJEmailPicker alloc] initWithFrame:frame];
	actf.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	actf.font = [UIFont systemFontOfSize:14.0];
	actf.autocorrectionType = UITextAutocorrectionTypeNo;
//	actf.emailPickerRegularFontName = @"Helvetica-Neue";
//	actf.emailPickerFontSize = FONT_SIZE_PATIENT_NAME_HISTORY;
	actf.textColor = [UIColor greenColor];
	actf.backgroundColor = [UIColor clearColor];
//	actf.autoCompleteDataSource = self;
	actf.pickerDelegate = self;
	actf.emailPickerTableView.clipsToBounds = YES;
	// Cells and Table color
	actf.emailPickerTableView.backgroundColor = [UIColor whiteColor];
	actf.possibleStrings = @[@"uuu@uu.com",@"aaa.aa.com",@"abc@cba.com",@"pqpq@ppp.com",@"fak@git.com"];


	return actf;
}

-(void) setAutocompleteHeight:(CGFloat)autocompleteHeight
{
	_autocompleteHeight = autocompleteHeight;
	__weak typeof(self) weakSelf = self;
	dispatch_async(dispatch_get_main_queue(), ^{
		[weakSelf.tableView beginUpdates];
		[weakSelf.tableView endUpdates];
	});
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0){
		return 50 + self.autocompleteHeight;
	}else {
		return 50;
	}
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 3;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString * cellId = @"com.demo.cellid01";
	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
	}
	switch (indexPath.row) {
	    case 0:
		{
			PPJEmailPicker * picker = [self createAutoCompleteFieldWithFrame:cell.contentView.frame];
			[cell.contentView addSubview:picker];
			break;
		}
	    default:
		{
			cell.textLabel.text = @"Oi";
			break;
		}
	}
	return cell;
}

-(void) picker:(PPJEmailPicker *)picker displayCompletionStateChange:(BOOL)visible
{
	if (visible) {
		self.autocompleteHeight = 3*44;
	}
	else {
		self.autocompleteHeight = 0;
	}
}
@end
