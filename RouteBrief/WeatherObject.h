//
//  WeatherObject.h
//  RouteBrief
//
//  Created by Jason Hoffman on 12/18/14.
//  Copyright (c) 2014 No5age. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherObject : NSObject

@property (nonatomic, strong) NSArray *metar;
@property (nonatomic , strong) NSArray *taf;
@property (nonatomic, strong) NSArray *zoneForecast;
@property (nonatomic, strong) NSArray *appendix;

@end
