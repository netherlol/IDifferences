/**
 *  CGMarkerHelper.m
 *  SpotDiferences
 *
 *  Copyright 2012 Go4Mobility
 *
 **/

#import "CGMarkerHelper.h"
#import "MazeView.h"


@implementation CGMarkerHelper



/**
 *
 * Draws a marker in the current CGContext.
 * Receives a point (CGPoint) indicating the center that should be used for 
 * the difference marker
 *
 *
 **/
+ (void) drawMarkerWithPoint:(CGPoint)point inView:(MazeView*)view {    
    [view addMarker:CGRectMake(point.x - 30, point.y-30, 60, 60)];
    
}


+(void)drawMarkerWithRect:(CGRect)rect 
                   inView:(MazeView*)view 
             insecundView:(MazeView*)rightImageView
{
    [view addMarker:rect];
    [rightImageView addMarker:rect];
}


+(void)drawMarker:(Differences*)difference 
           inView:(MazeView*)view 
     insecundView:(MazeView*)rightImageView
         inBounds:(CGSize)size {
    

    float topLeftX = (([difference.upleftX floatValue] /100) * size.width);
    float topLeftY = (([difference.upleftY floatValue] /100) * size.height);
    float downRightX = (([difference.downrightX floatValue] /100) * size.width);
    float downRightY = (([difference.downrightY floatValue] /100) * size.height);
    
    float width = downRightX -topLeftX;
    float height = downRightY - topLeftY;
    
    
    /*
    float ratio = (width - width*.7);
    NSLog(@"%f - %f", topLeftX, (topLeftX * 1.2));    
    NSLog(@"%f - %f", topLeftY, (topLeftY * 1.2));
    
     CGRect marker = CGRectMake((topLeftX==0?topLeftX:topLeftX + ratio), 
                               (topLeftY==0?topLeftY:topLeftY + ratio), 
                               width*.7, 
                               height*.7);
    */
    CGRect marker = CGRectMake(topLeftX, 
                               topLeftY, 
                               width, 
                               height);
    [CGMarkerHelper drawMarkerWithRect:marker inView:view insecundView:rightImageView];
    
}



@end
