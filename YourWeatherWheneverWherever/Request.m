//
//  Request.m
//  YourWeatherWheneverWherever
//
//  Created by Tobiasz Parys on 08/03/14.
//  Copyright (c) 2014 Tobiasz parys. All rights reserved.
//

#import "Request.h"

@implementation Request

+(NSDictionary *)JSONKeyPathsByPropertyKey{
    
    return @{@"query":@"query",
             @"type":@"type"
             };
}

+ (NSValueTransformer *)winddir16PointJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSArray *values) {
        return [values firstObject];
    } reverseBlock:^(NSString *string) {
        return @[string];
    }];
}

@end
