//
//  FlightAwareCaller.h
//  RouteBrief
//
//  Created by Jason Hoffman on 10/11/14.
//  Copyright (c) 2014 No5age. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h> 

@class FlightAwareCaller;

@protocol FlightAwareCallerDelegate <NSObject>

@optional

- (void)getFlightsForFN:(NSString *)fn completionHandler:(void (^)(NSDictionary *results, NSError *error))completionHandler;
- (void)getMetarForAirport:(NSString *)airports completionHandler:(void (^)(NSString *results, NSError *error))completionHandler;
- (void)getTafForAirport:(NSString *)airports completionHandler:(void (^)(NSString *results, NSError *error))completionHandler;
- (void)querySITAwithCompletionHandler:(void (^)(NSArray *nearestAirports, NSError *error))completionHandler;
- (void)startLocation;

@end


@interface FlightAwareCaller : AFHTTPSessionManager <NSURLSessionDataDelegate, CLLocationManagerDelegate>

@property (nonatomic, weak) __block NSString *weather;
@property (nonatomic, weak) __block NSArray *flights;
@property (nonatomic, strong) CLLocationManager *locationManager;


@property (nonatomic, weak) id <FlightAwareCallerDelegate> delegate;

- (void)getFlightsForFN:(NSString *)fn completionHandler:(void (^)(NSDictionary *results, NSError *error))completionHandler;
- (void)getMetarForAirport:(NSString *)airports completionHandler:(void (^)(NSString *results, NSError *error))completionHandler;
- (void)getTafForAirport:(NSString *)airports completionHandler:(void (^)(NSString *results, NSError *error))completionHandler;
- (void)querySITAwithCompletionHandler:(void (^)(NSArray *nearestAirports, NSError *error))completionHandler;
- (void)startLocation;

@end
