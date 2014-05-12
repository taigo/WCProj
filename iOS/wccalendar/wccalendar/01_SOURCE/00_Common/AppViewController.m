//
//  ViewController.m
//  aigo
//
//  Created by Tai Truong on 11/20/12.
//  Copyright (c) 2012 AIGO. All rights reserved.
//

#import "AppViewController.h"
#import <sqlite3.h>

@interface AppViewController ()

@end


@implementation AppViewController
@synthesize managedObjectContext = _managedObjectContext;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _listOfViewController = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(30, 30, 100, 30)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/////////////////////////////////
static AppViewController *_appVCInstance;
+ (AppViewController *)Shared
{
    if (!_appVCInstance) {
        _appVCInstance = [[AppViewController alloc] init];
    }
    return _appVCInstance;
}

#pragma mark - Indicator view animation

- (void)isRequesting:(BOOL)isRe andRequestType:(ENUM_API_REQUEST_TYPE)type andFrame:(CGRect)frame {
    if (isRe) {
        if (_requestingView == nil) {
            _requestingView = [UIView new];
            _requestingView.backgroundColor = [UIColor blackColor];
            _requestingView.alpha= 0.5;
        }
        if (_requestingIndicator == nil) {
            _requestingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [_requestingView addSubview:_requestingIndicator];
            
        }
        
        [_requestingView removeFromSuperview];
        [_requestingIndicator startAnimating];
		_requestingView.frame = frame;
		_requestingIndicator.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        [[[_listOfViewController lastObject] view] addSubview:_requestingView];
    }
    else {
        [_requestingIndicator stopAnimating];
        [_requestingView removeFromSuperview];
    }
}


#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSURL *)applicationCacheDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
}

-(void)requestUpdateDeviceToken:(NSString*)oldToken
{

}

#pragma mark - managedObjectContext

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        // set merge policy for main thread managed object context
        [_managedObjectContext setMergePolicy:NSMergeByPropertyStoreTrumpMergePolicy];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:kSqliteFileName withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }

    NSURL *storeURL = [[self applicationCacheDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",kSqliteFileName]];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        TTLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

// Returns YES if local database is compatible with current model. Else return NO
- (BOOL)validateLocalDatabase
{
    
    NSURL *storeURL = [[self applicationCacheDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",kSqliteFileName]];
    
//    TTLog(@"Local database path: %@", storeURL);
    
    NSError * error = nil;
    
    NSDictionary *storeMeta = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:nil URL:storeURL error:&error];
    
    if (!storeMeta) {
        TTLog(@"Unable to load store metadata from URL: %@; Error = %@", storeURL, error);
        return YES;
    }
    
    BOOL result = [[self managedObjectModel] isConfiguration: nil compatibleWithStoreMetadata: storeMeta];
    
    if (!result) {
        // reset _managedObjectModel to reload new model
        _managedObjectModel = nil;
        TTLog(@"Unable to load store metadata from URL: %@; Error = %i", storeURL, result);
    }
    return result;
}

- (BOOL) resetContent:(NSString*)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsDirectory = [[self applicationCacheDirectory] path];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", fileName]];
    BOOL dbexists = [fileManager fileExistsAtPath:writableDBPath];
    BOOL result = YES;
    if (!dbexists)
    {
        TTLog(@"DB not exist");
        NSString *defaultDBPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"sqlite"];
        result = [fileManager removeItemAtPath:defaultDBPath error:nil];
        TTLog(@"Default resetContent-%@", [NSNumber numberWithBool:result]);
    } else {
        result = [fileManager removeItemAtPath:writableDBPath error:nil];
        TTLog(@"Writeable resetContent-%@", [NSNumber numberWithBool:result]);
    }
    
    return result;
}

@end
