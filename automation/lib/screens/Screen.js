/***
 * Excerpted from "Test iOS Apps with UI Automation",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/jptios for more book information.
***/
"use strict";

var Screen = {
    target: function() {
        return UIATarget.localTarget();
    },

    app: function() {
        return this.target().frontMostApp();
    },

    window: function() {
        return this.app().mainWindow();
    },

    navigationBar: function() {
        return this.app().navigationBar();
    },

    toolbar: function() {
        return this.app().toolbar();
    },

    // Recursive Searching
    // ...

    searchWithPredicate: function(predicate, startElement) {
        if (!startElement) startElement = this.window();

        // ...
        var target = this.target();

        function recursiveSearch(predicate, startElement) {
            target.pushTimeout(0);
            // ...

            var elements = startElement.elements();
            var found = elements.firstWithPredicate(predicate);
            target.popTimeout();

            if (found.isValid()) return found;

            for (var i = 0; i < elements.length; i++) {
                var element = elements[i];
                found = recursiveSearch(predicate, element);
                if (found) return found;
            }

            return null;
        }

        var timeoutInMillis = target.timeout() * 1000;
        var start = new Date();
        do {
            var now = new Date();
            var found = recursiveSearch(predicate, startElement);
            target.delay(0.1);
        } while(!found && now - start < timeoutInMillis);

        return found;
    }

};

/* Instruments uses 4 char tab stops. */
/* vim: set shiftwidth=4 softtabstop=4 expandtab: */

