/***
 * Excerpted from "Test iOS Apps with UI Automation",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/jptios for more book information.
***/
#import "OpenStreetMapService.h"
#import "NBMLocationHelpers.h"
#import "NSString+NearbyMe.h"
#import "NSDictionary+NearbyMe.h"

static NSString *OSMAPIHost = @"nominatim.openstreetmap.org";

@implementation OpenStreetMapService

+ (void)setHost:(NSString *)host
{
    OSMAPIHost = [host copy];
}

// ...

+ (void)searchText:(NSString *)query
            within:(MKMapRect)rect
        completion:(OSMSCallback)serviceCompletion
{

    NBMLocationBounds bounds = NBMMakeLocationBoundsFromMapRect(rect);
    NSString *geocoded = NBMStringFromLocationBounds(bounds);
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"json", @"format",
                            query, @"q",
                            geocoded, @"viewbox",
                            @"1", @"bounded",
                            @"1", @"addressdetails",
                            nil];
    NSString *queryString = [params nbm_asQueryString];
    NSString *urlString = [NSString stringWithFormat:
                           @"http://%@/search?%@",
                           OSMAPIHost,
                           queryString];
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"%@", url);

    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    void(^networkCompletion)() = ^(NSURLResponse *res, NSData *data, NSError *e) {
        if (e) {
            serviceCompletion(nil, e);
            return;
        }

        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);

        NSError *error = nil;
        NSArray *json = [NSJSONSerialization JSONObjectWithData:data
                                                        options:0
                                                          error:&error];
        serviceCompletion(json, error);
    };

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:networkCompletion];
}

@end
