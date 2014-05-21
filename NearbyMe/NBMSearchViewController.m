/***
 * Excerpted from "Test iOS Apps with UI Automation",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/jptios for more book information.
***/
#import "NBMSearchViewController.h"
#import "NBMMapResultsViewController.h"
#import "NBMSavedSearch.h"

@interface NBMSearchViewController ()
<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *sortSwitch;

@end

@implementation NBMSearchViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavigationBar];

    self.detailViewController = (NBMResultsViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)addButtonPressed
{
    NSString *msg = @"Type a search string\nto add to the list";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New Search"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"Canel"
                                          otherButtonTitles:@"Add", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textField = [alert textFieldAtIndex:0];
    textField.returnKeyType = UIReturnKeyDone;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) return;

    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    [NBMSavedSearch insertEntityContext:context
                               withText:[alertView textFieldAtIndex:0].text];
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}


#pragma mark - IBActions

- (IBAction)sortSwitchChanged:(UISegmentedControl *)sender
{
    NSArray *oldIndexPaths = [self.tableView indexPathsForVisibleRows];

    NSMutableArray *oldVisibleObjects = [NSMutableArray array];

    for (NSIndexPath *path in oldIndexPaths) {
        [oldVisibleObjects addObject:[self.fetchedResultsController
                   objectAtIndexPath:path]];
    }

    [self refreshFetchedResultsController];

    [self.tableView beginUpdates];
    for (int i = 0; i < [oldVisibleObjects count]; i++) {
        NBMSavedSearch *search = [oldVisibleObjects objectAtIndex:i];
        NSIndexPath *oldIndexPath = [oldIndexPaths objectAtIndex:i];
        NSIndexPath *newIndexPath =
            [self.fetchedResultsController indexPathForObject:search];

        if ([oldIndexPaths containsObject:newIndexPath]) {
            [self.tableView moveRowAtIndexPath:oldIndexPath
                                   toIndexPath:newIndexPath];
        } else {
            [self.tableView deleteRowsAtIndexPaths:@[oldIndexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
    [self.tableView endUpdates];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void) tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context =
            [self.fetchedResultsController managedObjectContext];
        [context deleteObject:
            [self.fetchedResultsController objectAtIndexPath:indexPath]];

        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NBMSavedSearch *search = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    int64_t delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [search touch];
    });

    [self.searchControllerDelegate searchController:self didSelectSearchTerm:search.text];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NBMSavedSearch *search = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[segue destinationViewController] searchQuery:search.text];
    }
}


#pragma mark - Fetched results controller

- (NSArray *)sortDescriptorsForSelectedSortOrder
{
    NSSortDescriptor *sortDescriptor = nil;
    if (_sortSwitch.selectedSegmentIndex == 0) {
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastUsedAt" ascending:NO];
    } else {
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"text" ascending:YES];
    }
    return @[sortDescriptor];
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) return _fetchedResultsController;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SavedSearch" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setFetchBatchSize:20];
    [fetchRequest setSortDescriptors:[self sortDescriptorsForSelectedSortOrder]];

    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;

    [self refreshFetchedResultsController];

    return _fetchedResultsController;
}

- (void)refreshFetchedResultsController
{
    [self.fetchedResultsController.fetchRequest setSortDescriptors:[self sortDescriptorsForSelectedSortOrder]];
    [self.fetchedResultsController performFetch:nil];

    NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [object valueForKey:@"text"];
}


#pragma mark - Setup

- (void)setupNavigationBar
{
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self
                                                                               action:@selector(addButtonPressed)];
    self.navigationItem.rightBarButtonItem = addButton;
}


@end
