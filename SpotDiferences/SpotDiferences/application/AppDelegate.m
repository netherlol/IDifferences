//
//  AppDelegate.m
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"
#import <FacebookSDK/FacebookSDK.h>
#import "MyDocumentHandler.h"
#import "GameCenterManager.h"

static NSString* kAppId = @"366487963430871";

@interface AppDelegate()

@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;



- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;

@end

@implementation AppDelegate

static ConnectionManager *connectionManager;
static UIManagedDocument *appdocument;

+(void)setDocument:(UIManagedDocument *)documentt
{
    appdocument = documentt;
}

+(UIManagedDocument *)getDocument
{
    return appdocument;
}

@synthesize window             = _window;
@synthesize managedObjectModel = _managedObjectModel,
          managedObjectContext = _managedObjectContext,
    persistentStoreCoordinator = _persistentStoreCoordinator;

NSString *const FBSessionStateChangedNotification = @"com.example.Login:FBSessionStateChangedNotification";


+(ConnectionManager*) retrieveConnectionManager {
    if (connectionManager == nil) {
        connectionManager = [[ConnectionManager alloc] init];
        
    }

    
    return connectionManager;
}


-(void)postOnFacebook {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *data = [prefs objectForKey:@"facebookdata"];
    
    NSMutableDictionary *postParams =
    [[NSMutableDictionary alloc] initWithObjectsAndKeys:
     @"http://www.facebook.com/idifferences", @"link",
     @"http://www.idifferences.com/images/idifferences-facebook.png", @"picture",
     @"iDifferences", @"name",
     //data, @"caption",
     data, @"description",
     nil];
    
    [FBRequestConnection startWithGraphPath:@"me/feed"
                                 parameters:postParams
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error) {
                              /*
                              NSString *alertText;
                              if (error) {
                                  alertText = [NSString stringWithFormat:
                                               @"error: domain = %@, code = %d",
                                               error.domain, error.code];
                              } else {
                                  alertText = [NSString stringWithFormat:
                                               @"Posted action, id: %@",
                                               [result objectForKey:@"id"]];
                              }
                              // Show the result in an alert
                              [[[UIAlertView alloc] initWithTitle:@"Result"
                                                          message:alertText
                                                         delegate:self
                                                cancelButtonTitle:@"OK!"
                                                otherButtonTitles:nil]
                               show];
                               */
                          }
     ];
    
}

/*
 * Callback for session changes.
 */
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                // We have a valid session
                NSLog(@"User session found");
                [self postOnFacebook];
            }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:FBSessionStateChangedNotification
     object:session];
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void) closeSession {
    [FBSession.activeSession closeAndClearTokenInformation];
}

/*
 * Opens a Facebook session and optionally shows the login UX.
 */
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"user_likes", 
                            @"read_stream",
                            @"publish_actions",
                            nil];
    return [FBSession openActiveSessionWithPermissions:permissions
                                          allowLoginUI:allowLoginUI
                                     completionHandler:^(FBSession *session,
                                                         FBSessionState state,
                                                         NSError *error) {
                                         [self sessionStateChanged:session
                                                             state:state
                                                             error:error];
                                     }];
}

-(void)copyPersistentStoreFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *txtPath = [documentsDirectory stringByAppendingPathComponent:@"SpotDifferenceGame"];
    NSString *txtPath2 = [txtPath stringByAppendingPathComponent:@"StoreContent"];
    NSString *txtPath3 = [txtPath2 stringByAppendingPathComponent:@"persistentStore"];
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:txtPath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:txtPath withIntermediateDirectories:NO attributes:nil error:&error];
        [[NSFileManager defaultManager] createDirectoryAtPath:txtPath2 withIntermediateDirectories:NO attributes:nil error:&error];
        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"persistentStore" ofType:nil];
        [fileManager copyItemAtPath:resourcePath toPath:txtPath3 error:&error];
        if (error) {
            NSLog(@"error ! %@",[error description]);
        }
    }
}

-(BOOL)testReachability
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if(internetStatus == NotReachable) 
    {
        NSLog(@"no Internet Access");
        return NO;
    }else
    {
        NSLog(@"got Internet Access");    
        return YES;
    }
}




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [self testReachability];
    [FBProfilePictureView class];
    //[self copyPersistentStoreFile];
    //[self managedObjectContext];
    [UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationLandscapeLeft; 
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    // Assign an Observer class to the SKPaymentTransactionObserver,
	// so that it can monitor the transaction status.
    [[SKPaymentQueue defaultQueue] addTransactionObserver: [AppDelegate retrieveConnectionManager]];
    // Initialize Facebook
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [self saveContext];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if (FBSession.activeSession.state == FBSessionStateCreatedOpening) {
        [FBSession.activeSession close]; // so we close our session and start over
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [FBSession.activeSession close];
    [self saveContext];
}

- (BOOL)application:(UIApplication *)application 
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication 
         annotation:(id)annotation 
{
    return [FBSession.activeSession handleOpenURL:url]; 
}


#pragma mark - UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // Quit the app
    exit(1);
}

- (void)saveContext
{
    NSError *error;
    if (_managedObjectContext != nil) {
        if ([_managedObjectContext hasChanges] && ![_managedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

/*
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
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
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"GameModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SpotDifferenceGame"];
    NSURL *txtPath2 = [storeURL URLByAppendingPathComponent:@"StoreContent"];
    NSURL *txtPath3 = [txtPath2 URLByAppendingPathComponent:@"persistentStore"];
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:[storeURL path] withIntermediateDirectories:NO attributes:nil error:&error];
        [[NSFileManager defaultManager] createDirectoryAtPath:[txtPath2 path] withIntermediateDirectories:NO attributes:nil error:&error];
        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"persistentStore" ofType:nil];
        [fileManager copyItemAtPath:resourcePath toPath:[txtPath3 path ]error:&error];
        if (error) {
            NSLog(@"error ! %@",[error description]);
        }
        
    }

    
    /*
     Set up the store.
     For the sake of illustration, provide a pre-populated default store.
     */
   // NSFileManager *fileManager = [NSFileManager defaultManager];
    // If the expected store doesn't exist, copy the default store.
   /* if (![fileManager fileExistsAtPath:[storeURL path]]) {
        NSURL *defaultStoreURL = [[NSBundle mainBundle] URLForResource:@"persistentStore" withExtension:nil];
        if (defaultStoreURL) {
            [fileManager copyItemAtURL:defaultStoreURL toURL:storeURL error:NULL];
        }
    }*/
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    
    //NSError *error;
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:txtPath3 options:options error:&error]) {
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
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
