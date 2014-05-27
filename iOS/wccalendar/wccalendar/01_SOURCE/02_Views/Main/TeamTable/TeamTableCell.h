//
//  TeamTableCell.h
//  wccalendar
//
//  Created by Tai Truong on 5/12/14.
//  Copyright (c) 2014 Tai Truong. All rights reserved.
//

#import "CommonTableViewCell.h"
#import "TeamModel.h"

#define TEAM_TABLE_CELL_HEIGHT 60.0f

@interface TeamTableCell : CommonTableViewCell
@property (strong, nonatomic) UILabel *nameLbl;
@property (strong, nonatomic) UIImageView *logoImage;
@end
