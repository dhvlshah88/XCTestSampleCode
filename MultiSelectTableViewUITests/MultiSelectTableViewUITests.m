//
//  MultiSelectTableViewUITests.m
//  MultiSelectTableViewUITests
//
//  Created by Dhaval on 9/14/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface MultiSelectTableViewUITests : XCTestCase

@property (nonatomic, strong) XCUIApplication *app;

@end

@implementation MultiSelectTableViewUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    _app = [[XCUIApplication alloc] init];
    [self.app launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    [self.app terminate];
    _app = nil;
}

- (void)testDeleteAll {
    XCUIElement *masterNavigationBar = self.app.navigationBars[@"Master"];
    [masterNavigationBar.buttons[@"Edit"] tap];
    [masterNavigationBar.buttons[@"Delete All"] tap];
    [self.app.sheets[@"Are you sure you want to remove these items?"].buttons[@"OK"] tap];
    
    //check if total number of items in table after 'Delete All' is 0
    [self isEmptyTable];
    
    //check is item is disabled
    [self testDisabledElement:masterNavigationBar.buttons[@"Edit"]];
}

- (void)testDisabledElement:(XCUIElement *)element {
    // check if an element is disabled
    XCTAssertEqual(element.isEnabled, false, @"Expected Result: False \n Element should be disabled");
}

- (void)isEmptyTable {
    // check if the table is empty
    XCTAssertEqual(self.app.tables.cells.count, 0, @"Expected Result: 0");
}

- (void)testAddAndRemoveItems {
    XCUIElement *masterNavigationBar = self.app.navigationBars[@"Master"];
    XCUIElement *editButton = masterNavigationBar.buttons[@"Edit"];
    XCUIElement *addButton = masterNavigationBar.buttons[@"Add"];
    XCUIElement *okButton = self.app.sheets[@"Are you sure you want to remove these items?"].buttons[@"OK"];
    
    // get total number of items in table before adding 3 new items
    NSUInteger orginalTotalRecords = self.app.tables.cells.count;
    
    //add three items to table.
    [addButton tap];
    [addButton tap];
    [addButton tap];
    
    // get total number of items in table after adding 3 new items
    NSUInteger currentTotalRecords = self.app.tables.cells.count;
    
    //check to see if three new items were added
    [self testDifferenceInItemsForTableWith:orginalTotalRecords afterEditsCount:currentTotalRecords matchesExpectedCount:3];
    
    [editButton tap];
    
    XCUIElementQuery *tablesQuery = self.app.tables;
    [[[tablesQuery childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:5] swipeUp];
    
    //check if the cell exists before selecting
    [self testElementExists:[[tablesQuery childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:1]];
    
    XCUIElement *cell13 = [[tablesQuery childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:13];
    [self testElementExists:cell13];
    
    [cell13.staticTexts[@"New Item"] tap];
    
    //check if the cell is actually selected
    [self testIsCellSelected:cell13 expectedResult:true];
    
    //check if the cell exists before selecting
    XCUIElement *cell14 = [[tablesQuery childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:14];
    [self testElementExists:cell14];
    
    [cell14.staticTexts[@"New Item"] tap];
    
    //check if the cell is actually selected
    [self testIsCellSelected:cell14 expectedResult:true];
    
    //check if the cell is actually selected
    [self testIsCellSelected:(XCUIElement *)[[tablesQuery childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:12] expectedResult:false];
    
    NSString *expectedDeleteText = @"Delete (2)";
    XCUIElement *deleteButton = masterNavigationBar.buttons[expectedDeleteText];
    
    //check if two items were selected, so Delete (2) button exists.
    [self testElementExists:deleteButton];
    
    XCTAssertTrue([deleteButton.label isEqualToString:expectedDeleteText], @"Expected Result: button text %@ should be same as %@", deleteButton.label, expectedDeleteText);
    [deleteButton tap];
    [okButton tap];
    
    // get total number of items in table after removing 2 items
    orginalTotalRecords = currentTotalRecords;
    currentTotalRecords = self.app.tables.cells.count;
    [self testDifferenceInItemsForTableWith:orginalTotalRecords afterEditsCount:currentTotalRecords matchesExpectedCount:2];
}

- (void)testDifferenceInItemsForTableWith:(NSUInteger)originalCount afterEditsCount:(NSUInteger)afterEditsCount matchesExpectedCount:(NSUInteger)expectedCount {
    NSInteger diff = originalCount - afterEditsCount;
    XCTAssertEqual(ABS(diff), expectedCount, @"Expected Result: %lu", expectedCount);
}

- (void)testElementExists:(XCUIElement *)element {
    XCTAssert(element.exists, @"Expected Result: True");
}

- (void)testCellSelectedAt:(NSUInteger)index {
    XCUIElement *cell = [[self.app.tables childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:index];
    [self testIsCellSelected:cell expectedResult:true];
}

- (void)testIsCellSelected:(XCUIElement *)cell expectedResult:(Boolean)result {
    if (result)
        XCTAssertTrue(cell.isSelected, @"Expected Result: True");
    else
        XCTAssertFalse(cell.isSelected, @"Expected Result: False");
}

@end
