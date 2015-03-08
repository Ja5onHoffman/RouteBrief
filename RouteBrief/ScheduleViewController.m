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


@interface ScheduleViewController () <FlightStatsCallerDelegate>

@property (nonatomic, strong) __block NSArray *scheduledFlights;
@property (nonatomic, weak) NSString *origin;
@property (nonatomic, weak) NSString *destination;
@property (nonatomic, strong) FlightStatsCaller *fsc;
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
    
    self.fsc = [[FlightStatsCaller alloc] init];
    _formatter = [[NSDateFormatter alloc] init];
    
    HudView *hudView = [HudView hudInView:self.navigationController.view animated:YES];
    
    self.navigationController.navigationBarHidden = NO;
    
    UIColor *navColor = [UIColor colorWithRed:52.0f/255.0f green:60.0f/255.0f blue:69.0f/255.0f alpha:1.0];
    self.navigationController.navigationBar.backgroundColor = navColor;
    
    self.fsc.delegate = self;
    
    /*
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
    }; */
    
    // Need datePicker
    if (_flightDataReceived == NO) {
        [self.fsc retrieveFlightsForFlightNumber:self.fn onDate:self.date completionHandler:^(NSDictionary *resp) {
            NSLog(@"%@", resp);
    }];
        
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScheduleMatch" forIndexPath:indexPath];
    cell.backgroundView = [[CustomCellBackground alloc] init];
    cell.selectedBackgroundView = [[CustomCellBackground alloc] init];
    
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CustomHeader *header = [[CustomHeader alloc] init];
    header.titleLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    
    return header;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = @"Scheduled Flights";
    
    return title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
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

    //[self.fsc getFlightsForFN:self.fn
}

@end
