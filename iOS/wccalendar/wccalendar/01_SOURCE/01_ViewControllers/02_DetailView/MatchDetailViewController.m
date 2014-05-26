//
//  MatchDetailViewController.m
//  wccalendar
//
//  Created by Tai Truong on 5/22/14.
//  Copyright (c) 2014 Tai Truong. All rights reserved.
//

#import "MatchDetailViewController.h"
#import "CommonHeaderView.h"
#import "AppViewController.h"
#import "MatchItem.h"
#import "TeamModel.h"
#import "Group.h"
#import <QuartzCore/QuartzCore.h>
#import "TimeSelectorViewController.h"
#import "GADBannerView.h"

@interface MatchDetailViewController () <CommonHeaderDelegate, TimeSelectorDelegate>
{
    GADBannerView *bannerView_;
}
@property (weak, nonatomic) IBOutlet CommonHeaderView *headerView;
// General Info
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *stadiumLbl;
@property (weak, nonatomic) IBOutlet UILabel *revenueLbl;
@property (weak, nonatomic) IBOutlet UILabel *groupLbl;

// Team Info
@property (weak, nonatomic) IBOutlet UIImageView *h_imgView;
@property (weak, nonatomic) IBOutlet UILabel *h_nameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *a_imgView;
@property (weak, nonatomic) IBOutlet UILabel *a_nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *scoreLbl;

// Alarm
@property (weak, nonatomic) IBOutlet UIView *topSeparator;
@property (weak, nonatomic) IBOutlet UIView *bottomSeparator;
@property (weak, nonatomic) IBOutlet UILabel *alarmLbl;

- (IBAction)alarmBtnTouchUpInside:(id)sender;
@end

@implementation MatchDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initInterface];
    
    // Create a view of the standard size at the top of the screen.
    // Available AdSize constants are explained in GADAdSize.h.
    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeLargeBanner];
    
    // Specify the ad unit ID.
    bannerView_.adUnitID = MY_BANNER_UNIT_ID;
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    
    // Initiate a generic request to load it with an ad.
    [bannerView_ loadRequest:[GADRequest request]];
}

-(void)dealloc
{
    bannerView_ = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateInterface];
    
    [bannerView_ loadRequest:[GADRequest request]];
    bannerView_.frame = CGRectOffset(bannerView_.bounds, 0, self.view.bounds.size.height - bannerView_.frame.size.height);
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.shouldShowAlarmSelector) {
        [self showAlertTimeSelectorForItem:self.object animated:YES];
        self.shouldShowAlarmSelector = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Interface
-(void)initInterface
{
    self.view.backgroundColor = [SupportFunction colorFromHexString:@"efeff4"];
    // setup header
    NSString *title = [NSString stringWithFormat:@"%@ - %@", self.object.teamHome.shortName, self.object.teamAway.shortName];
    [self.headerView loadWithTitle:title withLeftButton:YES leftImage:nil leftText:@"Matchs" withRightButton:NO rightImage:nil];
    self.headerView.delegate = self;
    
    self.stadiumLbl.textColor = self.revenueLbl.textColor = self.alarmLbl.textColor = [UIColor grayColor];
    
    self.h_imgView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.h_imgView.layer.shadowOffset = CGSizeMake(0.0, 0.3);
    self.h_imgView.layer.shadowOpacity = 0.7;
    self.h_imgView.layer.shadowRadius = 1.0;
    self.h_imgView.clipsToBounds = NO;
    
    self.a_imgView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.a_imgView.layer.shadowOffset = CGSizeMake(0.0, 0.3);
    self.a_imgView.layer.shadowOpacity = 0.7;
    self.a_imgView.layer.shadowRadius = 1.0;
    self.a_imgView.clipsToBounds = NO;
    
    self.topSeparator.frame = CGRectMake(0, 0, WIDTH_IPHONE, 0.5);
    self.bottomSeparator.frame = CGRectMake(0, 39.5f, WIDTH_IPHONE, 0.5);
    
    self.stadiumLbl.font = self.revenueLbl.font = [UIFont fontWithName:FONT_APP_REGULAR size:17.0f];
}

-(void)updateInterface
{
    // update data
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    formatter.dateFormat = @"dd MMM yyyy - HH:mm";
    // date
    self.timeLbl.text = [[formatter stringFromDate:self.object.datetime] uppercaseString];
    
    // stadium
    self.stadiumLbl.text = self.object.stadium;
    // revenue
    self.revenueLbl.text = self.object.venue;
    // group
    self.groupLbl.text = self.object.group.name;
    
    // team home
    self.h_imgView.image = [UIImage imageNamed:self.object.teamHome.imageUrl];
    self.h_nameLbl.text = [self.object.teamHome.name uppercaseString];
    // update frame
    CGFloat nameHeight = CGRectGetHeight(self.h_nameLbl.frame);
    CGSize textSize = [self.h_nameLbl.text sizeWithFont:self.h_nameLbl.font constrainedToSize:CGSizeMake(CGRectGetWidth(self.h_nameLbl.frame), CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    if (textSize.height > nameHeight) {
        CGRect r = self.h_nameLbl.frame;
        r.size.height = textSize.height;
        self.h_nameLbl.frame = r;
    }
    
    // team away
    self.a_imgView.image = [UIImage imageNamed:self.object.teamAway.imageUrl];
    self.a_nameLbl.text = [self.object.teamAway.name uppercaseString];
    textSize = [self.a_nameLbl.text sizeWithFont:self.a_nameLbl.font constrainedToSize:CGSizeMake(CGRectGetWidth(self.a_nameLbl.frame), CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    if (textSize.height > nameHeight) {
        CGRect r = self.a_nameLbl.frame;
        r.size.height = textSize.height;
        self.a_nameLbl.frame = r;
    }
    
    // score
    if (self.object.score && ![self.object.score isEqualToString:@""]) {
        self.scoreLbl.text = self.object.score;
    }
    else {
        // show time
        formatter.dateFormat = @"HH:mm";
        self.scoreLbl.text = [[formatter stringFromDate:self.object.datetime] uppercaseString];
    }
    
    // alarm
    self.alarmLbl.text = [kAlertTimeTexts objectAtIndex:[self.object.alertTime intValue]];
}



#pragma mark - CommonHeaderDelegate
-(void)commonHeaderDidSelectRightButton:(CommonHeaderView *)view
{
    
}

-(void)commonHeaderDidSelectLeftButton:(CommonHeaderView *)view
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Events
- (IBAction)alarmBtnTouchUpInside:(id)sender {
    if ([self.object.datetime timeIntervalSinceNow] > 0) {
        [self showAlertTimeSelectorForItem:self.object animated:YES];
    }
}

-(void)showAlertTimeSelectorForItem:(MatchItem*)match animated:(BOOL)animated
{
    TimeSelectorViewController *controller = [TimeSelectorViewController new];
    controller.delegate = self;
    controller.object = match;
    controller.selectedTime = [match.alertTime intValue];
    [self.navigationController pushViewController:controller animated:animated];
}

#pragma mark - TimeSelectorDelegate
-(void)timeSelector:(TimeSelectorViewController *)controller didSelect:(enumAlertTime)time
{
    [self.navigationController popViewControllerAnimated:YES];
    MatchItem *match = controller.object;
    // only reset alert time if the new one is different
    if ([match.alertTime integerValue] != time) {
        match.alertTime = @(time);
        [self scheduleNotificationForMatch:match];
        [[AppViewController Shared] saveContext];
        
        // notify to delegate
        [self.delegate matchDetailDidSetAlarm:self];
    }
}

#pragma mark - Utilities

- (void)scheduleNotificationForMatch:(MatchItem *)match
{
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    // cancel current notification if any
    for (UILocalNotification *notificaiton in notifications)
    {
        NSDictionary *dic = notificaiton.userInfo;
        if ([[dic valueForKey:@"matchID"] isEqualToString:match.matchID]) {
            TTLog(@"CANCEL a notification");
            [[UIApplication sharedApplication] cancelLocalNotification:notificaiton];
        }
    }
    if ([match.alertTime integerValue] == enumAlertTime_None) {
        return;
    }
    
    // create new notification
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    
    
    //    // TODO: for testing
    //    NSDate *date = [NSDate date];
    //    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    //    NSDateComponents *components = [[NSDateComponents alloc] init];
    //    components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:date];
    //    if (components.second + 5 > 60) {
    //        components.second = 0;
    //        components.minute +=1;
    //    }
    //    else {
    //        components.second += 5;
    //    }
    //    NSDate *myNewDate = [calendar dateFromComponents:components];
    //    calendar = nil;
    //    components = nil;
    //    localNotification.fireDate = myNewDate;
    
    // TODO: set time for testing notification
    // set time
    NSDate *fireDate = [self alertDateForMath:match];
    localNotification.fireDate = fireDate;
    NSLog(@"Notification will be shown on: %@",localNotification.fireDate);
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    
    // set message
    localNotification.alertBody = [NSString stringWithFormat:@"Match %@ - %@ will begin %@.", match.teamHome.name, match.teamAway.name, [self stringFromAlertTime:match.alertTime]];
    localNotification.alertAction = NSLocalizedString(@"View details", nil);
    
    // set user info
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:match.matchID forKey:@"matchID"];
    localNotification.userInfo = infoDict;
    
    // set sound
    localNotification.soundName = @"We_Are_One.mp3";
    localNotification.applicationIconBadgeNumber = 0;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

-(NSString*)stringFromAlertTime:(NSNumber*)time
{
    switch (time.integerValue) {
        case enumAlertTime_OnTime:
            return @"now";
        case enumAlertTime_5Mins:
            return @"in 5 minutes";
        case enumAlertTime_15Mins:
            return @"in 15 minutes";
        case enumAlertTime_30Mins:
            return @"in 30 minutes";
        case enumAlertTime_1hour:
            return @"in 1 hour";
        case enumAlertTime_2hours:
            return @"in 2 hours";
        case enumAlertTime_3hours:
            return @"in 3 hours";
        case enumAlertTime_1day:
            return @"in 1 day";
        case enumAlertTime_2days:
            return @"in 2 days";
        case enumAlertTime_1week:
            return @"in 1 week";
            
        default:
            break;
    }
    return @"";
}

-(NSDate*)alertDateForMath:(MatchItem*)match
{
    NSDate *date = nil;
    switch (match.alertTime.integerValue) {
        case enumAlertTime_OnTime:
            date = match.datetime;
            break;
        case enumAlertTime_5Mins:
            date = [match.datetime dateByAddingTimeInterval:(-5*60)];
            break;
        case enumAlertTime_15Mins:
            date = [match.datetime dateByAddingTimeInterval:(-15*60)];
            break;
        case enumAlertTime_30Mins:
            date = [match.datetime dateByAddingTimeInterval:(-30*60)];
            break;
        case enumAlertTime_1hour:
            date = [match.datetime dateByAddingTimeInterval:(-60*60)];
            break;
        case enumAlertTime_2hours:
            date = [match.datetime dateByAddingTimeInterval:(-2*60*60)];
            break;
        case enumAlertTime_3hours:
            date = [match.datetime dateByAddingTimeInterval:(-3*60*60)];
            break;
        case enumAlertTime_1day:
            date = [match.datetime dateByAddingTimeInterval:(-24*60*60)];
            break;
        case enumAlertTime_2days:
            date = [match.datetime dateByAddingTimeInterval:(-2*24*60*60)];
            break;
        case enumAlertTime_1week:
            date = [match.datetime dateByAddingTimeInterval:(-7*24*60*60)];
            break;
            
        default:
            break;
    }
    
    TTLog(@"old = %@", match.datetime);
    TTLog(@"new = %@", date);
    
    return date;
}
@end
