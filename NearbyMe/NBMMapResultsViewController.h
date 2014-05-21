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
#import <MapKit/MapKit.h>
#import "NBMPointOfInterest.h"

@class NBMMapResultsViewController;

@protocol NBMMapResultsViewControllerDelegate <NSObject>

- (void)mapResultsControllerDidFinishShowingLocation:(NBMMapResultsViewController *)controller;

@end

@interface NBMMapResultsViewController : UIViewController
<CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic, weak) id<NBMMapResultsViewControllerDelegate> mapResultsDelegate;
@property (readonly) MKMapRect visibleMapRect;

- (void)showLocation:(CLLocation *)location radius:(CGFloat)radius animated:(BOOL)animated;

- (void)showPointOfInterest:(NBMPointOfInterest *)poi animated:(BOOL)animated;

- (void)removePointsOfInterest;
- (void)addPointsOfInterest:(NSArray *)pois;

@end
