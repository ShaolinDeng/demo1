/***
 * Excerpted from "Test iOS Apps with UI Automation",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/jptios for more book information.
***/
#import "NSString+NearbyMe.h"

@implementation NSString (NearbyMe)

- (NSString *)nbm_urlEncoded
{
    CFStringRef encoded = CFURLCreateStringByAddingPercentEscapes(
                              kCFAllocatorDefault, 
                              (__bridge CFStringRef) self, 
                              nil,
                              CFSTR("?!@#$^&%*+:;='\"`<>()[]{}/\\| "), 
                              kCFStringEncodingUTF8);
    
    NSString *encodedValue = [[NSString alloc] initWithString:
                              (__bridge_transfer NSString*) encoded];    
    
    if(!encodedValue) encodedValue = @"";
    
    return encodedValue;
}

@end
