//
//  GroupTableViewCell.m
//  wccalendar
//
//  Created by Tai Truong on 5/27/14.
//  Copyright (c) 2014 Tai Truong. All rights reserved.
//

#import "GroupTableViewCell.h"
#import "TeamTableCell.h"
#import "Group.h"

@implementation GroupTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        // Initialization code
        // name label
        _nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 18, 255.0f, 23.0f)];
        _nameLbl.font = [UIFont fontWithName:FONT_APP_REGULAR size:17.0f];
        _nameLbl.textColor = [UIColor darkGrayColor];
        [self addSubview:_nameLbl];
        
        // separator
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, TEAM_TABLE_CELL_HEIGHT - 0.5f, WIDTH_IPHONE, 0.5f)];
        [separator setBackgroundColor:[UIColor grayColor]];
        [self addSubview:separator];
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
    return TEAM_TABLE_CELL_HEIGHT;
}

-(void)setObject:(id)object
{
    [super setObject:object];
    
    Group *item = object;
    self.nameLbl.text = item.name;
}

@end
