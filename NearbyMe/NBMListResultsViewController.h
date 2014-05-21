/***
 * Excerpted from "Test iOS Apps with UI Automation",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/jptios for more book information.
***/
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "NBMPointOfInterest.h"

@class NBMListResultsViewController;

@protocol NBMListResultsViewControllerDelegate <NSObject>

- (void)listResultsController:(NBMListResultsViewController *)controller
        didTapPointOfInterest:(NBMPointOfInterest *)poi;

@end

@interface NBMListResultsViewController : UITableViewController
<CLLocationManagerDelegate>

- (void)setPointsOfInterest:(NSArray *)pointsOfInterest
               nearLocation:(CLLocation *)location;

@property (nonatomic, weak) id<NBMListResultsViewControllerDelegate> listResultsDelegate;

- (void)removePointsOfInterest;

@end
