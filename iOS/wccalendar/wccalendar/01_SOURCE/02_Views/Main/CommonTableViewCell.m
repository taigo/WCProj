//
//  CommonTableViewCell.m
//  YardClub
//
//  Created by Tai Truong on 4/9/14.
//  Copyright (c) 2014 siliconprime. All rights reserved.
//

#import "CommonTableViewCell.h"

@implementation CommonTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setObject:(id)object
{
    _object = object;
}

+(CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object
{
    return 25.0f;
}

@end
