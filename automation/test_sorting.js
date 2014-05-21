/***
 * Excerpted from "Test iOS Apps with UI Automation",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/jptios for more book information.
***/
// DATA_FACTORY_MESSAGE=generateSortingBehaviorTestTerms
"use strict";

#import "env.js";

test("Test search term sorting", function() {
    // ...
    var s = SearchTermScreen;
    s.sortByRecent();
    s.assertSearchTermOrder(["kiwi", "banana", "orange", "apple"]);
    s.sortByName();
    s.assertSearchTermOrder(["apple", "banana", "kiwi", "orange"]);
});

/* Instruments uses 4 char tab stops. */
/* vim: set shiftwidth=4 softtabstop=4 expandtab: */

