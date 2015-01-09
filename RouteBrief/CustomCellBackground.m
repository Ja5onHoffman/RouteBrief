//
//  CustomCellBackground.m
//  RouteBrief
//
//  Created by Jason Hoffman on 1/7/15.
//  Copyright (c) 2015 No5age. All rights reserved.
//

#import "CustomCellBackground.h"

@implementation CustomCellBackground

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGRect cellRect = self.bounds;
    
    UIColor * whiteColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    UIColor * lightGrayColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
    UIColor * separatorColor = [UIColor colorWithRed:208.0/255.0 green:208.0/255.0 blue:208.0/255.0 alpha:1.0];
    
    CGContextSaveGState(context); {
    
    CGFloat locations[2] = {0, 1.0};
        
    CGGradientRef cellGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)@[(id)whiteColor.CGColor, (id)lightGrayColor.CGColor], locations);
    CGPoint startPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMinY(self.bounds));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds));
    CGContextDrawLinearGradient(context, cellGradient, startPoint, endPoint, 0);
    
    } CGContextRestoreGState(context);
}

@end
