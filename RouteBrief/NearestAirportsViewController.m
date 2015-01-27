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
#import "CustomHeader.h"

@interface NearestAirportsViewController () <FlightStatsCallerDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NSArray *fullResp;
@property (nonatomic) float lat;
@property (nonatomic) float lon;

@end

@implementation NearestAirportsViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    cell.textLabel.text = self.airports[indexPath.row];
    cell.backgroundView = [[CustomCellBackground alloc] init];
    cell.selectedBackgroundView = [[CustomCellBackground alloc] init];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = @"Nearest Airports";
    return title;
}

// Used name of setter method and caused infinite loop
- (void)closestAirports:(NSNotification *)note
{
    self.airports = [[NSMutableArray alloc] init];
    self.fullResp = [[NSArray alloc] init];
    
    [self.fsc retrieveAirportsNearLon:self.lon andLat:self.lat completionHandler:^(NSDictionary *resp) {
        
        self.fullResp = resp[@"airports"];
        
        for (NSDictionary *dict in [resp objectForKey:@"airports"]) {
            if (dict[@"icao"]) {
                    [self.airports addObject:dict[@"icao"]];
                } else {
                    [self.airports addObject:dict[@"fs"]];
                }
            }
        
        self.spinner.hidden = YES;
        [self.tableView reloadData];
    }];
}

#pragma mark - Navigation


// Use weather URL returned from location call instead of calling again for weather
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    CurrentWxViewController *cwc = segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    cwc.currentAirport = self.airports[indexPath.row];
    NSString *url = [self.fullResp[indexPath.row] objectForKey:@"weatherUrl"];
    
    [self.fsc GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"segue response %@", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"segue response error");
    }];
    
    /*
    [self.fsc retrieveProduct:@"all" forAirport:cwc.currentAirport completionHandler:^(NSDictionary *resp) {
        dispatch_async(dispatch_get_main_queue(), ^{
            cwc.metarCell.textLabel.text = [[resp objectForKey:@"metar"] objectForKey:@"report"];
            cwc.tafCell.textLabel.text = [[resp objectForKey:@"metar"] objectForKey:@"report"];
        });
    }]; */
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
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    
    self.lat = location.coordinate.latitude;
    self.lon = location.coordinate.longitude;
    
    [self.locationManager stopUpdatingLocation];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"locationUpdated" object:nil];
}


@end



