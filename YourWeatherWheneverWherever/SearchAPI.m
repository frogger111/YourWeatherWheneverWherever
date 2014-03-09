//
//  SearchAPI.m
//  YourWeatherWheneverWherever
//
//  Created by Tobiasz Parys on 07/03/14.
//  Copyright (c) 2014 Tobiasz parys. All rights reserved.
//

#import "SearchAPI.h"
#import "SearchManager.h"

@interface SearchAPI() <SearchDelegate>

@end

@implementation SearchAPI{

    SearchManager *_searchManager;
    
}

+(SearchAPI *)API {

    static SearchAPI *_instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

-(id)init{

    if(self = [super init]){
    
        _searchManager = [[SearchManager alloc] init];
        _searchManager.delegate = self;
    }
    
    return self;
}

-(void)fetchCitiesWithString:(NSString *)string{

    [_searchManager fetchCitiesWithString:string];
    
}

-(void)searchManager:(SearchManager *)searchManager didFinishFetchingCities:(NSArray *)cities error:(NSError *)error{

    if(!error){
    
        [[NSNotificationCenter defaultCenter] postNotificationName:fetchCitiesNotification object:self userInfo:@{@"cities":cities}];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:fetchCitiesNotification object:self userInfo:@{@"error":error}];
    }
}

-(void)saveCity:(NSString *)city success:(void (^)(NSString *response))success
        failure:(void (^)(NSString *response, NSError *error))failure{

    [_searchManager saveCity:city success:success failure:failure];
}

@end
