//
//  ScheduleViewController.m
//  RouteBrief
//
//  Created by Jason Hoffman on 10/11/14.
//  Copyright (c) 2014 No5age. All rights reserved.
//

#import "ScheduleViewController.h"
#import "FlightNumberViewController.h"
#import "FlightAwareCaller.h"
#import "WeatherViewController.h"
#import "HudView.h"


@interface ScheduleViewController () <FlightAwareCallerDelegate>

@property (nonatomic, strong) __block NSArray *scheduledFlights;
@property (nonatomic, weak) NSString *origin;
@property (nonatomic, weak) NSString *destination;
@property (nonatomic, strong) FlightAwareCaller *fac;
@property (nonatomic, strong) NSDateFormatter *formatter;

@end

@implementation ScheduleViewController
{
    __block BOOL _flightDataReceived;
}

/*
 *  TODO: Implement NSDateFormatter to format date in schedule view
 *      - make reuseable -- static object in own method
 *
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"ScheduleViewController viewDidLoad");
    
    _fac = [[FlightAwareCaller alloc] init];
    _formatter = [[NSDateFormatter alloc] init];
    
    HudView *hudView = [HudView hudInView:self.navigationController.view animated:YES];
    
    self.navigationController.navigationBarHidden = NO;
    _fac.delegate = self;
    
    void (^compHandler)(NSDictionary *, NSError *) = ^(NSDictionary *results, NSError *error) {
        if (error) {
            NSLog(@"There was an error");
        } else {
            self.scheduledFlights = [results objectForKey:@"flights"];
            _flightDataReceived = YES;
           // NSLog(@"_scheduledFlights: %@", _scheduledFlights);
            NSLog(@"Saved");
            
            hudView.hidden = YES;
            self.view.userInteractionEnabled = YES;
        }
        
        [self.tableView reloadData];
    };
    
    if (_flightDataReceived == NO) {
        [_fac getFlightsForFN:self.fn completionHandler:compHandler];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return [self.scheduledFlights count];
}

// Origin and destination don't update after first row selection
// Also might not choose orig and dest for correct row

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScheduleMatch" forIndexPath:indexPath];
    
    id flightTime = self.scheduledFlights[indexPath.row][@"filed_time"];
    NSTimeInterval time = [flightTime intValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    // NSDate *now = [[NSDate alloc] init];
    
    [_formatter setDateStyle:NSDateFormatterLongStyle];
    [_formatter setTimeStyle:NSDateFormatterShortStyle];
    
    
    
    // Log date and route of each flight
    // Need to filter out flights occurring in the past
    _origin = self.scheduledFlights[indexPath.row][@"origin"];
    _destination = self.scheduledFlights[indexPath.row][@"destination"];
    
    cell.detailTextLabel.text = [_formatter stringFromDate:date];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ to %@", _origin, _destination];

    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    WeatherViewController *wvc = segue.destinationViewController;
    
    // Get indexPath for selected cell so orig and dest will update when new cell is selected
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    wvc.origin = self.scheduledFlights[indexPath.row][@"origin"];
    wvc.destination = self.scheduledFlights[indexPath.row][@"destination"];
}

- (IBAction)refresh:(id)sender
{
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

    [_fac getFlightsForFN:self.fn completionHandler:compHandler];
}

@end
