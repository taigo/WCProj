//
//  TeamModel.m
//  wccalendar
//
//  Created by Tai Truong on 5/12/14.
//  Copyright (c) 2014 Tai Truong. All rights reserved.
//

#import "TeamModel.h"
#import "MatchItem.h"


@implementation TeamModel

@dynamic imageUrl;
@dynamic name;
@dynamic teamID;
@dynamic initialTitle;
@dynamic matchs;

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
