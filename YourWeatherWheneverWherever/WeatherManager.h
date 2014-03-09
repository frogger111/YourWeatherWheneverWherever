//
//  WeatherManager.h
//  YourWeatherWheneverWherever
//
//  Created by Tobiasz Parys on 08/03/14.
//  Copyright (c) 2014 Tobiasz parys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherCondition.h"

@protocol WeatherProtocol;

@interface WeatherManager : NSObject

@property (nonatomic, weak) id<WeatherProtocol> delegate;

-(id)init;

-(void)fetchWeatherForCityName:(NSString *)cityName;

-(void)cancelFetchingCity;

-(void)fetchSavedCities:(void (^)(NSDictionary *citiesDict))block;

-(void)deleteCity:(NSString *)cityName success:(void (^)(NSString *city))success failure:(void (^)(NSString *city, NSError *error))failure;

@end

@protocol WeatherProtocol <NSObject>

@optional
-(void)weatherManager:(WeatherManager *)weatherMangaer didFinishFetchingWith:(WeatherCondition *)weatherCondition error:(NSError *)error;

@end
