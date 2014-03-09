//
//  NoAnimatingSearchBar.m
//  YourWeatherWheneverWherever
//
//  Created by Tobiasz Parys on 07/03/14.
//  Copyright (c) 2014 Tobiasz parys. All rights reserved.
//

#import "NoAnimatingSearchBar.h"

@implementation NoAnimatingSearchBar

- (void) _destroyCancelButton {
    NSLog(@"_destroyCancelButton");
}

-(void)_setShowsCancelButton:(BOOL)showsCancelButton {
    NSLog(@"_setShowsCancelButton:(BOOL)showsCancelButton");
}


@end
