/*
 *  CGMarkerHelper.h
 *  SpotDiferences
 *
 *  Copyright 2012 Go4Mobility
 *
 */

#import "MazeView.h"
#import "Differences.h"

@interface CGMarkerHelper : NSObject

+(void)drawMarkerWithPoint:(CGPoint)point inView:(MazeView*)view; 
+(void)drawMarker:(Differences*)difference 
           inView:(MazeView*)view 
     insecundView:(MazeView*)rightImageView
         inBounds:(CGSize)size ; 



@end
