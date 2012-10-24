//
//  HighScoresViewController.h
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 8/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@protocol updateHighScores <NSObject>

@optional
-(void)updateRanking:(NSString*)value;
-(void)updateTopPlayerPoints:(NSString*)value;
-(void)updateWorldAvarageTime:(NSString*)value;
-(void)updateWorldRecordTime:(NSString*)value;
-(void)updateWorldRecordPoints:(NSString*)value;
-(void)updateStatistics:(NSDictionary*)statisticData;
-(void)startedConnection;
-(void)connectionFailed;
-(void)connectionFinished;
@end

@interface HighScoresViewController : UIViewController <MBProgressHUDDelegate> {
	MBProgressHUD *HUD;
    
	long long expectedLength;
	long long currentLength;
}


@end
