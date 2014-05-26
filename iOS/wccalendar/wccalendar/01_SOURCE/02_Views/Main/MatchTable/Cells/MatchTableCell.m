//
//  MatchTableCell.m
//  wccalendar
//
//  Created by Tai Truong on 5/10/14.
//  Copyright (c) 2014 Tai Truong. All rights reserved.
//

#import "MatchTableCell.h"
#import "Group.h"

#define MATCH_TABLE_CELL_HEIGHT 60.0f

@implementation MatchTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        // Initialization code
        // day label
        _dateLbl = [[UILabel alloc] initWithFrame:CGRectMake(6, 1, 120.0f, 16.0f)];
        _dateLbl.font = [UIFont fontWithName:FONT_APP_THIN size:12.0f];
        _dateLbl.textColor = [UIColor grayColor];
        _dateLbl.numberOfLines = 0;
        [self addSubview:_dateLbl];
//        _dateLbl.backgroundColor = [UIColor greenColor];
        
        // group label
        _groupLbl = [[UILabel alloc] initWithFrame:CGRectMake(6, 17, 55.0f, 20.0f)];
        _groupLbl.font = [UIFont fontWithName:FONT_APP_THIN size:12.0f];
        _groupLbl.textColor = [UIColor grayColor];
        _groupLbl.numberOfLines = 0;
        [self addSubview:_groupLbl];
//        _groupLbl.backgroundColor = [UIColor redColor];
        
        // team1's image
        _team1_ImgView = [[UIImageView alloc] initWithFrame:CGRectMake(70, 18, 35, 23)];
        _team1_ImgView.layer.shadowColor = [UIColor blackColor].CGColor;
        _team1_ImgView.layer.shadowOffset = CGSizeMake(0.0, 0.3);
        _team1_ImgView.layer.shadowOpacity = 0.7;
        _team1_ImgView.layer.shadowRadius = 0.8;
        _team1_ImgView.clipsToBounds = NO;
        [self addSubview:_team1_ImgView];
        // team1's name label
        _team1_NameLbl = [[UILabel alloc] initWithFrame:CGRectMake(9 + CGRectGetMaxX(_team1_ImgView.frame), 15, 45.0f, 30.0f)];
        _team1_NameLbl.font = [UIFont fontWithName:FONT_APP_REGULAR size:17.0f];
        _team1_NameLbl.textColor = [UIColor blackColor];
        [self addSubview:_team1_NameLbl];
        
        // score/time label
        _timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(160, 15, 50.0f, 30.0f)];
        _timeLbl.font = [UIFont fontWithName:FONT_APP_REGULAR size:17.0f];
        _timeLbl.textColor = [UIColor darkGrayColor];
        _timeLbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_timeLbl];
        
        // team2's name label
        _team2_NameLbl = [[UILabel alloc] initWithFrame:CGRectMake(230, 15, 45.0f, 30.0f)];
        _team2_NameLbl.font = [UIFont fontWithName:FONT_APP_REGULAR size:17.0f];
        _team2_NameLbl.textColor = [UIColor blackColor];
        _timeLbl.textAlignment = NSTextAlignmentRight;
        [self addSubview:_team2_NameLbl];
        // team2's image
        _team2_ImgView = [[UIImageView alloc] initWithFrame:CGRectMake(274, 18, 35, 23)];
        _team2_ImgView.layer.shadowColor = [UIColor blackColor].CGColor;
        _team2_ImgView.layer.shadowOffset = CGSizeMake(0.0, 0.3);
        _team2_ImgView.layer.shadowOpacity = 0.7;
        _team2_ImgView.layer.shadowRadius = 0.8;
        _team2_ImgView.clipsToBounds = NO;
        [self addSubview:_team2_ImgView];
        
        // alarm button
        _alarmBtn = [[UIButton alloc] initWithFrame:CGRectMake(163, 2, 50, 35)];
        _alarmBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        [self addSubview:_alarmBtn];
        [_alarmBtn addTarget:self action:@selector(alarmBtnTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        
        // separator
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, MATCH_TABLE_CELL_HEIGHT - 0.5f, WIDTH_IPHONE, 0.5f)];
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

-(void)alarmBtnTouchUpInside
{
    [self.delegate matchCellDidSelectSetAlarm:self];
}

+(CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object
{
    return MATCH_TABLE_CELL_HEIGHT;
}

-(void)setObject:(id)object
{
    [super setObject:object];
    
    MatchItem *item = object;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    formatter.dateFormat = @"dd MMM yyyy";
    // date
    self.dateLbl.text = item.stage;//[[formatter stringFromDate:item.day] uppercaseString];
    
    // score/time
    if (item.score && ![item.score isEqualToString:@""]) {
        self.timeLbl.text = item.score;
    }
    else {
        // show time
        formatter.dateFormat = @"HH:mm";
        self.timeLbl.text = [[formatter stringFromDate:item.datetime] uppercaseString];
    }
    
    // group
    if ([item.stage isEqualToString:item.group.name]) {
        self.groupLbl.text = @"";
    }
    else self.groupLbl.text = item.group.name;
    
    // team 1
    TeamModel *team = item.teamHome;
    self.team1_ImgView.image = [UIImage imageNamed:team.imageUrl];
    self.team1_NameLbl.text = team.shortName;
    
    // team 2
    team = item.teamAway;
    self.team2_ImgView.image = [UIImage imageNamed:team.imageUrl];
    self.team2_NameLbl.text = team.shortName;
    
    if ([item.datetime timeIntervalSinceNow] > 0) {
        self.alarmBtn.hidden = NO;
        if ([item.alertTime intValue] > enumAlertTime_None) {
            // has alarm
            [self.alarmBtn setImage:[UIImage imageNamed:@"alarm_on.png"] forState:UIControlStateNormal];
        }
        else {
            [self.alarmBtn setImage:[UIImage imageNamed:@"alarm_off.png"] forState:UIControlStateNormal];
        }
    }
    else {
        self.alarmBtn.hidden = YES;
    }
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

@end
