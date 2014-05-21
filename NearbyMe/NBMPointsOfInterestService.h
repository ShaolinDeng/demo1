/***
 * Excerpted from "Test iOS Apps with UI Automation",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/jptios for more book information.
***/
#import <Foundation/Foundation.h>
#import "NBMPointOfInterest.h"

@class NBMPointsOfInterestService;

@protocol NBMPointsOfInterestServiceDelegate <NSObject>

- (void)poiService:(NBMPointsOfInterestService *)service didFetchResults:(NSArray *)results;
- (void)poiService:(NBMPointsOfInterestService *)service didFailWithError:(NSError *)error;

@end

@interface NBMPointsOfInterestService : NSObject

@property (weak, nonatomic) id<NBMPointsOfInterestServiceDelegate> delegate;

+ (instancetype)service;
+ (void)setServiceClass:(Class)newClass;

- (void)findByText:(NSString *)query
            within:(MKMapRect)rect;

- (void)cancel;

@end
