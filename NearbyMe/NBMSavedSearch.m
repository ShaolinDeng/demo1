/***
 * Excerpted from "Test iOS Apps with UI Automation",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/jptios for more book information.
***/
#import "NBMSavedSearch.h"

@implementation NBMSavedSearch

@dynamic text;
@dynamic lastUsedAt;

+ (NBMSavedSearch *)insertEntityContext:(NSManagedObjectContext *)context
                               withText:(NSString *)text
{
    NBMSavedSearch *search =
        [NSEntityDescription insertNewObjectForEntityForName:@"SavedSearch"
                                      inManagedObjectContext:context];
    search.text = text;
    search.lastUsedAt = [NSDate date];
    return search;
}

+ (NSUInteger)countEntitiesInContext:(NSManagedObjectContext *)context
{
    NSError *error = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SavedSearch"
                                              inManagedObjectContext:context];
    [request setEntity:entity];
    NSUInteger count = [context countForFetchRequest:request error:&error];
    if (count == NSNotFound) {
        NSLog(@"Counld not count saved search terms.\n%@", error);
        abort();
    }
    
    return count;
}

- (void)touch
{
    self.lastUsedAt = [NSDate date];
    [self.managedObjectContext save:nil];
}

@end
