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
// ...

#import "env.js";

if (!App.isOnIPad()) {
    throw new Error("Test suite only works on iPad");
}

test("Removing and replacing search term in landscape", function() {
    App.rotateLandscape();

    var s = SearchTermScreen;
    s.removeTerm("coffee");
    s.assertNoTerm("coffee");

    s.addTerm('coffee');
    s.assertTerm(0, 'coffee');
});

test("Removing and replacing search term in portrait", function() {
    App.rotatePortrait();

    var s = SearchTermScreen;
    s.removeTerm("coffee");
    s.assertNoTerm("coffee");

    s.addTerm('coffee');
    s.assertTerm(0, 'coffee');
});

/* Instruments uses 4 char tab stops. */
/* vim: set shiftwidth=4 softtabstop=4 expandtab: */

