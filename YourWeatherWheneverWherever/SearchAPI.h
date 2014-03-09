//
//  SearchAPI.h
//  YourWeatherWheneverWherever
//
//  Created by Tobiasz Parys on 07/03/14.
//  Copyright (c) 2014 Tobiasz parys. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *fetchCitiesNotification = @"pl.com.treadstone.fetchingCities.notification";

@interface SearchAPI : NSObject

+(SearchAPI *) API;

-(void)fetchCitiesWithString:(NSString *)string;

-(void)saveCity:(NSString *)city success:(void (^)(NSString *response))success
        failure:(void (^)(NSString *response, NSError *error))failure;

@end
