//
//  FlightStatsCaller.h
//  RouteBrief
//
//  Created by Jason Hoffman on 12/11/14.
//  Copyright (c) 2014 No5age. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlightStatsCaller : AFHTTPSessionManager <NSURLSessionDelegate>

+ (FlightStatsCaller *)sharedFlightStatsCaller;
- (instancetype)initWithBaseURL:(NSURL *)url;
- (void)getActiveAirlinesWithCompHandler:(void (^)(NSArray *ar))completionHandler;
- (NSDictionary *)getWeatherForAirport:(NSString *)airport;

@end
