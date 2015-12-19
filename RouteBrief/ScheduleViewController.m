//
//  ScheduleViewController.m
//  RouteBrief
//
//  Created by Jason Hoffman on 10/11/14.
//  Copyright (c) 2014 No5age. All rights reserved.
//

#import "ScheduleViewController.h"
#import "FlightNumberViewController.h"
#import "FlightStatsCaller.h"
#import "WeatherViewController.h"
#import "CustomCellBackground.h"
#import "CustomHeader.h"
#import "HudView.h"

static NSString *CellIdentifier = @"ScheduleMatch";

@interface ScheduleViewController () <FlightStatsCallerDelegate, NSCoding>

@property (nonatomic, strong) __block NSArray *scheduledFlights;
@property (nonatomic, strong) __block NSArray *airportsInfo;
@property (nonatomic, weak) NSString *origin;
@property (nonatomic, weak) NSString *destination;
@property (nonatomic, strong) FlightStatsCaller *fsc;
@property (nonatomic, strong) NSDateFormatter *formatter;
@property (nonatomic, strong) NSArray *responseObject;
@property (nonatomic, strong) NSMutableArray *airports;

@end

@implementation ScheduleViewController
{
    __block BOOL _flightDataReceived;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.fsc = [[FlightStatsCaller alloc] init];
    self.formatter = [[NSDateFormatter alloc] init];
    _flightDataReceived = NO;
    HudView *hudView = [HudView hudInView:self.navigationController.view animated:YES];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
//    [notificationCenter addObserver:self selector:@selector(updateWeather) name:@"updateWeather" object:nil];
    self.navigationController.navigationBarHidden = NO;
    
    UIColor *navColor = [UIColor colorWithRed:52.0f/255.0f green:60.0f/255.0f blue:69.0f/255.0f alpha:1.0];
    self.navigationController.navigationBar.backgroundColor = navColor;
    
    self.fsc.delegate = self;
    if (_flightDataReceived == NO) {
        [self.fsc retrieveFlightsForFlightNumber:self.fn onDate:self.date completionHandler:^(NSDictionary *resp) {
            self.responseObject = resp[@"scheduledFlights"];
            self.airportsInfo = resp[@"appendix"][@"airports"];
            hudView.hidden = YES;
            self.view.userInteractionEnabled = YES;
            [self.tableView reloadData];
//            [notificationCenter postNotificationName:@"updateWeather" object:nil];
        }];
    }
}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.responseObject count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    cell.backgroundView = [[CustomCellBackground alloc] init];
//    cell.selectedBackgroundView = [[CustomCellBackground alloc] init];
    cell.backgroundColor = [UIColor colorWithRed:224.0f/255.0 green:223.0f/255.0 blue:213.0f/255.0 alpha:1.0];
    [self.formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss.sss'"];
    NSDate *rsTimeDate = [self.formatter dateFromString:[self.responseObject[indexPath.row] objectForKey:@"departureTime"]];
    NSDateFormatter *visibleDateFormatter = [[NSDateFormatter alloc] init];
    [visibleDateFormatter setDateStyle:NSDateFormatterShortStyle];
    [visibleDateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSString *visDate = [visibleDateFormatter stringFromDate:rsTimeDate];
    
    UILabel *originLabel = (UILabel *)[cell viewWithTag:200];
    UILabel *destinationLabel = (UILabel *)[cell viewWithTag:201];
    UILabel *flightNumber = (UILabel *)[cell viewWithTag:202];
    UILabel *date = (UILabel *)[cell viewWithTag:203];
    
    [originLabel setText:self.responseObject[indexPath.row][@"departureAirportFsCode"]];
    [destinationLabel setText:self.responseObject[indexPath.row][@"arrivalAirportFsCode"]];
    [flightNumber setText:[self.fn uppercaseString]];
    [date setText:visDate];

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CustomHeader *header = [[CustomHeader alloc] init];
    header.titleLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    
    return header;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = @"Flight Info";
    
    return title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

//- (void)updateWeather {
//    NSArray *noDupes = [self.airportsInfo valueForKeyPath:@"@distinctUnionOfObjects.icao"];
//    for (NSString *airport in noDupes) {
//        [self.fsc retrieveProduct:@"all" forAirport:airport completionHandler:^(NSDictionary *resp) {
//            self.metar = [resp[@"metar"] objectForKey:@"report"];
//            NSString *taf = [resp[@"metar"] objectForKey:@"report"];
//            NSString *fTaf = [taf stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//            NSArray *components = [fTaf componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//            components = [components filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self <> ''"]];
//            self.taf = [components componentsJoinedByString:@" "];
//        }];
//    }
//}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    WeatherViewController *wvc = segue.destinationViewController;
    // Get indexPath for selected cell so orig and dest will update when new cell is selected
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    wvc.origin = self.responseObject[indexPath.row][@"departureAirportFsCode"];
    wvc.destination = self.responseObject[indexPath.row][@"arrivalAirportFsCode"];
    wvc.airportsInfo = self.airportsInfo;
}

- (IBAction)refresh:(id)sender {
    void (^compHandler)(NSDictionary *, NSError *) = ^(NSDictionary *results, NSError *error) {
        if (error) {
            NSLog(@"There was an error");
        } else {
            self.scheduledFlights = [results objectForKey:@"flights"];
            NSLog(@"_scheduledFlights: %@", _scheduledFlights);
            NSLog(@"Saved");
        }
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self.tableView reloadData];
        });
    };

}

@end

