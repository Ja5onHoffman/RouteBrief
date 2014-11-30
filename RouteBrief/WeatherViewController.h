//
//  WeatherViewController.h
//  RouteBrief
//
//  Created by Jason Hoffman on 10/11/14.
//  Copyright (c) 2014 No5age. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherViewController : UITableViewController

@property (nonatomic, weak) NSString *origin;
@property (nonatomic, weak) NSString *destination;
@property (nonatomic, weak) NSString *alternate;

@end
