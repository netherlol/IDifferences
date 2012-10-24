//
//  HighScoresViewController.m
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 8/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HighScoresViewController.h"
#import "UikitFramework.h"
#import "SoundManager.h"
#import "InicialViewController.h"
#import "MyDocumentHandler.h"
#import "Maze+Manage.h"
#import "AccountSettingsViewController.h"

@interface HighScoresViewController ()<updateHighScores,UIAlertViewDelegate>
@property (nonatomic,weak) IBOutlet UIImageView *imageview;
@property (nonatomic, weak) IBOutlet UIManagedDocument *document;
@property (nonatomic,strong) AccountSettingsViewController *Accountcontroller;
@property (nonatomic,strong) UILabel *ranking;
@property (nonatomic,strong) UILabel *topPlayerPoints;
@property (nonatomic,strong) UILabel *worldAvarageTime;
@property (nonatomic,strong) UILabel *userScore;
@property (nonatomic,strong) UILabel *userAverageTime;
@end

@implementation HighScoresViewController
@synthesize imageview = _imageview;
@synthesize document = _document;

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"AlertView Button Clicked");
    [self performSegueWithIdentifier:@"no login view" sender:self];
}

-(void)startedConnection
{
    HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.labelText = @"Connected...";
	HUD.delegate = self;
    [HUD hide:YES afterDelay:3];
}
-(void)connectionFailed{
    [HUD hide:YES];
    [self makeAAlertView:@"FAILED" message:@"CANNOT CONNECT TO SERVER PLEASE TRY AGAIN LATER"];
}
-(void)connectionFinished
{
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
	HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = @"FINISHED";
	[HUD hide:YES afterDelay:1];

}

-(void)updateStatistics:(NSDictionary*)statisticData
{
    NSLog(@"statistics callback %@",statisticData);
    if (! ([statisticData objectForKey:@"ranking"] == (NSString*)[NSNull null])) {
        [self.ranking setText:[NSString stringWithFormat:@"%d",[[statisticData objectForKey:@"ranking"] intValue]]];
    }else
        [self.ranking setText:@"N/A"];
    
    
    [self.topPlayerPoints setText: [NSString stringWithFormat:@"%d",[[statisticData objectForKey:@"highscore"] intValue]]];
    [self.worldAvarageTime setText:[statisticData objectForKey:@"averageTime"]];
    
    if (! ([statisticData objectForKey:@"userScore"] == 0)) {
        [self.userScore setText:[NSString stringWithFormat:@"%d",[[statisticData objectForKey:@"userScore"] intValue]]];
    }
    
    if (! ([statisticData objectForKey:@"userAverageTime"] == (NSString*)[NSNull null])) {
        [self.userAverageTime setText:[statisticData objectForKey:@"userAverageTime"]];
    }
}


-(void)playInterfaceSound
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *sound = [prefs stringForKey:@"sound"];
    
    if ([sound isEqualToString:@"YES"]) {
        [[SoundManager sharedSoundManager] playInterface];
    }
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
    [[MyDocumentHandler sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document){
        _document = document;
    }];
    self.imageview.image = [UIImage imageNamed:@"background_clear"];
    self.Accountcontroller = [[AccountSettingsViewController alloc] init];
    self.Accountcontroller.delegate = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#define LABEL_SIZE 10

-(void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *user = [prefs objectForKey:@"loggedinUser"];
    
    if (user) {
        if ([user isEqualToString:@"NO"]) {
            [self makeAAlertView:@"Warning" message:@"Please Login First"];
        }
    }else{
        [self makeAAlertView:@"Warning" message:@"Please Login First"];
    }
    
    
    
    [self.Accountcontroller getStatistic];
    
    UIImage *bimage = [UIImage imageNamed:@"btn_back"];
    UIImage *bbimage = [UIImage imageNamed:@"btn_red"];
    
    NSArray *finishedImages = [Maze getMazeByState:@"finished" inManagedObjectContext:self.document.managedObjectContext];
    int contador = 0;
    int contadorTime = 0;
    for (int c = 0; c<[finishedImages count]; c++) {
        Maze *maze = [finishedImages objectAtIndex:c];
        contador = contador + [maze.firstScore intValue]; 
        contadorTime = contadorTime + [maze.firstTime intValue];
    }
    
    int avarageTime = 0;
    if ([finishedImages count] != 0){
        avarageTime = contadorTime / [finishedImages count];
        NSLog(@"contador = %d array tem %d",contadorTime, [finishedImages count]);
    }
    
    UIButton *bbutton = [UikitFramework createButtonWithBackgroudImage:@"btn_back" title:@"" positionX:10 positionY:10]; 
    [bbutton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bbutton];
    
    UIButton *homeButton = [UikitFramework createButtonWithBackgroudImage:@"btn_home" title:@"" positionX:self.view.frame.size.width - 10 - bimage.size.width positionY:10]; 
    [homeButton addTarget:self action:@selector(homeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:homeButton];

    UILabel *label = [UikitFramework createLableWithText:@"HIGH SCORES" positionX:0 positionY:0 width:self.view.frame.size.width height:100];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:[UikitFramework getFontName] size: 25];
    
    [self.view addSubview:label];
    
    int offset = 70;
    int offsetx = 5;
    
    UIImageView *imageview = [UikitFramework createImageViewWithImage:@"btn_red" positionX:self.view.frame.size.width/2 - bbimage.size.width - offsetx positionY:90];
    [self.view addSubview:imageview];
    label = [UikitFramework createLableWithText:@"000" positionX:imageview.frame.origin.x positionY:imageview.frame.origin.y width:imageview.frame.size.width height:imageview.frame.size.height];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:[UikitFramework getFontName] size: 15];
    [self.view addSubview:label];
    self.ranking = label;
    label = [UikitFramework createLableWithText:@"MY\nRANKING" positionX:imageview.frame.origin.x - bbimage.size.width positionY:imageview.frame.origin.y    width:bbimage.size.width height:bbimage.size.height];
    label.numberOfLines = 0;
    label.textAlignment = UITextAlignmentRight;
    label.font = [UIFont fontWithName:[UikitFramework getFontName] size: LABEL_SIZE];
    [self.view addSubview:label];
    
    imageview = [UikitFramework createImageViewWithImage:@"btn_orange3" positionX:self.view.frame.size.width/2 - bbimage.size.width - offsetx positionY:90 + offset];
    [self.view addSubview:imageview];
    label = [UikitFramework createLableWithText:[NSString stringWithFormat:@"%d",contador] positionX:imageview.frame.origin.x positionY:imageview.frame.origin.y width:imageview.frame.size.width height:imageview.frame.size.height];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:[UikitFramework getFontName] size: 15];
    [self.view addSubview:label];
    self.userScore = label;
    label = [UikitFramework createLableWithText:@"MY\nPOINTS" positionX:imageview.frame.origin.x - bbimage.size.width positionY:imageview.frame.origin.y    width:bbimage.size.width height:bbimage.size.height];
    label.numberOfLines = 0;
    label.textAlignment = UITextAlignmentRight;
    label.font = [UIFont fontWithName:[UikitFramework getFontName] size: LABEL_SIZE];
    [self.view addSubview:label];

    
    
    imageview = [UikitFramework createImageViewWithImage:@"btn_orange" positionX:self.view.frame.size.width/2 - bbimage.size.width - offsetx positionY:90 + offset * 2];
    [self.view addSubview:imageview];
    label = [UikitFramework createLableWithText:[NSString stringWithFormat:@"%d",[finishedImages count]] positionX:imageview.frame.origin.x positionY:imageview.frame.origin.y width:imageview.frame.size.width height:imageview.frame.size.height];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:[UikitFramework getFontName] size: 15];
    [self.view addSubview:label];
    
    label = [UikitFramework createLableWithText:@"IMAGES\nCOMPLETED" positionX:imageview.frame.origin.x - bbimage.size.width positionY:imageview.frame.origin.y    width:bbimage.size.width height:bbimage.size.height];
    label.numberOfLines = 0;
    label.textAlignment = UITextAlignmentRight;
    label.font = [UIFont fontWithName:[UikitFramework getFontName] size: LABEL_SIZE];
    [self.view addSubview:label];
    
    imageview = [UikitFramework createImageViewWithImage:@"btn_darkgreen" positionX:self.view.frame.size.width/2 + offsetx positionY:90];
    [self.view addSubview:imageview];
    label = [UikitFramework createLableWithText:[NSString stringWithFormat:@"%d:%d",avarageTime/60,avarageTime%60] positionX:imageview.frame.origin.x positionY:imageview.frame.origin.y width:imageview.frame.size.width height:imageview.frame.size.height];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:[UikitFramework getFontName] size: 15];
    [self.view addSubview:label];
    self.userAverageTime = label;
    label = [UikitFramework createLableWithText:@"PERSONAL\nAVERAGE TIME" positionX:imageview.frame.origin.x + bbimage.size.width positionY:imageview.frame.origin.y    width:bbimage.size.width height:bbimage.size.height];
    label.numberOfLines = 0;
    label.textAlignment = UITextAlignmentLeft;
    label.font = [UIFont fontWithName:[UikitFramework getFontName] size: LABEL_SIZE];
    [self.view addSubview:label];
    
    
    imageview = [UikitFramework createImageViewWithImage:@"btn_green" positionX:self.view.frame.size.width/2 + offsetx positionY:90 + offset];
    [self.view addSubview:imageview];
    label = [UikitFramework createLableWithText:@"000" positionX:imageview.frame.origin.x positionY:imageview.frame.origin.y width:imageview.frame.size.width height:imageview.frame.size.height];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:[UikitFramework getFontName] size: 15];
    [self.view addSubview:label];
    self.topPlayerPoints = label;
    label = [UikitFramework createLableWithText:@"TOP PLAYER\nSCORE" positionX:imageview.frame.origin.x + bbimage.size.width positionY:imageview.frame.origin.y    width:bbimage.size.width height:bbimage.size.height];
    label.numberOfLines = 0;
    label.textAlignment = UITextAlignmentLeft;
    label.font = [UIFont fontWithName:[UikitFramework getFontName] size: LABEL_SIZE];
    [self.view addSubview:label];
    
    imageview = [UikitFramework createImageViewWithImage:@"btn_lightgreen" positionX:self.view.frame.size.width/2 + offsetx positionY:90 + offset * 2];
    [self.view addSubview:imageview];
    label = [UikitFramework createLableWithText:@"000" positionX:imageview.frame.origin.x positionY:imageview.frame.origin.y width:imageview.frame.size.width height:imageview.frame.size.height];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:[UikitFramework getFontName] size: 15];
    [self.view addSubview:label];
    self.worldAvarageTime = label;
    label = [UikitFramework createLableWithText:@"WORLD\nAVERAGE TIME" positionX:imageview.frame.origin.x + bbimage.size.width positionY:imageview.frame.origin.y    width:bbimage.size.width height:bbimage.size.height];
    label.numberOfLines = 0;
    label.textAlignment = UITextAlignmentLeft;
    label.font = [UIFont fontWithName:[UikitFramework getFontName] size: LABEL_SIZE];
    [self.view addSubview:label];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	HUD = nil;
}

-(void)makeAAlertView:(NSString*)title
              message:(NSString*)mesage
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:title
                              message:mesage
                              delegate:self
                              cancelButtonTitle:@"LOGIN"
                              otherButtonTitles:nil];
    [alertView show];
}


@end
