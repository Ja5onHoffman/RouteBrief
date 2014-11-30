//
//  AirlineDataObject.h
//  RouteBrief
//
//  Created by Jason Hoffman on 11/29/14.
//  Copyright (c) 2014 No5age. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AirlineDataObject : NSObject

- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

@property (nonatomic, strong) NSString *airlineID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *alias;
@property (nonatomic, strong) NSString *icaoCode;
@property (nonatomic, strong) NSString *callSign;
@property (nonatomic, strong) NSString *country;

@end
