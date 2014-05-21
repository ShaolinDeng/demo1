/***
 * Excerpted from "Test iOS Apps with UI Automation",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/jptios for more book information.
***/
"use strict";

var AlertScreen = {
    // ...
    alert: function() {
        return this.app().alert();
    },

    assertWithTitle: function(expectedTitle) {
        log("Checking for an alert with title", expectedTitle);
        assert(this.alert().isValid(), "Alert didn't show");
        var title = this.alert().staticTexts()[0].value();
        assertEqual(title, expectedTitle);
    },

    confirmLocationPermission: function() {
        this.target().pushTimeout(1);
        var alert = this.alert();
        this.target().popTimeout();
        if (alert.isValid()) {
            var title = alert.name();
            if (title.match(/Would Like to Use Your Current Location/)) {
                alert.defaultButton().tap();
            }
        }
    },

    confirm: function() {
        this.alert().defaultButton().tap();
    },

    cancel: function() {
        this.alert().cancelButton().tap();
    }
    // ...
};

AlertScreen.__proto__ = Screen;

/* Instruments uses 4 char tab stops. */
/* vim: set shiftwidth=4 softtabstop=4 expandtab: */

