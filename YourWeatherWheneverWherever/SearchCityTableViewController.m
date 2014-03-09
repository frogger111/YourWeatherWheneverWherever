//
//  SearchCityTableViewController.m
//  YourWeatherWheneverWherever
//
//  Created by Tobiasz Parys on 07/03/14.
//  Copyright (c) 2014 Tobiasz parys. All rights reserved.
//

#import "SearchCityTableViewController.h"
#import "SearchAPI.h"
#import "SearchTableViewCell.h"

@interface SearchCityTableViewController ()

@end

@implementation SearchCityTableViewController{

    NSArray *_cities;
    NSError *_error;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // after this the cancel button in search bar will be enable
    for (UIView *firstView in self.searchDisplayController.searchBar.subviews) {
        for(UIView* view in firstView.subviews) {
            if([view isKindOfClass:[UIButton class]]) {
                UIButton* button = (UIButton*) view;
                [button setEnabled:YES];
            }
        }
        
    }
    
    // tableview will be in rght place, under status bar.
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.tableView.contentOffset = CGPointMake(0, -20);
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchCities:) name:fetchCitiesNotification object:nil];
}


-(void)viewDidDisappear:(BOOL)animated{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:fetchCitiesNotification object:nil];
    
    [super viewDidDisappear:animated];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)asearchBar{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // fetch cities
    [[SearchAPI API] fetchCitiesWithString:searchString];
    
    return YES;
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    // cancel button, will be always showed
    self.searchBar.showsCancelButton = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Fetch Cities

-(void)fetchCities:(NSNotification *)aNotification{

    _cities = [[aNotification userInfo] objectForKey:@"cities"];
    _error = [[aNotification userInfo] objectForKey:@"error"];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_cities && !_error){
    
        return [_cities count];
    } else if (!_cities && _error){
    
        return 1;
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"SearchTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView){
        
        if(_cities && !_error){
        cell.textLabel.text = [((NSDictionary *)[_cities objectAtIndex:indexPath.row]) objectForKey:@"description"];
        } else {
            cell.textLabel.text = L(@"FETCHING_ERROR");
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    [[SearchAPI API] saveCity:cell.textLabel.text success:^(NSString *response) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } failure:^(NSString *response, NSError *error) {
        
        UIAlertView *alert;
        
        if(error.code == -1){
        
            alert = [[UIAlertView alloc] initWithTitle:L(@"ERROR") message:L(@"CITY_EXIST") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            
            
        } else {
            alert = [[UIAlertView alloc] initWithTitle:L(@"ERROR") message:L(@"CANNOT_SAVE_LOCALIZATION") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];

        }
        
        if(alert){
            [alert show];
        }
        
    }];
    
}

@end
