//
//  DifficultyViewController.m
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 6/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DifficultyViewController.h"
#import "ThemeViewController.h"
#import "Theme+Create.h"
#import "Maze+Manage.h"
#import "SoundManager.h"
#import "MyDocumentHandler.h"


@interface DifficultyViewController ()

@end

@implementation DifficultyViewController
@synthesize  document = _document;
@synthesize imageview = _imageview;

-(NSArray *)getThemes
{
    return [Theme getAllThemes:self.document.managedObjectContext];
}

-(NSArray *)getMazes
{
    return [Maze getAllMazes:self.document.managedObjectContext];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ThemeViewController *tvc = (ThemeViewController*)segue.destinationViewController;
    tvc.themes = [self getThemes];
}

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
    self.imageview.image = [UIImage imageNamed:@"background_clear"]; 
    [[MyDocumentHandler sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document){
        _document = document;
        //[self useDocument];
    }];

}

-(UILabel*)makeALabel:(NSString*)difficulty
            positionX:(float)positionX
            positionY:(float)positionY
                width:(float)width
               height:(float)height
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString*gameState = [prefs objectForKey:@"gameState"];
    NSArray *mazeByDifficulty = [Maze getMazeByDifficulty:difficulty state:gameState inManagedObjectContext:self.document.managedObjectContext];
    NSString *mazeCount = [NSString stringWithFormat:@"%d",[mazeByDifficulty count]];
    UILabel *label = [UikitFramework createLableWithText:mazeCount positionX:positionX positionY:positionY width:width height:height];
    label.font = [UIFont fontWithName:[UikitFramework getFontName] size: 15];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:label];
    return label;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    int halfViewSize = [self view].frame.size.width / 2;
    int offset = 40;
    
    
    UIImage *bimage = [UIImage imageNamed:@"btn_back"];

    UIButton *bbutton = [UikitFramework createButtonWithBackgroudImage:@"btn_back" title:@"" positionX:10 positionY:10]; 
    [bbutton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bbutton];
    
    UIButton *homeButton = [UikitFramework createButtonWithBackgroudImage:@"btn_home" title:@"" positionX:self.view.frame.size.width - 10 - bimage.size.width positionY:10]; 
    [homeButton addTarget:self action:@selector(homeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:homeButton];
    
    UILabel *label = [UikitFramework createLableWithText:@"SELECT DIFFICULTY" positionX:0 positionY:0 width:self.view.frame.size.width height:100];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:[UikitFramework getFontName] size: 25];
    [self.view addSubview:label];
  
    UIImage *image = [UIImage imageNamed:@"btn_orange"];

    UIButton *BeginnerButton = [UikitFramework createButtonWithBackgroudImage:@"btn_orange" title:@"BEGINNER" positionX:halfViewSize - image.size.width -offset positionY:150]; 
    [BeginnerButton addTarget:self action:@selector(beginnerButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:BeginnerButton];
    
    UIImageView *imageview = [self createMazeNumberView:BeginnerButton.frame.origin.x positiony:BeginnerButton.frame.origin.y];
    [self.view addSubview:imageview];
    
    
    [self makeALabel:@"beginner" positionX:imageview.frame.origin.x positionY:imageview.frame.origin.y width:imageview.frame.size.width height:imageview.frame.size.height];

    
    UIButton *IntermediateButton = [UikitFramework createButtonWithBackgroudImage:@"btn_orange2" title:@"INTERMEDIATE" positionX:halfViewSize + offset positionY:150]; 
    [IntermediateButton addTarget:self action:@selector(intermediateButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:IntermediateButton];
    
    imageview = [self createMazeNumberView:IntermediateButton.frame.origin.x positiony:IntermediateButton.frame.origin.y];

    
    [self makeALabel:@"intermediate" positionX:imageview.frame.origin.x positionY:imageview.frame.origin.y width:imageview.frame.size.width height:imageview.frame.size.height];
    
    UIButton *ExpertButton = [UikitFramework createButtonWithBackgroudImage:@"btn_orange3" title:@"EXPERT" positionX:halfViewSize - image.size.width -offset positionY:240]; 
    [ExpertButton addTarget:self action:@selector(expertButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ExpertButton];
    
    imageview = [self createMazeNumberView:ExpertButton.frame.origin.x positiony:ExpertButton.frame.origin.y];
    
    [self makeALabel:@"expert" positionX:imageview.frame.origin.x positionY:imageview.frame.origin.y width:imageview.frame.size.width height:imageview.frame.size.height];
    
    UIButton *DetectiveButton = [UikitFramework createButtonWithBackgroudImage:@"btn_red" title:@"DETECTIVE" positionX:halfViewSize + offset positionY:240]; 
    [DetectiveButton addTarget:self action:@selector(detectiveButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:DetectiveButton];

    imageview = [self createMazeNumberView:DetectiveButton.frame.origin.x positiony:DetectiveButton.frame.origin.y];
    
    [self makeALabel:@"detective" positionX:imageview.frame.origin.x positionY:imageview.frame.origin.y width:imageview.frame.size.width height:imageview.frame.size.height];
    
    image = [UIImage imageNamed:@"lupa"];
    imageview = [UikitFramework createImageViewWithImage:@"lupa" positionX:DetectiveButton.frame.origin.x +DetectiveButton.frame.size.width - image.size.width positionY:DetectiveButton.frame.origin.y + 20];
    [self.view addSubview:imageview];
}

-(UIImageView *)createMazeNumberView:(float)positionx
                  positiony:(float)positiony
{
    UIImageView * imageview = [UikitFramework createImageViewWithImage:@"number_mazes" positionX:positionx - 30 positionY:positiony - 30];
    [self.view addSubview:imageview];
    return imageview;
}

-(void)playInterfaceSound
{
    [[SoundManager sharedSoundManager] playInterface];
}

-(void)beginnerButtonTapped:(UIButton*)sender
{
    [self playInterfaceSound];
    [self dificultyChosed:@"beginner"];
}

-(void)intermediateButtonTapped:(UIButton*)sender
{
    [self playInterfaceSound];
    [self dificultyChosed:@"intermediate"];
}

-(void)expertButtonTapped:(UIButton*)sender
{
    [self playInterfaceSound];
    [self dificultyChosed:@"expert"];
}

-(void)detectiveButtonTapped:(UIButton*)sender
{
    [self playInterfaceSound];
    [self dificultyChosed:@"detective"];
}

-(void)dificultyChosed:(NSString*)difficulty
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:difficulty forKey:@"difficulty"];
    [prefs synchronize];
    [self performSegueWithIdentifier:@"choose theme" sender:self];
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
