//
//  AppDelegate.h
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ConnectionManager.h"
#import <GameKit/GameKit.h>

static BOOL isGameCenterAPIAvailable();

@class InicialViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate>{
    
}
extern NSString *const FBSessionStateChangedNotification;
@property (strong, nonatomic) UIWindow *window;


- (void) closeSession;
- (BOOL) openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
+ (ConnectionManager*) retrieveConnectionManager;
+(void)setDocument:(UIManagedDocument *)documentt;
+(UIManagedDocument *)getDocument;
-(BOOL)testReachability;

@end
