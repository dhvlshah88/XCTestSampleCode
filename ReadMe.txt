# TableMultiSelect

"TableMultiSelect" demonstrates the use of multiple selection of table cells in UITableView, in particular using multiple selection to delete one or more items.

----
Copyright (C) 2011-2013 Apple Inc. All rights reserved.


# Test Cases 

Here I have tried to show you two test cases:

1) testDeleteAll: 
	To test a scenario where pressing Delete all button would delete all the default 12 items, making table empty.

2) testAddAndRemoveItems:  
	To test a scenario where 3 new items are successfully added to table and removing 2 of them would reduce table size from 15 to 13. Also the delete button text would show “Delete(2)” (i.e. count of items selected to delete). 

#Steps of run the test cases:

1 Open project in Xcode.
2 Select Test option from Run button (play button)
3 And test it.

(Note: As you debug/test the project you would see that first and second test case run successfully.)

