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


@interface ScheduleViewController () <FlightAwareCallerDelegate>

@property (nonatomic, strong) __block NSArray *scheduledFlights;
@property (nonatomic, weak) NSString *origin;
@property (nonatomic, weak) NSString *destination;
@property (nonatomic, strong) FlightAwareCaller *fac;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation ScheduleViewController
{
    __block BOOL _flightDataReceived;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _spinner.hidden = NO;
    
    
    _fac = [[FlightAwareCaller alloc] init];
    
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
        }
        dispatch_async(dispatch_get_main_queue(), ^(void){
            _spinner.hidden = YES;
            [self.tableView reloadData];
        });
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScheduleMatch" forIndexPath:indexPath];
    
    id flightTime = self.scheduledFlights[indexPath.row][@"filed_time"];
    NSTimeInterval time = [flightTime intValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDate *now = [[NSDate alloc] init];
    
    // Log date and route of each flight
    // Need to filter out flights occurring in the past
    _origin = self.scheduledFlights[indexPath.row][@"origin"];
    _destination = self.scheduledFlights[indexPath.row][@"destination"];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", date];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", _origin, _destination];

    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    WeatherViewController *wvc = segue.destinationViewController;
    
    wvc.origin = self.origin;
    wvc.destination = self.destination;
}

// Needs to know self.fn
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
