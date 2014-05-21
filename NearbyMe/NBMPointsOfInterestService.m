/***
 * Excerpted from "Test iOS Apps with UI Automation",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/jptios for more book information.
***/
#import <MapKit/MapKit.h>
#import "NBMPointsOfInterestService.h"

@interface NBMPointsOfInterestService ()

@property (nonatomic, strong) MKLocalSearch *search;

@end

static Class pointsOfInterestServiceClass = nil;

@implementation NBMPointsOfInterestService

+ (instancetype)service
{
    return [[pointsOfInterestServiceClass alloc] init];
}

// ...

+ (void)initialize
{
    if (self != [NBMPointsOfInterestService class]) return;

    pointsOfInterestServiceClass = self;
}

+ (void)setServiceClass:(Class)newClass
{
    pointsOfInterestServiceClass = newClass;
}

- (void)findByText:(NSString *)query
            within:(MKMapRect)rect
{
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = query;
    request.region = MKCoordinateRegionForMapRect(rect);

    self.search = [[MKLocalSearch alloc] initWithRequest:request];

    NBMPointsOfInterestService * __weak weakSelf = self;
    MKLocalSearchCompletionHandler completion =
        ^(MKLocalSearchResponse *response, NSError *error) {
            if (error) {
                [weakSelf.delegate poiService:self didFailWithError:error];
            } else {
                NSArray *pois = [weakSelf pointsOfInterestFromResponse:response];
                [weakSelf.delegate poiService:self didFetchResults:pois];
            }
        };

    [self.search startWithCompletionHandler:completion];
}

- (void)cancel
{
    [self.search cancel];
    self.search = nil;
}

- (NSArray *)pointsOfInterestFromResponse:(MKLocalSearchResponse *)response
{
    NSMutableArray *pointsOfInterest = [NSMutableArray new];
    
    for (MKMapItem *item in response.mapItems) {
        NBMPointOfInterest *poi = [[NBMPointOfInterest alloc] init];
        poi.title = item.name;
        poi.coordinate = item.placemark.location.coordinate;
        [pointsOfInterest addObject:poi];
    }

    return pointsOfInterest;
}

@end
