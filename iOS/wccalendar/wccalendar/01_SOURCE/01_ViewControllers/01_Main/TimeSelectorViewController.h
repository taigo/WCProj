//
//  TimeSelectorViewController.h
//  wccalendar
//
//  Created by Tai Truong on 5/13/14.
//  Copyright (c) 2014 Tai Truong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TimeSelectorViewController;
@protocol TimeSelectorDelegate <NSObject>

-(void)timeSelector:(TimeSelectorViewController*)controller didSelect:(enumAlertTime)time;

@end
@interface TimeSelectorViewController : UIViewController
@property (weak, nonatomic) id<TimeSelectorDelegate> delegate;
@property (weak, nonatomic) id object;
@property (assign, nonatomic) enumAlertTime selectedTime;
@end
