//
//  MatchTableCell.m
//  wccalendar
//
//  Created by Tai Truong on 5/10/14.
//  Copyright (c) 2014 Tai Truong. All rights reserved.
//

#import "MatchTableCell.h"

#define MATCH_TABLE_CELL_HEIGHT 25.0f

@implementation MatchTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

+(CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object
{
    return MATCH_TABLE_CELL_HEIGHT;
}

-(void)setObject:(id)object
{
    [super setObject:object];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

@end
