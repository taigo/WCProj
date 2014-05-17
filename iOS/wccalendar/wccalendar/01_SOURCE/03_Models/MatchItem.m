//
//  MatchItem.m
//  wccalendar
//
//  Created by Tai Truong on 5/17/14.
//  Copyright (c) 2014 Tai Truong. All rights reserved.
//

#import "MatchItem.h"
#import "Group.h"
#import "TeamModel.h"
#import "AppViewController.h"

@implementation MatchItem

@dynamic alertTime;
@dynamic day;
@dynamic matchID;
@dynamic score;
@dynamic datetime;
@dynamic stage;
@dynamic matchNum;
@dynamic stadium;
@dynamic venue;
@dynamic teamHome;
@dynamic teamAway;
@dynamic group;


+(void)updateMatch:(NSDictionary *)data
{
    NSManagedObjectContext *managedObjectContext = [AppViewController Shared].managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:WC_MATCH_MODEL];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"matchID" ascending:YES selector:@selector(compare:)];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    
    NSInteger matchID = [[data objectForKey:@"matchid"] integerValue];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"matchID.intValue = %d", matchID];
    [fetchRequest setPredicate:predicate];
    //    fetchRequest.predicate = predicate;
    NSArray *results = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    //    VKLog(@"fetchedResultsControllerSearch %@", results);
    if (results.count > 0) {
        MatchItem *item = results[0];
        // update score
        NSArray *scores = [data objectForKey:@"score"];
        if (scores.count > 0) {
            item.score = [scores componentsJoinedByString:@" - "];
        }
        else {
            item.score = nil;
        }
        
        // update team
        NSString *homeID = [data objectForKey:@"team_home"];
        NSString *awayID = [data objectForKey:@"team_away"];
        if (![homeID isEqualToString:item.teamHome.teamID] && ![awayID isEqualToString:item.teamAway.teamID]) {
            item.teamHome = [TeamModel teamWithID:homeID];
            item.teamAway = [TeamModel teamWithID:awayID];
        }
        
    }
}
@end
