//
//  MatchItem.h
//  wccalendar
//
//  Created by Tai Truong on 5/17/14.
//  Copyright (c) 2014 Tai Truong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Group, TeamModel;

@interface MatchItem : NSManagedObject

@property (nonatomic, retain) NSNumber * alertTime;
@property (nonatomic, retain) NSDate * day;
@property (nonatomic, retain) NSString * matchID;
@property (nonatomic, retain) NSString * score;
@property (nonatomic, retain) NSDate * datetime;
@property (nonatomic, retain) NSString * stage;
@property (nonatomic, retain) NSString * matchNum;
@property (nonatomic, retain) NSString * stadium;
@property (nonatomic, retain) NSString * venue;
@property (nonatomic, retain) TeamModel *teamHome;
@property (nonatomic, retain) TeamModel *teamAway;
@property (nonatomic, retain) Group *group;

@end
