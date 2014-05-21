/***
 * Excerpted from "Test iOS Apps with UI Automation",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/jptios for more book information.
***/
#import <Foundation/Foundation.h>
#import "NBMDocument.h"

@interface NBMTestDataFactory : NSObject

- (id)initWithDocument:(NBMDocument *)document;

// Utility Methods
- (void)resetDocument;
- (void)saveDocument;
- (void)addSavedSearchTerm:(NSString *)term;

// Scenario Methods
- (void)generateAThousandSearchTerms;
- (void)generateSortingBehaviorTestTerms;

@end
