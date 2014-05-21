/***
 * Excerpted from "Test iOS Apps with UI Automation",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/jptios for more book information.
***/
#import "NBMResultsViewController.h"
#import "NBMMapResultsViewController.h"
#import "NBMListResultsViewController.h"
#import "NBMPointsOfInterestService.h"
#import "NBMLocationManager.h"

@interface NBMResultsViewController ()
<NBMListResultsViewControllerDelegate,
NBMMapResultsViewControllerDelegate,
NBMPointsOfInterestServiceDelegate>

@property (strong, nonatomic) NBMPointsOfInterestService *poiService;
@property (strong, nonatomic) NBMLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet UISegmentedControl *resultsSwitch;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) UIViewController *selectedViewController;

@property (weak, nonatomic) NBMMapResultsViewController *mapViewController;
@property (weak, nonatomic) NBMListResultsViewController *listViewController;

@end

@implementation NBMResultsViewController


#pragma mark - Setup

- (void)awakeFromNib
{
    self.mapViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"mapResultsViewController"];
    [self addChildViewController:self.mapViewController];
    self.mapViewController.mapResultsDelegate = self;
    self.listViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"listResultsViewController"];
    [self addChildViewController:self.listViewController];
    self.listViewController.listResultsDelegate = self;
    
    self.title = @"";
}

- (void)searchQuery:(NSString *)term
{
    self.queryText = term;
    self.title = self.queryText;
    if (self.selectedViewController) {
        [self fetchQuery];
    } else {
        [self showMapView];
        [self zoomMapToCurrentLocation];
    }
}


#pragma mark - IB Actions

- (IBAction)refresh
{
    if (self.queryText) [self fetchQuery];
}


#pragma mark - View Controller Callbacks

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (self.queryText && !self.selectedViewController) [self showMapView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (self.selectedViewController) {
        [self performSelector:@selector(zoomMapToCurrentLocation) withObject:nil afterDelay:0];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.poiService cancel];
    [self.locationManager cancel];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    self.selectedViewController.view.frame = self.view.bounds;
}


#pragma mark - Picking View Controller

- (IBAction)switchView:(UISegmentedControl *)switchControl
{
    switch (switchControl.selectedSegmentIndex) {
        case 0:
            [self showMapView];
            break;
        case 1:
            [self showListView];
            break;
        default:
            NSAssert(false, @"Unknown switch value %d", switchControl.selectedSegmentIndex);
    }
}

- (void)showMapView
{
    if (self.mapViewController == self.selectedViewController) return;

    [self showNewViewController:self.mapViewController];
}

- (void)showListView
{
    if (self.listViewController == self.selectedViewController) return;
    
    [self showNewViewController:self.listViewController];
}

- (void)showNewViewController:(UIViewController *)newController
{
    newController.view.frame = self.containerView.bounds;
    [UIView transitionWithView:self.containerView duration:0.1
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
        [self.selectedViewController viewWillDisappear:YES];
        [self.selectedViewController.view removeFromSuperview];

        [newController viewWillAppear:YES];
        [self.containerView addSubview:newController.view];
    } completion:^(BOOL finished) {
        [self.selectedViewController viewDidDisappear:YES];
        [newController viewDidAppear:YES];
        self.selectedViewController = newController;
    }];    
}


#pragma mark - Map Results Delegate Methods

- (void)mapResultsControllerDidFinishShowingLocation:(NBMMapResultsViewController *)controller
{
    [self refresh];
}


#pragma mark - List Results Delegate Methods

- (void)listResultsController:(NBMListResultsViewController *)controller
        didTapPointOfInterest:(NBMPointOfInterest *)poi
{
    [self.resultsSwitch setSelectedSegmentIndex:0];
    [self switchView:self.resultsSwitch];
    [self.mapViewController showPointOfInterest:poi animated:YES];
}


#pragma mark - Querying

- (void)zoomMapToCurrentLocation
{
    [self.locationManager findUserLocation:^(NBMLocationManager *locationManager) {
        [self.mapViewController showLocation:locationManager.currentLocation radius:1000 animated:YES];
        // Will be called back when location is done showing
    } onError:^(NSError *error) {
        NSString *msg = @"Cannot determine your location. Make sure NearbyMe has permission to use your location in the Settings app.";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Disabled"
                                                        message:msg
                                                       delegate:nil
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)fetchQuery
{
    [self.mapViewController removePointsOfInterest];
    [self.listViewController removePointsOfInterest];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    [self.poiService cancel];   // Cancel previous operation, if any
    self.poiService = [NBMPointsOfInterestService service];
    self.poiService.delegate = self;

    [self.poiService findByText:self.queryText
                         within:self.mapViewController.visibleMapRect];
}

- (void)poiService:(NBMPointsOfInterestService *)service didFetchResults:(NSArray *)results
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    if ([results count] == 0) {
        // Only show the alert if this view is the visible one
        if (self.view.window) [self alertNoResultsFound];
    } else {
        [self setPointsOfInterest:results];
    }
}

- (void)poiService:(NBMPointsOfInterestService *)service didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error"
                                                    message:error.localizedDescription
                                                   delegate:nil
                                          cancelButtonTitle:@"Okay"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)setPointsOfInterest:(NSArray *)results
{
    [self.mapViewController addPointsOfInterest:results];
    [_listViewController setPointsOfInterest:results
                                nearLocation:self.locationManager.currentLocation];
}


#pragma mark - Notifying The User

- (void)alertNoResultsFound
{
    NSString *msg = [NSString stringWithFormat:@"No results found with \"%@\" in the visible map area.", self.queryText];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not found"
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"Okay"
                                          otherButtonTitles:nil];
    [alert show];
}


#pragma mark - Lazy Initialization

- (NBMLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[NBMLocationManager alloc] init];
    }
    return _locationManager;
}


@end
