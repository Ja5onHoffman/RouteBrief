//
//  FlightStatsCaller.m
//  RouteBrief
//
//  Created by Jason Hoffman on 12/11/14.
//  Copyright (c) 2014 No5age. All rights reserved.
//

#import "FlightStatsCaller.h"

// Still active airlines - need to change to base url
static NSString * const FlightStatsBaseURL = @"https://api.flightstats.com/flex";

@interface FlightStatsCaller ()

@property (nonatomic, strong) NSString *appID;
@property (nonatomic ,strong) NSString *appKey;

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
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"keys" ofType:@"plist"];
        NSDictionary *keys = [NSDictionary dictionaryWithContentsOfFile:path];
        
        self.appID = [keys objectForKey:@"appID"];
        self.appKey = [keys objectForKey:@"appKey"];
        
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return self;
}

- (void)getActiveAirlinesWithCompHandler:(void (^)(NSArray *ar))completionHandler
{
    __block NSArray *airlines = [[NSArray alloc] init];
    
    [self.requestSerializer setValue:self.appKey forHTTPHeaderField:@"appKey"];
    [self.requestSerializer setValue:self.appID forHTTPHeaderField:@"appId"];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@", FlightStatsBaseURL, @"airlines/rest/v1/json", @"active"];
    NSLog(@"url %@", url);
    
    [self GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortByName];
        airlines = [responseObject[@"airlines"] sortedArrayUsingDescriptors:sortDescriptors];

        completionHandler(airlines);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"There was an error");
    }];
    
}

// AFNetworking
- (void)retrieveProduct:(NSString *)product forAirport:(NSString *)airport completionHandler:(void(^)(NSDictionary *resp))completionHandler
{
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@", FlightStatsBaseURL, @"weather/rest/v1/json", product, airport];
    
    [self.requestSerializer setValue:self.appKey forHTTPHeaderField:@"appKey"];
    [self.requestSerializer setValue:self.appID forHTTPHeaderField:@"appId"];
    
    [self GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        completionHandler(responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        NSLog(@"There was an error");
    }];
}

- (void)retrieveAirportsNearLon:(float)lon andLat:(float)lat completionHandler:(void(^)(NSDictionary *resp))completionHandler
{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%f/%f/%@", FlightStatsBaseURL, @"airports/rest/v1/json/withinRadius", lon, lat, @"25"];
    NSLog(@"retreiveAirportsNear");
    [self.requestSerializer setValue:self.appKey forHTTPHeaderField:@"appKey"];
    [self.requestSerializer setValue:self.appID forHTTPHeaderField:@"appId"];
    
    NSLog(@"url %@", url);
    
    [self GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {

        completionHandler(responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"There was an error");
    }];
}

@end
