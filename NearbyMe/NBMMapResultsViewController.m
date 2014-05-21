/***
 * Excerpted from "Test iOS Apps with UI Automation",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/jptios for more book information.
***/
#import "NBMMapResultsViewController.h"
#import "NBMAccessibleAnnotationView.h"

@interface NBMMapResultsViewController ()
@property (strong, nonatomic) IBOutlet MKMapView *map;
@property (nonatomic) BOOL movingTowardLocation;
@end

@implementation NBMMapResultsViewController


#pragma mark Map Stuff

- (void)showLocation:(CLLocation *)location radius:(CGFloat)radius animated:(BOOL)animated
{
    _movingTowardLocation = YES;
    CLLocationCoordinate2D userCoordinate = location.coordinate;
    MKCoordinateRegion region;
    region = MKCoordinateRegionMakeWithDistance(userCoordinate,
                                                radius * 2,
                                                radius * 2);
    [_map setRegion:region animated:animated];
}

- (void)showPointOfInterest:(NBMPointOfInterest *)poi animated:(BOOL)animated
{
    [_map selectAnnotation:poi animated:animated];
}

- (MKMapRect)visibleMapRect
{
    return _map.visibleMapRect;
}

- (void)removePointsOfInterest
{
    for (id<MKAnnotation> annotation in self.map.annotations) {
        if (![annotation isKindOfClass:[MKUserLocation class]]) {
            [self.map removeAnnotation:annotation];
        }
    }
}

- (void)addPointsOfInterest:(NSArray *)pois
{
    for (NBMPointOfInterest *poi in pois) {
        [self.map addAnnotation:poi];
    }
}


#pragma mark - Map Delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    } else {
        MKPinAnnotationView *view = [[NBMAccessibleAnnotationView alloc]
                                     initWithAnnotation:annotation
                                     reuseIdentifier:nil];
        view.canShowCallout = YES;
        view.animatesDrop = YES;
        return view;
    }
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (_movingTowardLocation) {
        [self.mapResultsDelegate mapResultsControllerDidFinishShowingLocation:self];
        _movingTowardLocation = NO;
    }
}


@end
