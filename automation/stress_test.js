/***
 * Excerpted from "Test iOS Apps with UI Automation",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/jptios for more book information.
***/
"use strict";

#import "env.js";

for (var i = 0; i < 30; i++) {
    test("View map and go back, iteration: " + i, function() {
        SearchTermScreen.tapTerm("coffee");
        ResultsScreen.goBack();
        if (i % 4 == 0) triggerMemoryWarning();
    });
}

/* Instruments uses 4 char tab stops. */
/* vim: set shiftwidth=4 softtabstop=4 expandtab: */

