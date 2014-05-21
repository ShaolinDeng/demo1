/***
 * Excerpted from "Test iOS Apps with UI Automation",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/jptios for more book information.
***/
#import <CoreData/CoreData.h>

@interface NBMSavedSearch : NSManagedObject

@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSDate *lastUsedAt;

+ (NBMSavedSearch *)insertEntityContext:(NSManagedObjectContext *)context
                               withText:(NSString *)text;
+ (NSUInteger)countEntitiesInContext:(NSManagedObjectContext *)context;

- (void)touch;

@end
