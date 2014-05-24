//
//  MatchDetailViewController.h
//  wccalendar
//
//  Created by Tai Truong on 5/22/14.
//  Copyright (c) 2014 Tai Truong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MatchItem, MatchDetailViewController;

@protocol MatchDetailViewDelegate <NSObject>

-(void)matchDetailDidSetAlarm:(MatchDetailViewController*)controller;

@end

@interface MatchDetailViewController : UIViewController
@property (weak, nonatomic) MatchItem *object;
@property (weak, nonatomic) id<MatchDetailViewDelegate> delegate;
@property (assign, nonatomic) BOOL shouldShowAlarmSelector;
@end
