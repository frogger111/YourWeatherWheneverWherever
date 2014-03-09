//
//  DailyWeatherTableViewCell.m
//  YourWeatherWheneverWherever
//
//  Created by Tobiasz Parys on 09/03/14.
//  Copyright (c) 2014 Tobiasz parys. All rights reserved.
//

#import "DailyWeatherTableViewCell.h"
#import <UIImageView+AFNetworking.h>
@interface DailyWeatherTableViewCell()

@property (nonatomic, strong) NSDateFormatter *df;

@end

@implementation DailyWeatherTableViewCell{

    UILabel *_dateLabel;
    UIImageView *_iconView;
    UILabel *_temperatureLabel;
    
    
}

@synthesize df = _df;

#pragma -mark Getters

-(NSDateFormatter *)df{

    // NSDateFormatter object is heave to initialize, so i use lazzy loading
    if(!_df) _df = [[NSDateFormatter alloc] init]; return _df;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGFloat inset = 20;
        CGFloat temperatureHeight = 110;
        CGFloat hiloHeight = 40;
        CGFloat iconHeight = 30;
        
        CGRect iconFrame = CGRectMake(self.frame.size.width - iconHeight - inset,
                                      (self.frame.size.height - iconHeight / 2) / 2,
                                      iconHeight,
                                      iconHeight);
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(inset, 5, 100, 20)];
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.textColor = [UIColor whiteColor];
        _dateLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
        [self addSubview:_dateLabel];
        
        _temperatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(inset, 30, 150, 20)];
        _temperatureLabel.backgroundColor = [UIColor clearColor];
        _temperatureLabel.textColor = [UIColor whiteColor];
        _temperatureLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
        [self addSubview:_temperatureLabel];
        
        _iconView = [[UIImageView alloc] initWithFrame:iconFrame];
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
        _iconView.backgroundColor = [UIColor clearColor];
        [self addSubview:_iconView];
        
    }
    return self;
}

-(void)setDailyWeather:(Weather *)dailyWeather{

    _dateLabel.text = [self convertDateToDayName:dailyWeather.date];
    _temperatureLabel.text = [NSString stringWithFormat:@"Max temp %d°C/%d°F", dailyWeather.tempMaxC, dailyWeather.tempMaxF];
    [_iconView setImageWithURL:[NSURL URLWithString:dailyWeather.weatherIconUrl]];
    
}

-(NSString *)convertDateToDayName:(NSString *)date{
    
    [self.df setDateFormat:@"yyyy-MM-dd"];
    NSDate *date1 = [self.df dateFromString:date];
    
    NSCalendar* calender = [NSCalendar currentCalendar];
    NSDateComponents* component = [calender components:NSWeekdayCalendarUnit fromDate:date1];
    
    switch ([component weekday]) {
        case 1:
            return L(@"Monday");
            break;
        case 2:
            return L(@"Tuesday");
            break;
        case 3:
            return L(@"Wednesday");
            break;
        case 4:
            return L(@"Thursday");
            break;
        case 5:
            return L(@"Friday");
            break;
        case 6:
            return L(@"Saturday");
            break;
        case 7:
            return L(@"Sunday");
            break;
        default:
            break;
    }
    
    return @"";
    
}
@end
