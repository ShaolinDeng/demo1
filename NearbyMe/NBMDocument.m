/***
 * Excerpted from "Test iOS Apps with UI Automation",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/jptios for more book information.
***/
#import "NBMDocument.h"
#import "NBMSavedSearch.h"

NSString * const kDocumentFileName = @"NearbyMe.sqlite";

@implementation NBMDocument

@synthesize managedObjectContext=_managedObjectContext;
@synthesize managedObjectModel=_managedObjectModel;
@synthesize persistentStoreCoordinator=_persistentStoreCoordinator;

- (BOOL)deleteAndReset:(NSError **)error
{
    // These will be reconstructed when the properties are next accessed.
    _managedObjectContext = nil;
    _managedObjectModel = nil;
    _persistentStoreCoordinator = nil;

    NSFileManager *manager = [NSFileManager defaultManager];

    if ([manager fileExistsAtPath:self.persistentStoreURL.path]) {
        return [[NSFileManager defaultManager]
                removeItemAtURL:self.persistentStoreURL error:error];
    } else {
        return YES;
    }
}

- (BOOL)save:(NSError **)error
{
    return [self.managedObjectContext save:error];
}

- (void)setupDefaultDataIfEmpty
{
    NSArray *defaultSearches = @[@"fish", @"sandwich", @"coffee"];
    NSError *error = nil;
    
    NSUInteger count = [NBMSavedSearch
                            countEntitiesInContext:self.managedObjectContext];
    if (count > 0) return;  // Database already has records
    
    for (NSString *text in defaultSearches) {
        [NBMSavedSearch insertEntityContext:self.managedObjectContext
                                   withText:text];
    }
    
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error initializing database.\n%@", error);
        abort();
    }
              
}


#pragma mark - Core Data stack

- (NSManagedObjectContext *)managedObjectContext
{
    if (!_managedObjectContext) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"NearbyMe" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }

    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                   initWithManagedObjectModel:self.managedObjectModel];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:self.persistentStoreURL
                                                         options:nil
                                                           error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}


#pragma mark - Application's Documents directory

- (NSURL *)applicationDocumentsDirectory
{
    NSArray *urls = [[NSFileManager defaultManager]
                     URLsForDirectory:NSDocumentDirectory
                            inDomains:NSUserDomainMask];
    return [urls lastObject];
}

- (NSURL *)persistentStoreURL
{
    return [self.applicationDocumentsDirectory URLByAppendingPathComponent:kDocumentFileName];
}

@end
