//
//  Group.h
//  wccalendar
//
//  Created by Tai Truong on 5/17/14.
//  Copyright (c) 2014 Tai Truong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MatchItem, TeamModel;

@interface Group : NSManagedObject

@property (nonatomic, retain) NSString * groupID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *teams;
@property (nonatomic, retain) NSSet *matchs;
@end

@interface Group (CoreDataGeneratedAccessors)

- (void)addTeamsObject:(TeamModel *)value;
- (void)removeTeamsObject:(TeamModel *)value;
- (void)addTeams:(NSSet *)values;
- (void)removeTeams:(NSSet *)values;

- (void)addMatchsObject:(MatchItem *)value;
- (void)removeMatchsObject:(MatchItem *)value;
- (void)addMatchs:(NSSet *)values;
- (void)removeMatchs:(NSSet *)values;

@end
