//
//  TeamModel.m
//  wccalendar
//
//  Created by Tai Truong on 5/17/14.
//  Copyright (c) 2014 Tai Truong. All rights reserved.
//

#import "TeamModel.h"
#import "Group.h"
#import "MatchItem.h"
#import "AppViewController.h"

@implementation TeamModel

@dynamic imageUrl;
@dynamic initialTitle;
@dynamic name;
@dynamic teamID;
@dynamic shortName;
@dynamic matchs;
@dynamic group;


-(NSString *)initialTitle
{
    if(!self.name || self.name.length == 0)
        return @"#";
    
    [self willAccessValueForKey:@"initialTitle"];
    NSString *stringToReturn = [[self.name uppercaseString] substringToIndex:1];
    [self didAccessValueForKey:@"initialTitle"];
    return stringToReturn;
}

+(TeamModel *)teamWithID:(NSString *)teamID
{
    NSManagedObjectContext *managedObjectContext = [AppViewController Shared].managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:WC_TEAM_MODEL];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"teamID" ascending:YES selector:@selector(compare:)];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"teamID = %@", teamID];
    [fetchRequest setPredicate:predicate];
    //    fetchRequest.predicate = predicate;
    NSArray *results = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    return [results count] > 0 ? results[0] : nil;
}
@end
