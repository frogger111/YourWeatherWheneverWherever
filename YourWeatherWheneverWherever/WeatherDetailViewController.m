//
//  WeatherDetailViewController.m
//  YourWeatherWheneverWherever
//
//  Created by Tobiasz Parys on 09/03/14.
//  Copyright (c) 2014 Tobiasz parys. All rights reserved.
//

#import "WeatherDetailViewController.h"
#import "WeatherAPI.h"
#import "WeatherCondition.h"
#import <TSMessages/TSMessage.h>
#import <LBBlurredImage/UIImageView+LBBlurredImage.h>
#import "Weather.h"
#import "DailyWeatherTableViewCell.h"

@interface WeatherDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) WeatherTableView *weatherTableView;

@end

@implementation WeatherDetailViewController{

    WeatherCondition *_weatherCondition;
    NSError *_error;
}

- (void)viewDidLoad
{
    [super viewDidLoad];


    
    UIImage *background = [UIImage imageNamed:@"bg2"];
    self.blureImageView.alpha = 0.7;
    [self.blureImageView setImageToBlur:background blurRadius:10 completionBlock:nil];
    
    self.weatherTableView = [[WeatherTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.weatherTableView.backgroundColor = [UIColor clearColor];
    self.weatherTableView.delegate = self;
    self.weatherTableView.dataSource = self;
    self.weatherTableView.separatorColor = [UIColor colorWithWhite:1 alpha:0.2];
    self.weatherTableView.pagingEnabled = YES;
    [self.view addSubview:self.weatherTableView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:fetchCityNotification object:nil];
    
    if(self.cityRequest) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [[WeatherAPI API] fetchWeatherForCityName:self.cityRequest];
    } else {
        [TSMessage showNotificationWithTitle:L(@"ERROR")
                                    subtitle:L(@"FETCH_ERROR")
                                        type:TSMessageNotificationTypeError];

    }
}



-(void)viewDidDisappear:(BOOL)animated{

    [[WeatherAPI API] cancelFetchingCity];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:fetchCityNotification object:nil];
}

-(void)refreshData:(NSNotification *)aNotification{

    _weatherCondition = [[aNotification userInfo] objectForKey:@"weatherCondition"];
    _error = [[aNotification userInfo] objectForKey:@"error"];
    
    if(_error){
        [TSMessage showNotificationWithTitle:L(@"ERROR")
                                    subtitle:L(@"FETCH_ERROR")
                                        type:TSMessageNotificationTypeError];
    } else {
    
        [self.weatherTableView setWeatherCondition:(_weatherCondition)];
        [self.weatherTableView reloadData];
    
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_weatherCondition && !_error){
    
        return [_weatherCondition.weather count];
    } else {
    
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    DailyWeatherTableViewCell *cell = (DailyWeatherTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[DailyWeatherTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    Weather *weather = [_weatherCondition.weather objectAtIndex:indexPath.row];
    
    [cell setDailyWeather:weather];
    
    

    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger cellCount = [self tableView:tableView numberOfRowsInSection:indexPath.section];
    
    return [UIScreen mainScreen].bounds.size.height / (CGFloat)cellCount - 50;
}

@end
