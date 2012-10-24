//
//  SplashViewController.m
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SplashViewController.h"
#import "MyDocumentHandler.h"
#import "Seed.h"
#import "Theme+Create.h"
#import "Maze+Manage.h"
#import "SoundManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AppDelegate.h"

@interface SplashViewController ()
@property (nonatomic) int time;
@property (nonatomic,weak) NSTimer *timer;
@property (nonatomic,strong) MPMoviePlayerController *player;
@property (nonatomic) int end;
@property (nonatomic) __block __weak id observer;
@end

@implementation SplashViewController
@synthesize time = _time;
@synthesize timer = _timer;
@synthesize imageview = _imageview;
@synthesize document  =_document;
@synthesize player=_player;
@synthesize end=_end;

-(void)populateInicialData
{
    [Seed populateDatabase:self.document.managedObjectContext];
}

-(NSArray *)getThemes
{
    return [Theme getAllThemes:self.document.managedObjectContext];
}

-(NSArray *)getMazes
{
    return [Maze getAllMazes:self.document.managedObjectContext];
}

-(void)useDocument
{
    [AppDelegate setDocument:self.document];
    
    NSArray *themes = [self getThemes];

    if ([themes count] == 0) {
        [self populateInicialData];
        [self.document saveToURL:self.document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
    }
}

-(void)startTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 
                                                  target:self 
                                                selector:@selector(timerCall:) 
                                                userInfo:nil 
                                                 repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/*
 *
 * end a timer
 *
 */

-(void)stopTimer
{
    [self.timer invalidate];
}

-(void)timerCall:(NSTimer*)sender
{
    if(self.time >= 3)
    {
        [self stopTimer];
        [self performSegueWithIdentifier:@"show inicial view" sender:self];
    }
    self.time++;
}

-(void)playVideo
{
    
    NSString *filepath   =   [[NSBundle mainBundle] pathForResource:@"iPhone" ofType:@"mp4"];  
    NSURL    *fileURL    =   [NSURL fileURLWithPath:filepath];   
    MPMoviePlayerController *moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:fileURL];  
    [self.view addSubview:moviePlayerController.view];  
    moviePlayerController.fullscreen = YES;  
    [moviePlayerController play];  
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //self.imageview.image = [UIImage imageNamed:@"splash_screen"]; 
    
    [self playmov];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    //[self stopTimer];
    [super viewDidDisappear:animated];
}

-(void)playSound
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *sound = [prefs stringForKey:@"sound"];
    if ([sound isEqualToString:@"YES"]) {
        [[SoundManager sharedSoundManager] playIntro];
    }
}

- (void)playmov {
    
    [self play];
}

-(void)play
{
    NSString * pathv = [[NSBundle mainBundle] pathForResource:@"Go4 Mobility games - iPhone 960x640" ofType:@"mp4"];
    NSLog(@"%@",pathv);
    NSURL *url = [NSURL fileURLWithPath:pathv];
    
    self.player = [[MPMoviePlayerController alloc] initWithContentURL: url];
    [self.player prepareToPlay];
    [self.player.view setFrame: self.view.bounds];
    [self.view addSubview:self.player.view];
    
    self.player.controlStyle =  MPMovieControlStyleNone;
    
    self.player.shouldAutoplay = NO;
    
    //self.player.fullscreen = YES;

    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieLoadStateDidChange:) 
                                                 name:MPMoviePlayerLoadStateDidChangeNotification 
                                               object:self.player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self  
                                             selector:@selector(moviePlayBackDidFinish:)  
                                                 name:MPMoviePlayerPlaybackDidFinishNotification  
                                               object:self.player];  
    
    
    self.observer = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:[UIApplication sharedApplication] queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [self.player play];
    }];
    
    [self.player play];

}

-(void)playSecundVideo
{
    
    NSString * pathv = [[NSBundle mainBundle] pathForResource:@"iPhone 960x640-2" ofType:@"mp4"];
    NSLog(@"%@",pathv);
    NSURL *url = [NSURL fileURLWithPath:pathv];
    
    self.player = [[MPMoviePlayerController alloc] initWithContentURL: url];
    [self.player prepareToPlay];
    [self.player.view setFrame: self.view.bounds];
    [self.view addSubview:self.player.view];
    
    self.player.controlStyle =  MPMovieControlStyleNone;
    
    self.player.shouldAutoplay = NO;
    /*
    self.player = [[MPMoviePlayerController alloc] initWithContentURL: url];
    [self.player prepareToPlay];
    [self.player.view setFrame: self.view.bounds];  
    self.player.controlStyle =  MPMovieControlStyleNone;
    [self.player setShouldAutoplay:YES];
    */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieLoadStateDidChange:) 
                                                 name:MPMoviePlayerLoadStateDidChangeNotification 
                                               object:self.player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self  
                                             selector:@selector(secundMoviePlayBackDidFinish:)  
                                                 name:MPMoviePlayerPlaybackDidFinishNotification  
                                               object:self.player];
    
    
    self.observer = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification
                                                      object:[UIApplication sharedApplication]
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      [self.player play];
                                                  }];
    [self.player play];

}



-(void)movieLoadStateDidChange: (NSNotification*)notification{
    if ( (self.player.loadState & MPMovieLoadStatePlayable) == MPMovieLoadStatePlayable) {
        [[NSNotificationCenter defaultCenter] 
         removeObserver:self 
         name:MPMoviePlayerLoadStateDidChangeNotification 
         object:self.player] ; 
        [self.view addSubview:self.player.view];
    }
}

- (void)moviePlayBackDidFinish:(NSNotification *)notification  
{  
    NSLog(@"movie finished");
    [[NSNotificationCenter defaultCenter] removeObserver:self.observer];
    [self playSecundVideo];
}  


- (void)secundMoviePlayBackDidFinish:(NSNotification *)notification  
{  
    NSLog(@"movie finished");
    self.end = 1;
    [[NSNotificationCenter defaultCenter] removeObserver:self.observer];
    [self performSegueWithIdentifier:@"show inicial view" sender:self];
} 

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
    if (self.end == 1) {
        NSLog(@"i did it !!! %d",self.end);
        //[self performSegueWithIdentifier:@"show inicial view" sender:self];
    }
    //NSLog(@"i did it !!! %d",self.end);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //[self startTimer];    
    //self.time = 0;
    [[MyDocumentHandler sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document){
        _document = document;
        [self useDocument];
    }];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

@end
