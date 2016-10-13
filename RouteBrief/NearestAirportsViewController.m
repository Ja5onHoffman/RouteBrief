//
//  NearestAirportsViewController.m
//  RouteBrief
//
//  Created by Jason Hoffman on 10/30/14.
//  Copyright (c) 2014 No5age. All rights reserved.
//

#import "NearestAirportsViewController.h"
#import "CurrentWxViewController.h"
#import "CustomCellBackground.h"
#import "CustomUINavigationBar.h"
#import "CustomHeader.h"

@interface NearestAirportsViewController () <FlightStatsCallerDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NSArray *fullResp;
@property (nonatomic) BOOL closestAirportsCalled;
@property (nonatomic) float lat;
@property (nonatomic) float lon;

@end

@implementation NearestAirportsViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    NSLog(@"self.closestAirportsCalled %i", self.closestAirportsCalled);
    
    if (self) {
        self.fsc = [[FlightStatsCaller alloc] init];
        self.fsc.delegate = self;
        self.spinner.hidden = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closestAirports:) name:@"locationUpdated" object:nil];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.airports count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CustomHeader *header = [[CustomHeader alloc] init];
    header.titleLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nearbyAirport" forIndexPath:indexPath];
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
    UILabel *distanceLabel = (UILabel *)[cell viewWithTag:101];
    titleLabel.text = self.airports[indexPath.row][0];
    distanceLabel.text = self.airports[indexPath.row][1];
    cell.backgroundView = [[CustomCellBackground alloc] init];
    cell.selectedBackgroundView = [[CustomCellBackground alloc] init];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = @"Nearest Airports";
    return title;
}

- (void)closestAirports:(NSNotification *)note
{
    if (self.closestAirportsCalled == NO) {
        NSLog(@"closestAirports");
        self.airports = [[NSMutableArray alloc] init];
        self.fullResp = [[NSArray alloc] init];
        
        [self.fsc retrieveAirportsNearLon:self.lon andLat:self.lat completionHandler:^(NSDictionary *resp) {
            self.fullResp = resp[@"airports"];
            for (NSDictionary *dict in [resp objectForKey:@"airports"]) {
                double lat = [dict[@"latitude"] doubleValue];
                double lon = [dict[@"longitude"] doubleValue];
                CLLocation *loc = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
                CLLocation *userLoc = [[CLLocation alloc] initWithLatitude:self.lat longitude:self.lon];
                CLLocationDistance dist = [userLoc distanceFromLocation:loc];
                NSString *miles = [[NSString stringWithFormat:@"%.1f", (dist * 0.00062137)] stringByAppendingString:@" miles"];
                if (dict[@"icao"]) {
                   [self.airports addObject:[NSArray arrayWithObjects:dict[@"icao"], miles, nil]];
                } else {
                    [self.airports addObject:[NSArray arrayWithObjects:dict[@"fs"], miles, nil]];
                }
            }
            self.spinner.hidden = YES;
            [self.tableView reloadData];
        }];
        
        self.closestAirportsCalled = YES;
        
    } else {
        NSLog(@"Already called");
    }
}

#pragma mark - Navigation

- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Use weather URL returned from location call instead of calling again for weather
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    CurrentWxViewController *cwc = segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    cwc.currentAirport = self.airports[indexPath.row];
    NSString *url = [self.fullResp[indexPath.row] objectForKey:@"weatherUrl"];
    [self.fsc GET:url parameters:self.fsc.params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            cwc.metarCell.textLabel.text = [[responseObject objectForKey:@"metar"] objectForKey:@"report"];
            cwc.tafCell.textLabel.text = [[responseObject objectForKey:@"taf"] objectForKey:@"report"];
        });
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"segue response error");
    }];
}

#pragma mark - Location Manager

/************************************************************************************
 *
 *   Use CLLocationCoordinate2D and CLPlacemark in code instead of .latitude, etc.
 *
 ************************************************************************************/

- (void)startLocation
{
    if (nil == self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    }
    
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation* location = [locations lastObject];
    
    self.lat = location.coordinate.latitude;
    self.lon = location.coordinate.longitude;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"locationUpdated" object:nil];
    [self.locationManager stopUpdatingLocation];
}


@end



