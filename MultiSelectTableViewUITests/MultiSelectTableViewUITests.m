//
//  MultiSelectTableViewUITests.m
//  MultiSelectTableViewUITests
//
//  Created by Dhaval on 9/14/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface MultiSelectTableViewUITests : XCTestCase

@end

@implementation MultiSelectTableViewUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDeleteAll {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElement *masterNavigationBar = app.navigationBars[@"Master"];
    [masterNavigationBar.buttons[@"Edit"] tap];
    [masterNavigationBar.buttons[@"Delete All"] tap];
    [app.sheets[@"Are you sure you want to remove these items?"].buttons[@"OK"] tap];
    
    // an assert to check if the final count of items in table after Delete All is 0
    XCTAssertEqual(app.tables.cells.count, 0, @"Expected Result: 0");
    
    //a method call to testDisabledElement to check is item is disabled
    [self testDisabledElement:masterNavigationBar.buttons[@"Edit"]];
}

- (void)testDisabledElement:(XCUIElement *)element {
    // an assert to check if an element is disabled
    XCTAssertEqual(element.isEnabled, false, @"Expected Result: False \n Element should be disabled");
}

- (void)testAddAndRemove {
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElement *masterNavigationBar = app.navigationBars[@"Master"];
    XCUIElement *editButton = masterNavigationBar.buttons[@"Edit"];
    XCUIElement *addButton = masterNavigationBar.buttons[@"Add"];
    XCUIElement *okButton = app.sheets[@"Are you sure you want to remove these items?"].buttons[@"OK"];
    
    // get total number of items in table before adding 3 new items
    NSUInteger orginalTotalRecords = app.tables.cells.count;
    
    //add three items to table.
    [addButton tap];
    [addButton tap];
    [addButton tap];
    
    // get total number of items in table after adding 3 new items
    NSUInteger currentTotalRecords = app.tables.cells.count;
    
    XCTAssertEqual(currentTotalRecords - orginalTotalRecords, 3, @"Expected Result: 3");
    
    [editButton tap];
    
    XCUIElementQuery *tablesQuery = app.tables;
    [[[tablesQuery childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:5] swipeUp];
    
    //check if the cell exists before selecting
    XCTAssert([[tablesQuery childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:12].exists, @"Expected Result: True");
    XCTAssert([[tablesQuery childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:13].exists, @"Expected Result: True");
    
    [[[tablesQuery childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:13].staticTexts[@"New Item"] tap];
    
    //check if the cell is actually selected
    XCTAssertTrue([[tablesQuery childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:13].isSelected, @"Expected Result: True");
    
    //check if the cell exists before selecting
    XCTAssert([[tablesQuery childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:14].exists, @"Expected Result: True");
    
    [[[tablesQuery childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:14].staticTexts[@"New Item"] tap];
    
    //check if the cell is actually selected
    XCTAssertTrue([[tablesQuery childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:14].isSelected, @"Expected Result: True");
    
    //check if the cell is actually selected
    XCTAssertEqual([[tablesQuery childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:12].isSelected, false, @"Expected Result: False");
    
    //check if two items were selected
    XCTAssert(masterNavigationBar.buttons[@"Delete (2)"].exists, @"Expected Result: True");
    
    XCUIElement *deleteButton = masterNavigationBar.buttons[@"Delete (2)"];
    
    NSString *expectedText = @"Delete (2)";
    XCTAssertTrue([deleteButton.label isEqualToString:expectedText], @"Expected Result: button text %@ should be same as %@", deleteButton.label, expectedText);
    [deleteButton tap];
    [okButton tap];
    
    // get total number of items in table after removing 2 items
    XCTAssertEqual(currentTotalRecords - app.tables.cells.count, 2, @"Expected Result: 2");
}

@end
