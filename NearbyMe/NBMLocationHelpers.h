/***
 * Excerpted from "Test iOS Apps with UI Automation",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/jptios for more book information.
***/
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

typedef struct {
    CLLocationCoordinate2D topLeft;
    CLLocationCoordinate2D bottomRight;
} NBMLocationBounds;

static inline NBMLocationBounds NBMMakeLocationBoundsFromMapRect(MKMapRect rect) {
    MKMapPoint tlpoint = MKMapPointMake(MKMapRectGetMinX(rect), MKMapRectGetMinY(rect));
    CLLocationCoordinate2D topLeft = MKCoordinateForMapPoint(tlpoint);
    MKMapPoint brpoint = MKMapPointMake(MKMapRectGetMaxX(rect), MKMapRectGetMaxY(rect));
    CLLocationCoordinate2D bottomRight = MKCoordinateForMapPoint(brpoint);

    NBMLocationBounds result;
    result.topLeft = topLeft;
    result.bottomRight = bottomRight;
    return result;
}

static inline NSString *NBMStringFromLocationBounds(NBMLocationBounds bounds) {
    NSString *result = [NSString stringWithFormat:@"%f,%f,%f,%f",
                        bounds.topLeft.longitude,
                        bounds.topLeft.latitude,
                        bounds.bottomRight.longitude,
                        bounds.bottomRight.latitude];
    return result;

}
