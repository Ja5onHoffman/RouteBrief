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

@interface NearestAirportsViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation NearestAirportsViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        NSLog(@"NearestAirportsViewController init");
        _fac = [[FlightAwareCaller alloc] init];
        self.fac.delegate = self;
        _spinner.hidden = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setAirports:) name:@"locationUpdated" object:nil];
        
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"NearestAirportsViewController viewDidLoad");
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"airports count %lu", [_airports count]);
    return [_airports count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nearbyAirport" forIndexPath:indexPath];
    
    // Error because <null> at end of array
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

- (void)setAirports:(NSNotification *)note
{
    NSLog(@"setAirports");
    [self.fac querySITAwithCompletionHandler:^(NSArray *nearestAirports, NSError *error) {
        NSRange range = NSMakeRange(0, nearestAirports.count - 1);
        _airports = [nearestAirports objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
        NSLog(@"airports: %@", _airports);
        _spinner.hidden = YES;
        [self.tableView reloadData];
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    CurrentWxViewController *cwc = segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    cwc.currentAirport = _airports[indexPath.row];
    
    [_fac getMetarForAirport:cwc.currentAirport completionHandler:^(NSString *results, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            cwc.metarCell.textLabel.text = results;
        });
    }];
    
    [_fac getTafForAirport:cwc.currentAirport completionHandler:^(NSString *results, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            cwc.tafCell.textLabel.text = results;
        });
    }];
}

@end



