//
//  Group.m
//  wccalendar
//
//  Created by Tai Truong on 5/27/14.
//  Copyright (c) 2014 Tai Truong. All rights reserved.
//

#import "Group.h"
#import "MatchItem.h"
#import "TeamModel.h"
#import "AppViewController.h"

@implementation Group

@dynamic groupID;
@dynamic name;
@dynamic matchs;
@dynamic teams;

+(NSArray *)getListGroup
{
    NSManagedObjectContext *managedObjectContext = [AppViewController Shared].managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:WC_GROUP_MODEL];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"groupID" ascending:YES];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"groupID.intValue < 8"]; // only get groups in group stage
    [fetchRequest setPredicate:predicate];
    
    NSArray *results = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    return results;
}
@end
