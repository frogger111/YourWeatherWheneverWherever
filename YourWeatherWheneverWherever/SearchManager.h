//
//  SearchManager.h
//  YourWeatherWheneverWherever
//
//  Created by Tobiasz Parys on 07/03/14.
//  Copyright (c) 2014 Tobiasz parys. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SearchDelegate;

@interface SearchManager : NSObject

@property (nonatomic, weak) id<SearchDelegate> delegate;

-(void)fetchCitiesWithString:(NSString *)string;

-(void)saveCity:(NSString *)city success:(void (^)(NSString *response))success
        failure:(void (^)(NSString *response, NSError *error))failure;

@end

@protocol SearchDelegate <NSObject>

@optional
-(void)searchManager:(SearchManager *)searchManager didFinishFetchingCities:(NSArray *)cities error:(NSError *)error;

@end
