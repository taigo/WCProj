//
//  MatchItem.h
//  wccalendar
//
//  Created by Tai Truong on 5/12/14.
//  Copyright (c) 2014 Tai Truong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TeamModel;

@interface MatchItem : NSManagedObject

@property (nonatomic, retain) NSString * score;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSDate * day;
@property (nonatomic, retain) NSString * matchID;
@property (nonatomic, retain) TeamModel *team1;
@property (nonatomic, retain) TeamModel *team2;

@end
