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

@interface PPJUITextFieldPrivateDelegate : NSObject <UITextFieldDelegate> {
@public
	id<UITextFieldDelegate> _userDelegate;
}
@end

@implementation PPJUITextFieldPrivateDelegate

- (BOOL)respondsToSelector:(SEL)selector {
	return [_userDelegate respondsToSelector:selector] || [super respondsToSelector:selector];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
	[invocation invokeWithTarget:_userDelegate];
}

#pragma mark - delegate override methods
- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	BOOL resp = [(PPJEmailPicker *)textField PPJ_TextField:textField shouldChangeCharactersInRange:range replacementString:string];
	if (resp && [_userDelegate respondsToSelector:_cmd]) {
		resp = resp && [_userDelegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
	}
	return resp;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
	BOOL resp = [(PPJEmailPicker *)textField PPJ_textFieldShouldReturn:textField];
	if (resp && [_userDelegate respondsToSelector:_cmd]) {
		resp = resp && [_userDelegate textFieldShouldReturn:textField];
	}
	return resp;
}

@end

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
@property (copy,   nonatomic) NSString            *tmpPlaceholder;
@end

@implementation PPJEmailPicker {
	PPJUITextFieldPrivateDelegate * _privateDelegate;
}

#pragma mark - private delegate;
- (void) initDelegate
{
	_privateDelegate = [[PPJUITextFieldPrivateDelegate alloc] init];
	super.delegate = _privateDelegate;
}

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
	[self initDelegate];
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
	_privateDelegate->_userDelegate = delegate;
	super.delegate = nil;
	super.delegate = _privateDelegate;
}

- (id<UITextFieldDelegate>)delegate
{
	return _privateDelegate->_userDelegate;
}

- (NSString *) placeholder
{
    return super.placeholder;
}

- (void) setPlaceholder:(NSString *)placeholder
{
    if (super.placeholder != nil)
    {
        _tmpPlaceholder = super.placeholder;
    }
    super.placeholder = placeholder;
}

-(void) setSelectedEmailList:(NSMutableArray *)selectedEmailList
{
	if (![_selectedEmailList isEqual:selectedEmailList]) {
		_selectedEmailList = [selectedEmailList mutableCopy];
		[self renderList];
	}
}

- (UIFont *) autoCompleteTextFont
{
	if (!_autoCompleteTextFont) {
		_autoCompleteTextFont = [UIFont systemFontOfSize:13.0f];
	}
	return _autoCompleteTextFont;
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
		lbl.labelTextColor = self.pickerTextColor;
		lbl.backgroundColor = self.pickerBackgroundColor;
		lbl.labelSelectedTextColor = self.pickerSelectedTextColor;
		lbl.labelSelectedBackgroundColor = self.pickerSelectedBackgroundColor;
		[lbl setTitle:s forState:UIControlStateNormal];
		[lbl setTitleColor:self.pickerSelectedTextColor forState:UIControlStateNormal];
		lbl.titleLabel.font = self.autoCompleteTextFont;
		[lbl sizeToFit];
		[self.selectedEmailUI addObject:lbl];
		[self addSubview:lbl];
        if (!self.showPlaceholderWhileEditing) {
            self.placeholder = nil;
        }
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
	NSInteger count = (m.count > self.numberOfAutocompleteRows)?self.numberOfAutocompleteRows : m.count;
	self.possibleStringsFiltered = m;
	if (count == 0) {
		[self closeDropDown];
		return;
	}
	if (![self isDropDownVisible]) {
		[self showDropDown:count];
	}
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
	cell.textLabel.textColor = self.autoCompleteTableCellTextColor;
	cell.backgroundColor = self.autoCompleteTableCellBackgroundColor;
	return cell;
}

#pragma mark - Add and Delete emails
- (void) addString:(NSString *)str
{
	[self.selectedEmailList addObject:str];
	PPJSelectableLabel * lbl = [[PPJSelectableLabel alloc] init];
	lbl.labelTextColor = self.pickerTextColor;
	lbl.labelBackgroundColor = self.pickerBackgroundColor;
	lbl.labelSelectedTextColor = self.pickerSelectedTextColor;
	lbl.labelSelectedBackgroundColor = self.pickerSelectedBackgroundColor;
	[lbl setTitle:str forState:UIControlStateNormal];
	[lbl setTitleColor:self.pickerTextColor forState:UIControlStateNormal];
	lbl.titleLabel.font = self.autoCompleteTextFont;
	[lbl sizeToFit];
	[self.selectedEmailUI addObject:lbl];
	[self addSubview:lbl];
    if (!self.showPlaceholderWhileEditing) {
        self.placeholder = nil;
    }
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
	[self layoutSubviews];
	self.currentSelectedEmail = nil;
    if (self.selectedEmailUI.count == 0) {
        if (!self.showPlaceholderWhileEditing) {
            super.placeholder = self.tmpPlaceholder;
        }
    }
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
	if (self.currentSelectedEmail) {
		// remove and don't call super
		[self removeCurrentSelectedEmail];
		return;
	}
	NSInteger length = self.text.length;
	if (length == 0) {
		[self removeCurrentSelectedEmail];
	} else if (length == 1) {
		[self closeDropDown];
	}
	[super deleteBackward];
}

-(BOOL) resignFirstResponder
{
	[self closeDropDown];
	return [super resignFirstResponder];
}



#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)PPJ_TextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	NSString * newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
	if ([string isEqualToString:@" "]) {
		NSString * add = textField.text;
		if (add.length > 0) {
			[self addString:add];
			[self closeDropDown];
			textField.text = @"";
		}
		return NO;
	}
	[self filterArray:newString];
	
	return YES;
}


- (BOOL)PPJ_textFieldShouldReturn:(UITextField *)txtField
{
	NSString * add = txtField.text;
	if (add.length > 0) {
		[self addString:add];
		[self closeDropDown];
		txtField.text = @"";
	}
	return NO;
}

@end
