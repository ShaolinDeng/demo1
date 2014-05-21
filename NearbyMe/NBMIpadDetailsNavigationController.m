/***
 * Excerpted from "Test iOS Apps with UI Automation",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/jptios for more book information.
***/
#import "NBMIpadDetailsNavigationController.h"
#import "NBMResultsViewController.h"

@interface NBMIpadDetailsNavigationController ()
<UINavigationControllerDelegate>

@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@end

@implementation NBMIpadDetailsNavigationController

- (void)searchController:(NBMSearchViewController *)controller didSelectSearchTerm:(NSString *)term
{
    NBMResultsViewController *resultsController = [self.viewControllers objectAtIndex:0];
    [resultsController searchQuery:term];
    [self.masterPopoverController dismissPopoverAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self showMasterPopoverIfNoQueryText];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.navigationItem.leftBarButtonItem) {
        viewController.navigationItem.leftBarButtonItem = self.navigationItem.leftBarButtonItem;
    }
}

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Searches", @"Searches");
    UIViewController *topController = self.topViewController;
    [topController.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];

    self.navigationItem.leftBarButtonItem = barButtonItem;
    self.masterPopoverController = popoverController;

    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (self.view.window) [self showMasterPopoverIfNoQueryText];
    });
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    UIViewController *topController = self.topViewController;
    [topController.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.navigationItem.leftBarButtonItem = nil;
    self.masterPopoverController = nil;
}

- (void)showMasterPopoverIfNoQueryText
{
    NBMResultsViewController *resultsController = [self.viewControllers objectAtIndex:0];
    if (!resultsController.queryText) {
        [self.masterPopoverController presentPopoverFromBarButtonItem:nil
                                             permittedArrowDirections:UIPopoverArrowDirectionAny
                                                             animated:YES];
    }
}

@end
