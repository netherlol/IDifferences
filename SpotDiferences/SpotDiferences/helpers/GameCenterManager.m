//
//  GameCenterManager.m
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 10/16/12.
//
//

#import "GameCenterManager.h"


@implementation GameCenterManager

static GameCenterManager *_sharedInstance;
+ (GameCenterManager *)sharedGameCenterManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (void)showLeaderboard:(NSString *)leaderboard
         viewController:(UIViewController*)vc
{
    if (self.enableGameCenter) {
        GKLeaderboardViewController * leaderboardViewController = [[GKLeaderboardViewController alloc] init];
        [leaderboardViewController setCategory:leaderboard];
        [leaderboardViewController setLeaderboardDelegate:self];
        [vc presentModalViewController:leaderboardViewController  animated:YES];

    }
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	[viewController dismissModalViewControllerAnimated: YES];
}

- (void)submitScore:(GKScore *)score
{
    if (self.enableGameCenter) {
        if ([GKLocalPlayer localPlayer].authenticated) {
            if (!score.value) {
                return;
            }
            
            [score reportScoreWithCompletionHandler:^(NSError *error){
                if (!error || (![error code] && ![error domain])) {
                }
            }];
        }
    }
}

-(BOOL)isGameCenterEnable
{
    if ([self.enableGameCenter isEqualToString:@"YES"]) {
        return YES;
    }
    return NO;
}

static BOOL isGameCenterAPIAvailable()
{
    // Check for presence of GKLocalPlayer API.
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    // The device must be running running iOS 4.1 or later.
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}


-(void)gameCenterAuthentication
{
    self.gameCenterAuthenticationComplete = NO;
    
    if (!isGameCenterAPIAvailable()) {
        NSLog(@"game center is not available");
    } else {
        
        GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
        
        /*
         The authenticateWithCompletionHandler method is like all completion handler methods and runs a block
         of code after completing its task. The difference with this method is that it does not release the
         completion handler after calling it. Whenever your application returns to the foreground after
         running in the background, Game Kit re-authenticates the user and calls the retained completion
         handler. This means the authenticateWithCompletionHandler: method only needs to be called once each
         time your application is launched. This is the reason the sample authenticates in the application
         delegate's application:didFinishLaunchingWithOptions: method instead of in the view controller's
         viewDidLoad method.
         
         Remember this call returns immediately, before the user is authenticated. This is because it uses
         Grand Central Dispatch to call the block asynchronously once authentication completes.
         */
        [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error) {
            // If there is an error, do not assume local player is not authenticated.
            if (localPlayer.isAuthenticated) {
                
                // Enable Game Center Functionality
                self.gameCenterAuthenticationComplete = YES;
                
                if (! self.currentPlayerID || ! [self.currentPlayerID isEqualToString:localPlayer.playerID]) {
                    
                    // Switching Users
                    //  if (!mainViewController.player || ![self.currentPlayerID isEqualToString:localPlayer.playerID]) {
                    // If there is an existing player, replace the existing PlayerModel object with a
                    // new object, and use it to load the new player's saved achievements.
                    // It is not necessary for the previous PlayerModel object to writes its data first;
                    // It automatically saves the changes whenever its list of stored
                    // achievements changes.
                    
                    //     mainViewController.player = [[[PlayerModel alloc] init] autorelease];
                    // }
                    // [[mainViewController player] loadStoredScores];
                    // [[mainViewController player] resubmitStoredScores];
                    
                    // Load new game instance around new player being logged in.
                    
                }
                self.enableGameCenter=@"YES";
                //[mainViewController enableGameCenter:YES];
            } else {
                // User has logged out of Game Center or can not login to Game Center, your app should run
				// without GameCenter support or user interface.
                self.gameCenterAuthenticationComplete = NO;
                //[self.mainViewController enableGameCenter:NO];
                self.enableGameCenter=@"NO";
            }
        }];
    }
}

@end
