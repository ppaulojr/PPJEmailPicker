# PPJEmailPicker
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/PPJEmailPicker.svg)](https://img.shields.io/cocoapods/v/PPJEmailPicker.svg)
[![GitHub issues](https://img.shields.io/github/issues/ppaulojr/PPJEmailPicker.svg?style=plastic)](https://github.com/ppaulojr/PPJEmailPicker/issues) 
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg?style=plastic)](https://raw.githubusercontent.com/ppaulojr/PPJEmailPicker/master/LICENSE)
[![Twitter](https://img.shields.io/badge/twitter-@ppaulojr-blue.svg?style=flat)](http://twitter.com/ppaulojr)

An UITextField replacement to select multiple e-mails

## Demo
![maildemo2](https://cloud.githubusercontent.com/assets/1206478/15519274/0f0b316a-21d7-11e6-81d2-dc6ceacea184.gif)

## Installation with CocoaPods

#### Podfile

Add the line below to your `Podfile`:

```ruby
pod 'PPJEmailPicker'
```

## Usage

### Programatically 

```objc
-(PPJEmailPicker *) createAutoCompleteFieldWithFrame:(CGRect)frame
{
	PPJEmailPicker * actf = [[PPJEmailPicker alloc] initWithFrame:frame];
	actf.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	actf.font = [UIFont systemFontOfSize:14.0];
	actf.autocorrectionType = UITextAutocorrectionTypeNo;
	actf.pickerDelegate = self;
	actf.emailPickerTableView.clipsToBounds = YES;
	// Cells and Table color
	actf.possibleStrings = [[ListOfEmails emails] mutableCopy];
	actf.placeholder = NSLocalizedString(@"Type e-mail to send recognition", nil);
	return actf;
}
```

