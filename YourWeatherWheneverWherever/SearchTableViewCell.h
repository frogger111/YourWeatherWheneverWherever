//
//  SearchTableViewCell.h
//  YourWeatherWheneverWherever
//
//  Created by Tobiasz Parys on 07/03/14.
//  Copyright (c) 2014 Tobiasz parys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *citiName;

-(void) setCityName:(NSString *)cityName;

@end
