/***
 * Excerpted from "Test iOS Apps with UI Automation",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/jptios for more book information.
***/
// DATA_FACTORY_MESSAGE=resetDocument
"use strict";

#import "env.js";

test("User told to enable location services", function() {
    SearchTermScreen.tapTerm("coffee");
    var title = "“NearbyMe” Would Like to Use Your Current Location";
    AlertScreen.assertWithTitle(title);
    AlertScreen.cancel();
    delay(1);  // Wait for previous alert to vanish
    AlertScreen.assertWithTitle("Location Disabled");
});

/* Instruments uses 4 char tab stops. */
/* vim: set shiftwidth=4 softtabstop=4 expandtab: */

