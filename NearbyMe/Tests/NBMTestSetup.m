/***
 * Excerpted from "Test iOS Apps with UI Automation",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/jptios for more book information.
***/
#import "NBMTestSetup.h"
#import "NBMTestDataFactory.h"
#import "OpenStreetMapService.h"
#import "NBMPointsOfInterestServiceStub.h"

// Define the HTTP endpoint that will mimic Open Street Map for our tests.
// If running in the simulator, then assume the server is running on the same
// Mac. If running on the device, then you'll need to update the hostname
// below and make sure the device is on the same WiFi as the Mac so it can
// talk to the fake server.

#if TARGET_IPHONE_SIMULATOR
#define TestOSMServiceHost @"localhost:4567"
#else
// Replace with your Mac's hostname
#define TestOSMServiceHost @"snarkbait.local:4567"
#endif


static inline NSString *NBMEnvironment(NSString *varName)
{
    NSDictionary *environment = [[NSProcessInfo processInfo] environment];
    return [environment objectForKey:varName];
}

@interface NBMTestSetup ()
@property (nonatomic, retain) NBMDocument *document;
@end

@implementation NBMTestSetup

- (id)initWithDocument:(NBMDocument *)document
{
    self = [super init];
    if (self) {
        _document = document;
    }
    return self;
}

- (void)runIfInUITests
{
    if (NBMEnvironment(@"UI_TESTS") == nil) return;

    NSLog(@"UI_TESTS environment variable detected.");

    NSString *dataFactoryMessage = NBMEnvironment(@"DATA_FACTORY_MESSAGE");
    if (dataFactoryMessage) {
        [self sendMessageToDataFactory:dataFactoryMessage];
    }

    [NBMPointsOfInterestServiceStub stubServiceSuperclass];
}

- (void)sendMessageToDataFactory:(NSString *)message
{
    NSLog(@"Sending message \"%@\" to data factory.", message);
    NBMTestDataFactory *factory =
            [[NBMTestDataFactory alloc] initWithDocument:self.document];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [factory performSelector:NSSelectorFromString(message)];
#pragma clang diagnostic pop
}

@end
