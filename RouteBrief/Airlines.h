//
//  Airlines.h
//
//  Created by Jason Hoffman on 12/4/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Airlines : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *iCAO;
@property (nonatomic, strong) NSString *active;
@property (nonatomic, strong) NSString *airlineID;
@property (nonatomic, strong) NSString *alias;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *callsign;
@property (nonatomic, strong) NSString *iATA;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
