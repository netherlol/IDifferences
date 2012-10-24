//
//  AccountLoginTableViewController.h
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 9/26/12.
//
//

#import <UIKit/UIKit.h>
#import "HighScoresViewController.h"

@interface AccountSettingsViewController: UITableViewController<UITextFieldDelegate>

-(void)submitScore:(int)score
        scoreboard:(NSString*)scoreboard;
-(void)getMyRanking;
-(void)getTopPlayerPoints;
-(void)getWorldAvarageTime;
-(void)getStatistic;
-(void)getWorldRecordTime:(NSString*)uniqueID;
-(void)getWorldRecordPoint:(NSString*)uniqueID;
@property (nonatomic,strong)id<updateHighScores> delegate;
@property (nonatomic, weak) IBOutlet UIManagedDocument *document;
@end
