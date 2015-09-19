//
//  WeatherViewController.m
//  RouteBrief
//
//  Created by Jason Hoffman on 10/11/14.
//  Copyright (c) 2014 No5age. All rights reserved.
//

#import "WeatherViewController.h"
#import "FlightAwareCaller.h"
#import "FlightStatsCaller.h"
#import "WeatherDetailViewController.h"

@interface WeatherViewController () <FlightAwareCallerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *originCode;
@property (weak, nonatomic) IBOutlet UILabel *originName;
@property (weak, nonatomic) IBOutlet UILabel *originCondition;
@property (weak, nonatomic) IBOutlet UILabel *destinationCode;
@property (weak, nonatomic) IBOutlet UILabel *destinationName;
@property (weak, nonatomic) IBOutlet UILabel *destinationCondition;
@property (weak, nonatomic) IBOutlet UITextField *alternateField;
@property (nonatomic, strong) FlightAwareCaller *fac;
@property (nonatomic, strong) FlightStatsCaller *fsc;

@end

@implementation WeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fsc = [[FlightStatsCaller alloc] init];
    
    [self setUpLabels];
    self.navigationController.navigationBarHidden = NO;
}

- (void)setUpLabels {
    [self.originCode setText:self.origin];
    [self.destinationCode setText:self.destination];
    NSPredicate *originPredicate = [NSPredicate predicateWithFormat:@"%K like %@", @"fs", self.origin];
    NSPredicate *destinationPredicate = [NSPredicate predicateWithFormat:@"%K like %@", @"fs", self.destination];
    NSArray *oArray = [self.airportsInfo filteredArrayUsingPredicate:originPredicate];
    NSArray *dArray = [self.airportsInfo filteredArrayUsingPredicate:destinationPredicate];
    [self.originName setText:oArray[0][@"name"]];
    [self.destinationName setText:dArray[0][@"name"]];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    WeatherDetailViewController *wdc = segue.destinationViewController;
    wdc.results = NO;
    if ([segue.identifier isEqualToString:@"originSegue"] || [segue.identifier isEqualToString:@"destinationSegue"]) {
        UITableViewCell *cell = sender;
        NSString *airport = @"";
        if (cell.tag == 98) {
            airport = self.origin;
        } else if (cell.tag == 99) {
            airport = self.destination;
        }
        dispatch_async(dispatch_get_main_queue(), ^(void){
            wdc.codeMetar.text = [NSString stringWithFormat:@"%@ METAR", airport];
            wdc.codeTaf.text = [NSString stringWithFormat:@"%@ TAF", airport];
            [self.fsc retrieveProduct:@"all" forAirport:airport completionHandler:^(NSDictionary *resp) {
                NSString *metar = [resp[@"metar"] objectForKey:@"report"];
                NSString *taf = [resp[@"metar"] objectForKey:@"report"];
                NSString *fTaf = [taf stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                NSArray *components = [fTaf componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                components = [components filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self <> ''"]];
                fTaf= [components componentsJoinedByString:@" "];
                [wdc.metarLabel setText:metar];
                [wdc.tafLabel setText:fTaf];
            }];
        });
    } else if ([segue.identifier isEqualToString:@"alternateSegue"]) {
            NSString *alternate = self.alternateField.text;
            dispatch_async(dispatch_get_main_queue(), ^(void){
                wdc.codeMetar.text = [NSString stringWithFormat:@"%@ METAR", [alternate uppercaseString]];
                wdc.codeTaf.text = [NSString stringWithFormat:@"%@ TAF", [alternate uppercaseString]];
            });
            
            [_fac getMetarForAirport:alternate completionHandler:^(NSString *results, NSError *error) {
                if ([results length] != 0) {
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        wdc.metarLabel.text = results;
                        wdc.results = YES;
                        NSLog(@"wdc.results %d", wdc.results);
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        wdc.metarLabel.text = @"";
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"noResults" object:nil];
                    });
                }
            }];
            
            [_fac getTafForAirport:alternate completionHandler:^(NSString *results, NSError *error) {
                if ([results length] != 0)  {
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        wdc.tafLabel.text = results;
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        wdc.tafLabel.text = @"";
                    });
                }
            }];
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"alternateSegue"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Missing Alternate" message:@"Please enter an alternate airport using the four letter format 'KDTW'" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
        [alert addAction:alertAction];

        
        if ([self.alternateField.text length] != 4) {
            [self presentViewController:alert animated:YES completion:^{}];
            return NO;
        } else {
            return YES;
        }
    }
    
    return YES;
}



@end
