//
//  ViewController.m
//  wccalendar
//
//  Created by Tai Truong on 5/8/14.
//  Copyright (c) 2014 Tai Truong. All rights reserved.
//

#import "ViewController.h"
#import "AppViewController.h"
#import "MatchTableCell.h"
#import "CommonHeaderView.h"
#import "TeamFilterViewController.h"
#import "TimeSelectorViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, CommonHeaderDelegate, TeamFilterDelegate, TimeSelectorDelegate>
@property (weak, nonatomic) IBOutlet CommonHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) TeamModel *filteredTeam;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _filteredTeam = nil;
	// Do any additional setup after loading the view, typically from a nib.
    if ([self.fetchedResultsController.fetchedObjects count] == 0) {
        [self addSampleData];
    }
    
    [self initInterface];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)addSampleData
{
    
        // add team
        NSManagedObjectContext *managedObjectContext = [AppViewController Shared].managedObjectContext;
        TeamModel *team1 = [NSEntityDescription insertNewObjectForEntityForName:WC_TEAM_MODEL inManagedObjectContext:managedObjectContext];
        team1.name = @"BRA";
        team1.imageUrl = @"bra.png";
        
        TeamModel *team2 = [NSEntityDescription insertNewObjectForEntityForName:WC_TEAM_MODEL inManagedObjectContext:managedObjectContext];
        team2.name = @"CRO";
        team2.imageUrl = @"cro.png";
    
    for (NSInteger i = 0; i < 5; i++) {
        // add match
        MatchItem *match1 = [NSEntityDescription insertNewObjectForEntityForName:WC_MATCH_MODEL inManagedObjectContext:managedObjectContext];
        match1.time = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        TTLog(@"%@", match1.time);
        formatter.dateFormat = @"yyyy/MM/dd";
        NSString *dateStr = [formatter stringFromDate:match1.time];
        formatter.dateFormat = @"yyyy/MM/dd";
        match1.day = [formatter dateFromString:dateStr];
        [match1 setTeam1:team1];
        [match1 setTeam2:team2];
        // add match to team
        [team1 addMatchsObject:match1];
        [team2 addMatchsObject:match1];
    }
    
    
    // save context
    [[AppViewController Shared] saveContext];
    
    _fetchedResultsController = nil;
    // reload view
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Interface
-(void)initInterface
{
    // setup header
    [self.headerView loadWithTitle:@"MATCHS" withLeftButton:NO leftImage:nil leftText:nil withRightButton:YES rightImage:[UIImage imageNamed:@"home_icon_fillter"]];
    self.headerView.rightBtn.frame = CGRectMake(275, 27, 32, 32);
    self.headerView.delegate = self;
}

#pragma mark - CommonHeaderDelegate
-(void)commonHeaderDidSelectRightButton:(CommonHeaderView *)view
{
    // show filter view
    TeamFilterViewController *filterController = [TeamFilterViewController new];
    filterController.delegate = self;
    [self.navigationController pushViewController:filterController animated:YES];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.fetchedResultsController.sections count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.fetchedResultsController.sections objectAtIndex:section] numberOfObjects];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MatchTableCell tableView:tableView rowHeightForObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = [[MatchTableCell class] description];
    MatchTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[MatchTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    [cell setObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self showAlertTimeSelectorForItem:[self.fetchedResultsController objectAtIndexPath:indexPath]];
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    MatchItem *item = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"EEEE dd MMMM";
//    return [[formatter stringFromDate:item.day] capitalizedString];
//}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25.0f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"matchtableheader"];
    if (!view) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_IPHONE, 25.0f)];
        view.backgroundColor = [SupportFunction colorFromHexString:@"efeff4"];
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 25.0f - 0.5f, WIDTH_IPHONE, 0.5f)];
        [separator setBackgroundColor:[UIColor grayColor]];
        [view addSubview:separator];
        
        // text label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 300, 25.0f)];
        label.font = [UIFont fontWithName:FONT_APP_BOLD size:17.0f];
        label.tag = 1000;
        label.backgroundColor = [UIColor clearColor];
        [view addSubview:label];
    }
    
    MatchItem *item = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"EEEE dd MMMM";
    UILabel *textLbl = (id)[view viewWithTag:1000];
    textLbl.text = [[formatter stringFromDate:item.day] capitalizedString];
    return view;
}

#pragma mark - Database methods
-(NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    NSManagedObjectContext * _managedObjectContext = [AppViewController Shared].managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.includesSubentities = NO;
    NSEntityDescription *entity = [NSEntityDescription entityForName:WC_MATCH_MODEL inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    if (self.filteredTeam) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"team1 == %@ OR team2 == %@", self.filteredTeam, self.filteredTeam];
        [fetchRequest setPredicate:predicate];
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"time"  ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:_managedObjectContext sectionNameKeyPath:@"day" cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    NSError *error;
    if (![_fetchedResultsController performFetch:&error]) {
        TTLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);
    }
    
    return _fetchedResultsController;
}

#pragma mark - TeamFilterDelegate
-(void)teamFilter:(TeamFilterViewController *)controller didSelect:(TeamModel *)item
{
    [controller.navigationController popViewControllerAnimated:YES];
    
    self.filteredTeam = item;
    // re-fetch datasource
    _fetchedResultsController = nil;
    // reload view
    [self.tableView reloadData];
}

#pragma mark - TimeSelectorDelegate
-(void)timeSelector:(TimeSelectorViewController *)controller didSelect:(enumAlertTime)time
{
    
}

#pragma mark - Utilities

-(void)showAlertTimeSelectorForItem:(MatchItem*)match
{
    TimeSelectorViewController *controller = [TimeSelectorViewController new];
    controller.delegate = self;
    controller.object = match;
    // TODO: need save alert time for match
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)scheduleNotificationForDate:(NSDate *)date
{
    // Here we cancel all previously scheduled notifications
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    localNotification.fireDate = date;
    NSLog(@"Notification will be shown on: %@",localNotification.fireDate);
    
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    
    localNotification.alertBody = [NSString stringWithFormat:@"Your notification message"];
    localNotification.alertAction = NSLocalizedString(@"View details", nil);
    
    /* Here we set notification sound and badge on the app's icon "-1"
     means that number indicator on the badge will be decreased by one
     - so there will be no badge on the icon */
    localNotification.soundName = UILocalNotificationDefaultSoundName;//@"KhucXuan.m4r";
    localNotification.applicationIconBadgeNumber = 0;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

-(IBAction)setReminderForDate:(NSDate*)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:date];
    if (components.second + 5 > 60) {
        components.second = 0;
        components.minute +=1;
    }
    else {
        components.second += 5;
    }
    
    NSDate *myNewDate = [calendar dateFromComponents:components];
    calendar = nil;
    components = nil;
    
    [self scheduleNotificationForDate:myNewDate];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"Alarm has been set"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
@end
