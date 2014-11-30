//
//  CurrentWxViewController.m
//  RouteBrief
//
//  Created by Jason Hoffman on 10/21/14.
//  Copyright (c) 2014 No5age. All rights reserved.
//

#import "CurrentWxViewController.h"
#import "FlightAwareCaller.h"

@interface CurrentWxViewController ()

@property (nonatomic, weak) IBOutlet UIBarButtonItem *doneButton;
@property (nonatomic, weak) NSString *airportMetar;
@property (nonatomic, strong) FlightAwareCaller *fac;

@end

@implementation CurrentWxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
