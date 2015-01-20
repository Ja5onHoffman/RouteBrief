//
//  FlightStatsCaller.h
//  RouteBrief
//
//  Created by Jason Hoffman on 12/11/14.
//  Copyright (c) 2014 No5age. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FlightStatsCaller;

@protocol FlightStatsCallerDelegate <NSObject>

@optional

- (void)getWeatherForAirport:(NSString *)airport completionHandler:(void (^)(NSDictionary *results, NSError *error))completionHandler;

@end

@interface FlightStatsCaller : AFHTTPSessionManager <NSURLSessionDelegate>

+ (FlightStatsCaller *)sharedFlightStatsCaller;
- (instancetype)initWithBaseURL:(NSURL *)url;
- (void)getActiveAirlinesWithCompHandler:(void (^)(NSArray *ar))completionHandler;
- (void)getWeatherForAirport:(NSString *)airport completionHandler:(void (^)(NSDictionary *results, NSError *error))completionHandler;

@property (nonatomic, weak) id<FlightStatsCallerDelegate> delegate;

@end
