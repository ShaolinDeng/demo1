/***
 * Excerpted from "Test iOS Apps with UI Automation",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/jptios for more book information.
***/
#import "NBMTestDataFactory.h"
#import "NBMSavedSearch.h"

@interface NBMTestDataFactory ()
@property (nonatomic, strong) NBMDocument *document;
@end

@implementation NBMTestDataFactory

- (id)initWithDocument:(NBMDocument *)document
{
    self = [super init];
    if (self) {
        _document = document;
    }
    return self;
}

#pragma mark - Scenario Methods

- (void)generateAThousandSearchTerms
{
    [self resetDocument];
    for (int count = 0; count < 1000; count++) {
        int length = arc4random_uniform(10) + 4;
        unichar buf[length];

        for (int idx = 0; idx < length; idx++) {
            buf[idx] = (unichar)('a' + arc4random_uniform(26));
        }

        NSString *term = [NSString stringWithCharacters:buf length:length];
        [self addSavedSearchTerm:term];
    }
    [self saveDocument];
}

- (void)generateSortingBehaviorTestTerms
{
    [self resetDocument];
    for (NSString *term in @[@"apple", @"orange", @"banana", @"kiwi"]) {
        [self addSavedSearchTerm:term];
    }
    [self saveDocument];
}


#pragma mark - Utility Methods

- (void)resetDocument
{
    NSError *error = nil;
    if (![self.document deleteAndReset:&error]) {
        NSLog(@"%s: Could not reset database\n%@",
              __PRETTY_FUNCTION__, error);
        abort();
    }
}

- (void)saveDocument
{
    NSError *error = nil;
    if (![self.document save:&error]) {
        NSLog(@"%s: Could not save database\n%@",
              __PRETTY_FUNCTION__, error);
        abort();
    }
}

- (void)addSavedSearchTerm:(NSString *)term
{
    [NBMSavedSearch insertEntityContext:self.document.managedObjectContext
                               withText:term];
}

@end
