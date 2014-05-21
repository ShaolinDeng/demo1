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

@class NBMLocationManager;

typedef void (^NBMLocationManagerFindCallback)(NBMLocationManager *locationManager);
typedef void (^NBMLocationManagerErrorCallback)(NSError *error);

@interface NBMLocationManager : NSObject

@property (nonatomic, readonly) BOOL locationAcquired;
@property (readonly, strong, nonatomic) CLLocation *currentLocation;

- (void)findUserLocation:(NBMLocationManagerFindCallback)callback
                 onError:(NBMLocationManagerErrorCallback)onError;
- (void)cancel;

@end
