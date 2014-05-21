/***
 * Excerpted from "Test iOS Apps with UI Automation",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/jptios for more book information.
***/
#import "NBMPointsOfInterestServiceStub.h"

@implementation NBMPointsOfInterestServiceStub

+ (void)stubServiceSuperclass
{
    [NBMPointsOfInterestService setServiceClass:self];
}

// ...

- (void)findByText:(NSString *)query
            within:(MKMapRect)rect
{
    NSArray *pois = @[];

    MKMapPoint downtownSF = MKMapPointForCoordinate(
                                CLLocationCoordinate2DMake(37.7873, -122.4082));

    if ([query isEqualToString:@"coffee"] &&
            MKMapRectContainsPoint(rect, downtownSF)) {

        pois = [self pointsOfInterestFromRawResultsInBundleNamed:@"san_fran"];
    }

    [self.delegate poiService:self didFetchResults:pois];
}

- (NSArray *)pointsOfInterestFromRawResultsInBundleNamed:(NSString *)name
{
    NSArray *results = [self rawResultsFromBundleFileName:name];

    NSMutableArray *pointsOfInterest = [NSMutableArray new];

    for (NSDictionary *result in results) {
        NBMPointOfInterest *poi = [[NBMPointOfInterest alloc] init];
        poi.title = result[@"title"];
        poi.coordinate = CLLocationCoordinate2DMake(
                            [result[@"lat"] floatValue],
                            [result[@"lon"] floatValue]);
        [pointsOfInterest addObject:poi];
    }

    return pointsOfInterest;
}

- (NSArray *)rawResultsFromBundleFileName:(NSString *)name
{
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:name
                                             withExtension:@"plist"];
    NSArray *results = [NSArray arrayWithContentsOfURL:fileURL];

    if (!results) {
        NSLog(@"Error parsing JSON from %@\n%s",
              fileURL, __PRETTY_FUNCTION__);
        abort();
    }

    return results;
}

@end
