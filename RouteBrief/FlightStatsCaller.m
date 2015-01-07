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

static NSString * const FlightStatsWeatherPackageURL = @"https://api.flightstats.com/flex/airlines/rest/v1/json/active?appId=0726c1bf&appKey=e4fe2b66fbd0d317a96266a9ec555522";

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

/*
- (NSDictionary *)getWeatherForAirport:(NSString *)airport
{
    NSDictionary *weatherPackage = [[NSDictionary alloc] init];
    
    //[self GET:<#(NSString *)#> parameters:<#(id)#> success:<#^(NSURLSessionDataTask *task, id responseObject)success#> failure:<#^(NSURLSessionDataTask *task, NSError *error)failure#>]
    
    return;
} */

@end
