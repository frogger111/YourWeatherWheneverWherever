//
//  DailyWeatherTableViewCell.h
//  YourWeatherWheneverWherever
//
//  Created by Tobiasz Parys on 09/03/14.
//  Copyright (c) 2014 Tobiasz parys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Weather.h"

@interface DailyWeatherTableViewCell : UITableViewCell

-(void) setDailyWeather:(Weather *)dailyWeather;

@end
