/***
 * Excerpted from "Test iOS Apps with UI Automation",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/jptios for more book information.
***/
#import "NBMListResultsViewController.h"
#import "NBMPointOfInterest.h"

@interface NBMListResultsViewController ()

@property (strong, nonatomic) NSArray *pointsOfInterest;
@property (strong, nonatomic) CLLocation* searchLocation;

@end

@implementation NBMListResultsViewController

- (void)setPointsOfInterest:(NSArray *)pointsOfInterest
               nearLocation:(CLLocation *)location
{
    self.searchLocation = location;

    NSComparator comparator = ^NSComparisonResult(NBMPointOfInterest *obj1, NBMPointOfInterest *obj2) {
        CGFloat distance1 = [self distanceFromSearchLocation:obj1.coordinate];
        CGFloat distance2 = [self distanceFromSearchLocation:obj2.coordinate];

        if (distance1 > distance2) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if (distance1 < distance2) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    
    self.pointsOfInterest = [pointsOfInterest sortedArrayUsingComparator:comparator];
    [self.tableView reloadData];
}

- (void)removePointsOfInterest
{
    self.pointsOfInterest = @[];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.pointsOfInterest count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListResultTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];

    NBMPointOfInterest *poi = _pointsOfInterest[indexPath.row];

    cell.textLabel.text = poi.title;

    // Localization is left as an exercise for the reader. :)
    NSString *units = @"mi";
    CGFloat distance = [self distanceFromSearchLocation:poi.coordinate];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.1f %@", distance, units];
    
    return cell;
}

- (CGFloat)distanceFromSearchLocation:(CLLocationCoordinate2D)coordinates
{
    CLLocation *dest = [[CLLocation alloc] initWithLatitude:coordinates.latitude longitude:coordinates.longitude];

    // Convert meters to miles
    return [_searchLocation distanceFromLocation:dest] * 0.000621371;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Give a slight delay so the user sees the selection
    double delayInSeconds = 0.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NBMPointOfInterest *poi = _pointsOfInterest[indexPath.row];
        [_listResultsDelegate listResultsController:self didTapPointOfInterest:poi];
    });
}

@end
