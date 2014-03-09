//
//  WeatherAPI.h
//  YourWeatherWheneverWherever
//
//  Created by Tobiasz Parys on 08/03/14.
//  Copyright (c) 2014 Tobiasz parys. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *fetchCityNotification = @"pl.com.treadstone.fetch.city.notifiation";

@interface WeatherAPI : NSObject

+(WeatherAPI *) API;

-(void)fetchWeatherForCityName:(NSString *)cityName;

-(void)fetchSavedCities:(void (^)(NSDictionary *citiesDict))block;

-(void)cancelFetchingCity;

-(void)deleteCity:(NSString *)cityName success:(void (^)(NSString *city))success failure:(void (^)(NSString *city, NSError *error))failure;

@end
