//
//  SoundManager.m
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SoundManager.h"

@interface SoundManager() 
@property(nonatomic,strong) AVAudioPlayer *intro;
@property(nonatomic,strong) AVAudioPlayer *check;
@property(nonatomic,strong) AVAudioPlayer *erro;
@property(nonatomic,strong) AVAudioPlayer *final;
@property(nonatomic,strong) AVAudioPlayer *interface;
@end


@implementation SoundManager
@synthesize intro = _intro;
@synthesize check = _check;
@synthesize erro = _erro;
@synthesize final = _final;
@synthesize interface = _interface;
static  SoundManager * _sharedSOundManager;

+ (SoundManager *)sharedSoundManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedSOundManager = [[self alloc] init];
    });
    
    return _sharedSOundManager;
}


-(id)init
{
    self = [super init];
    if(self)
    {
        
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"intro" ofType:@"mp3"]];
        
        NSError *error;
        self.intro = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        
        if (error) {
            NSLog(@"Error in audioPlayer: %@", [error localizedDescription]);
        }else {
            [self.intro prepareToPlay];
            self.intro.accessibilityValue = @"intro";
        }
        
        url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"check" ofType:@"mp3"]];
        
        self.check = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        
        if (error) {
            NSLog(@"Error in audioPlayer: %@", [error localizedDescription]);
        }else {
            [self.check prepareToPlay];
            self.intro.accessibilityValue = @"check";
        }
        
        url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"erro" ofType:@"mp3"]];
        
        self.erro = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        
        if (error) {
            NSLog(@"Error in audioPlayer: %@", [error localizedDescription]);
        }else {
            [self.erro prepareToPlay];
            self.intro.accessibilityValue = @"erro";
        }
        
        url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"final" ofType:@"mp3"]];
        
        self.final = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        
        if (error) {
            NSLog(@"Error in audioPlayer: %@", [error localizedDescription]);
        }else {
            [self.final prepareToPlay];
            self.intro.accessibilityValue = @"final";
        }
        
        url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"interface" ofType:@"mp3"]];
        
        self.interface = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        
        if (error) {
            NSLog(@"Error in audioPlayer: %@", [error localizedDescription]);
        }else {
            [self.interface prepareToPlay];
            self.intro.accessibilityValue = @"interface";
        }
        
    }
    return self;
}


-(void)playIntro
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *sound = [prefs stringForKey:@"sound"];
    if (![sound isEqualToString:@"NO"]) {
        if (!self.intro.isPlaying) {
            if (self.intro.currentTime != 0) {
                self.intro.currentTime = 0;
            }
            self.intro.numberOfLoops = -1;
            self.intro.volume = 0;
            [self.intro play];
            [self fadein];
        }

    }
}

-(void)fadein
{
    if (self.intro.volume < 1) {
        self.intro.volume += 0.1;
        [self performSelector:@selector(fadein) withObject:nil afterDelay:0.1 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
}

-(void)fadeout
{
    if (self.intro.volume > 0.1) {
        self.intro.volume -= 0.1;
        [self performSelector:@selector(fadeout) withObject:nil afterDelay:0.1 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }else {
        [self.intro stop];
    }
}

-(void)stopIntro
{
    if(self.intro.isPlaying)
    {
        [self fadeout];
    }
}
-(void)playCheck
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *sound = [prefs stringForKey:@"sound"];
    if (![sound isEqualToString:@"NO"]) {
        [self.check play];
    }
}
-(void)stopCheck
{
    [self.check stop];
}
-(void)playErro
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *sound = [prefs stringForKey:@"sound"];
    if (![sound isEqualToString:@"NO"]) {
        [self.erro play];
    }
}
-(void)stopErro
{
    [self.erro stop];
}
-(void)playFinal
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *sound = [prefs stringForKey:@"sound"];
    if (![sound isEqualToString:@"NO"]) {
        [self.final play];
    }
}
-(void)stopFinal
{
    [self.final stop];
}
-(void)playInterface
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *sound = [prefs stringForKey:@"sound"];
    if (![sound isEqualToString:@"NO"]) {
        [self.interface play];
    }
}
-(void)stopInterface
{
    [self.interface stop];
}

-(void)stopAllSounds
{
    [self stopIntro];
    [self stopCheck];
    [self stopErro];
    [self stopFinal];
    [self stopInterface];
}

@end
