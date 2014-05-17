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
@end
