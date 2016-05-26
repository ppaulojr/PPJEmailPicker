# PPJEmailPicker
[![Build Status](https://travis-ci.org/ppaulojr/PPJEmailPicker.svg?branch=master)](https://travis-ci.org/ppaulojr/PPJEmailPicker)
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

#### Step 1 - Import Header

```objc
#import "PPJEmailPicker.h"
```

##### Step 2 - create object
```objc
-(PPJEmailPicker *) createAutoCompleteFieldWithFrame:(CGRect)frame
{
	PPJEmailPicker * actf = [[PPJEmailPicker alloc] initWithFrame:frame];
	actf.pickerDelegate = self;
	actf.possibleStrings = [[ListOfEmails emails] mutableCopy];
	actf.placeholder = NSLocalizedString(@"Type e-mail to send recognition", nil);
	return actf;
}
```

##### Step 3 - Pass a list of emails to it
```objc
	actf.possibleStrings = @[@"email1@email.com", @"email2@email.com];
```

### Interface Builder

Add a `UITextField` and change the class to `PPJEmailPicker`.

Don't forget to set the `pickerDelegate` and to pass a list of e-mails for autocompletion.

## Questions

Contact me at Twitter: [@ppaulojr](https://twitter.com/ppaulojr)
