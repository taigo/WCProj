//
//  ViewController.m
//  wcparsehtml
//
//  Created by Tai Truong on 5/13/14.
//  Copyright (c) 2014 Tai Truong. All rights reserved.
//

#import "ViewController.h"
#import "TFHpple.h"

// html key
#define kHtmlClass @"class"
#define kHtmlMatchListRound @"match-list-round"
#define kHtmlMatchListDate @"match-list-date anchor"
#define kHtmlMatch  @"col-xs-12 clear-grid"

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

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
- (IBAction)startBtnTouchUpInside:(id)sender;

@end

@implementation ViewController
{
    NSMutableDictionary *id2team;
    NSMutableArray *_groups;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startBtnTouchUpInside:(id)sender {
    NSMutableArray *matchs = [self parseMatchs];
//    NSLog(@"result = %@", matchs);
    NSMutableArray *jsonTeams = [self getTeams:matchs];
    NSMutableArray *jsonMatchs = [self getMatchs:matchs];
    
//    // data for client
//    NSDictionary *dataDic = [NSDictionary dictionaryWithObjectsAndKeys:_groups, @"groups", jsonTeams, @"teams", jsonMatchs, @"matchs", nil];
//    [self writeToFile:dataDic];
    
    // data for server
    NSMutableArray *scoresInfo = [NSMutableArray array];
    for (NSDictionary *dic in jsonMatchs) {
        NSMutableDictionary *scoreDic = [NSMutableDictionary dictionary];
        [scoreDic setObject:dic[kDataTeamHome] forKey:kDataTeamHome];
        [scoreDic setObject:dic[kDataTeamAway] forKey:kDataTeamAway];
        [scoreDic setObject:dic[@"matchid"] forKey:@"matchid"];
        [scoreDic setObject:@[] forKey:@"score"];
        [scoreDic setObject:dic[kDataDaytimeUTC] forKey:kDataDaytimeUTC];
        [scoresInfo addObject:scoreDic];
    }
    [self writeToFile:scoresInfo];
}

-(void)writeToFile:(NSDictionary*)dataDic
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"data.json"];
    
    NSLog(@"saved: %@", filePath);
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDic
                                                   options:kNilOptions
                                                     error:&error];
    [data writeToFile:filePath atomically:YES];
}

-(NSMutableArray*)getTeams:(NSMutableArray*)matchs
{
    _groups = [NSMutableArray array];
    NSMutableDictionary *name2groupID = [NSMutableDictionary dictionary];
    NSInteger groupID = 0;
    
    NSMutableArray *teams = [NSMutableArray array];
    id2team = [NSMutableDictionary dictionary];
    for (NSMutableDictionary *dic in matchs)
    {
        
        // group
        NSString *group = dic[kDataGroup];
        if (![name2groupID objectForKey:group]) {
            [name2groupID setObject:@(groupID) forKey:group];
            NSDictionary *groupDic = [NSDictionary dictionaryWithObjectsAndKeys:@(groupID), kDataGroupID, group, @"name", nil];
            [_groups addObject:groupDic];
            groupID++;
        }
        
        // set group ID for this match
        [dic setObject:name2groupID[group] forKey:kDataGroupID];
        [dic removeObjectForKey:kDataGroup];
        
        NSMutableDictionary *teamDic = [dic objectForKey:kDataTeamHome];
        NSString *teamID = [teamDic valueForKey:kDataShortName];
        
        // check existed
//        NSLog(@"teamID-1 = %@", teamID);
        if (![id2team objectForKey:teamID]) {
//            NSLog(@"Added %@", teamID);
            // set team id
            [teamDic setValue:teamID forKey:@"team_id"];
            [teamDic setObject:name2groupID[group] forKey:kDataGroupID];
            
            [teams addObject:teamDic];
            [id2team setObject:teamDic forKey:teamID];
        }
        else {
//            NSLog(@"Existed %@", teamID);
        }
        
        teamDic = [dic objectForKey:kDataTeamAway];
        teamID = [teamDic valueForKey:kDataShortName];
        // check existed
//        NSLog(@"teamID-2 = %@", teamID);
        if (![id2team objectForKey:teamID]) {
//            NSLog(@"Added %@", teamID);
            // set team id
            [teamDic setValue:teamID forKey:@"team_id"];
            [teamDic setObject:name2groupID[group] forKey:kDataGroupID];
            [teams addObject:teamDic];
            [id2team setObject:teamDic forKey:teamID];
        }
        else {
//            NSLog(@"Existed %@", teamID);
        }
    }
    return teams;
}

-(NSMutableArray*)getMatchs:(NSMutableArray*)matchs
{
    
    NSMutableArray *jsonMatchs = [NSMutableArray array];
    for (NSMutableDictionary *dic in matchs)
    {
        // match ID
        NSString *matchNum = [[[dic objectForKey:kDataMatchNum] componentsSeparatedByString:@" "] lastObject];
        [dic setValue:matchNum forKey:@"matchid"];
        // dateime
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [formatter setDateFormat:@"ddMM HH:mm"];
        NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%@ %@", dic[kDataDayMonthUTC], dic[kDataTimeUTC]]];
//        NSLog(@"date = %@", date);
        [dic removeObjectForKey:kDataTimeUTC];
        [dic removeObjectForKey:kDataDayMonthUTC];
        formatter.dateFormat = @"2014-MM-dd HH:mm:ss ZZZ";
        NSString *dateStr = [formatter stringFromDate:date];
        [dic setObject:dateStr forKey:kDataDaytimeUTC];
        
        
        // teams
        NSDictionary *teamDic = [dic objectForKey:kDataTeamHome];
        NSString *teamID = [teamDic valueForKey:kDataShortName];
        // check existed
//        NSLog(@"teamID-1 = %@", teamID);
        if ([id2team objectForKey:teamID]) {
//            NSLog(@"Existed %@", teamID);
            // set team id
            [dic setObject:teamID forKey:kDataTeamHome];
        }
        else {
//            NSLog(@"NOT Existed %@", teamID);
        }
        
        teamDic = [dic objectForKey:kDataTeamAway];
        teamID = [teamDic valueForKey:kDataShortName];
        // check existed
//        NSLog(@"teamID-2 = %@", teamID);
        if ([id2team objectForKey:teamID]) {
//            NSLog(@"Existed %@", teamID);
            // set team id
            [dic setObject:teamID forKey:kDataTeamAway];
        }
        else {
//            NSLog(@"NOT Existed %@", teamID);
        }
        
        // location
        [dic setObject:[dic[kDataLocationStadium] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:kDataLocationStadium];
         [dic setObject:[dic[kDataLocationVenue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:kDataLocationVenue];
        
        // add to list
        [jsonMatchs addObject:dic];
    }
    return jsonMatchs;
}

-(NSMutableArray*)parseMatchs
{
    NSMutableArray *matchs = [NSMutableArray array];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"2014_WorldCup" ofType:@"html"];
    NSData *htmlData = [NSData dataWithContentsOfFile:filePath options:NSUTF8StringEncoding error:nil];
    TFHpple *htmlParser = [TFHpple hppleWithHTMLData:htmlData];
    NSString *htmlXPathQueryString = @"//div[@class='matches']/div";
    NSArray *htmlNodes = [htmlParser searchWithXPathQuery:htmlXPathQueryString];
    NSString *stage = @"";
    for (TFHppleElement *element in htmlNodes) {
        // state
        if ([[element objectForKey:kHtmlClass] isEqualToString:kHtmlMatchListRound]) {
            stage = [self getStage:element];
        }
        // match list date
        else if ([[element objectForKey:kHtmlClass] isEqualToString:kHtmlMatchListDate]) {
            NSArray *subMatchs = [self getMatchsOfDate:element];
            // set stage for match and add match to array
            for (NSMutableDictionary *dic in subMatchs)
            {
                [dic setValue:stage forKeyPath:kDataStage];
                [matchs addObject:dic];
            }
            subMatchs = nil;
        }
        
    }
    return matchs;
}

-(NSString*)getStage:(TFHppleElement*)element
{
    return element.firstChild.text;
}

-(NSArray*)getMatchsOfDate:(TFHppleElement*)matchListDate
{
    NSMutableArray *matchs = [NSMutableArray arrayWithCapacity:matchListDate.children.count];
    NSArray *childElements = [matchListDate childrenWithClassName:kHtmlMatch];
    for (TFHppleElement *element in childElements)
    {
        NSDictionary *match = [self getMatch:element];
        [matchs addObject:match];
    }
    return matchs;
}

-(NSDictionary*)getMatch:(TFHppleElement*)matchElement
{
    NSMutableDictionary *match = [NSMutableDictionary dictionary];
    matchElement = [matchElement firstChildWithClassName:@"mu fixture"];
    // time info
    TFHppleElement *i_Child = [matchElement firstChildWithClassName:@"mu-i"];
    [match setValue:[i_Child firstChildWithClassName:@"mu-i-matchnum"].text forKey:kDataMatchNum];
    [match setValue:[i_Child firstChildWithClassName:@"mu-i-group"].text forKey:kDataGroup];
    [match setValue:[[i_Child firstChildWithClassName:@"mu-i-location"] firstChildWithClassName:@"mu-i-stadium"].text forKey:kDataLocationStadium];
    [match setValue:[[i_Child firstChildWithClassName:@"mu-i-location"] firstChildWithClassName:@"mu-i-venue"].text forKey:kDataLocationVenue];
    // team info
    TFHppleElement *m_Child = [matchElement firstChildWithClassName:@"mu-m"];
    // team home
    TFHppleElement *tHome = [m_Child firstChildWithClassName:@"t home"];
    NSMutableDictionary *teamDic = [NSMutableDictionary dictionary];
    NSString *flagImg = [[[[[[tHome firstChildWithClassName:@"t-i i-4"] firstChild] firstChild] objectForKey:@"src"] componentsSeparatedByString:@"/"] lastObject];
    [teamDic setValue:flagImg forKey:kDataFlag];
    [teamDic setValue:[[tHome firstChildWithClassName:@"t-n"] firstChildWithClassName:@"t-nText"].text forKey:kDataFullName];
    [teamDic setValue:[[tHome firstChildWithClassName:@"t-n"] firstChildWithClassName:@"t-nTri"].text forKey:kDataShortName];
    [match setObject:teamDic forKey:kDataTeamHome];
    
    // team away
    TFHppleElement *tAway = [m_Child firstChildWithClassName:@"t away"];
    teamDic = [NSMutableDictionary dictionary];
    flagImg = [[[[[[tAway firstChildWithClassName:@"t-i i-4"] firstChild] firstChild] objectForKey:@"src"] componentsSeparatedByString:@"/"] lastObject];
    [teamDic setValue:flagImg forKey:kDataFlag];
    if ([[tAway firstChildWithClassName:@"t-n"] firstChildWithClassName:@"t-nText"])
    {
        [teamDic setValue:[[tAway firstChildWithClassName:@"t-n"] firstChildWithClassName:@"t-nText"].text forKey:kDataFullName];
    } else {
        [teamDic setValue:[[tAway firstChildWithClassName:@"t-n"] firstChildWithClassName:@"t-nText kern"].text forKey:kDataFullName];
    }
    [teamDic setValue:[[tAway firstChildWithClassName:@"t-n"] firstChildWithClassName:@"t-nTri"].text forKey:kDataShortName];
    [match setObject:teamDic forKey:kDataTeamAway];
    
    // time
    TFHppleElement *datetimeElt = [[[m_Child firstChildWithClassName:@"s"] firstChildWithClassName:@"s-fixture"] firstChildWithClassName:@"s-score s-date-HHmm"];
    [match setValue:[datetimeElt objectForKey:@"data-timeutc"] forKey:kDataTimeUTC];
    [match setValue:[datetimeElt objectForKey:@"data-daymonthutc"] forKey:kDataDayMonthUTC];
    
    return match;
}
@end
