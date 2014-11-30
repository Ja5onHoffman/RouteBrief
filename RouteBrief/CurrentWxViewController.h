//
//  CurrentWxViewController.h
//  RouteBrief
//
//  Created by Jason Hoffman on 10/21/14.
//  Copyright (c) 2014 No5age. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrentWxViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITableViewCell *metarCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *tafCell;

@property (nonatomic, strong) NSString *currentAirport;

@end
