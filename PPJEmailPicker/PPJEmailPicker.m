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
@property (strong, nonatomic) NSMutableArray      *selectedEmailUI;
@property (strong, nonatomic) PPJSelectableLabel  *currentSelectedEmail;
@property (strong, nonatomic) NSMutableArray      *possibleStringsFiltered;
@property (assign, nonatomic) UIEdgeInsets         inset;
@property (assign, nonatomic) CGFloat              matchDistance;
@property (assign, nonatomic) CGColorRef           originalShadowColor;
@property (assign, nonatomic) CGSize               originalShadowOffset;
@property (assign, nonatomic) CGFloat              originalShadowOpacity;
@property (assign, nonatomic) CGFloat              minimumHeightTextField;
@end

@implementation PPJEmailPicker

#pragma mark - init override
- (instancetype)init
{
	self = [super init];
	if (self) {
		[self commonInit];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		[self commonInit];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self commonInit];
	}
	return self;
}

-(void) commonInit
{
	self.tableHeight                          = 100.0f;
	_emailPickerTableView                     = [self newEmailPickerTableViewForTextField:self];
	self.inset                                = UIEdgeInsetsZero;
	self.selectedEmailUI                      = [@[] mutableCopy];
	self.selectedEmailList                    = [@[] mutableCopy];
	self.numberOfAutocompleteRows             = 3;
	self.autoCompleteRowHeight                = 44.0f;
	self.autoCompleteTableCellTextColor       = [UIColor blackColor];
	self.autoCompleteTableCellBackgroundColor = [UIColor clearColor];
	self.emailPickerTableView.clipsToBounds   = YES;
	self.pickerBackgroundColor                = [UIColor backgroudDefaultColor];
	self.pickerTextColor                      = [UIColor foregroundDefaultColor];
	self.pickerSelectedTextColor              = [UIColor backgroudDefaultColor];
	self.pickerSelectedBackgroundColor        = [UIColor foregroundDefaultColor];
	super.delegate = self;
	[self registerNotifications];
}

#pragma mark - accessibility 
- (NSString *) accessibilityLabel
{
	NSString * accessbilityStr = @"";
	for (NSString * string in self.selectedEmailList) {
		accessbilityStr = [accessbilityStr stringByAppendingFormat:@"%@ ,",string];
	}
	return [accessbilityStr stringByAppendingString:self.text];
}

#pragma mark - notification Handler

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

#pragma mark - setters and getters
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

#pragma mark - layout
-(void) layoutSubviews
{
	//TODO: Refactor this ugly code
	[super layoutSubviews];
	CGRect finalFrame = self.frame;
	self.inset = UIEdgeInsetsZero;
	for (int i = 1; i < self.selectedEmailUI.count; i++) {
		CGRect frame = ((PPJSelectableLabel *)(self.selectedEmailUI[i-1])).frame;
		PPJSelectableLabel * lbl  = self.selectedEmailUI[i];
		if ((frame.origin.x + frame.size.width) + PPJEMAILPICKER_PADDING_X + lbl.frame.size.width > self.frame.size.width) {
			lbl.frame = CGRectMake(0,
									 frame.origin.y + frame.size.height + PPJEMAILPICKER_PADDING_Y,
									 lbl.frame.size.width,
									 lbl.frame.size.height);
		}
		else {
			lbl.frame = CGRectMake(frame.origin.x + frame.size.width + PPJEMAILPICKER_PADDING_X,
									 frame.origin.y,
									 lbl.frame.size.width,
									 lbl.frame.size.height);
		}
	}
	PPJSelectableLabel * lastElem = (self.selectedEmailUI).lastObject;
	if (lastElem) {
		self.inset = UIEdgeInsetsMake(lastElem.frame.origin.y,
									  lastElem.frame.origin.x + lastElem.frame.size.width,
									  0.0, 0.0);
		CGFloat height = lastElem.frame.origin.y + lastElem.frame.size.height + 2;
		height = (height > 30)? height : 30;
		if (height == 30) {
			for (PPJSelectableLabel * lbl in self.selectedEmailUI) {
				lbl.frame = CGRectMake(lbl.frame.origin.x,
									   (30.0f - lbl.frame.size.height) / 2,
									   lbl.frame.size.width,
									   lbl.frame.size.height);
			}
		}
		finalFrame.size = CGSizeMake(finalFrame.size.width, height);
	}
	
	self.frame = finalFrame;
	self.emailPickerTableView.frame = [self emailPickerTableViewFrameForTextField:self];
}

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
	return UIEdgeInsetsInsetRect([super textRectForBounds:bounds], self.inset);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
	return [self textRectForBounds:bounds];
}

#pragma mark - auxiliary functions
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
		[lbl setTitleColor:self.pickerSelectedTextColor forState:UIControlStateNormal];
		[lbl sizeToFit];
		[self.selectedEmailUI addObject:lbl];
		[self addSubview:lbl];
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
		self.possibleStringsFiltered = [@[] mutableCopy];
		[self closeDropDown];
		return;
	}
	filter = filter.lowercaseString;
	NSMutableArray *m = [NSMutableArray array];
	for (NSString * string in self.possibleStrings) {
		if ([string hasPrefix:filter])
		{
			[m addObject:string];
		}
	}
	[m sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
		return [((NSString*)obj1) compare:((NSString*)obj2)];
	}];
	self.possibleStringsFiltered = m;
	if (![self isDropDownVisible]) {
		[self showDropDown:self.numberOfAutocompleteRows];
	}
	else {
		[self.emailPickerTableView reloadData];
	}
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
	cell.textLabel.textColor = self.autoCompleteTableCellTextColor;
	cell.backgroundColor = self.autoCompleteTableCellBackgroundColor;
	return cell;
}

#pragma mark - Add and Delete emails
- (void) addString:(NSString *)str
{
	[self.selectedEmailList addObject:str];
	PPJSelectableLabel * lbl = [[PPJSelectableLabel alloc] init];
	[lbl setTitle:str forState:UIControlStateNormal];
	[lbl setTitleColor:self.pickerTextColor forState:UIControlStateNormal];
	[lbl sizeToFit];
	[self.selectedEmailUI addObject:lbl];
	[self addSubview:lbl];
	if ([self.pickerDelegate respondsToSelector:@selector(picker:haveArrayOfEmails:)]) {
		[self.pickerDelegate picker:self haveArrayOfEmails:[self.selectedEmailList copy]];
	}
}

- (void) removeCurrentSelectedEmail
{
	if (!self.currentSelectedEmail) {
		self.currentSelectedEmail = (self.selectedEmailUI).lastObject;
	}
	NSString * selectedEmailText = self.currentSelectedEmail.titleLabel.text;
	[self.selectedEmailList removeObject:selectedEmailText];
	[self.selectedEmailUI removeObject:self.currentSelectedEmail];
	[self.currentSelectedEmail removeFromSuperview];
	self.currentSelectedEmail = nil;
	if ([self.pickerDelegate respondsToSelector:@selector(picker:haveArrayOfEmails:)]) {
		[self.pickerDelegate picker:self haveArrayOfEmails:[self.selectedEmailList copy]];
	}
}

#pragma mark -
#pragma mark TableView Delegate
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return self.autoCompleteRowHeight;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self addString:self.possibleStringsFiltered[indexPath.row]];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	self.text = @"";
	[self filterArray:@""];
	[self closeDropDown];
}

#pragma mark -
#pragma mark SubUI Creation

- (UITableView *)newEmailPickerTableViewForTextField:(PPJEmailPicker *)textField
{
	CGRect dropDownTableFrame = [self emailPickerTableViewFrameForTextField:textField];
	
	UITableView *newTableView = [[UITableView alloc] initWithFrame:dropDownTableFrame
															 style:UITableViewStylePlain];
	newTableView.delegate = textField;
	newTableView.dataSource = textField;
	[newTableView setScrollEnabled:YES];
	newTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
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

- (void)saveCurrentShadowProperties
{
	self.originalShadowColor = self.layer.shadowColor;
	self.originalShadowOffset = self.layer.shadowOffset;
	self.originalShadowOpacity = self.layer.shadowOpacity;
}

- (void)restoreOriginalShadowProperties
{
	(self.layer).shadowColor = self.originalShadowColor;
	(self.layer).shadowOffset = self.originalShadowOffset;
	(self.layer).shadowOpacity = self.originalShadowOpacity;
}

- (void)closeDropDown
{
	[self.emailPickerTableView removeFromSuperview];
	[self restoreOriginalShadowProperties];
	if ([self.pickerDelegate respondsToSelector:@selector(picker:displayCompletionStateChange:)]) {
		[self.pickerDelegate picker:self displayCompletionStateChange:NO];
	}
	if ([self.pickerDelegate respondsToSelector:@selector(picker:changedHeight:)]) {
		CGFloat diff = self.frame.size.height - 30.0;
		[self.pickerDelegate picker:self changedHeight:diff];
	}
}

- (BOOL)isDropDownVisible
{
	if (self.emailPickerTableView.superview) {
		return YES;
	}
	return NO;
}

-(void) showDropDown:(NSInteger)numberOfRows
{

	if (numberOfRows) {
		self.emailPickerTableView.alpha = 1.0;
		if (!self.emailPickerTableView.superview) {

		}

		[self.superview bringSubviewToFront:self];
		[self.superview insertSubview:self.emailPickerTableView
			   belowSubview:self];
		[self.emailPickerTableView setUserInteractionEnabled:YES];
		if(self.makeTextFieldDropShadowWithAutoCompleteTableOpen)
		{
			(self.layer).shadowColor = [UIColor blackColor].CGColor;
			(self.layer).shadowOffset = CGSizeMake(0, 1);
			(self.layer).shadowOpacity = 0.35;
		}
		if ([self.pickerDelegate respondsToSelector:@selector(picker:displayCompletionStateChange:)]) {
			[self.pickerDelegate picker:self displayCompletionStateChange:YES];
		}
		if ([self.pickerDelegate respondsToSelector:@selector(picker:changedHeight:)]) {
			CGFloat diff = self.frame.size.height - 30.0;
			[self.pickerDelegate picker:self changedHeight:diff + numberOfRows*self.autoCompleteRowHeight];
		}
	} else {
		[self closeDropDown];
		[self restoreOriginalShadowProperties];
		(self.emailPickerTableView.layer).shadowOpacity = 0.0;
	}

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

-(BOOL) resignFirstResponder
{
	[self closeDropDown];
	return [super resignFirstResponder];
}

-(BOOL) becomeFirstResponder
{
	BOOL superAnswer = [super becomeFirstResponder];
	if (superAnswer) {
//		dispatch_async(dispatch_get_main_queue(), ^{
//			[self showDropDown:3];
//		});
	}
	return superAnswer;
}


#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	if ([string isEqualToString:@" "]) {
		NSString * add = textField.text;
		if (add.length > 0) {
			[self addString:add];
			[self closeDropDown];
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
		[self closeDropDown];
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
