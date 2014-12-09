//
//  Airline.h
//
//  Created by Jason Hoffman on 12/4/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Airline : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *airlines;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
