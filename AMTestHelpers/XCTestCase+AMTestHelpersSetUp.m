//
//  XCTestCase+AMTestHelpersSetUp.m
//  AMTestHelpers
//
//  Created by Dominic Miller on 10/26/17.
//

#import <XCTest/XCTest.h>
#import <AMTestHelpers/AMTestHelpers-Swift.h>

@implementation XCTestCase (AMTestHelpersSetUp)

+ (void)setUp {
    [AMTestHelper prepareForTests];
}

@end

