//
//  CommonHeaderView.h
//  YardClub
//
//  Created by Tai Truong on 4/8/14.
//  Copyright (c) 2014 siliconprime. All rights reserved.
//

#import <UIKit/UIKit.h>

#define COMMON_HEADER_HEIGHT 64.0f

@class CommonHeaderView;
@protocol CommonHeaderDelegate <NSObject>

@optional
-(void)commonHeaderDidSelectLeftButton:(CommonHeaderView*)view;
-(void)commonHeaderDidSelectRightButton:(CommonHeaderView*)view;

@end

@interface CommonHeaderView : UIView

@property (strong, nonatomic) UILabel *titleLbl;
@property (strong, nonatomic) UIButton *leftBtn;
@property (strong, nonatomic) UILabel *leftLbl;
@property (strong, nonatomic) UIButton *rightBtn;

@property (weak, nonatomic) id<CommonHeaderDelegate> delegate;

-(void)loadWithTitle:(NSString*)title withLeftButton:(BOOL)showLeftBtn leftImage:(UIImage*)leftImage leftText:(NSString*)leftText withRightButton:(BOOL)showRightBtn rightImage:(UIImage*)rightImage;
@end
