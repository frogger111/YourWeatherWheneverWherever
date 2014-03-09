//
//  SearchManager.m
//  YourWeatherWheneverWherever
//
//  Created by Tobiasz Parys on 07/03/14.
//  Copyright (c) 2014 Tobiasz parys. All rights reserved.
//

#import "SearchManager.h"
#import <AFNetworking/AFNetworking.h>

@implementation SearchManager{

    AFHTTPRequestOperationManager *_afHttpRequestOperationManager;
}


-(id)init{

    if(self = [super init]){
    
        _afHttpRequestOperationManager = [AFHTTPRequestOperationManager manager];
        _afHttpRequestOperationManager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
    return self;
}

-(void)fetchCitiesWithString:(NSString *)string{

    NSString *configPath = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
    NSDictionary *config = [NSDictionary dictionaryWithContentsOfFile:configPath];
    
    
    // new request has come, so I have to cancel all previews operations
    [_afHttpRequestOperationManager.operationQueue cancelAllOperations];
    
    NSDictionary *params = @{@"input":string,
                             @"types":@"geocode",
                             @"language":[[NSLocale preferredLanguages] objectAtIndex:0],
                             @"sensor":@"true",
                             @"key":[config objectForKey:@"googlePlacesKey"]};
    
    [_afHttpRequestOperationManager GET:[config objectForKey:@"googlePlacesURL"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *response = responseObject[@"predictions"];
        if(response.count > 0){
        
            [self.delegate searchManager:self didFinishFetchingCities:response error:nil];
        }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error %@", error);
        [self.delegate searchManager:self didFinishFetchingCities:nil error:error];
    }];
}

-(void)saveCity:(NSString *)city success:(void (^)(NSString *))success failure:(void (^)(NSString *, NSError *))failure{

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        if([[userDefaults objectForKey:@"citiesDict"] objectForKey:city]){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(failure){
                    
                       failure(city, [NSError errorWithDomain:@"Error. city exist" code:-1 userInfo:nil]);
                }
            });
        } else {
            
            NSMutableDictionary *citiesArray = [[userDefaults objectForKey:@"citiesDict"] mutableCopy];
            
            if(!citiesArray){
            
                citiesArray = [[NSMutableDictionary alloc] init];
            
            }
            
            [citiesArray setObject:city forKey:city];
            [userDefaults setObject:citiesArray forKey:@"citiesDict"];
            
            
            if([userDefaults synchronize]){
            
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(success){
                    
                        success(city);
                    }
                });
            } else {
            
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if(failure){
                    
                        failure(city, [NSError errorWithDomain:@"Error with sync" code:-2 userInfo:nil]);
                    }
                });
            }
        }
    });
}

@end
