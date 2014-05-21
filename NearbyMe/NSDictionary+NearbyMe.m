/***
 * Excerpted from "Test iOS Apps with UI Automation",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/jptios for more book information.
***/
#import "NSDictionary+NearbyMe.h"
#import "NSString+NearbyMe.h"

@implementation NSDictionary (NearbyMe)

- (NSString *)nbm_asQueryString
{
    NSMutableString *string = [NSMutableString string];
    
    for (NSString *key in self) {
        NSString *value = [self valueForKey:key];
        [string appendFormat:@"%@=%@&", key, [value nbm_urlEncoded]];
    }
    
    if ([string length] > 0)
        [string deleteCharactersInRange:NSMakeRange([string length] - 1, 1)];
    
    return string;    
}

@end
