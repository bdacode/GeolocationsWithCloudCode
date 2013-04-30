//
//  MasterViewController.m
//  Geolocations
//
//  Created by Héctor Ramos on 7/31/12.
//

// PFQueryTableViewController UIStoryboard Template

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "SearchViewController.h"

@implementation MasterViewController
@synthesize locationManager = _locationManager;
@synthesize avgButton, avgPoint;

#pragma mark - NSObject

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"geoPointAnnotiationUpdated" object:nil];
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    if (![CLLocationManager locationServicesEnabled]) {
        
    }
    
    [[self locationManager] startUpdatingLocation];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    [headerView setBackgroundColor:[UIColor colorWithRed:223.0/255.0 green:231.0/255.0 blue:238.0/255.0 alpha:1.0]];
    avgButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [avgButton setFrame:CGRectMake(60, 5, 200, 40)];
    [avgButton setTitle:@"Loading..." forState:UIControlStateNormal];
    [avgButton addTarget:self action:@selector(showAverageLocation) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:avgButton];
    [self.tableView setTableHeaderView:headerView];
    
    // Listen for annotation updates. Triggers a refresh whenever an annotation is dragged and dropped.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadObjects) name:@"geoPointAnnotiationUpdated" object:nil];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self reloadAverageButton];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait || UIInterfaceOrientationIsLandscape(interfaceOrientation));
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        // Row selection
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    } else if ([[segue identifier] isEqualToString:@"showSearch"]) {
        // Search button
        [[segue destinationViewController] setInitialLocation:[self locationManager].location];
    }
}


#pragma mark - PFQueryTableViewController

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
}

/*
 // Override to customize what kind of query to perform on the class. The default is to query for
 // all objects ordered by createdAt descending.
 - (PFQuery *)queryForTable {
 PFQuery *query = [PFQuery queryWithClassName:self.className];
 
 // If Pull To Refresh is enabled, query against the network by default.
 if (self.pullToRefreshEnabled) {
 query.cachePolicy = kPFCachePolicyNetworkOnly;
 }
 
 // If no objects are loaded in memory, we look to the cache first to fill the table
 // and then subsequently do a query against the network.
 if (self.objects.count == 0) {
 query.cachePolicy = kPFCachePolicyCacheThenNetwork;
 }
 
 [query orderByDescending:@"createdAt"];
 
 return query;
 }
 */

// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
// and the imageView being the imageKey in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    // A date formatter for the creation date.
    static NSDateFormatter *dateFormatter = nil;
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	}
    
	static NSNumberFormatter *numberFormatter = nil;
	if (numberFormatter == nil) {
		numberFormatter = [[NSNumberFormatter alloc] init];
		[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
		[numberFormatter setMaximumFractionDigits:3];
	}
    
    PFTableViewCell *cell = (PFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"LocationCell"];
    
    // Configure the cell
    PFGeoPoint *geoPoint = [object objectForKey:@"location"];
    
	cell.textLabel.text = [dateFormatter stringFromDate:[object updatedAt]];
    
    NSString *string = [NSString stringWithFormat:@"%@, %@",
						[numberFormatter stringFromNumber:[NSNumber numberWithDouble:geoPoint.latitude]],
						[numberFormatter stringFromNumber:[NSNumber numberWithDouble:geoPoint.longitude]]];
    
    cell.detailTextLabel.text = string;
    
    return cell;
}

/*
 // Override if you need to change the ordering of objects in the table.
 - (PFObject *)objectAtIndex:(NSIndexPath *)indexPath {
 return [self.objects objectAtIndex:indexPath.row];
 }
 */

/*
 // Override to customize the look of the cell that allows the user to load the next page of objects.
 // The default implementation is a UITableViewCellStyleDefault cell with simple labels.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
 static NSString *CellIdentifier = @"NextPage";
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
 if (cell == nil) {
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }
 
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 cell.textLabel.text = @"Load more...";
 
 return cell;
 }
 */


#pragma mark - UITableViewDataSource

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the object from Parse and reload the table view
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, and save it to Parse
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark - CLLocationManagerDelegate

/**
 Conditionally enable the Search/Add buttons:
 If the location manager is generating updates, then enable the buttons;
 If the location manager is failing, then disable the buttons.
 */
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    self.navigationItem.leftBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
}


#pragma mark - MasterViewController

/**
 Return a location manager -- create one if necessary.
 */
- (CLLocationManager *)locationManager {
	
    if (_locationManager != nil) {
		return _locationManager;
	}
	
	_locationManager = [[CLLocationManager alloc] init];
	[_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
	[_locationManager setDelegate:self];
    [_locationManager setPurpose:@"Your current location is used to demonstrate PFGeoPoint and Geo Queries."];
	
	return _locationManager;
}

- (IBAction)insertCurrentLocation:(id)sender {
	// If it's not possible to get a location, then return.
	CLLocation *location = _locationManager.location;
	if (!location) {
		return;
	}
    
	// Configure the new event with information from the location.
	CLLocationCoordinate2D coordinate = [location coordinate];
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    PFObject *object = [PFObject objectWithClassName:@"Location"];
    [object setObject:geoPoint forKey:@"location"];
    [object setObject:[PFUser currentUser] forKey:@"user"];
    
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // Reload the PFQueryTableViewController
            [self loadObjects];
            
            // Refresh average button
            [self reloadAverageButton];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Something went wrong"
                                        message:[[error userInfo] objectForKey:@"error"]
                                       delegate:nil
                              cancelButtonTitle:@"ok"
                              otherButtonTitles: nil] show];
        }
    }];
}

- (void)reloadAverageButton {
    [PFCloud callFunctionInBackground:@"getLocationAverage" withParameters:[NSDictionary new] block:^(id object, NSError *error) {
        if (!error) {
            avgPoint = object;
            [avgButton setTitle:@"See average location!" forState:UIControlStateNormal];
        } else {
            avgPoint = nil;
            [avgButton setTitle:@"Sorry, not available!" forState:UIControlStateNormal];
        }
    }];
}

- (void)showAverageLocation {
    // Check if an average point has been calculated
    if (avgPoint) {
        // Manually show the detail view controller
        DetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
        PFObject *tempObject = [PFObject objectWithClassName:@"Location"];
        [tempObject setObject:avgPoint forKey:@"location"];
        [detailViewController setDetailItem:tempObject];
        [detailViewController setTitle:@"Average Location"];
        [self.navigationController pushViewController:detailViewController animated:YES];
        // If not calculated, show an error message
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Not available"
                                    message:@"Your average location is not currently available."
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles: nil] show];
    }
}

@end