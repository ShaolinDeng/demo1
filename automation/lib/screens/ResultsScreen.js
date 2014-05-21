/***
 * Excerpted from "Test iOS Apps with UI Automation",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/jptios for more book information.
***/
"use strict";

var ResultsScreen = {
    goBack: function() {
        var backButton = this.navigationBar().leftButton();
        backButton.tap();
    },

    showList: function() {
        log("Switching to the list of results");
        var toggle = this.toolbar().segmentedControls()[0];
        toggle.buttons()['List'].tap();
    },

    // ...

    tapRefreshButton: function() {
        this.navigationBar().rightButton().tap();
    }

};

ResultsScreen.__proto__ = Screen;

/* Instruments uses 4-wide tab stops. */
/* vim: set shiftwidth=4 softtabstop=4 expandtab: */

