//
//  CommonHeaderView.m
//  YardClub
//
//  Created by Tai Truong on 4/8/14.
//  Copyright (c) 2014 siliconprime. All rights reserved.
//

#import "CommonHeaderView.h"

@implementation CommonHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)init
{
    self = [super init];
    if (self) {
        [self initInterface];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initInterface];
    }
    return self;
}

-(void)initInterface
{
    self.frame = CGRectMake(0, 0, WIDTH_IPHONE, COMMON_HEADER_HEIGHT);
    self.backgroundColor = [SupportFunction colorFromHexString:@"f7f7f7"];
    
    // title label
    _titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.bounds), 44)];
    _titleLbl.font = [UIFont fontWithName:FONT_APP_BOLD size:17.0f];
    _titleLbl.textColor = [UIColor blackColor];
    _titleLbl.backgroundColor = [UIColor clearColor];
    _titleLbl.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLbl];
    
    // left label
    // title label
    _leftLbl = [[UILabel alloc] initWithFrame:CGRectMake(25, 20, 90, 44)];
    _leftLbl.font = [UIFont fontWithName:FONT_APP_REGULAR size:16.0f];
    _leftLbl.textColor = [UIColor blackColor];
    _leftLbl.backgroundColor = [UIColor clearColor];
    _leftLbl.minimumScaleFactor = 0.6f;
    _leftLbl.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_leftLbl];
    
    // left button
    _leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(8, 21, 65, 44)];
    [_leftBtn setImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
    _leftBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_leftBtn addTarget:self action:@selector(leftBtnTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_leftBtn];
    
    // right button
    _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(245, 20, 65, 44)];
    [_rightBtn setImage:[UIImage imageNamed:@"icn-call.png"] forState:UIControlStateNormal];
    _rightBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_rightBtn addTarget:self action:@selector(rightBtnTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_rightBtn];
    
    _rightBtn.titleLabel.font = _leftBtn.titleLabel.font = _leftLbl.font;
    [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    // separator
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, COMMON_HEADER_HEIGHT - 0.5f, WIDTH_IPHONE, 0.5f)];
    [separator setBackgroundColor:[UIColor grayColor]];
    [self addSubview:separator];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)leftBtnTouchUpInside
{
    if ([self.delegate respondsToSelector:@selector(commonHeaderDidSelectLeftButton:)]) {
        [self.delegate commonHeaderDidSelectLeftButton:self];
    }
}

-(void)rightBtnTouchUpInside
{
    if ([self.delegate respondsToSelector:@selector(commonHeaderDidSelectRightButton:)]) {
        [self.delegate commonHeaderDidSelectRightButton:self];
    }
}

#pragma mark - Public Methods
-(void)loadWithTitle:(NSString *)title withLeftButton:(BOOL)showLeftBtn leftImage:(UIImage *)leftImage leftText:(NSString*)leftText withRightButton:(BOOL)showRightBtn rightImage:(UIImage *)rightImage
{
    // set title
    self.titleLbl.text = title;
    
    // config left/right buttons
    self.leftBtn.hidden = !showLeftBtn;
    if (showLeftBtn && leftImage) {
        [self.leftBtn setImage:leftImage forState:UIControlStateNormal];
    }
    self.leftLbl.text = leftText;
    
    self.rightBtn.hidden = !showRightBtn;
    if (showRightBtn && rightImage) {
        [self.rightBtn setImage:rightImage forState:UIControlStateNormal];
    }
}

@end
