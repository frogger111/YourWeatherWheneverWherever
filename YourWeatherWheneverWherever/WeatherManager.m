//
//  WeatherManager.m
//  YourWeatherWheneverWherever
//
//  Created by Tobiasz Parys on 08/03/14.
//  Copyright (c) 2014 Tobiasz parys. All rights reserved.
//

#import "WeatherManager.h"
#import <AFNetworking/AFNetworking.h>
#import "WeatherCondition.h"
#import <ReactiveCocoa/ReactiveCocoa/ReactiveCocoa.h>

@implementation WeatherManager{

    AFHTTPRequestOperationManager *_afHttpRequestOperationManager;
}

-(id)init{
    
    if(self = [super init]){
        
        _afHttpRequestOperationManager = [AFHTTPRequestOperationManager manager];
        _afHttpRequestOperationManager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
    return self;
}


-(void)fetchWeatherForCityName:(NSString *)cityName{
    
    NSString *configPath = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
    NSDictionary *config = [NSDictionary dictionaryWithContentsOfFile:configPath];
    
    // new request has come, so I have to cancel all previews operations
    [_afHttpRequestOperationManager.operationQueue cancelAllOperations];
    
    NSDictionary *params = @{@"q":cityName,
                             @"format":@"json",
                             @"num_of_days":@"5",
                             @"key":[config objectForKey:@"worldWeatherKey"]};
    
    [_afHttpRequestOperationManager GET:[config objectForKey:@"worldWeatherURL"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error;
        
        // I know that I'm parsing JSON in main thread. but the response is short, so I decided to parse it here. If response would be heavy, I would pass response to another thread and parse it there.
        WeatherCondition *weatherCondition = [MTLJSONAdapter modelOfClass:[WeatherCondition class] fromJSONDictionary:(NSDictionary *)responseObject error:&error];
        
        [self.delegate weatherManager:self didFinishFetchingWith:weatherCondition error:error];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.delegate weatherManager:self didFinishFetchingWith:nil error:error];
    }];
}

-(void)cancelFetchingCity{

    [_afHttpRequestOperationManager.operationQueue cancelAllOperations];
}

-(void)deleteCity:(NSString *)cityName success:(void (^)(NSString *city))success failure:(void (^)(NSString *city, NSError *error))failure{

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            
            if(![userDefaults objectForKey:@"citiesDict"]){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(failure){
                        
                        failure(cityName, [NSError errorWithDomain:@"Error. city exist" code:-1 userInfo:nil]);
                    }
                });
            } else {
                
                NSMutableDictionary *citiesArray = [[userDefaults objectForKey:@"citiesDict"] mutableCopy];
                
                [citiesArray removeObjectForKey:cityName];
                [userDefaults setObject:citiesArray forKey:@"citiesDict"];
                
                
                if([userDefaults synchronize]){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(success){
                            
                            success(cityName);
                        }
                    });
                } else {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if(failure){
                            
                            failure(cityName, [NSError errorWithDomain:@"Error with sync" code:-2 userInfo:nil]);
                        }
                    });
                }
            }
        });
        
    });
}

-(void)fetchSavedCities:(void (^)(NSDictionary *citiesDict))block{

    if(block)        
        block([[NSUserDefaults standardUserDefaults] objectForKey:@"citiesDict"]);
    
}

@end
