//
//  ScheduleResultsCell.h
//  RouteBrief
//
//  Created by Jason Hoffman on 3/13/15.
//  Copyright (c) 2015 No5age. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleResultsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *originLabel;
@property (weak, nonatomic) IBOutlet UILabel *destinationLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *flightNumber;

@end
