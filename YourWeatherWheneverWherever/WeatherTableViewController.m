//
//  WeatherTableViewController.m
//  YourWeatherWheneverWherever
//
//  Created by Tobiasz Parys on 07/03/14.
//  Copyright (c) 2014 Tobiasz parys. All rights reserved.
//

#import "WeatherTableViewController.h"
#import <LBBlurredImage/UIImageView+LBBlurredImage.h>
#import "SearchCityTableViewController.h"
#import "WeatherDetailViewController.h"
#import "WeatherTableView.h"
#import "WeatherAPI.h"


@interface WeatherTableViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation WeatherTableViewController{

    UIStoryboard *_mainStoryboard;
    NSMutableArray *_cities;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    UIImage *background = [UIImage imageNamed:@"bg1"];
    
    self.blureImageView.alpha = 0.7;
    [self.blureImageView setImageToBlur:background blurRadius:10 completionBlock:nil];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;

    
    self.citiesTableView.backgroundColor = [UIColor clearColor];
    self.citiesTableView.separatorColor = [UIColor colorWithWhite:1 alpha:0.2];
    


}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [[WeatherAPI API] fetchSavedCities:^(NSDictionary *citiesDict) {
        _cities = [[citiesDict allKeys] mutableCopy];
        
        [self.citiesTableView reloadData];
    }];
    
    
}

#pragma -mark IBActions 
-(IBAction)searchCitySelector:(id)sender {
    
    SearchCityTableViewController *sctvc = (SearchCityTableViewController *)[_mainStoryboard instantiateViewControllerWithIdentifier:@"SearchCityTableViewController"];
    
    [self presentViewController:sctvc animated:YES completion:nil];
    
    
}

-(IBAction)editSelector:(id)sender {
    
    WeatherDetailViewController *wdvc = (WeatherDetailViewController *)[_mainStoryboard instantiateViewControllerWithIdentifier:@"WeatherDetailViewController"];
    
    [self.navigationController pushViewController:wdvc animated:YES];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_cities){
        
        return _cities.count;
    } else {
        
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    cell.textLabel.text = [_cities objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    WeatherDetailViewController *wdvc = (WeatherDetailViewController *)[_mainStoryboard instantiateViewControllerWithIdentifier:@"WeatherDetailViewController"];
    
    wdvc.cityRequest = cell.textLabel.text;
    
    [self.navigationController pushViewController:wdvc animated:YES];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath

{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [[WeatherAPI API] deleteCity:[_cities objectAtIndex:indexPath.row] success:^(NSString *city) {
            [_cities removeObjectAtIndex:indexPath.row];
            
            [tableView reloadData];
        } failure:^(NSString *city, NSError *error) {
            
            [TSMessage showNotificationWithTitle:L(@"ERROR")
                                        subtitle:L(@"DETELE_ERROR")
                                            type:TSMessageNotificationTypeError];
        }];
        
        
    }
}

@end
