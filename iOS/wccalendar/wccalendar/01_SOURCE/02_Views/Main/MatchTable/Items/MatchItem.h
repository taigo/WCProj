//
//  MatchItem.h
//  wccalendar
//
//  Created by Tai Truong on 5/10/14.
//  Copyright (c) 2014 Tai Truong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MatchItem : NSObject
@property (strong, nonatomic) NSString *team1_Name;
@property (strong, nonatomic) NSString *team2_Name;
@property (strong, nonatomic) NSString *team1_Img;
@property (strong, nonatomic) NSString *team2_Img;
@property (strong, nonatomic) NSString *score;
@property (strong, nonatomic) NSDate *time;
@end
