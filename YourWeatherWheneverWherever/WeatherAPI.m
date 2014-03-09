//
//  WeatherAPI.m
//  YourWeatherWheneverWherever
//
//  Created by Tobiasz Parys on 08/03/14.
//  Copyright (c) 2014 Tobiasz parys. All rights reserved.
//

#import "WeatherAPI.h"
#import "WeatherManager.h"

@interface WeatherAPI() <WeatherProtocol>

@end

@implementation WeatherAPI{

    WeatherManager *_weatherManager;
}

+(WeatherAPI *)API{

    static WeatherAPI *_instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

-(id)init{

    if(self = [super init]){
    
        _weatherManager = [[WeatherManager alloc] init];
        _weatherManager.delegate = self;
    }
    
    return self;
    
}

-(void)fetchWeatherForCityName:(NSString *)cityName{

    [_weatherManager fetchWeatherForCityName:cityName]; 
}

-(void)cancelFetchingCity{

    [_weatherManager cancelFetchingCity];
}

-(void)weatherManager:(WeatherManager *)weatherMangaer didFinishFetchingWith:(WeatherCondition *)weatherCondition error:(NSError *)error{

    if(!error){
    
        [[NSNotificationCenter defaultCenter] postNotificationName:fetchCityNotification object:nil userInfo:@{@"weatherCondition":weatherCondition}];
    } else {
    
        [[NSNotificationCenter defaultCenter] postNotificationName:fetchCityNotification object:nil userInfo:@{@"error":error}];
    }
}

-(void)fetchSavedCities:(void (^)(NSDictionary *))block{

    [_weatherManager fetchSavedCities:block];
}

-(void)deleteCity:(NSString *)cityName success:(void (^)(NSString *city))success failure:(void (^)(NSString *city, NSError *error))failure{

    [_weatherManager deleteCity:cityName success:success failure:failure];
}

@end
