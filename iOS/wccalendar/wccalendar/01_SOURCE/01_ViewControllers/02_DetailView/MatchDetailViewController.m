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

@interface MatchDetailViewController () <UITableViewDataSource, UITableViewDelegate, CommonHeaderDelegate>
@property (weak, nonatomic) IBOutlet CommonHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
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
    NSString *title = [NSString stringWithFormat:@"%@ - %@", self.object.teamHome.shortName, self.object.teamAway.shortName];
    [self.headerView loadWithTitle:title withLeftButton:YES leftImage:nil leftText:@"Matchs" withRightButton:NO rightImage:nil];
    self.headerView.delegate = self;
}

#pragma mark - CommonHeaderDelegate
-(void)commonHeaderDidSelectRightButton:(CommonHeaderView *)view
{
    
}

-(void)commonHeaderDidSelectLeftButton:(CommonHeaderView *)view
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
@end
