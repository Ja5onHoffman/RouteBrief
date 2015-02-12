//
//  FlightAwareCaller.m
//  RouteBrief
//
//  Created by Jason Hoffman on 10/11/14.
//  Copyright (c) 2014 No5age. All rights reserved.
//

#import "FlightAwareCaller.h"

#define FLIGHTAWARE_USERNAME @"name"
#define FLIGHTAWARE_API_KEY @"key"
#define SITA_API_KEY @"key"


@interface FlightAwareCaller ()

@property (nonatomic, strong) NSURLSession *urlSession;
@property (nonatomic, assign) BOOL locationUpdated;
@property (nonatomic, weak) NSString *airport;
@property (nonatomic, strong) NSNotificationCenter *notificationCenter;
@property (nonatomic) float lat;
@property (nonatomic) float lon;

@end


@implementation FlightAwareCaller

- (void)getMetarForAirport:(NSString *)airports completionHandler:(void (^)(NSString *results, NSError *error))completionHandler
{
    NSLog(@"getMetar");

    
    NSString *requestString = [NSString stringWithFormat:@"http://%@:%@@flightxml.flightaware.com/json/FlightXML2/Metar?airport=%@", FLIGHTAWARE_USERNAME, FLIGHTAWARE_API_KEY, airports];
    NSLog(@"requestSTring: %@", requestString);
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    config.HTTPAdditionalHeaders = @{@"Accept" : @"application/json"};
    _urlSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];

    NSURLSessionDataTask *dataTask = [_urlSession dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSString *resultString = [jsonObject objectForKey:@"MetarResult"];
        
        completionHandler(resultString, error);
    }];
    
    [dataTask resume];
}

- (void)getTafForAirport:(NSString *)airports completionHandler:(void (^)(NSString *results, NSError *error))completionHandler
{
    NSLog(@"getTaf");
    
    NSString *requestString = [NSString stringWithFormat:@"http://%@:%@@flightxml.flightaware.com/json/FlightXML2/Taf?airport=%@", FLIGHTAWARE_USERNAME, FLIGHTAWARE_API_KEY, airports];
    NSLog(@"requestSTring: %@", requestString);
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    config.HTTPAdditionalHeaders = @{@"Accept" : @"application/json"};
    _urlSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask = [_urlSession dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSLog(@"jsonObject %@", jsonObject);
        NSString *resultString = [[jsonObject objectForKey:@"TafResult"] substringFromIndex:17];

        completionHandler(resultString, error);
    }];
    
    [dataTask resume];
}

- (void)getFlightsForFN:(NSString *)fn completionHandler:(void (^)(NSDictionary *results, NSError *error))completionHandler
{
    NSLog(@"getFlights");
    if (fn) {
        NSString *requestString = [NSString stringWithFormat:@"http://%@:%@@flightxml.flightaware.com/json/FlightXML2/FlightInfo?ident=%@", FLIGHTAWARE_USERNAME, FLIGHTAWARE_API_KEY, fn];
        NSLog(@"%@", requestString);
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        config.HTTPAdditionalHeaders = @{@"Accept" : @"application/json"};
        _urlSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
        
        NSURL *url = [NSURL URLWithString:requestString];
        NSURLRequest *req = [NSURLRequest requestWithURL:url];
        
        NSURLSessionDataTask *dataTask = [_urlSession dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (completionHandler) {
                if (error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completionHandler(nil, error);
                    });
                } else {
                    NSError *parseError;
                    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completionHandler(jsonObject[@"FlightInfoResult"], parseError);
                    });
                }
            }
        }];
        
        [dataTask resume];
    } else {
        NSLog(@"No fn");
    }
}

- (void)querySITAwithCompletionHandler:(void (^)(NSArray *nearestAirports, NSError *error))completionHandler
{
    NSLog(@"querySita");
    NSString *url = [NSString stringWithFormat:@"https://airport.api.aero/airport/nearest/%f/%f?maxAirports=5&user_key=%@", _lat, _lon, SITA_API_KEY];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    _urlSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLSessionDataTask *dataTask = [_urlSession dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (completionHandler) {
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler(nil, error);
                });
            } else {
                NSError *parseError;
                NSData *json = [data subdataWithRange:NSMakeRange(9, data.length - 10)];
                NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:&parseError];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler([jsonObject valueForKeyPath:@"airports.code"], parseError);
                    NSLog(@"jsonObject: %@", [jsonObject valueForKeyPath:@"airports.code"]);
                });
            }
        }
    }];
    
    [dataTask resume];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler {
    
    NSString *user = FLIGHTAWARE_USERNAME;
    NSString *password = FLIGHTAWARE_API_KEY;
    
    NSLog(@"didReceiveChallenge");
    
    NSURLCredential *secretHandshake = [NSURLCredential credentialWithUser:user password:password persistence:NSURLCredentialPersistenceForSession];
    
    completionHandler(NSURLSessionAuthChallengeUseCredential,secretHandshake);
}

#pragma mark - Location Manager

/************************************************************************************
 *
 *   Use CLLocationCoordinate2D and CLPlacemark in code instead of .latitude, etc.
 *
 ************************************************************************************/

- (void)startLocation
{
    NSLog(@"startLocation");
    if (nil == _locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    }
    
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingLocation];
}

/*
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"didUpdateLocation");
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    
    _lat = location.coordinate.latitude;
    _lon = location.coordinate.longitude;
    
    NSLog(@"%f", location.coordinate.latitude);
    NSLog(@"%f", location.coordinate.longitude);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"locationUpdated" object:nil];
    [self.locationManager stopUpdatingLocation];
} */

@end
