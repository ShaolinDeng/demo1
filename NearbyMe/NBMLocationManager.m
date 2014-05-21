/***
 * Excerpted from "Test iOS Apps with UI Automation",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/jptios for more book information.
***/
#import "NBMLocationManager.h"
#import "NBMAccessibleAnnotationView.h"


@interface NBMLocationManager () <CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic, readwrite) CLLocation *currentLocation;
@property (nonatomic, readwrite) BOOL locationAcquired;
@property (copy, nonatomic) NBMLocationManagerFindCallback callback;
@property (copy, nonatomic) NBMLocationManagerErrorCallback onError;
@property (strong, nonatomic) NSTimer *settlingTimer;
@end

@implementation NBMLocationManager

- (void)dealloc
{
    [self cleanup];
    [_locationManager stopUpdatingLocation];
    self.locationManager = nil;
}

- (void)findUserLocation:(NBMLocationManagerFindCallback)callback
                 onError:(NBMLocationManagerErrorCallback)onError;
{
    [self startLocationManager];
    self.callback = callback;
    self.onError = onError;
}

- (void)cancel
{
    [self cleanup];
}


#pragma mark - Core Location

- (void)startLocationManager
{
    if (_locationManager) return;
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    if (_locationAcquired) return;

    [self.settlingTimer invalidate];
    self.settlingTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(settlingTimerFired) userInfo:nil repeats:NO];
}

- (void)settlingTimerFired
{
    if (_locationAcquired) return;
    
    _locationAcquired = YES;
    
    self.currentLocation = _locationManager.location;

    if (_callback) _callback(self);
    [self cleanup];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    if (_onError) _onError(error);
    [self cleanup];
}

- (void)cleanup
{
    [self.settlingTimer invalidate];
    self.settlingTimer = nil;
    self.callback = nil;
    self.onError = nil;
}


@end

