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
#import "ScheduleResultsCell.h"
#import "CustomHeader.h"
#import "HudView.h"


@interface ScheduleViewController () <FlightStatsCallerDelegate>

@property (nonatomic, strong) __block NSArray *scheduledFlights;
@property (nonatomic, weak) NSString *origin;
@property (nonatomic, weak) NSString *destination;
@property (nonatomic, strong) FlightStatsCaller *fsc;
@property (nonatomic, strong) NSDateFormatter *formatter;
@property (nonatomic, strong) NSDictionary *responseObject;

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
    [self.tableView registerClass:[ScheduleResultsCell class] forCellReuseIdentifier:@"ScheduleMatch"];
    
    if (_flightDataReceived == NO) {
        [self.fsc retrieveFlightsForFlightNumber:self.fn onDate:self.date completionHandler:^(NSDictionary *resp) {
            
            self.responseObject = resp[@"appendix"];
            hudView.hidden = YES;
            self.view.userInteractionEnabled = YES;
            
            [self.tableView reloadData];
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
    //return [self.scheduledFlights count];
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cfraip");
    
    ScheduleResultsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScheduleMatch" forIndexPath:indexPath];
    NSLog(@"respobject %@", self.responseObject[@"flightStatuses"][0][@"departureAirportFsCode"]);
    
    cell.backgroundView = [[CustomCellBackground alloc] init];
    cell.selectedBackgroundView = [[CustomCellBackground alloc] init];
    
    id flightTime = self.responseObject[@"flightStatuses"][@"departureDate"][@"dateLocal"];
    NSTimeInterval time = [flightTime intValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    // NSDate *now = [[NSDate alloc] init];
    
    [_formatter setDateStyle:NSDateFormatterLongStyle];
    [_formatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSLog(@"departure airport %@", [NSString stringWithFormat:@"%@", self.responseObject[@"flightStatuses"][@"departureAirportFsCode"]]);
    
    
    cell.originLabel.text = self.responseObject[@"flightStatuses"][@"departureAirportFsCode"];
    cell.destinationLabel.text = self.responseObject[@"flightStatuses"][@"arrivalAirportFsCode"];
        
    cell.flightNumber.text = self.fn;

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
