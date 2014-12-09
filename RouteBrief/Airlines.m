//
//  Airlines.m
//
//  Created by Jason Hoffman on 12/4/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "Airlines.h"


NSString *const kAirlinesICAO = @"ICAO";
NSString *const kAirlinesActive = @"Active";
NSString *const kAirlinesAirlineID = @"Airline ID";
NSString *const kAirlinesAlias = @"Alias";
NSString *const kAirlinesCountry = @"Country";
NSString *const kAirlinesName = @"Name";
NSString *const kAirlinesCallsign = @"Callsign";
NSString *const kAirlinesIATA = @"IATA";


@interface Airlines ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Airlines

@synthesize iCAO = _iCAO;
@synthesize active = _active;
@synthesize airlineID = _airlineID;
@synthesize alias = _alias;
@synthesize country = _country;
@synthesize name = _name;
@synthesize callsign = _callsign;
@synthesize iATA = _iATA;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.iCAO = [self objectOrNilForKey:kAirlinesICAO fromDictionary:dict];
            self.active = [self objectOrNilForKey:kAirlinesActive fromDictionary:dict];
            self.airlineID = [self objectOrNilForKey:kAirlinesAirlineID fromDictionary:dict];
            self.alias = [self objectOrNilForKey:kAirlinesAlias fromDictionary:dict];
            self.country = [self objectOrNilForKey:kAirlinesCountry fromDictionary:dict];
            self.name = [self objectOrNilForKey:kAirlinesName fromDictionary:dict];
            self.callsign = [self objectOrNilForKey:kAirlinesCallsign fromDictionary:dict];
            self.iATA = [self objectOrNilForKey:kAirlinesIATA fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.iCAO forKey:kAirlinesICAO];
    [mutableDict setValue:self.active forKey:kAirlinesActive];
    [mutableDict setValue:self.airlineID forKey:kAirlinesAirlineID];
    [mutableDict setValue:self.alias forKey:kAirlinesAlias];
    [mutableDict setValue:self.country forKey:kAirlinesCountry];
    [mutableDict setValue:self.name forKey:kAirlinesName];
    [mutableDict setValue:self.callsign forKey:kAirlinesCallsign];
    [mutableDict setValue:self.iATA forKey:kAirlinesIATA];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.iCAO = [aDecoder decodeObjectForKey:kAirlinesICAO];
    self.active = [aDecoder decodeObjectForKey:kAirlinesActive];
    self.airlineID = [aDecoder decodeObjectForKey:kAirlinesAirlineID];
    self.alias = [aDecoder decodeObjectForKey:kAirlinesAlias];
    self.country = [aDecoder decodeObjectForKey:kAirlinesCountry];
    self.name = [aDecoder decodeObjectForKey:kAirlinesName];
    self.callsign = [aDecoder decodeObjectForKey:kAirlinesCallsign];
    self.iATA = [aDecoder decodeObjectForKey:kAirlinesIATA];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_iCAO forKey:kAirlinesICAO];
    [aCoder encodeObject:_active forKey:kAirlinesActive];
    [aCoder encodeObject:_airlineID forKey:kAirlinesAirlineID];
    [aCoder encodeObject:_alias forKey:kAirlinesAlias];
    [aCoder encodeObject:_country forKey:kAirlinesCountry];
    [aCoder encodeObject:_name forKey:kAirlinesName];
    [aCoder encodeObject:_callsign forKey:kAirlinesCallsign];
    [aCoder encodeObject:_iATA forKey:kAirlinesIATA];
}

- (id)copyWithZone:(NSZone *)zone
{
    Airlines *copy = [[Airlines alloc] init];
    
    if (copy) {

        copy.iCAO = [self.iCAO copyWithZone:zone];
        copy.active = [self.active copyWithZone:zone];
        copy.airlineID = [self.airlineID copyWithZone:zone];
        copy.alias = [self.alias copyWithZone:zone];
        copy.country = [self.country copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.callsign = [self.callsign copyWithZone:zone];
        copy.iATA = [self.iATA copyWithZone:zone];
    }
    
    return copy;
}


@end
