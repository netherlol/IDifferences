//
//  GameCenterManager.h
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 10/16/12.
//
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface GameCenterManager : NSObject<GKLeaderboardViewControllerDelegate>
@property (nonatomic)NSString *enableGameCenter;

+ (GameCenterManager *)sharedGameCenterManager;

- (void)showLeaderboard:(NSString *)leaderboard
         viewController:(UIViewController*)vc;

- (void)submitScore:(GKScore *)score;

// currentPlayerID is the value of the playerID last time we authenticated.
@property (retain,readwrite) NSString * currentPlayerID;

// isGameCenterAuthenticationComplete is set after authentication, and authenticateWithCompletionHandler's completionHandler block has been run. It is unset when the application is backgrounded.
@property (readwrite, getter=isGameCenterAuthenticationComplete) BOOL gameCenterAuthenticationComplete;
-(void)gameCenterAuthentication;
@end
