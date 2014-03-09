//
//  WeatherTableView.m
//  YourWeatherWheneverWherever
//
//  Created by Tobiasz Parys on 08/03/14.
//  Copyright (c) 2014 Tobiasz parys. All rights reserved.
//

#import "WeatherTableView.h"
#import <UIImageView+AFNetworking.h>

@implementation WeatherTableView{

    UILabel *_temperatureLabel;
    UILabel *_hiloLabel;
    UILabel *_cityLabel;
    UILabel *_conditionsLabel;
    UIImageView *_iconView;

}

-(id)initWithFrame:(CGRect)frame {

    if (self= [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.separatorColor = [UIColor colorWithWhite:1 alpha:0.2];
        self.pagingEnabled = YES;
        
        // header frame
        CGRect headerFrame = [UIScreen mainScreen].bounds;
        

        CGFloat inset = 20;

        CGFloat temperatureHeight = 110;
        CGFloat hiloHeight = 40;
        CGFloat iconHeight = 30;

        CGRect hiloFrame = CGRectMake(inset,
                                      headerFrame.size.height - hiloHeight,
                                      headerFrame.size.width - (2 * inset),
                                      hiloHeight);
        
        CGRect temperatureFrame = CGRectMake(inset,
                                             headerFrame.size.height - (temperatureHeight + hiloHeight),
                                             headerFrame.size.width - (2 * inset),
                                             temperatureHeight);
        
        CGRect iconFrame = CGRectMake(inset,
                                      temperatureFrame.origin.y - iconHeight,
                                      iconHeight,
                                      iconHeight);
        // 5
        CGRect conditionsFrame = iconFrame;
        conditionsFrame.size.width = self.bounds.size.width - (((2 * inset) + iconHeight) + 10);
        conditionsFrame.origin.x = iconFrame.origin.x + (iconHeight + 10);
        
        // 1
        UIView *header = [[UIView alloc] initWithFrame:headerFrame];
        header.backgroundColor = [UIColor clearColor];
        self.tableHeaderView = header;
        
        // 2
        // bottom left
        _temperatureLabel = [[UILabel alloc] initWithFrame:temperatureFrame];
        _temperatureLabel.backgroundColor = [UIColor clearColor];
        _temperatureLabel.textColor = [UIColor whiteColor];
        _temperatureLabel.text = @"0°";
        _temperatureLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:120];
        _temperatureLabel.alpha = 0;
        [header addSubview:_temperatureLabel];
        
        // bottom left
        _hiloLabel = [[UILabel alloc] initWithFrame:hiloFrame];
        _hiloLabel.backgroundColor = [UIColor clearColor];
        _hiloLabel.textColor = [UIColor whiteColor];
        _hiloLabel.text = @"0° / 0°";
        _hiloLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:28];
        _hiloLabel.alpha = 0;
        [header addSubview:_hiloLabel];
        
        // top
        _cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 26, self.bounds.size.width, 30)];
        _cityLabel.backgroundColor = [UIColor clearColor];
        _cityLabel.textColor = [UIColor whiteColor];
        _cityLabel.text = L(@"LOADING");
        _cityLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        _cityLabel.textAlignment = NSTextAlignmentCenter;
        [header addSubview:_cityLabel];
        
        _conditionsLabel = [[UILabel alloc] initWithFrame:conditionsFrame];
        _conditionsLabel.backgroundColor = [UIColor clearColor];
        _conditionsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        _conditionsLabel.textColor = [UIColor whiteColor];
        _conditionsLabel.alpha = 0;
        [header addSubview:_conditionsLabel];
        


        _iconView = [[UIImageView alloc] initWithFrame:iconFrame];
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
        _iconView.backgroundColor = [UIColor clearColor];
        _iconView.alpha = 0;
        [header addSubview:_iconView];
        
        
        
    }
    return self;
}

-(void)setWeatherCondition:(WeatherCondition *)weatherCondition{

    
    
    
    [_iconView setImageWithURL:[NSURL URLWithString:weatherCondition.weatherIconUrl]];
    _conditionsLabel.text = weatherCondition.weatherDesc;
    _cityLabel.text = ((Request *)[weatherCondition.request objectAtIndex:0]).query;
    _temperatureLabel.text = [NSString stringWithFormat:@"%d°", weatherCondition.tempC];
    _hiloLabel.text = [NSString stringWithFormat:@"%d°C/%dF°",weatherCondition.tempC, weatherCondition.tempF];
    
    [UIView animateWithDuration:0.3f animations:^{
        _iconView.alpha = 1;
        _conditionsLabel.alpha = 1;
        _temperatureLabel.alpha = 1;
        _hiloLabel.alpha = 1;
    }];
    
}
@end
