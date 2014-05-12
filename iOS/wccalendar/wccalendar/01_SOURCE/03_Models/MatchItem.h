//
//  MatchItem.h
//  wccalendar
//
//  Created by Tai Truong on 5/12/14.
//  Copyright (c) 2014 Tai Truong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define WC_MATCH_MODEL @"MatchItem"

@class TeamModel;

@interface MatchItem : NSManagedObject

@property (nonatomic, retain) NSString * score;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSDate * day;
@property (nonatomic, retain) NSString * matchID;
@property (nonatomic, retain) NSSet *teams;
@end

@interface MatchItem (CoreDataGeneratedAccessors)

- (void)addTeamsObject:(TeamModel *)value;
- (void)removeTeamsObject:(TeamModel *)value;
- (void)addTeams:(NSSet *)values;
- (void)removeTeams:(NSSet *)values;

@end
