//
//  SoundManager.h
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface SoundManager : NSObject
+(SoundManager*)sharedSoundManager;
-(id)init;
-(void)playIntro;
-(void)stopIntro;
-(void)playCheck;
-(void)stopCheck;
-(void)playErro;
-(void)stopErro;
-(void)playFinal;
-(void)stopFinal;
-(void)playInterface;
-(void)stopInterface;
@end
