//
//  WeatherViewController.m
//  RouteBrief
//
//  Created by Jason Hoffman on 10/11/14.
//  Copyright (c) 2014 No5age. All rights reserved.
//

#import "WeatherViewController.h"
#import "FlightAwareCaller.h"
#import "WeatherDetailViewController.h"

@interface WeatherViewController () <FlightAwareCallerDelegate>


@property (weak, nonatomic) __block IBOutlet UITableViewCell *originCell;
@property (weak, nonatomic) __block IBOutlet UITableViewCell *destinationCell;

@property (nonatomic, strong) FlightAwareCaller *fac;
@property (weak, nonatomic) IBOutlet UITextField *alternateTextField;

@end

@implementation WeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _fac = [[FlightAwareCaller alloc] init];
    _originCell.textLabel.text = self.origin;
    _destinationCell.textLabel.text = self.destination;
    
    [_fac getMetarForAirport:self.origin completionHandler:^(NSString *results, NSError *error){
       dispatch_async(dispatch_get_main_queue(), ^(void){
           _originCell.detailTextLabel.text = results;
        });
    }];

    [_fac getMetarForAirport:self.destination completionHandler:^(NSString *results, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^(void){
            _destinationCell.detailTextLabel.text = results;
        });
    }];
    
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    WeatherDetailViewController *wdc = segue.destinationViewController;
    wdc.results = NO;
    
    if ([segue.identifier isEqualToString:@"originSegue"] || [segue.identifier  isEqualToString:@"destinationSegue"]) {
        UITableViewCell *cell = sender;
        dispatch_async(dispatch_get_main_queue(), ^(void){
            wdc.codeMetar.text = [NSString stringWithFormat:@"%@ METAR", cell.textLabel.text];
            wdc.codeTaf.text = [NSString stringWithFormat:@"%@ TAF", cell.textLabel.text];
            
            wdc.metarText = cell.detailTextLabel.text;
            
            
            [_fac getTafForAirport:cell.textLabel.text
                 completionHandler:^(NSString *results, NSError *error) {
                     dispatch_async(dispatch_get_main_queue(), ^(void){
                         wdc.tafText = results;
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"labelsUpdated" object:nil];
                     });
                 }];
        });
    } else if ([segue.identifier isEqualToString:@"alternateSegue"]) {
            
            NSString *alternate = self.alternateTextField.text;
        
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

        
        if ([self.alternateTextField.text length] != 4) {
            [self presentViewController:alert animated:YES completion:^{}];
            return NO;
        } else {
            return YES;
        }
    }
    
    return YES;
}



@end
