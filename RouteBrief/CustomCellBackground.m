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
    
    
    UIColor *whiteColor1 = [UIColor colorWithWhite:0.6 alpha:1.0];
    UIColor *whiteColor2 = [UIColor colorWithWhite:0.4 alpha:1];
    
    CGContextSaveGState(context); {
    
    CGFloat locations[3] = {0, 0.5, 1.0};
    /*
    CGGradientRef cellGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)@[(id)whiteColor1.CGColor, (id)
    CGPoint startPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMinY(self.bounds));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds));
    CGContextDrawLinearGradient(context, cellGradient, startPoint, endPoint, 0);
    
    } CGContextRestoreGState(context); */
}

@end
