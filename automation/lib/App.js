/***
 * Excerpted from "Test iOS Apps with UI Automation",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/jptios for more book information.
***/
"use strict";

var App = {
    setLocation: function(name) {
        var locations = {
            "Akron":         { latitude: 41.0814, longitude: -81.5192 },
            "San Francisco": { latitude: 37.7873, longitude: -122.4082 }
        };
        var coords = locations[name];
        if (!coords) throw "Could not find coordinates named " + name;
        this.target().setLocation(coords);
    },

    // ...

    isOnIPad: function() {
        return this.target().model().match("iPad");
    },

    isPortrait: function() {
        var orientation = this.target().deviceOrientation();
        return orientation == UIA_DEVICE_ORIENTATION_PORTRAIT ||
            orientation == UIA_DEVICE_ORIENTATION_PORTRAIT_UPSIDEDOWN;
    },

    rotateLandscape: function() {
        var orientation = UIA_DEVICE_ORIENTATION_LANDSCAPELEFT;
        this.target().setDeviceOrientation(orientation);
    },

    rotatePortrait: function() {
        var orientation = UIA_DEVICE_ORIENTATION_PORTRAIT;
        this.target().setDeviceOrientation(orientation);
    },

    target: function() {
        return UIATarget.localTarget();
    }

};

/* Instruments uses 4 char tab stops. */
/* vim: set shiftwidth=4 softtabstop=4 expandtab: */

