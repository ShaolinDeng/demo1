/***
 * Excerpted from "Test iOS Apps with UI Automation",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/jptios for more book information.
***/
"use strict";

// We want to handle all alerts *synchronously* so return true to tell the
// system that we'll take care of it
UIATarget.onAlert = function() { return true; };

function log() {    // Variable # of arguments
    var msg = Array.prototype.join.call(arguments, ', ');
    UIALogger.logMessage(msg);
}

function delay(seconds) {
    UIATarget.localTarget().delay(seconds);
}

function test(description, steps) {
    try {
        UIALogger.logStart(description);
        steps();
        UIALogger.logPass("Test passed");
    } catch(exception) {
        UIALogger.logError(exception.message);
        UIATarget.localTarget().logElementTree();
        UIALogger.logFail("Test failed");
        throw exception;
    }
}

function assert(value, failMsg) {
    if (value) return;
    if (!failMsg) failMsg = "Assert failed";
    throw new Error(failMsg);
}

function assertEqual(value1, value2, failMsg) {
    if (value1 === value2) return;
    if (!failMsg) failMsg = "Assert Equal failed";
    var fullMsg = failMsg + ": '" + value1 + "'" +
        " !== '" + value2 + "'";
    assert(false, fullMsg);
}

function assertNotEqual(value1, value2, failMsg) {
    if (value1 !== value2) return;
    if (!failMsg) failMsg = "Assert Not Equal failed";
    var fullMsg = failMsg + ": '" + value1 + "'" +
        " === '" + value2 + "'";
    assert(false, fullMsg);
}

function assertEqualArrays(array1, array2, failMsg) {
    var failMsg = "Arrays not equal: " +
                     array1.toString() + " != " + array2.toString();
    assert(array1.length === array2.length, failMsg);
    for (var i = 0; i < array1.length; i++) {
        assert(array1[i] === array2[i], failMsg);
    }
}

function predicateWithFormat(format) {
    var parts = format.split("%@");
    var result = [];

    result.push(parts[0]);
    for (var i = 1; i < parts.length; i++) {
        var value = arguments[i];
        if (typeof value == 'string') {
            var allQuotes = new RegExp('"', 'g');
            value = '"' + value.replace(allQuotes, '\\"') + '"';
        }
        var part = parts[i];
        result.push(value, part);
    }

    return result.join('');
}

function execute() {      // variable arguments
    var cmdString = Array.prototype.join.call(arguments, " ");
    UIALogger.logMessage("Executing: " + cmdString);

    var host = UIATarget.localTarget().host();
    var cmd = arguments[0];
    var args = Array.prototype.slice.call(arguments, 1);
    var result = host.performTaskWithPathArgumentsTimeout(cmd, args, 5);

    if (result.exitCode > 0) {
        UIALogger.logError(result.stdout);
        UIALogger.logError(result.stderr);
    }

    return result;
}

function triggerMemoryWarning() {
    if (!UIATarget.localTarget().model().match("Simulator")) {
        log("Can't trigger memory warnings on device");
        return;
    }

    var cmd = 'tell application "System Events" ' +
              'to click menu item "Simulate Memory Warning" ' +
              'of menu "Hardware" of menu bar item "Hardware" ' +
              'of menu bar 1 of process "iPhone Simulator"';

    var result = execute("/usr/bin/osascript", "-e", cmd);

    if (result.exitCode > 0) {
        UIALogger.logError("Could not trigger memory warning");
    } else {
        UIALogger.logWarning("Triggered memory warning");
    }
}

#import "lib/App.js";

// Import screen files into our test environment
#import "lib/screens/Screen.js";
#import "lib/screens/SearchTermScreen.js";
#import "lib/screens/ResultsScreen.js";
#import "lib/screens/ResultsListScreen.js";
#import "lib/screens/ResultsMapScreen.js";
#import "lib/screens/AlertScreen.js";

/* Instruments uses 4-wide tab stops. */
/* vim: set shiftwidth=4 softtabstop=4 expandtab: */

