//
//  MazeView.h
//  SpotDiferences
//
//  Created by Miguel Cartó on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MazeView : UIView

-(void) setImage:(UIImage*)image;
-(void) addMarker:(CGRect) marker;
-(void) reset;

@end
