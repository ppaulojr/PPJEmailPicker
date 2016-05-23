//
//  PPJEmailPickerDemoUITests.m
//  PPJEmailPickerDemoUITests
//
//  Created by Pedro Paulo Oliveira Junior on 17/05/16.
//  Copyright © 2016 Netfilter. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface PPJEmailPickerDemoUITests : XCTestCase

@end

@implementation PPJEmailPickerDemoUITests

- (void)setUp {
    [super setUp];
    self.continueAfterFailure = NO;
    [[[XCUIApplication alloc] init] launch];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testAddElements {

}

@end
