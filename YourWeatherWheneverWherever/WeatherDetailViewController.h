//
//  WeatherDetailViewController.h
//  YourWeatherWheneverWherever
//
//  Created by Tobiasz Parys on 09/03/14.
//  Copyright (c) 2014 Tobiasz parys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherTableView.h"


@interface WeatherDetailViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIImageView *blureImageView;

@property (nonatomic, strong) NSString *cityRequest;

@end
