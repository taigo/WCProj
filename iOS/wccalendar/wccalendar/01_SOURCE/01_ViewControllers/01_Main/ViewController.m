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
#import "Group.h"
#import "MatchDetailViewController.h"
#import "GADBannerView.h"

// data key
#define kDataStage @"stage"
#define kDataMatchNum @"match_num"
#define kDataGroup @"group"
#define kDataGroupID @"groupid"
#define kDataLocationStadium @"location_stadium"
#define kDataLocationVenue @"location_venue"
#define kDataTeamHome @"team_home"
#define kDataTeamAway @"team_away"
#define kDataFlag @"flag_img"
#define kDataFullName @"fullname"
#define kDataShortName @"shortname"
#define kDataTimeUTC @"timeutc"
#define kDataDayMonthUTC @"daymonthutc"
#define kDataDaytimeUTC @"datetime"
#define kDataTeamID @"team_id"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, CommonHeaderDelegate, TeamFilterDelegate, MatchTableCellDelegate, MatchDetailViewDelegate>
{
    GADBannerView *bannerView_;
}
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
        [self addData];
    }
    
    [self initInterface];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(getMatchsInfo)
                                                name:UIApplicationDidBecomeActiveNotification
                                              object:nil];
    
    // Create a view of the standard size at the top of the screen.
    // Available AdSize constants are explained in GADAdSize.h.
    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    bannerView_ = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [bannerView_ loadRequest:[GADRequest request]];
    bannerView_.frame = CGRectOffset(bannerView_.bounds, 0, self.view.bounds.size.height - bannerView_.frame.size.height);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, bannerView_.frame.size.height, 0);
    
}

-(void)getMatchsInfo
{
    [[WebserviceManager sharedInstance] operationWithType:ENUM_API_REQUEST_GET_MATCHS_INFO andPostMethodKind:NO andParams:nil inView:nil completeBlock:^(id responseObject) {
        [self updateMatchsInfo:responseObject];
    } failureBlock:^(NSError *error) {
        
    }];
}

-(void)updateMatchsInfo:(NSArray*)data
{
    for (NSDictionary *dic in data) {
        [MatchItem updateMatch:dic];
    }
    
    // save context
    [[AppViewController Shared] saveContext];
    
    _fetchedResultsController = nil;
    // reload view
    [self.tableView reloadData];
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
        match1.matchID = [NSString stringWithFormat:@"%d", i];
        match1.datetime = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        TTLog(@"%@", match1.datetime);
        formatter.dateFormat = @"yyyy/MM/dd";
        NSString *dateStr = [formatter stringFromDate:match1.datetime];
        formatter.dateFormat = @"yyyy/MM/dd";
        match1.day = [formatter dateFromString:dateStr];
        [match1 setTeamHome:team1];
        [match1 setTeamAway:team2];
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

-(void)addData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    NSError *error;
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    NSManagedObjectContext *managedObjectContext = [AppViewController Shared].managedObjectContext;
    // group
    NSArray *groups = [jsonDic objectForKey:@"groups"];
    NSMutableDictionary *id2Group = [NSMutableDictionary dictionary];
    for (NSDictionary *dic in groups)
    {
        Group *item = [NSEntityDescription insertNewObjectForEntityForName:WC_GROUP_MODEL inManagedObjectContext:managedObjectContext];
        item.groupID = [dic[kDataGroupID] stringValue];
        item.name = dic[@"name"];
        // add to id 2 group
        [id2Group setObject:item forKey:item.groupID];
    }
    // team
    NSArray *teams = [jsonDic objectForKey:@"teams"];
    NSMutableDictionary *id2Team = [NSMutableDictionary dictionary];
    for (NSDictionary *dic in teams)
    {
        TeamModel *item = [NSEntityDescription insertNewObjectForEntityForName:WC_TEAM_MODEL inManagedObjectContext:managedObjectContext];
        item.teamID = dic[kDataTeamID];
        item.name = dic[kDataFullName];
        item.shortName = dic[kDataShortName];
        item.imageUrl = dic[kDataFlag];
        NSString *groupID = [dic[kDataGroupID] stringValue];
        if ([id2Group objectForKey:groupID]) {
            item.group = [id2Group objectForKey:groupID];
        }
        else {
            NSLog(@"not have group");
        }
        
        [id2Team setObject:item forKey:item.teamID];
    }
    // match
    NSArray *matchs = [jsonDic objectForKey:@"matchs"];
    for (NSDictionary *dic in matchs)
    {
        MatchItem *item = [NSEntityDescription insertNewObjectForEntityForName:WC_MATCH_MODEL inManagedObjectContext:managedObjectContext];
        item.matchID = dic[@"matchid"];
        item.stage = dic[kDataStage];
        item.stadium = dic[kDataLocationStadium];
        item.venue = dic[kDataLocationVenue];
        item.matchNum = dic[kDataMatchNum];
        NSString *groupID = [dic[kDataGroupID] stringValue];
        if ([id2Group objectForKey:groupID]) {
            item.group = [id2Group objectForKey:groupID];
        }
        else {
            NSLog(@"not have group");
        }
        NSString *team_home = dic[kDataTeamHome];
        if ([id2Team objectForKey:team_home]) {
            item.teamHome = [id2Team objectForKey:team_home];
        }
        else {
            NSLog(@"not have team home");
        }
        NSString *team_away = dic[kDataTeamAway];
        if ([id2Team objectForKey:team_away]) {
            item.teamAway = [id2Team objectForKey:team_away];
        }
        else {
            NSLog(@"not have team away");
        }
        
        // datetime
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss ZZZ";
        NSDate *date = [formatter dateFromString:dic[kDataDaytimeUTC]];
        
        NSDateFormatter *formatterLocal = [[NSDateFormatter alloc] init];
        [formatterLocal setTimeZone:[NSTimeZone localTimeZone]];
        formatterLocal.dateFormat = @"yyyy-MM-dd HH:mm:ss ZZZ";
        NSDate *date2 = [formatterLocal dateFromString:dic[kDataDaytimeUTC]];
        NSString *temp = [formatterLocal stringFromDate:date2];
        
        item.datetime = [formatterLocal dateFromString:temp];
        NSLog(@"%@", item.datetime);
        
        // day
        formatterLocal.dateFormat = @"yyyy/MM/dd";
        NSString *dateStr = [formatterLocal stringFromDate:item.datetime];
        item.day = [formatterLocal dateFromString:dateStr];
        NSLog(@"day = %@", item.day);
        
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
    [self.headerView loadWithTitle:@"WORLD CUP 2014" withLeftButton:NO leftImage:nil leftText:nil withRightButton:YES rightImage:[UIImage imageNamed:@"home_icon_fillter"]];
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
        cell.delegate = self;
    }
    
    [cell setObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MatchDetailViewController *matchDetail = [MatchDetailViewController new];
    matchDetail.delegate = self;
    [matchDetail setObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    [self.navigationController pushViewController:matchDetail animated:YES];
}

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
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
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
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"teamHome == %@ OR teamAway == %@", self.filteredTeam, self.filteredTeam];
        [fetchRequest setPredicate:predicate];
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"datetime"  ascending:YES];
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
    if (item == nil)
    {
        // clear filter
        self.headerView.rightBtn.frame = CGRectMake(275, 27, 32, 32);
        [self.headerView.rightBtn setImage:[UIImage imageNamed:@"home_icon_fillter"] forState:UIControlStateNormal];
    }
    else {
        // team filter
        self.headerView.rightBtn.frame = CGRectMake(275, 30, 35, 23);
        [self.headerView.rightBtn setImage:[UIImage imageNamed:item.imageUrl] forState:UIControlStateNormal];
    }
    // re-fetch datasource
    _fetchedResultsController = nil;
    // reload view
    [self.tableView reloadData];
}

#pragma mark - MatchTableCellDelegate
-(void)matchCellDidSelectSetAlarm:(MatchTableCell *)cell
{
    MatchDetailViewController *matchDetail = [MatchDetailViewController new];
    [matchDetail setObject:cell.object];
    matchDetail.shouldShowAlarmSelector = YES;
    matchDetail.delegate = self;
    [self.navigationController pushViewController:matchDetail animated:NO];
}

#pragma mark - MatchDetailViewDelegate
-(void)matchDetailDidSetAlarm:(MatchDetailViewController *)controller
{
    [self.tableView reloadData];
}
@end
