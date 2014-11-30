//
//  NearestAirportsViewController.h
//  RouteBrief
//
//  Created by Jason Hoffman on 10/30/14.
//  Copyright (c) 2014 No5age. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlightAwareCaller.h"

@interface NearestAirportsViewController : UITableViewController <FlightAwareCallerDelegate>

@property (nonatomic, strong) FlightAwareCaller *fac;
@property (nonatomic, strong) NSArray *airports;

@end
