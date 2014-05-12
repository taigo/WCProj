//
//  TeamFilterViewController.h
//  wccalendar
//
//  Created by Tai Truong on 5/12/14.
//  Copyright (c) 2014 Tai Truong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TeamFilterViewController, TeamModel;
@protocol TeamFilterDelegate <NSObject>
-(void)teamFilter:(TeamFilterViewController*)controller didSelect:(TeamModel*)item;
@end

@interface TeamFilterViewController : UIViewController
@property (weak, nonatomic) id<TeamFilterDelegate> delegate;
@end
