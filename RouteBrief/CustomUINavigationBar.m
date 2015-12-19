//
//  CustomUINavigationBar.m
//  RouteBrief
//
//  Created by Jason Hoffman on 12/11/15.
//  Copyright © 2015 No5age. All rights reserved.
//

#import "CustomUINavigationBar.h"

@implementation CustomUINavigationBar

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        UIColor *navColor = [UIColor colorWithRed:197.0f/255.0f green:12.0f/255.0f blue:22.0f/255.0f alpha:1.0];
        [self setBackgroundColor:navColor];
    }
    return self;
}

@end
