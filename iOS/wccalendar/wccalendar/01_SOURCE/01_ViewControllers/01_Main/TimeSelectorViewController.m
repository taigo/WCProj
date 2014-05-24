//
//  TimeSelectorViewController.m
//  wccalendar
//
//  Created by Tai Truong on 5/13/14.
//  Copyright (c) 2014 Tai Truong. All rights reserved.
//

#import "TimeSelectorViewController.h"
#import "CommonHeaderView.h"

#define TIME_CELL_HEIGHT 40.0f

@interface TimeSelectorViewController () <UITableViewDataSource, UITableViewDelegate, CommonHeaderDelegate>
@property (weak, nonatomic) IBOutlet CommonHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *datasource;
@end

@implementation TimeSelectorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _selectedTime = enumAlertTime_None;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initInterface];
    
    // init datasource
    _datasource = kAlertTimeTexts;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    UIEdgeInsets contentInset = self.tableView.contentInset;
    contentInset.top = (CGRectGetHeight(self.tableView.bounds) - enumAlertTime_Num*TIME_CELL_HEIGHT)/2.0f;
    self.tableView.contentInset = contentInset;
}

#pragma mark - Interface
-(void)initInterface
{
    // setup header
    [self.headerView loadWithTitle:@"Match Alert" withLeftButton:YES leftImage:nil leftText:@"Matchs" withRightButton:NO rightImage:nil];
    self.headerView.delegate = self;
    
    self.tableView.backgroundColor = [SupportFunction colorFromHexString:@"efeff4"];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.datasource count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TIME_CELL_HEIGHT;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"timecellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        // separator
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(10, TIME_CELL_HEIGHT - 0.5f, WIDTH_IPHONE - 10, 0.5f)];
        [separator setBackgroundColor:[UIColor grayColor]];
        [cell addSubview:separator];
        cell.textLabel.font = [UIFont fontWithName:FONT_APP_REGULAR size:15.0f];
    }
    
    cell.textLabel.text = [self.datasource objectAtIndex:indexPath.row];
    if (indexPath.row == self.selectedTime) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // add separator
    if (indexPath.row == 0) {
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_IPHONE, 0.5f)];
        [separator setBackgroundColor:[UIColor grayColor]];
        [cell addSubview:separator];
    }
    else if (indexPath.row == self.datasource.count-1)
    {
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, TIME_CELL_HEIGHT - 0.5f, WIDTH_IPHONE, 0.5f)];
        [separator setBackgroundColor:[UIColor grayColor]];
        [cell addSubview:separator];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedTime inSection:0]];
    cell.accessoryType = UITableViewCellAccessoryNone;
    // set check mark for new selection
    cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    // set new time
    self.selectedTime = indexPath.row;
    // call delegate
    [self.delegate timeSelector:self didSelect:indexPath.row];
    
}
@end
