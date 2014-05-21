/***
 * Excerpted from "Test iOS Apps with UI Automation",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/jptios for more book information.
***/
#import "NBMAppDelegate.h"
#import "NBMDocument.h"
#import "NBMSearchViewController.h"
#import "NBMIpadDetailsNavigationController.h"
#import "NBMTestSetup.h"

@interface NBMAppDelegate ()

@property (nonatomic, strong) NBMDocument *document;

@end

@implementation NBMAppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Initialize data structures
    self.document = [[NBMDocument alloc] init];

    NBMTestSetup *setup = [[NBMTestSetup alloc] initWithDocument:self.document];
    [setup runIfInUITests];

    // ...

    // Finish normal setup for the user
    [self.document setupDefaultDataIfEmpty];

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [self setupApplicationForiPad];
    } else {
        [self setupApplicationForiPhone];
    }

    return YES;
}


#pragma mark - Setup Methods

- (void)setupApplicationForiPad
{
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    splitViewController.presentsWithGesture = NO;

    NBMIpadDetailsNavigationController *iPadDetailController = [splitViewController.viewControllers lastObject];
    splitViewController.delegate = iPadDetailController;
    
    UINavigationController *masterNavigationController = [splitViewController.viewControllers objectAtIndex:0];
    NBMSearchViewController *controller = (NBMSearchViewController *)masterNavigationController.topViewController;
    controller.managedObjectContext = _document.managedObjectContext;
    controller.searchControllerDelegate = iPadDetailController;
}

- (void)setupApplicationForiPhone
{
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    NBMSearchViewController *controller = (NBMSearchViewController *)navigationController.topViewController;
    controller.managedObjectContext = _document.managedObjectContext;
}

@end
