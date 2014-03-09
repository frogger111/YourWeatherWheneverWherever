//
//  WeatherTableViewController.h
//  YourWeatherWheneverWherever
//
//  Created by Tobiasz Parys on 07/03/14.
//  Copyright (c) 2014 Tobiasz parys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherTableViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIImageView *blureImageView;
@property (nonatomic, weak) IBOutlet UITableView *citiesTableView;


-(IBAction)searchCitySelector:(id)sender;

-(IBAction)editSelector:(id)sender;

@end
