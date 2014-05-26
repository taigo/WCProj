//
//  MatchTableCell.h
//  wccalendar
//
//  Created by Tai Truong on 5/10/14.
//  Copyright (c) 2014 Tai Truong. All rights reserved.
//

#import "CommonTableViewCell.h"
#import "MatchItem.h"
#import "TeamModel.h"

@class MatchTableCell;
@protocol MatchTableCellDelegate <NSObject>

-(void)matchCellDidSelectSetAlarm:(MatchTableCell*)cell;

@end

@interface MatchTableCell : CommonTableViewCell
@property (strong, nonatomic) UILabel *dateLbl;
@property (strong, nonatomic) UILabel *groupLbl;
@property (strong, nonatomic) UILabel *timeLbl;
@property (strong, nonatomic) UILabel *team1_NameLbl;
@property (strong, nonatomic) UILabel *team2_NameLbl;
@property (strong, nonatomic) UIImageView *team1_ImgView;
@property (strong, nonatomic) UIImageView *team2_ImgView;
@property (strong, nonatomic) UIButton *alarmBtn;

@property (weak, nonatomic) id<MatchTableCellDelegate> delegate;
@end
