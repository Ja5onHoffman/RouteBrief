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
@property (nonatomic, strong) NSString *originMetar;
@property (nonatomic, strong) NSString *originTaf;
@property (weak, nonatomic) IBOutlet UILabel *originCondition;
@property (weak, nonatomic) IBOutlet UILabel *destinationCode;
@property (weak, nonatomic) IBOutlet UILabel *destinationName;
@property (nonatomic, strong) NSString *destinationMetar;
@property (nonatomic, strong) NSString *destinationTaf;
@property (weak, nonatomic) IBOutlet UILabel *destinationCondition;
@property (weak, nonatomic) IBOutlet UITextField *alternateField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *oActivity;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *dActivity;
@property (nonatomic, strong) FlightAwareCaller *fac;
@property (nonatomic, strong) FlightStatsCaller *fsc;

@end

@implementation WeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fsc = [[FlightStatsCaller alloc] init];
    [self setUpLabels];
    self.navigationController.navigationBarHidden = NO;
    [self.oActivity startAnimating];
    [self.dActivity startAnimating];
    self.originCondition.hidden = YES;
    self.destinationCondition.hidden = YES;
    [self getWeather];
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

#pragma mark - TableView

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *v = (UITableViewHeaderFooterView *)view;
    v.contentView.backgroundColor = [UIColor colorWithRed:232.0f/255.0f green:233.0f/255.0f blue:235.0f/255.0f alpha:1.0];
    v.textLabel.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:22];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [self getColorForCell:cell];
    // color for condition label
//    [cell viewWithTag:102].tintColor = [self getColorForLabelInCell:cell];
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
            if (cell.tag == 98) {
                [wdc.metarLabel setText:self.originMetar];
                [wdc.tafLabel setText:self.originTaf];
            } else if (cell.tag == 99) {
                [wdc.metarLabel setText:self.destinationMetar];
                [wdc.tafLabel setText:self.destinationTaf];
            }
        });
    } else if ([segue.identifier isEqualToString:@"alternateSegue"]) {
            NSString *alternate = self.alternateField.text;
            dispatch_async(dispatch_get_main_queue(), ^(void){
                wdc.codeMetar.text = [NSString stringWithFormat:@"%@ METAR", [alternate uppercaseString]];
                wdc.codeTaf.text = [NSString stringWithFormat:@"%@ TAF", [alternate uppercaseString]];
            });
        
        [self.fsc retrieveProduct:@"all" forAirport:self.alternateField.text completionHandler:^(NSDictionary *resp) {
            wdc.metarLabel.text = [resp[@"metar"] objectForKey:@"report"];
            NSString *taf = [resp[@"taf"] objectForKey:@"report"];
            NSString *fTaf = [taf stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSArray *components = [fTaf componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            components = [components filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self <> ''"]];
            wdc.tafLabel.text = [components componentsJoinedByString:@" "];
        }];

    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
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

#pragma mark - Get Weather

- (void)getWeather {
//    NSArray *noDupes = [self.airportsInfo valueForKeyPath:@"@distinctUnionOfObjects.icao"];
    NSArray *airports = [NSArray arrayWithObjects:self.originCode.text, self.destinationCode.text, nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        // Origin
        [self.fsc retrieveProduct:@"all" forAirport:airports[0] completionHandler:^(NSDictionary *resp) {
            self.originMetar = [resp[@"metar"] objectForKey:@"report"];
            [self.originCondition setText:[self getConditionsFromArray:[resp[@"metar"] objectForKey:@"tags"]]];
            self.oActivity.hidden = YES;
            self.originCondition.hidden = NO;
            NSString *taf = [resp[@"taf"] objectForKey:@"report"];
            NSString *fTaf = [taf stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSArray *components = [fTaf componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            components = [components filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self <> ''"]];
            self.originTaf = [components componentsJoinedByString:@" "];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];

        }];
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // Destination
        [self.fsc retrieveProduct:@"all" forAirport:airports[1] completionHandler:^(NSDictionary *resp) {
            self.destinationMetar = [resp[@"metar"] objectForKey:@"report"];
            [self.destinationCondition setText:[self getConditionsFromArray:[resp[@"metar"] objectForKey:@"tags"]]];
            self.dActivity.hidden = YES;
            self.destinationCondition.hidden = NO;
            NSString *taf = [resp[@"taf"] objectForKey:@"report"];
            NSString *fTaf = [taf stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSArray *components = [fTaf componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            components = [components filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self <> ''"]];
            self.destinationTaf = [components componentsJoinedByString:@" "];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        }];
    });
}

- (UIColor *)getColorForCell:(UITableViewCell *)cell {
    UIColor *vfr = [UIColor colorWithRed:127.0f/255.0f green:233.0f/255.0f blue:205.0f/255.0f alpha:1.0];
    UIColor *mvfr = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:163.0f/255.0f alpha:1.0];
    UIColor *ifr = [UIColor colorWithRed:239.0f/255.0f green:100.0f/255.0f blue:97.0f/255.0f alpha:1.0];
    UIColor *none = [UIColor colorWithRed:224.0f/255.0f green:223.0f/255.0f blue:213.0f/255.0f alpha:1.0];
    UILabel *oLabel = [cell viewWithTag:102];
    if ([oLabel.text isEqualToString: @"VFR"]) {
        return vfr;
    } else if ([oLabel.text isEqualToString:@"IFR"] || [oLabel.text isEqualToString:@"LIFR"]) {
        return ifr;
    } else if ([oLabel.text isEqualToString:@"MVFR"]) {
        return mvfr;
    }
    
    return none;
}

- (UIColor *)getColorForLabelInCell:(UITableViewCell *)cell {
    UIColor *vfr = [UIColor colorWithRed:127.0f/255.0f green:255.0f/255.0f blue:205.0f/255.0f alpha:1.0];
    UIColor *mvfr = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:140.0f/255.0f alpha:1.0];
    UIColor *ifr = [UIColor colorWithRed:239.0f/255.0f green:80.0f/255.0f blue:97.0f/255.0f alpha:1.0];
    UIColor *none = [UIColor colorWithRed:224.0f/255.0f green:223.0f/255.0f blue:213.0f/255.0f alpha:1.0];
    UILabel *oLabel = [cell viewWithTag:102];
    if ([oLabel.text isEqualToString: @"VFR"]) {
        return vfr;
    } else if ([oLabel.text isEqualToString:@"IFR"] || [oLabel.text isEqualToString:@"LIFR"]) {
        return ifr;
    } else if ([oLabel.text isEqualToString:@"MVFR"]) {
        return mvfr;
    }
    
    return none;
}

// NSPredicate to find 'instrumentation' dictionary in tags
- (NSString *)getConditionsFromArray:(NSArray *)array {
    NSPredicate *p = [NSPredicate predicateWithFormat:@"key CONTAINS[cd] 'Instrumentation'"];
    NSArray *c = [array filteredArrayUsingPredicate:p];
    NSString *conditions = [c[0] objectForKey:@"value"];
    return conditions;
}

@end
