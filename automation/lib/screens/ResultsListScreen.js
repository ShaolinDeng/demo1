/***
 * Excerpted from "Test iOS Apps with UI Automation",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/jptios for more book information.
***/
"use strict";

var ResultsListScreen = {
    assertResult: function(name) {
        log("Checking for list for result", name);
        var tableView = this.window().tableViews()[0];
        var cell = tableView.cells()[name];
        assert(cell.isValid(), "Result not found!");
    }
};

ResultsListScreen.__proto__ = Screen;

/* Instruments uses 4-wide tab stops. */
/* vim: set shiftwidth=4 softtabstop=4 expandtab: */

