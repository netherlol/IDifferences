//
//  ImageDetailViewController.m
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 6/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageDetailViewController.h"
#import "Maze+Manage.h"
#import "Theme.h"
#import "GameViewController.h"
#import "SoundManager.h"
#import "InicialViewController.h"
#import "Difficulty.h"
#import "AccountSettingsViewController.h"
#import "HighScoresViewController.h"
#import "Pack+manage.h"

@interface ImageDetailViewController ()<updateHighScores>
@property (nonatomic,weak) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *besttime;
@property (weak, nonatomic) IBOutlet UILabel *expectedtime;
@property (weak, nonatomic) IBOutlet UILabel *personalscore;
@property (weak, nonatomic) IBOutlet UILabel *highestscore;
@property (weak, nonatomic) IBOutlet UILabel *mazeDetail;
@property (weak, nonatomic) UIButton *worldRecordTime;
@property (weak, nonatomic) UIButton *worldRecordPoints;
@property (strong,nonatomic) AccountSettingsViewController *accountcontroler;
@end

@implementation ImageDetailViewController

@synthesize document = _document;
@synthesize foto = _foto;
@synthesize imageview = _imageview;
@synthesize besttime = _besttime;
@synthesize expectedtime = _expectedtime;
@synthesize personalscore = _personalscore;
@synthesize highestscore = _highestscore;
@synthesize mazeDetail = _mazeDetail;
@synthesize maze = _maze;


-(void)updateWorldRecordTime:(NSString *)value
{
    [self.worldRecordTime setTitle:[NSString stringWithFormat:@"%@", value] forState:UIControlStateNormal];
}

-(void)updateWorldRecordPoints:(NSString *)value
{
    [self.worldRecordPoints setTitle:[NSString stringWithFormat:@"%@", value] forState:UIControlStateNormal];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)Foto:(NSString*)foto
{
    _foto = foto;
    NSLog(@"%@",foto);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageview.image = [UIImage imageNamed:@"background_clear"]; 
    _maze = [Maze getMazeByName:self.foto inManagedObjectContext:self.document.managedObjectContext];
    NSString *themeName = [_maze.theme.name uppercaseString];
    
    NSString *labelToShow = _maze.showLabel;
    if (!labelToShow) {
        labelToShow = _maze.name;
    }
    
    NSString *lvlName = [labelToShow uppercaseString];
    lvlName = [lvlName stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    self.mazeDetail.text = [NSString stringWithFormat:@"%@ -  %@",themeName ,lvlName];
    self.mazeDetail.font = [UIFont fontWithName:[UikitFramework getFontName] size: 25];
    
    self.accountcontroler = [[AccountSettingsViewController alloc]init];
    self.accountcontroler.delegate = self;
}

- (void)viewDidUnload
{
    [self setBesttime:nil];
    [self setExpectedtime:nil];
    [self setPersonalscore:nil];
    [self setHighestscore:nil];
    [self setMazeDetail:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)playSound
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *sound = [prefs stringForKey:@"sound"];

    if ([sound isEqualToString:@"YES"]) {
        [[SoundManager sharedSoundManager] playIntro];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [self playSound];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *difficulty = [prefs stringForKey:@"difficulty"];
    int halfViewSize = [self view].frame.size.width / 2;
    int x = 150;
    int y = 20;
    
    UIImage *bimage = [UIImage imageNamed:@"btn_back"];
    
    UIButton *bbutton = [UikitFramework createButtonWithBackgroudImage:@"btn_back" title:@"" positionX:10 positionY:10];
    [bbutton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bbutton];
    
    UIButton *homeButton = [UikitFramework createButtonWithBackgroudImage:@"btn_home" title:@"" positionX:self.view.frame.size.width - 10 - bimage.size.width positionY:10];
    [homeButton addTarget:self action:@selector(homeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:homeButton];
    
    UIImage *image;
    if ([self.documentDirectory isEqualToString:@"YES"]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [paths objectAtIndex:0];
        NSString *unzipPath = [path stringByAppendingPathComponent:@"unzip"];
        //NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:unzipPath error:NULL];
        NSString *package = [unzipPath stringByAppendingPathComponent:_maze.pack.name];
        NSString *images = [package stringByAppendingPathComponent:@"thumbnail"];
        NSString *mazeName = [images stringByAppendingPathComponent:[NSString stringWithFormat:@"thumbnail_%@@2x.png",self.foto]];
        NSLog(@"%@",mazeName);
        
        NSData *imageData = [NSData dataWithContentsOfFile:mazeName options:0 error:nil];
        image = [UIImage imageWithData:imageData];
        
        
    }else
    {
        image = [UIImage imageNamed:[NSString stringWithFormat:@"thumbnail_%@",self.foto]];
    }
    //NSString *fotoPath = [NSString stringWithFormat:@"thumbnail_%@",self.foto];
    UIImageView *imageview = [[UIImageView alloc]initWithImage:image];
    imageview.frame = CGRectMake(10, 70, 179.5, 179.5);
    NSLog(@"%f - %f",image.size.width, image.size.height);
    //[UikitFramework createImageViewWithImage:fotoPath positionX:10 positionY:70];
    
    self.imageview = imageview;
    [self.view addSubview:imageview];
    
    UIImage *stripe = [UIImage imageNamed:[UikitFramework getStripeByDifficulty:difficulty]];
    UIImageView *stripeImageview =[UikitFramework createImageViewWithImage:[UikitFramework getStripeByDifficulty:self.maze.dificulty.name] positionX:10 + imageview.frame.size.width - stripe.size.width - 5 positionY:75];
    [self.view addSubview:stripeImageview];
    
    UIImage *playimage = [UIImage imageNamed:@"btn_wine"];
    UIButton *playbutton = [UikitFramework createButtonWithBackgroudImage:@"btn_wine" title:@"START!" positionX:halfViewSize - playimage.size.width/2 positionY:250];
    [playbutton addTarget:self action:@selector(startButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playbutton];
    
    UIButton *best_time_button = [UikitFramework createButtonWithBackgroudImage:@"btn_long_red" title:@"00:00" positionX:self.imageview.frame.size.width + 20 + x positionY:50 + y];
    [self.view addSubview:best_time_button];
    best_time_button.titleLabel.textAlignment = UITextAlignmentCenter;
    best_time_button.enabled = NO;
    UILabel *best_time_lable = [UikitFramework createLableWithText:@"WORLD RECORD\n[TIME]" positionX:self.imageview.frame.size.width + 40 positionY:50 + y width:best_time_button.frame.size.width height:best_time_button.frame.size.height];
    best_time_lable.textAlignment = UITextAlignmentRight;
    best_time_lable.numberOfLines = 0;
    best_time_lable.font = [UIFont fontWithName:[UikitFramework getFontName] size: 10];
    best_time_lable.textColor = [UIColor whiteColor];
    [self.view addSubview:best_time_lable];
    self.worldRecordTime = best_time_button;
    
    UIButton *highest_score_button = [UikitFramework createButtonWithBackgroudImage:@"btn_long_orange2" title:[self.maze.personalscore stringValue]positionX:self.imageview.frame.size.width + 20 + x positionY:100 + y];
    [self.view addSubview:highest_score_button];
    highest_score_button.titleLabel.textAlignment = UITextAlignmentCenter;
    highest_score_button.enabled = NO;
    
    UILabel *highest_score_lable = [UikitFramework createLableWithText:@"WORLD RECORD\n[POINTS]" positionX:self.imageview.frame.size.width + 40 positionY:100 + y width:highest_score_button.frame.size.width height:highest_score_button.frame.size.height];
    highest_score_lable.textAlignment = UITextAlignmentRight;
    highest_score_lable.numberOfLines = 0;
    highest_score_lable.font = [UIFont fontWithName:[UikitFramework getFontName] size: 10];
    highest_score_lable.textColor = [UIColor whiteColor];
    [self.view addSubview:highest_score_lable];
    self.worldRecordPoints = highest_score_button;
    
    
    NSString *gameState = [prefs objectForKey:@"gameState"];
    if ([gameState isEqualToString:@"paused"]) {
        UIButton *CurrentPoint = [UikitFramework createButtonWithBackgroudImage:@"btn_long_red" title:[NSString stringWithFormat:@"%d",self.maze.personalscore.intValue] positionX:self.imageview.frame.size.width + 20 + x positionY:150 + y];
        [self.view addSubview:CurrentPoint];
        CurrentPoint.titleLabel.textAlignment = UITextAlignmentCenter;
        CurrentPoint.enabled = NO;
        UILabel *CurrentPoint_lable = [UikitFramework createLableWithText:@"Current\n[Points]" positionX:self.imageview.frame.size.width + 40 positionY:150 + y width:CurrentPoint.frame.size.width height:CurrentPoint.frame.size.height];
        CurrentPoint_lable.textAlignment = UITextAlignmentRight;
        CurrentPoint_lable.numberOfLines = 0;
        CurrentPoint_lable.font = [UIFont fontWithName:[UikitFramework getFontName] size: 10];
        CurrentPoint_lable.textColor = [UIColor whiteColor];
        [self.view addSubview:CurrentPoint_lable];

        
        int min = self.maze.personalTime.intValue/60;
        int sec = self.maze.personalTime.intValue%60;
        NSString *minString;
        NSString *secString;
        if (min <10) {
            minString = [NSString stringWithFormat:@"0%d",min];
        }else
            minString = [NSString stringWithFormat:@"%d",min];
        
        if (sec < 10) {
            secString = [NSString stringWithFormat:@"0%d",sec];
        }else
            secString = [NSString stringWithFormat:@"%d",sec];
        
        UIButton *CurrentTime = [UikitFramework createButtonWithBackgroudImage:@"btn_long_orange2" title:[NSString stringWithFormat:@"%@:%@",minString,secString] positionX:self.imageview.frame.size.width + 20 + x positionY:200 + y];
        [self.view addSubview:CurrentTime];
        CurrentTime.titleLabel.textAlignment = UITextAlignmentCenter;
        CurrentTime.enabled = NO;
        UILabel *CurrentTime_lable = [UikitFramework createLableWithText:@"Current\n[TIME]" positionX:self.imageview.frame.size.width + 40 positionY:200 + y width:CurrentTime.frame.size.width height:CurrentTime.frame.size.height];
        CurrentTime_lable.textAlignment = UITextAlignmentRight;
        CurrentTime_lable.numberOfLines = 0;
        CurrentTime_lable.font = [UIFont fontWithName:[UikitFramework getFontName] size: 10];
        CurrentTime_lable.textColor = [UIColor whiteColor];
        [self.view addSubview:CurrentTime_lable];

    }else if ([gameState isEqualToString:@"finished"]){
        
        UIButton *CurrentPoint = [UikitFramework createButtonWithBackgroudImage:@"btn_long_red" title:[NSString stringWithFormat:@"%d",self.maze.personalscore.intValue] positionX:self.imageview.frame.size.width + 20 + x positionY:150 + y];
        [self.view addSubview:CurrentPoint];
        CurrentPoint.titleLabel.textAlignment = UITextAlignmentCenter;
        CurrentPoint.enabled = NO;
        UILabel *CurrentPoint_lable = [UikitFramework createLableWithText:@"MY\n[Points]" positionX:self.imageview.frame.size.width + 40 positionY:150 + y width:CurrentPoint.frame.size.width height:CurrentPoint.frame.size.height];
        CurrentPoint_lable.textAlignment = UITextAlignmentRight;
        CurrentPoint_lable.numberOfLines = 0;
        CurrentPoint_lable.font = [UIFont fontWithName:[UikitFramework getFontName] size: 10];
        CurrentPoint_lable.textColor = [UIColor whiteColor];
        [self.view addSubview:CurrentPoint_lable];
        
        int min = self.maze.personalTime.intValue/60;
        int sec = self.maze.personalTime.intValue%60;
        NSString *minString;
        NSString *secString;
        if (min <10) {
            minString = [NSString stringWithFormat:@"0%d",min];
        }else
            minString = [NSString stringWithFormat:@"%d",min];
        
        if (sec < 10) {
            secString = [NSString stringWithFormat:@"0%d",sec];
        }else
            secString = [NSString stringWithFormat:@"%d",sec];

        
        UIButton *CurrentTime = [UikitFramework createButtonWithBackgroudImage:@"btn_long_orange2" title:[NSString stringWithFormat:@"%@:%@",minString,secString] positionX:self.imageview.frame.size.width + 20 + x positionY:200 + y];
        [self.view addSubview:CurrentTime];
        CurrentTime.titleLabel.textAlignment = UITextAlignmentCenter;
        CurrentTime.enabled = NO;
        UILabel *CurrentTime_lable = [UikitFramework createLableWithText:@"MY\n[TIME]" positionX:self.imageview.frame.size.width + 40 positionY:200 + y width:CurrentTime.frame.size.width height:CurrentTime.frame.size.height];
        CurrentTime_lable.textAlignment = UITextAlignmentRight;
        CurrentTime_lable.numberOfLines = 0;
        CurrentTime_lable.font = [UIFont fontWithName:[UikitFramework getFontName] size: 10];
        CurrentTime_lable.textColor = [UIColor whiteColor];
        [self.view addSubview:CurrentTime_lable];

    }
    
    [self.accountcontroler getWorldRecordTime:self.maze.uniqueID];
    [self.accountcontroler getWorldRecordPoint:self.maze.uniqueID];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
        
}

-(void)playInterfaceSound
{
    [[SoundManager sharedSoundManager] playInterface];
}


-(void)startButtonTapped:(UIButton*)sender
{
    [self playInterfaceSound];
    [[SoundManager sharedSoundManager] stopIntro];
    [self performSegueWithIdentifier:@"start game" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    GameViewController *gvc = (GameViewController*)segue.destinationViewController;
    [gvc setupWith:_maze andContext: [_document managedObjectContext]];
    
}

-(void)backButtonTapped:(UIButton*)sender
{
    self.imageview.hidden = YES;
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    //return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

@end
