//
//  NearestAirportsViewController.h
//  RouteBrief
//
//  Created by Jason Hoffman on 10/30/14.
//  Copyright (c) 2014 No5age. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "FlightAwareCaller.h"
#import "FlightStatsCaller.h"

@interface NearestAirportsViewController : UITableViewController <FlightAwareCallerDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) FlightAwareCaller *fac;
@property (nonatomic, strong) FlightStatsCaller *fsc;
@property (nonatomic, strong) NSMutableArray *airports;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end
