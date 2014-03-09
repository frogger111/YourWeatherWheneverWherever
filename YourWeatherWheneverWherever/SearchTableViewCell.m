
//
//  SearchTableViewCell.m
//  YourWeatherWheneverWherever
//
//  Created by Tobiasz Parys on 07/03/14.
//  Copyright (c) 2014 Tobiasz parys. All rights reserved.
//

#import "SearchTableViewCell.h"

@implementation SearchTableViewCell

@synthesize citiName;

-(void)setCityName:(NSString *)cityName{

    self.citiName.text = cityName;
}

@end
