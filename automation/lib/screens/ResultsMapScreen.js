/***
 * Excerpted from "Test iOS Apps with UI Automation",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/jptios for more book information.
***/
"use strict";

var ResultsMapScreen = {

    assertPinNamed: function(name) {
        assert(this.pinNamed(name).isValid(), "Not found");
    },

    // ...

    assertNoPins: function() {
        var predicate = "name beginswith \"POI: \"";
        this.target().pushTimeout(0.1);
        var pins = this.window().elements().withPredicate(predicate);
        assert(pins.length === 0, "Expected no pins on the map");
        this.target().popTimeout();
    },

    // ...

    pinNamed: function(name) {
        log("Looking up", name, "on the map");
        var elements = this.window().elements();
        return elements["POI: " + name];
    },

    mapView: function() {
        return this.window().mapViews()[0];
    },

    moveMapFarToTheLeft: function() {
        var rect = this.mapView().rect();
        var mapCenter = {
            x: rect.size.width/2 + rect.origin.x,
            y: rect.size.height/2 + rect.origin.y
        };
        var startPoint = {
            x: mapCenter.x - 60,
            y: mapCenter.y
        };
        var endPoint = {
            x: mapCenter.x,
            y: mapCenter.y
        };
        this.target().pinchCloseFromToForDuration(startPoint, endPoint, 3);

        var options = {
            startOffset: {x:0.2, y:0.5},
            endOffset:   {x:0.9, y:0.4}
        };
        this.mapView().flickInsideWithOptions(options);
    }

};

ResultsMapScreen.__proto__ = Screen;

/* Instruments uses 4-wide tab stops. */
/* vim: set shiftwidth=4 softtabstop=4 expandtab: */

