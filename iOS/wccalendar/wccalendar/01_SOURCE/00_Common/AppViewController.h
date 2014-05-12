//
//  ViewController.h
//  aigo
//
//  Created by Tai Truong on 11/20/12.
//  Copyright (c) 2012 AIGO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CoreData/CoreData.h"
#import "ViewController.h"

@interface AppViewController : UINavigationController <UINavigationControllerDelegate> {
    NSMutableArray                                  *_listOfViewController;
    UIView                                          *_requestingView;
    UIActivityIndicatorView                         *_requestingIndicator;
    
    NSTimer                                         *_timerCountDown;
}

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (AppViewController *)Shared;

#pragma mark - Indicator view animation
- (void)isRequesting:(BOOL)isRe andRequestType:(ENUM_API_REQUEST_TYPE)type andFrame:(CGRect)frame;

#pragma mark - Model
- (void)saveContext;
- (BOOL)validateLocalDatabase;
- (BOOL) resetContent:(NSString*)fileName;
-(void)requestUpdateDeviceToken:(NSString*)oldToken;

// navigation methods

@end
