# TableMultiSelect

"TableMultiSelect" demonstrates the use of multiple selection of table cells in UITableView, in particular using multiple selection to delete one or more items.

----
Copyright (C) 2011-2013 Apple Inc. All rights reserved.


# Test Cases

Here I have tried to show you two test cases:

1) testDeleteAll:
To test a scenario where pressing Delete all button would delete all the default 12 items, making table empty.

2) testAddAndRemoveItems:
To test a scenario where 3 new items are successfully added to the table and removing 2 of them would reduce table size from 15 to 13. Also, the delete button text would show “Delete(2)” (i.e. count of items selected to delete).

#Steps of run the test cases:

1. Open project in Xcode.
2. Select Test option from Run button (play button)
3. Run it and see all UI test cases executing visually in the simulator.
4. Or press a small play button in Xcode against each testMethod name, which turns green when the cursor is over it.

(Note: As you debug/test the project you would see that first and second test case run successfully.)

I have tried to separate some code into their individual functions, so it can be used again and also it makes my code more readable. I have included comments so it is easy to understand each step in the test case.
Here are few examples of function I created:

isEmptyTable - function fails if table is not empty.

testDisabledElement: - a function which consumes XCUIElement and checks if an element is disabled or fail the test while printing the expected result.

doesElementExists: - function fails if element doesn't exists.

isCellSelected:expectedResult: - function fails if cell state and expected result doesn't match.

cellSelectedAt: - fumction fails if cell is not selected.

compareStrings:expectedString: - function fails if two strings are not equal.

Now, let me explain the problems and the solution I came up for them

# Problem 1:

The first test case defines a scenario when the app launches and user presses Edit button. The table goes into the editing mode and navigation bar presents the user with Delete All button.
When the user presses that button and confirmation message is shown. After confirming, all the items in the table are deleted. In order to test if all the items were deleted, in test case "testDeleteAll" I wrote a check
to see if a total number of cells in the table is equal to zero. After the test is passed, I wrote second assert to checks if the Edit button is disabled by checking XCUIElement's isEnabled property.

# Problem 2:

The second test case defines scenario where user press Add(+) button 3 times to add 3 new items. This can be check by comparing the difference between original table cell count before adding and table cell
count after adding, it should be 3. Once the check is passed, press the Edit button on the navigation bar to set the table to editing mode. So when in editing mode, select two recently added items and here I check
if the selected cells are "New Items". Once again if this check is passed, we would see that the left navigation bar button text changes to
"Delete (2)" showing the number of selected cells in parenthesis. In order to check if the Delete button text is "Delete (2)", I compared Delete button text with the expected string i.e. "Delete (2)".
And if that test passes, tap on delete button to delete those two selected items from the table. Now to verify that two new items were deleted from the table, I have written the same test I wrote earlier while
adding the items, only this time difference will be 2.
