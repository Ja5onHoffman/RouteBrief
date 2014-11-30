//
//  HudView.m
//  RouteBrief
//
//  Created by Jason Hoffman on 11/7/14.
//  Copyright (c) 2014 No5age. All rights reserved.
//

#import "HudView.h"

@implementation HudView

+ (instancetype)hudInView:(UIView *)view animated:(BOOL)animated
{
    HudView *hudView = [[HudView alloc] initWithFrame:view.bounds];
    hudView.opaque = NO;
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    spinner.center = hudView.center;
    [hudView addSubview:spinner];
    
    // Need this for spinner to show
    [spinner startAnimating];
    
    [view addSubview:hudView];

    return hudView;
}

- (void)drawRect:(CGRect)rect
{
    const CGFloat boxWidth = 96.0f;
    const CGFloat boxHeight = 96.0f;
    
    CGRect boxRect = CGRectMake(
                                roundf(self.bounds.size.width - boxWidth) / 2.0f,
                                roundf(self.bounds.size.height - boxHeight) / 2.0f,
                                boxWidth,
                                boxHeight);
    
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:boxRect cornerRadius:10.0f];
    [[UIColor colorWithWhite:0.3f alpha:0.8f] setFill];
    [roundedRect fill];
}

@end
