//
//  Airline.m
//
//  Created by Jason Hoffman on 12/4/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "Airline.h"
#import "Airlines.h"


NSString *const kAirlineAirlines = @"airlines";


@interface Airline ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Airline

@synthesize airlines = _airlines;


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
    NSObject *receivedAirlines = [dict objectForKey:kAirlineAirlines];
    NSMutableArray *parsedAirlines = [NSMutableArray array];
    if ([receivedAirlines isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedAirlines) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedAirlines addObject:[Airlines modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedAirlines isKindOfClass:[NSDictionary class]]) {
       [parsedAirlines addObject:[Airlines modelObjectWithDictionary:(NSDictionary *)receivedAirlines]];
    }

    self.airlines = [NSArray arrayWithArray:parsedAirlines];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForAirlines = [NSMutableArray array];
    for (NSObject *subArrayObject in self.airlines) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForAirlines addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForAirlines addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForAirlines] forKey:kAirlineAirlines];

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

    self.airlines = [aDecoder decodeObjectForKey:kAirlineAirlines];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_airlines forKey:kAirlineAirlines];
}

- (id)copyWithZone:(NSZone *)zone
{
    Airline *copy = [[Airline alloc] init];
    
    if (copy) {

        copy.airlines = [self.airlines copyWithZone:zone];
    }
    
    return copy;
}


@end
