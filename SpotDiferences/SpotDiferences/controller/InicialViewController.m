//
//  InicialViewController.m
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "InicialViewController.h"
#import "MyDocumentHandler.h"
#import "Theme+Create.h"
#import "ThemeViewController.h"
#import "Seed.h"
#import "Maze+Manage.h"
#import "DifficultyViewController.h"
#import "SoundManager.h"
#import "GameCenterManager.h"
#import "AccountSettingsViewController.h"
#define fontSize 15
#define fontName @"junegull"

@interface InicialViewController ()
@property (nonatomic,weak) UIButton *NewGameButton;
@end

@implementation InicialViewController

@synthesize  document = _document;
@synthesize imageview = _imageview;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)playInterfaceSound
{
    [[SoundManager sharedSoundManager] playInterface];
}

-(void)playSound
{
    [[SoundManager sharedSoundManager] playIntro];
}

-(void)submeteUnsubmetedScores
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([appDelegate testReachability]) {
        NSArray* mazes = [Maze getUnSubmetedMazes:self.document.managedObjectContext];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *loggedinUser = [prefs stringForKey:@"loggedinUser"];
        if ([loggedinUser isEqualToString:@"YES"] && [mazes count] > 0) {
            for (int c = 0; c < [mazes count]; c++) {
                Maze * maze = [mazes objectAtIndex:c];
                AccountSettingsViewController *scoreSender = [[AccountSettingsViewController alloc]init];
                scoreSender.document = self.document;
                [scoreSender submitScore:[maze.firstScore intValue]  scoreboard:maze.uniqueID];
                [scoreSender submitScore:[maze.firstTime intValue] scoreboard:[NSString stringWithFormat:@"%@.TIME",maze.uniqueID]];
            }
        }
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self playSound];
    int offset = 40;
    int halfViewSize = [self view].frame.size.width / 2;
    UIImage *image = [UIImage imageNamed:@"btn_wine"];

    if (!self.NewGameButton) {
        self.NewGameButton = [UikitFramework createButtonWithBackgroudImage:@"btn_wine" title:@"PLAY" positionX:halfViewSize - image.size.width -offset positionY:150];
        [self.NewGameButton addTarget:self action:@selector(playGameButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        self.NewGameButton.titleLabel.font = [UIFont fontWithName:fontName size: fontSize];
        [self.view addSubview:self.NewGameButton];
        
        UIButton *HIGHSCORESGameButton = [UikitFramework createButtonWithBackgroudImage:@"btn_orange3" title:@"HIGH SCORES" positionX:halfViewSize + offset positionY:150];
        
        [HIGHSCORESGameButton addTarget:self action:@selector(highscoresButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        HIGHSCORESGameButton.titleLabel.font = [UIFont fontWithName:fontName size: fontSize];
        [self.view addSubview:HIGHSCORESGameButton];
        
        UIButton *BuyButton = [UikitFramework createButtonWithBackgroudImage:@"btn_palegreen" title:@"BUY" positionX:halfViewSize - image.size.width -offset positionY:240];
        [BuyButton addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        BuyButton.titleLabel.font = [UIFont fontWithName:fontName size: fontSize];
        [self.view addSubview:BuyButton];
        
        UIButton *SETTINGSGameButton = [UikitFramework createButtonWithBackgroudImage:@"btn_orange" title:@"SETTINGS" positionX:halfViewSize + offset positionY:240];
        [SETTINGSGameButton addTarget:self action:@selector(settingsButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        SETTINGSGameButton.titleLabel.font = [UIFont fontWithName:fontName size: fontSize];
        [self.view addSubview:SETTINGSGameButton];

        UIButton * visitUsButton = [UikitFramework createButtonWithBackgroudImage:@"icon_weblink" title:@"" positionX:self.view.frame.size.width - 70 positionY:30];
        [visitUsButton addTarget:self action:@selector(visitUsButtonButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        visitUsButton.titleLabel.font = [UIFont fontWithName:fontName size: fontSize];
        [self.view addSubview:visitUsButton];

        UILabel *label = [UikitFramework createLableWithText:@"VISIT US" positionX:visitUsButton.frame.origin.x - 45 positionY:visitUsButton.frame.origin.y + 15 width:100 height:100];
        
        [self.view addSubview:label];
        
        UIButton * gamecenterButton = [UikitFramework createButtonWithBackgroudImage:@"Game_Center_logo" title:@"" positionX:20 positionY:30];
        [gamecenterButton addTarget:self action:@selector(gamecenterButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        gamecenterButton.titleLabel.font = [UIFont fontWithName:fontName size: fontSize];
        [self.view addSubview:gamecenterButton];
    }
    
    [self submeteUnsubmetedScores];
}

-(void)gamecenterButtonTapped:(UIButton*)sender
{
    [self playInterfaceSound];
    [[GameCenterManager sharedGameCenterManager] gameCenterAuthentication];
    
    NSString *gamecenterenable = [GameCenterManager sharedGameCenterManager].enableGameCenter;
    
    if ([gamecenterenable isEqualToString:@"YES"]) {
        NSString * leaderboardCategory = @"iDifferences.Global";
        [[GameCenterManager sharedGameCenterManager] showLeaderboard:leaderboardCategory viewController:self];
    }
    

    /*
    int64_t score = 2001;
    GKScore * submitScore = [[GKScore alloc] initWithCategory:leaderboardCategory];
    [submitScore setValue:score];
    [submitScore setShouldSetDefaultLeaderboard:YES];
    
    //[[GameCenterManager sharedGameCenterManager] submitScore:submitScore];
     */

}

-(void)visitUsButtonButtonTapped:(UIButton*)sender
{
    [self playInterfaceSound];

     NSURL *url = [NSURL URLWithString:@"http://www.idifferences.com"];
     
     if (![[UIApplication sharedApplication] openURL:url])
     NSLog(@"%@%@",@"Failed to open url:",[url description]);

}

-(void)playGameButtonTapped:(UIButton*)sender
{
    [self playInterfaceSound];
   
    
    [self performSegueWithIdentifier:@"playStyle" sender:self];
}



-(void)setGameState:(NSString*)state
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:state forKey:@"gameState"];
    [prefs synchronize];

}

-(void)buyButtonTapped:(UIButton*)sender
{
    [self playInterfaceSound];
    [self performSegueWithIdentifier:@"buy" sender:self];
}

-(void)highscoresButtonTapped:(UIButton*)sender
{
    [self playInterfaceSound];
    [self performSegueWithIdentifier:@"highscores" sender:self];
}

-(void)settingsButtonTapped:(UIButton*)sender
{
    [self playInterfaceSound];
    [self performSegueWithIdentifier:@"settings" sender:self];
}

-(void)newGameButtonTapped:(UIButton *)sender
{
    [self playInterfaceSound];
    [self setGameState:@"normal"];
    [self performSegueWithIdentifier:@"go to dificulty" sender:self];
}

-(void)finishedGameButtonTapped:(UIButton*)sender
{
    [self playInterfaceSound];
    [self setGameState:@"finished"];
    [self performSegueWithIdentifier:@"go to dificulty" sender:self];

}

-(void)resumeGameButtonTapped:(UIButton*)sender
{
    [self playInterfaceSound];
    [self setGameState:@"paused"];
    [self performSegueWithIdentifier:@"resumeGame" sender:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageview.image = [UIImage imageNamed:@"background_clear"]; 
    
    UIImageView *imageview = [UikitFramework createImageViewWithImage:@"logo_idifferences" positionX:0 positionY:0];
    [self.view addSubview:imageview];

    
    [[MyDocumentHandler sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document){
        _document = document;
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"go to dificulty"]){
        //DifficultyViewController *DVC = (DifficultyViewController*)segue.destinationViewController;
        //[DVC setDocument:self.document];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

@end
