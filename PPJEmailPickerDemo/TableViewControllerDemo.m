//
//  TableViewControllerDemo.m
//  PPJEmailPickerDemo
//
//  Created by Pedro Paulo Oliveira Junior on 19/05/16.
//  Copyright © 2016 Netfilter. All rights reserved.
//

#import "TableViewControllerDemo.h"
#import "PPJEmailPicker.h"
#import "ListOfEmails.h"

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
//	actf.textColor = [UIColor greenColor];
//	actf.backgroundColor = [UIColor clearColor];
	actf.pickerDelegate = self;
	actf.emailPickerTableView.clipsToBounds = YES;
	// Cells and Table color
//	actf.emailPickerTableView.backgroundColor = [UIColor whiteColor];
	actf.possibleStrings = [[ListOfEmails emails] mutableCopy];
	actf.placeholder = NSLocalizedString(@"Type e-mail to send recognition", nil);
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
	if (indexPath.row == 0){
		return 44 + self.autocompleteHeight;
	}else {
		return 44;
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

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width,50)];
	return view;
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

-(void) picker:(PPJEmailPicker *)picker changedHeight:(CGFloat)height
{
	self.autocompleteHeight = height;
}
@end
