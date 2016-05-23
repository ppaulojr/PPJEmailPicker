//
//  PPJEmailPickerDemoTests.m
//  PPJEmailPickerDemoTests
//
//  Created by Pedro Paulo Oliveira Junior on 17/05/16.
//  Copyright © 2016 Netfilter. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PPJEmailPicker.h"

@interface PPJEmailPickerDemoTests : XCTestCase
@property (strong, nonatomic) PPJEmailPicker *email;
@end

@implementation PPJEmailPickerDemoTests

- (void)setUp {
    [super setUp];
	self.email = [[PPJEmailPicker alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0f, 30.0f)];
}

- (void) tearDown {
	[super tearDown];
	self.email = nil;
}

- (void)testCreation {
	XCTAssert(self.email != nil, @"Check creation");
}

- (void) testInitialSize {
	XCTAssert(self.email.frame.size.width == 320.0f, @"Width");
	XCTAssert(self.email.frame.size.height == 30.0f, @"Height");
}

- (void) testAccessibility {
	self.email.text = @"Hello";
	XCTAssert([self.email.accessibilityLabel isEqualToString:@"Hello"]);
}

@end
