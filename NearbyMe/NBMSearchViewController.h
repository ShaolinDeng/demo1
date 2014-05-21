/***
 * Excerpted from "Test iOS Apps with UI Automation",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/jptios for more book information.
***/
#import <UIKit/UIKit.h>
#import "NBMResultsViewController.h"
#import <CoreData/CoreData.h>

@class NBMSearchViewController;

@protocol NBMSearchViewControllerDelegate <NSObject>

- (void)searchController:(NBMSearchViewController *)controller didSelectSearchTerm:(NSString *)term;

@end

@interface NBMSearchViewController : UITableViewController
<NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NBMResultsViewController *detailViewController;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet id<NBMSearchViewControllerDelegate> searchControllerDelegate;

@end
