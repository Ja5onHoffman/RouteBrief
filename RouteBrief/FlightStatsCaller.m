//
//  FlightStatsCaller.m
//  RouteBrief
//
//  Created by Jason Hoffman on 12/11/14.
//  Copyright (c) 2014 No5age. All rights reserved.
//

#import "FlightStatsCaller.h"

#define FLIGHT_STATS_APP_ID @"0726c1bf"
#define FLIGHT_STATS_API_KEY @"e4fe2b66fbd0d317a96266a9ec555522"


// Still active airlines - need to change to base url
static NSString * const FlightStatsBaseURL = @"https://api.flightstats.com/flex/airlines/rest/v1/json/active?appId=0726c1bf&appKey=e4fe2b66fbd0d317a96266a9ec555522";

static NSString * const FlightStatsWeatherPackageURL = @"https://api.flightstats.com/flex/weather/rest/v1/json/all/DFW?appId=0726c1bf&appKey=e4fe2b66fbd0d317a96266a9ec555522";

@interface FlightStatsCaller ()


@end

@implementation FlightStatsCaller

+ (FlightStatsCaller *)sharedFlightStatsCaller
{
    static FlightStatsCaller *_sharedFlightStatsCaller = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedFlightStatsCaller = [[self alloc] initWithBaseURL:[NSURL URLWithString:FlightStatsBaseURL]];
    });
    
    return _sharedFlightStatsCaller;
}

- (instancetype)initWithBaseURL:(NSURL *)url{
    
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return self;
}

- (void)getActiveAirlinesWithCompHandler:(void (^)(NSArray *ar))completionHandler
{
    __block NSArray *airlines = [[NSArray alloc] init];
    
    [self GET:FlightStatsBaseURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortByName];
        airlines = [responseObject[@"airlines"] sortedArrayUsingDescriptors:sortDescriptors];

        completionHandler(airlines);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"There was an error");
    }];
    
}

// AFNetworking
- (NSDictionary *)getWeatherForAirport:(NSString *)airport
{
    NSDictionary *dummyDict = [[NSDictionary alloc] init];
    [self GET:FlightStatsWeatherPackageURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *weatherPackage = responseObject;
        NSLog(@"weatherPackage %@", [[weatherPackage objectForKey:@"metar"] objectForKey:@"report"]);
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"There was an error");
    }];
    
    return dummyDict;
}

@end
