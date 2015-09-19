//
//  WeatherViewController.h
//  RouteBrief
//
//  Created by Jason Hoffman on 10/11/14.
//  Copyright (c) 2014 No5age. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherViewController : UITableViewController

@property (nonatomic, strong) NSString *origin;
@property (nonatomic, strong) NSString *destination;
@property (nonatomic, strong) NSString *alternate;
@property (nonatomic, strong) NSArray *airportsInfo;

@end
