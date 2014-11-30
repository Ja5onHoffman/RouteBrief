//
//  JSONLoader.m
//  RouteBrief
//
//  Created by Jason Hoffman on 11/29/14.
//  Copyright (c) 2014 No5age. All rights reserved.
//

#import "JSONLoader.h"
#import "AirlineDataObject.h"

@implementation JSONLoader

- (NSDictionary *)airlinesFromJSONFile
{
 
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"airlineData" ofType:@"json"];
    NSData *JSONData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:nil];
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:nil];

    return jsonObject;
}

@end