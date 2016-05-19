//
//  PPJEmailPicker.m
//  PPJEmailPickerDemo
//
//  Created by Pedro Paulo Oliveira Junior on 17/05/16.
//  Copyright © 2016 Netfilter. All rights reserved.
//

#import "PPJEmailPicker.h"
#import "PPJCommon.h"
#define PPJEMAILPICKER_PADDING_X 5
#define PPJEMAILPICKER_PADDING_Y 2



@interface PPJEmailPicker ()
@property (strong, nonatomic) NSMutableArray *selectedEmailUI;
@property (assign, nonatomic) CGPoint inset;
@property (strong, nonatomic) PPJSelectableLabel *currentSelectedEmail;
@property (strong, nonatomic) NSMutableArray *possibleStringsFiltered;
@end

@implementation PPJEmailPicker

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		_tableHeight = 100.0f;
		_emailPickerTableView = [self newEmailPickerTableViewForTextField:self];
		_inset = CGPointZero;
		[super setDelegate:self];
		[self registerNotifications];
	}
	return self;
}

-(void) registerNotifications
{
	NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
	
	[center addObserver:self
			   selector:@selector(selectedLabel:)
				   name:kPPJSelectableLabelNotification
				 object:nil];
	
	[center addObserver:self
			   selector:@selector(unSelectedLabel:)
				   name:kPPJUnSelectableLabelNotification
				 object:nil];

}

-(void) selectedLabel:(NSNotification *)aNotification
{
	PPJSelectableLabel * selected = (PPJSelectableLabel *) aNotification.object;
	for (PPJSelectableLabel * lbl in self.selectedEmailUI) {
		if (![lbl isEqual:selected]) {
			[lbl deselect];
		}
	}
	self.currentSelectedEmail = selected;
}

-(void) unSelectedLabel:(NSNotification *)aNotification
{
	self.currentSelectedEmail = nil;
}

- (void)setDelegate:(id<UITextFieldDelegate>)delegate
{
	[self willChangeValueForKey:@"delegate"];
	self.originalDelegate = delegate;
	[self didChangeValueForKey:@"delegate"];
}

- (id<UITextFieldDelegate>)delegate
{
	return self.originalDelegate;
}

-(void) setSelectedEmailList:(NSMutableArray *)selectedEmailList
{
	if (![_selectedEmailList isEqual:selectedEmailList]) {
		_selectedEmailList = [selectedEmailList mutableCopy];
		[self renderList];
	}
}

-(void) layoutSubviews
{
	[super layoutSubviews];
	CGRect finalFrame = self.frame;
	for (int i = 1; i < self.selectedEmailUI.count; i++) {
		CGRect frame = ((PPJSelectableLabel *)(self.selectedEmailUI[i-1])).frame;
		PPJSelectableLabel * lbl  = self.selectedEmailUI[i];
		if ((frame.origin.x + frame.size.width) + PPJEMAILPICKER_PADDING_X + lbl.frame.size.width > self.frame.size.width) {
			[lbl setFrame:CGRectMake(0,
									 frame.origin.y + frame.size.height + PPJEMAILPICKER_PADDING_Y,
									 lbl.frame.size.width,
									 lbl.frame.size.height)];
			finalFrame  = CGRectMake(self.frame.origin.x,
									 self.frame.origin.y,
									 self.frame.size.width,
									 frame.origin.y + frame.size.height
									 + lbl.frame.size.height + 2*PPJEMAILPICKER_PADDING_Y);
		}
		else {
			[lbl setFrame:CGRectMake(frame.origin.x + frame.size.width + PPJEMAILPICKER_PADDING_X,
									 frame.origin.y,
									 lbl.frame.size.width,
									 lbl.frame.size.height)];
		}
		self.inset = CGPointMake(lbl.frame.origin.x + lbl.frame.size.width,
								 lbl.frame.origin.y);
	}
	self.frame = finalFrame;
	self.emailPickerTableView.frame = [self emailPickerTableViewFrameForTextField:self];
}

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
	return CGRectMake(self.inset.x + 2,
					  self.inset.y + 2,
					  self.frame.size.width - self.inset.x - 2,
					  30);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
	return CGRectMake(self.inset.x + 2,
					  self.inset.y + 2,
					  self.frame.size.width - self.inset.x - 2,
					  30);
}

-(void) renderList
{
	for (UIView * v in self.subviews) {
		if ([v isKindOfClass:[PPJSelectableLabel class]]) {
			[v removeFromSuperview];
		}
	}
	self.selectedEmailUI = [@[] mutableCopy];
	for (NSString * s in self.selectedEmailList) {
		PPJSelectableLabel * lbl = [[PPJSelectableLabel alloc] init];
		[lbl setTitle:s forState:UIControlStateNormal];
		[lbl setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
		[lbl sizeToFit];
		[self addSubview:lbl];
		[self.selectedEmailUI addObject:lbl];
	}
}

#pragma mark - Filter Array
-(void) setPossibleStrings:(NSArray *)possibleStrings
{
	_possibleStrings = [possibleStrings copy];
	[self filterArray:self.text];
}

-(void) filterArray:(NSString *)filter
{
	if (filter.length == 0) {
		self.possibleStringsFiltered = [self.possibleStrings mutableCopy];
		[self.emailPickerTableView reloadData];
		return;
	}
	NSMutableArray *m = [NSMutableArray array];
	for (NSString * string in self.possibleStrings) {
		if ([string rangeOfString:filter].location != NSNotFound)
		{
			[m addObject:string];
		}
	}
	self.possibleStringsFiltered = m;
	[self.emailPickerTableView reloadData];
	
}

#pragma mark - TableView Data Source
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
	return (self.possibleStringsFiltered.count > 0)?1:0;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return (self.possibleStringsFiltered.count > 3)?3:self.possibleStringsFiltered.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *cellIdentifier = @"PPJEmailPickerTableViewCell";
	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
	cell.textLabel.text = self.possibleStringsFiltered[indexPath.row];
	return cell;
}

#pragma mark - Add and Delete
- (void) addString:(NSString *)str
{
	[self.selectedEmailList addObject:str];
	PPJSelectableLabel * lbl = [[PPJSelectableLabel alloc] init];
	[lbl setTitle:str forState:UIControlStateNormal];
	[lbl setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
	[lbl sizeToFit];
	[self addSubview:lbl];
	[self.selectedEmailUI addObject:lbl];
}

- (void) removeCurrentSelectedEmail
{
	if (!self.currentSelectedEmail) {
		self.currentSelectedEmail = [self.selectedEmailUI lastObject];
	}
	NSString * selectedEmailText = self.currentSelectedEmail.titleLabel.text;
	[self.selectedEmailList removeObject:selectedEmailText];
	[self.selectedEmailUI removeObject:self.currentSelectedEmail];
	[self.currentSelectedEmail removeFromSuperview];
	self.currentSelectedEmail = nil;
}

#pragma mark -
#pragma mark TableView Delegate
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self addString:self.possibleStringsFiltered[indexPath.row]];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	self.text = @"";
	[self filterArray:@""];
}

#pragma mark -
#pragma mark SubUI Creation

- (UITableView *)newEmailPickerTableViewForTextField:(PPJEmailPicker *)textField
{
	CGRect dropDownTableFrame = [self emailPickerTableViewFrameForTextField:textField];
	
	UITableView *newTableView = [[UITableView alloc] initWithFrame:dropDownTableFrame
															 style:UITableViewStylePlain];
	[newTableView setDelegate:textField];
	[newTableView setDataSource:textField];
	[newTableView setScrollEnabled:YES];
	[newTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	
	return newTableView;
}

- (CGRect)emailPickerTableViewFrameForTextField:(PPJEmailPicker *)textField
{
	CGRect frame = CGRectZero;
	
	if (CGRectGetWidth(self.emailPickerTableViewFrame) > 0){
		frame = self.emailPickerTableViewFrame;
	} else {
		frame = textField.frame;
		frame.origin.y += textField.frame.size.height;
	}
	
	frame.size.height += textField.tableHeight;
	frame = CGRectInset(frame, 1, 0);
	
	return frame;
}

-(void) showDropDown
{
	[self.superview bringSubviewToFront:self];
	UIView *rootView = [self.window.subviews objectAtIndex:0];
	[rootView insertSubview:self.emailPickerTableView
			   belowSubview:self];
}

#pragma mark -
#pragma mark Method Override

-(void) deleteBackward
{
	if (self.text.length == 0) {
		[self removeCurrentSelectedEmail];
	}
	[super deleteBackward];
}


#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	if ([string isEqualToString:@" "]) {
		NSString * add = textField.text;
		if (add.length > 0) {
			[self addString:add];
			textField.text = @"";
		}
		return NO;
	}
	[self filterArray:[textField.text stringByAppendingString:string]];
	if ([self.originalDelegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
		return [self.originalDelegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
	}
	
	return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)txtField
{
	NSString * add = txtField.text;
	if (add.length > 0) {
		[self addString:add];
		txtField.text = @"";
	}
	return NO;
}

#pragma mark -
#pragma mark NSObject method overrides

- (id)forwardingTargetForSelector:(SEL)aSelector
{
	if ([self.originalDelegate respondsToSelector:aSelector] && self.originalDelegate != self) {
		return self.originalDelegate;
	}
	return [super forwardingTargetForSelector:aSelector];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
	BOOL respondsToSelector = [super respondsToSelector:aSelector];
	
	if (!respondsToSelector && self.originalDelegate != self) {
		respondsToSelector = [self.originalDelegate respondsToSelector:aSelector];
	}
	return respondsToSelector;
}

@end
