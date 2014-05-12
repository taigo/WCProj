//
//  TeamModel.h
//  wccalendar
//
//  Created by Tai Truong on 5/12/14.
//  Copyright (c) 2014 Tai Truong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MatchItem;

@interface TeamModel : NSManagedObject

@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * teamID;
@property (nonatomic, retain) NSString * initialTitle;
@property (nonatomic, retain) NSSet *matchs;
@end

@interface TeamModel (CoreDataGeneratedAccessors)

- (void)addMatchsObject:(MatchItem *)value;
- (void)removeMatchsObject:(MatchItem *)value;
- (void)addMatchs:(NSSet *)values;
- (void)removeMatchs:(NSSet *)values;

@end
