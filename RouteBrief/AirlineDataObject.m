//
//  AirlineDataObject.m
//  RouteBrief
//
//  Created by Jason Hoffman on 11/29/14.
//  Copyright (c) 2014 No5age. All rights reserved.
//

#import "AirlineDataObject.h"

@implementation AirlineDataObject

- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary
{
    self = [super init];
    
    if (self) {
        _airlineID = [jsonDictionary objectForKey:@"Airline ID"];
        _name = [jsonDictionary objectForKey:@"Name"];
        _alias = [jsonDictionary objectForKey:@"Alias"];
        _icaoCode = [jsonDictionary objectForKey:@"ICAO"];
        _callSign = [jsonDictionary objectForKey:@"Callsign"];
        _country = [jsonDictionary objectForKey:@"Country"];

    }
    
    return self;
}

@end
