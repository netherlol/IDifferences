/*
 *  MazeHelper.h
 *  SpotDiferences
 *
 *  Copyright 2012 Go4Mobility
 *
 */

#import <UIKit/UIKit.h>
#import "Maze.h"
#import "Differences.h"

@interface MazeHelper : NSObject

@property (nonatomic) float initialZoomScale;
@property (nonatomic) CGSize viewSize;
@property (nonatomic,weak) NSString *mazeImage;
@property (nonatomic,strong) NSMutableArray *mazeDifferences;
@property (nonatomic,strong) NSMutableArray *availableDifferences;

+(MazeHelper *)initWith:(Maze *)maze 
        mazeDifferences:(NSMutableArray*)differences;

-(void)reset;
-(Differences*)differenceFound:(CGPoint)position;
-(UIImage*)getRightImage;
-(UIImage*)getLeftImage;

-(CGPoint) percentageToPoint:(float)percentageX yValue:(float)percentageY;
-(int)getBonusScoreByDifficulty;
-(int)getMazeZoomFactor;
-(int)getMazeAvailableTime;
-(int)getMazeRemainingTimeScoreByDifficulty;
-(int)getValueByDifficulty;
-(int)getMazeNoErrorBonusByDifficulty;
-(int)getExtraTimeValueByDifficulty;
-(int)getErrorValueByDifficulty ;

@end
