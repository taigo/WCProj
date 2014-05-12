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

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) IBOutlet CommonHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    if ([self.fetchedResultsController.fetchedObjects count] == 0) {
        [self addSampleData];
    }
    
    [self initInterface];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // set table inset
    [self.tableView setContentInset:UIEdgeInsetsZero];
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
    
    // save context
    [[AppViewController Shared] saveContext];
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
    [self.headerView loadWithTitle:@"MATCHS" withLeftButton:NO leftImage:nil leftText:nil withRightButton:NO rightImage:nil];
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
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    MatchItem *item = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"EEEE dd MMMM";
    return [[formatter stringFromDate:item.day] capitalizedString];
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
@end
