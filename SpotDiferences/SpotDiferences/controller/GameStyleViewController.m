//
//  GameStyleViewController.m
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 9/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameStyleViewController.h"
#import "UikitFramework.h"
#import "SoundManager.h"
#import "InicialViewController.h"

@interface GameStyleViewController ()
@property (nonatomic,weak) IBOutlet UIImageView *imageview;
@end

@implementation GameStyleViewController
@synthesize imageview = _imageview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.imageview.image = [UIImage imageNamed:@"background_clear"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self playSound];
    int offset = 25;
    int halfViewSize = [self view].frame.size.width / 2;
    UIImage *image = [UIImage imageNamed:@"btn_wine"];
    
    UIImage *bimage = [UIImage imageNamed:@"btn_back"];
    
    UIButton *bbutton = [UikitFramework createButtonWithBackgroudImage:@"btn_back" title:@"" positionX:10 positionY:10]; 
    [bbutton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bbutton];
    
    UIButton *homeButton = [UikitFramework createButtonWithBackgroudImage:@"btn_home" title:@"" positionX:self.view.frame.size.width - 10 - bimage.size.width positionY:10]; 
    [homeButton addTarget:self action:@selector(homeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:homeButton];

    UIButton *resumeGameButton = [UikitFramework createButtonWithBackgroudImage:@"btn_darkpink" title:@"RESUME" positionX:halfViewSize - image.size.width / 2 positionY:150];
    [resumeGameButton addTarget:self action:@selector(resumeGameButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resumeGameButton];
    
    UIButton *newGameButton = [UikitFramework createButtonWithBackgroudImage:@"btn_wine" title:@"NEW" positionX:halfViewSize - image.size.width * 1.5 - offset  positionY:150];
    [newGameButton addTarget:self action:@selector(newGameButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newGameButton];
    
    UIButton *finishedGameButton = [UikitFramework createButtonWithBackgroudImage:@"btn_pink" title:@"FINISHED" positionX:halfViewSize +image.size.width * 0.5+ offset  positionY:150];
    [finishedGameButton addTarget:self action:@selector(finishedGameButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:finishedGameButton];
    
    UILabel *label = [UikitFramework createLableWithText:@"SELECT GAME STATUS" positionX:0 positionY:0 width:self.view.frame.size.width height:100];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:[UikitFramework getFontName] size: 25];
    [self.view addSubview:label];
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

-(void)setGameState:(NSString*)state
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:state forKey:@"gameState"];
    [prefs synchronize];
    
}

-(void)playSound
{
    [[SoundManager sharedSoundManager] playIntro];
}

-(void)playInterfaceSound
{
    [[SoundManager sharedSoundManager] playInterface];
}

-(void)backButtonTapped:(UIButton*)sender
{
    [self playInterfaceSound];
    [[self navigationController]popViewControllerAnimated:YES];
}

- (IBAction) backToHome {
    NSArray *viewControllers = [[self navigationController] viewControllers];
    for (int c=0; c < [viewControllers count]; c++) {
        id obj = [viewControllers objectAtIndex:c];
        if([obj isKindOfClass:[InicialViewController class]])
            [self.navigationController popToViewController:obj animated:YES];    
    }
}

-(void)homeButtonTapped:(UIButton*)sender
{
    [self playInterfaceSound];
    [self backToHome];
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
