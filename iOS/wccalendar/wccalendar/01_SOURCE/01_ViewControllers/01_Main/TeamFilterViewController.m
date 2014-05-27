//
//  TeamFilterViewController.m
//  wccalendar
//
//  Created by Tai Truong on 5/12/14.
//  Copyright (c) 2014 Tai Truong. All rights reserved.
//

#import "TeamFilterViewController.h"
#import "CommonHeaderView.h"
#import "AppViewController.h"
#import "TeamTableCell.h"
#import "Group.h"
#import "GroupTableViewCell.h"

@interface TeamFilterViewController () <UITableViewDataSource, UITableViewDelegate, CommonHeaderDelegate>
@property (weak, nonatomic) IBOutlet CommonHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSArray *groups;
@end

@implementation TeamFilterViewController

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
}

-(NSArray *)groups
{
    if (!_groups) {
        _groups = [Group getListGroup];
    }
    return _groups;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // set table inset
    
}

-(void)viewDidLayoutSubviews
{
    [self.tableView setContentInset:UIEdgeInsetsZero];   
}

#pragma mark - Interface
-(void)initInterface
{
    // setup header
    [self.headerView loadWithTitle:@"Filter" withLeftButton:YES leftImage:nil leftText:@"Cancel" withRightButton:YES rightImage:nil];
    self.headerView.delegate = self;
    [self.headerView.rightBtn setTitle:@"Clear" forState:UIControlStateNormal];
}

#pragma mark - CommonHeaderDelegate
-(void)commonHeaderDidSelectRightButton:(CommonHeaderView *)view
{
    [self.delegate teamFilter:self didSelect:nil];
}

-(void)commonHeaderDidSelectLeftButton:(CommonHeaderView *)view
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.fetchedResultsController.sections count] + 1; // 1 for group section
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        // group section
        return [self.groups count];
    }
    
    return [[self.fetchedResultsController.sections objectAtIndex:section-1] numberOfObjects];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [TeamTableCell tableView:tableView rowHeightForObject:nil];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class class;
    id object;
    if (indexPath.section == 0) {
        // group section
        class = [GroupTableViewCell class];
        object = [self.groups objectAtIndex:indexPath.row];
    }
    else {
        class = [TeamTableCell class];
        indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section-1];
        object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    
    NSString *cellID = [class description];
    CommonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[class alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    [cell setObject:object];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id object;
    if (indexPath.section == 0) {
        // group section
        object = [self.groups objectAtIndex:indexPath.row];
    }
    else {
        indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section-1];
        object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    [self.delegate teamFilter:self didSelect:object];
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *titles = [NSMutableArray arrayWithArray:self.fetchedResultsController.sectionIndexTitles];
    [titles insertObject:@"#" atIndex:0];
    return titles;
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if ([title isEqualToString:@"#"]) {
        return 0; // group section
    }
    index--;
    return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index] + 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        // group section and first team section
        return 25.0f;
    }
    return 0.0f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section > 1) {
        return nil;
    }

    UIView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"filtertableheader"];
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
    UILabel *textLbl = (id)[view viewWithTag:1000];
    textLbl.text = section == 0 ? @"Groups" : @"Teams";
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:WC_TEAM_MODEL inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"imageUrl != nil"];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:_managedObjectContext sectionNameKeyPath:@"initialTitle" cacheName:nil];
    
    NSError *error;
    if (![_fetchedResultsController performFetch:&error]) {
        TTLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);
    }
    
    return _fetchedResultsController;
}
@end
