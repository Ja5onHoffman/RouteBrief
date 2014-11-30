//
//  FlightNumberViewController.m
//  RouteBrief
//
//  Created by Jason Hoffman on 10/11/14.
//  Copyright (c) 2014 No5age. All rights reserved.
//

#import "FlightNumberViewController.h"
#import "ScheduleViewController.h"
#import "CurrentWxViewController.h"
#import "FlightAwareCaller.h"

@interface FlightNumberViewController ()

@property (nonatomic, weak) IBOutlet UITextField *fnLabel;
@property (weak, nonatomic) IBOutlet UIButton *currentWxButton;

@end

@implementation FlightNumberViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Add segue instead of button press? YES
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"scheduledFlights"]) {
        ScheduleViewController *svc = segue.destinationViewController;
        svc.fn = _fnLabel.text;
        NSLog(@"_fnLabel.text: %@", _fnLabel.text);
        NSLog(@"svc.fn: %@", svc.fn);
    } else if ([segue.identifier isEqualToString:@"currentWxBrief"]) {
        CurrentWxViewController *cvc = segue.destinationViewController;
        cvc.metarCell.textLabel.text = @"This is the Metar cell";
        cvc.tafCell.textLabel.text = @"This isthe Taf cell";
    
    }

}

@end
