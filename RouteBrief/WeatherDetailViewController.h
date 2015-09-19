//
//  WeatherDetailViewController.h
//  RouteBrief
//
//  Created by Jason Hoffman on 10/20/14.
//  Copyright (c) 2014 No5age. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherDetailViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *codeMetar;
@property (weak, nonatomic) IBOutlet UILabel *codeTaf;
@property (weak, nonatomic) IBOutlet UILabel *metarLabel;
@property (weak, nonatomic) IBOutlet UILabel *tafLabel;
@property (nonatomic) BOOL results;

@end
