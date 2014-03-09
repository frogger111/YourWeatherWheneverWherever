//
//  WeatherTableView.h
//  YourWeatherWheneverWherever
//
//  Created by Tobiasz Parys on 08/03/14.
//  Copyright (c) 2014 Tobiasz parys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherCondition.h"

@interface WeatherTableView : UITableView

-(void)setWeatherCondition:(WeatherCondition *)weatherCondition;

-(id)initWithFrame:(CGRect)frame;

@end
