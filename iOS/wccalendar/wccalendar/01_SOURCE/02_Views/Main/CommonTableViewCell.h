//
//  CommonTableViewCell.h
//  YardClub
//
//  Created by Tai Truong on 4/9/14.
//  Copyright (c) 2014 siliconprime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonTableViewCell : UITableViewCell
@property (weak, nonatomic) id object;
+(CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object;
@end
