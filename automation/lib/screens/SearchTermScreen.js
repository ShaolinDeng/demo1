/***
 * Excerpted from "Test iOS Apps with UI Automation",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/jptios for more book information.
***/
"use strict";

var SearchTermScreen = {

    sortByRecent: function() {
        log("Sorting search terms by recent");
        this.toolbar().segmentedControls()[0].buttons()[0].tap();
    },

    sortByName: function() {
        log("Sorting search terms by name");
        this.toolbar().segmentedControls()[0].buttons()[1].tap();
    },

    addTerm: function(name) {
        log("Showing alert to add search term");
        UIATarget.onAlert = function() {
            return true;
        };
        this.navigationBar().rightButton().tap();

        this.app().keyboard().typeString(name);
        this.app().alert().defaultButton().tap();
    },

    removeTerm: function(name) {
        log("Removing search term", name);
        var editButton = this.navigationBar().leftButton();
        editButton.tap();

        var cell = this.tableView().cells()[name];

        var deleteSwitch = cell.switches()[0];
        deleteSwitch.tap();

        var deleteButton = cell.buttons()[0];
        deleteButton.tap();

        editButton.tap();
    },

    assertTerm: function(index, name) {
        log("Checking for", name, "at index", index);
        var cell = this.tableView().cells()[index];
        assertEqual(cell.name(), name);
    },

    assertNoTerm: function(name) {
        log("Assert no term named", name);
        this.target().pushTimeout(0.1);
        var cell = this.tableView().cells()[name];
        this.target().popTimeout();
        assert(!cell.isValid(), "Cell still there");
    },

    assertSearchTermOrder: function(terms) {
        var termCells = this.tableView().cells().toArray();
        var actualTerms = termCells.map(function(cell) {
            return cell.name();
        });

        assertEqualArrays(actualTerms, terms);
    },

    tapTerm: function(name) {
        this.tableView().cells()[name].tap();
	this.target().delay(10);
    },

    navigationBar: function() {
        if (App.isOnIPad() && App.isPortrait()) {
            return this.window().popover().navigationBar();
        } else {
            return this.__proto__.navigationBar();
        }
    },

    tableView: function() {
        var root;
        if (App.isOnIPad() && App.isPortrait()) {
            root = this.window().popover();
        } else {
            root = this.window();
        }
        return root.tableViews()[0];
    }
};

SearchTermScreen.__proto__ = Screen;

/* Instruments uses 4-wide tab stops. */
/* vim: set shiftwidth=4 softtabstop=4 expandtab: */

