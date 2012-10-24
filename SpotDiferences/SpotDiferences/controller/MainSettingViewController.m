//
//  MainSettingViewController.m
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 9/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainSettingViewController.h"
#import "UikitFramework.h"
#import "SoundManager.h"
#import "InicialViewController.h"

@interface MainSettingViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic)  IBOutlet UIView *userPreferenceView;
@property (weak, nonatomic)  IBOutlet UIView *gameFlowView;
@property (weak, nonatomic)  UIImageView *userPreferenceImageView;
@property (weak, nonatomic)  UIImageView *gameFlowImageView;
@property (nonatomic, weak) IBOutlet UIPageControl *pagecontrol;
@property (nonatomic, weak) UISwitch *mainMenu;
@property (nonatomic, weak) UISwitch *keepDifficulty;
@property (nonatomic, weak) UISwitch *increaseDifficulty;
@property (nonatomic, weak) UISwitch *surprise;
@property (nonatomic, weak) UISwitch *autoExtendsTime;
@property (nonatomic, weak) UISwitch *sound;
@property (nonatomic, weak) UISwitch *facebookAutoPost;
@property (nonatomic, strong) NSMutableArray *radio;
@end

@implementation MainSettingViewController
@synthesize scrollView;
@synthesize userPreferenceView;
@synthesize gameFlowView;
@synthesize userPreferenceImageView;
@synthesize gameFlowImageView;
@synthesize pagecontrol=_pagecontrol;

@synthesize mainMenu = _mainMenu;
@synthesize keepDifficulty = _keepDifficulty;
@synthesize increaseDifficulty = _increaseDifficulty;
@synthesize surprise = _surprise;
@synthesize autoExtendsTime = _autoExtendsTime;
@synthesize sound = _sound;
@synthesize facebookAutoPost = _facebookAutoPost;
@synthesize radio = _radio;

-(NSMutableArray*)radio
{
    if (!_radio) {
        _radio = [[NSMutableArray alloc]init];
    }
    return _radio;
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
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 2, self.scrollView.frame.size.height);
    self.scrollView.delegate = self;
    [self setupGameFlowView];
    [self setupUserPreferencesView];
    [self setupPageContol];
    
}

-(void)setupPageContol
{
    if(!self.pagecontrol){
        UIPageControl *pagecontrol = [[UIPageControl alloc] initWithFrame:CGRectMake(221, 280, 38, 36)];
        
        pagecontrol.numberOfPages = 2;
        
        pagecontrol.currentPage = 0;
        pagecontrol.userInteractionEnabled = NO;
        self.pagecontrol = pagecontrol;
        [self.view addSubview:pagecontrol]; 
    }

}
#define LABEL_SIZE 15
#define offset 50
#define LABEL_WIDTH 300
-(void)setupUserPreferencesView
{
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.userPreferenceView.frame.size.width, self.userPreferenceView.frame.size.height)];
    imageview.image = [UIImage imageNamed:@"background_clear"];
    [self.userPreferenceView addSubview:imageview];
    
    UIImage *bimage = [UIImage imageNamed:@"btn_back"];
    
    UIButton *bbutton = [UikitFramework createButtonWithBackgroudImage:@"btn_back" title:@"" positionX:10 positionY:10]; 
    [bbutton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.userPreferenceView addSubview:bbutton];
    
    UIButton *homeButton = [UikitFramework createButtonWithBackgroudImage:@"btn_home" title:@"" positionX:self.view.frame.size.width - 10 - bimage.size.width positionY:10]; 
    [homeButton addTarget:self action:@selector(homeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.userPreferenceView addSubview:homeButton];

    UILabel *label = [UikitFramework createLableWithText:@"GAME SETTINGS" positionX:0 positionY:0 width:self.view.frame.size.width height:90];
    label.textAlignment = UITextAlignmentCenter;
    label.numberOfLines = 0;
    label.font = [UIFont fontWithName:[UikitFramework getFontName] size: 25];
    [self.userPreferenceView addSubview:label];
    
    UIButton * userpreferenceButton = [UikitFramework createButtonWithBackgroudImage:@"USER-PREFERENCES-1" title:@"USER PREFERENCES" positionX:120 positionY:60];
    [userpreferenceButton addTarget:self action:@selector(nothingButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    userpreferenceButton.titleLabel.font = [UIFont fontWithName:[UikitFramework getFontName] size: 25];
    [self.userPreferenceView addSubview:userpreferenceButton];
    
    label = [UikitFramework createLableWithText:@"AUTOMATICALLY EXTEND TIME" positionX:20 positionY:100 width:LABEL_WIDTH height:50];
    label.font = [UIFont fontWithName:[UikitFramework getFontName] size:LABEL_SIZE];
    label.textAlignment = UITextAlignmentLeft;
    [self.userPreferenceView addSubview:label];
    
    UISwitch *extendTime = [[UISwitch alloc] initWithFrame:CGRectMake(label.frame.origin.x + label.frame.size.width +offset, label.frame.origin.y + 10, label.frame.size.width, label.frame.size.height)];
    self.autoExtendsTime = extendTime;
    [self.userPreferenceView addSubview:extendTime];
    
    label = [UikitFramework createLableWithText:@"GAME SOUND" positionX:20 positionY:150 width:LABEL_WIDTH height:50];
    label.font = [UIFont fontWithName:[UikitFramework getFontName] size:LABEL_SIZE];
    label.textAlignment = UITextAlignmentLeft;
    [self.userPreferenceView addSubview:label];
    
    UISwitch *gameSound = [[UISwitch alloc] initWithFrame:CGRectMake(label.frame.origin.x + label.frame.size.width +offset, label.frame.origin.y + 10, label.frame.size.width, label.frame.size.height)];
    self.sound = gameSound;
    [self.userPreferenceView addSubview:gameSound];
    
    label = [UikitFramework createLableWithText:@"SOCIAL NETWORK AUTO-POST" positionX:20 positionY:200 width:LABEL_WIDTH height:50];
    label.font = [UIFont fontWithName:[UikitFramework getFontName] size:LABEL_SIZE];
    label.textAlignment = UITextAlignmentLeft;
    [self.userPreferenceView addSubview:label];
    
    UISwitch *social = [[UISwitch alloc] initWithFrame:CGRectMake(label.frame.origin.x + label.frame.size.width +offset, label.frame.origin.y + 10, label.frame.size.width, label.frame.size.height)];
    self.facebookAutoPost = social;
    [self.userPreferenceView addSubview:social];

    [self.autoExtendsTime addTarget:self action:@selector(extendTimeChanged:) forControlEvents:UIControlEventValueChanged];
    [self.sound addTarget:self action:@selector(soundChanged:) forControlEvents:UIControlEventValueChanged];
    [self.facebookAutoPost addTarget:self action:@selector(socialChanged:) forControlEvents:UIControlEventValueChanged];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *autoExtendsTime = [prefs stringForKey:@"autoExtendsTime"];
    if ([autoExtendsTime isEqualToString:@"YES"]) {
        self.autoExtendsTime.on = YES;
    }else {
        self.autoExtendsTime.on = NO;
    }

    NSString *sound = [prefs objectForKey:@"sound"];
    if ([sound isEqualToString:@"NO"]) {
        self.sound.on = NO;
    }else {
        [prefs setObject:@"YES" forKey:@"sound"];
        self.sound.on = YES;
    }
    
    NSString *facebookAutoPost = [prefs stringForKey:@"SocialAutoPost"];
    if ([facebookAutoPost isEqualToString:@"YES"]) {
        self.facebookAutoPost.on = YES;
    }else {
        self.facebookAutoPost.on = NO;
    }

}



-(void)setupGameFlowView
{
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.gameFlowView.frame.size.width, self.gameFlowView.frame.size.height)];
    imageview.image = [UIImage imageNamed:@"background_clear"];
    [self.gameFlowView addSubview:imageview];
    
    UIImage *bimage = [UIImage imageNamed:@"btn_back"];
    
    UIButton *bbutton = [UikitFramework createButtonWithBackgroudImage:@"btn_back" title:@"" positionX:10 positionY:10]; 
    [bbutton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.gameFlowView addSubview:bbutton];
    
    UIButton *homeButton = [UikitFramework createButtonWithBackgroudImage:@"btn_home" title:@"" positionX:self.view.frame.size.width - 10 - bimage.size.width positionY:10]; 
    [homeButton addTarget:self action:@selector(homeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.gameFlowView addSubview:homeButton];
    
    UILabel *label = [UikitFramework createLableWithText:@"GAME SETTINGS" positionX:0 positionY:0 width:self.view.frame.size.width height:90];
    label.textAlignment = UITextAlignmentCenter;
    label.numberOfLines = 0;
    label.font = [UIFont fontWithName:[UikitFramework getFontName] size: 25];
    [self.gameFlowView addSubview:label];
    
    UIButton * userpreferenceButton = [UikitFramework createButtonWithBackgroudImage:@"IMAGENS-FLOW-1" title:@"IMAGE FLOW" positionX:135 positionY:60];
    [userpreferenceButton addTarget:self action:@selector(nothingButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    userpreferenceButton.titleLabel.font = [UIFont fontWithName:[UikitFramework getFontName] size: 25];
    [self.gameFlowView addSubview:userpreferenceButton];
    
    label = [UikitFramework createLableWithText:@"BACK TO MAIN MENU" positionX:20 positionY:100 width:LABEL_WIDTH height:50];
    label.font = [UIFont fontWithName:[UikitFramework getFontName] size:LABEL_SIZE];
    label.textAlignment = UITextAlignmentLeft;
    [self.gameFlowView addSubview:label];
    
    UISwitch *mainMenu = [[UISwitch alloc] initWithFrame:CGRectMake(label.frame.origin.x + label.frame.size.width +offset, label.frame.origin.y + 10, label.frame.size.width, label.frame.size.height)];
    self.mainMenu = mainMenu;
    [self.gameFlowView addSubview:mainMenu];
    
    label = [UikitFramework createLableWithText:@"KEEP DIFFICULTY" positionX:20 positionY:150 width:LABEL_WIDTH height:50];
    label.font = [UIFont fontWithName:[UikitFramework getFontName] size:LABEL_SIZE];
    label.textAlignment = UITextAlignmentLeft;
    [self.gameFlowView addSubview:label];
    
    UISwitch *keepDifficulty = [[UISwitch alloc] initWithFrame:CGRectMake(label.frame.origin.x + label.frame.size.width +offset, label.frame.origin.y + 10, label.frame.size.width, label.frame.size.height)];
    self.keepDifficulty = keepDifficulty;
    [self.gameFlowView addSubview:keepDifficulty];
    
    label = [UikitFramework createLableWithText:@"INCREASE DIFFICULTY (DEFAULT)" positionX:20 positionY:200 width:LABEL_WIDTH height:50];
    label.font = [UIFont fontWithName:[UikitFramework getFontName] size:LABEL_SIZE];
    label.textAlignment = UITextAlignmentLeft;
    [self.gameFlowView addSubview:label];
    
    UISwitch *increaseDifficulty = [[UISwitch alloc] initWithFrame:CGRectMake(label.frame.origin.x + label.frame.size.width +offset, label.frame.origin.y + 10, label.frame.size.width, label.frame.size.height)];
    self.increaseDifficulty = increaseDifficulty;
    [self.gameFlowView addSubview:increaseDifficulty];
    
    label = [UikitFramework createLableWithText:@"SURPRISE ME!" positionX:20 positionY:250 width:LABEL_WIDTH height:50];
    label.font = [UIFont fontWithName:[UikitFramework getFontName] size:LABEL_SIZE];
    label.textAlignment = UITextAlignmentLeft;
    [self.gameFlowView addSubview:label];
    
    UISwitch *surprise = [[UISwitch alloc] initWithFrame:CGRectMake(label.frame.origin.x + label.frame.size.width +offset, label.frame.origin.y + 10, label.frame.size.width, label.frame.size.height)];
    self.surprise = surprise;
    [self.gameFlowView addSubview:surprise];
    
    [self.mainMenu addTarget:self action:@selector(mainMenuChanged:) forControlEvents:UIControlEventValueChanged];
    [self.keepDifficulty addTarget:self action:@selector(keepDifficultyChanged:) forControlEvents:UIControlEventValueChanged];
    [self.increaseDifficulty addTarget:self action:@selector(increaseDifficultyChanged:) forControlEvents:UIControlEventValueChanged];
    [self.surprise addTarget:self action:@selector(surpriseChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self.radio addObject:mainMenu];
    [self.radio addObject:keepDifficulty];
    [self.radio addObject:increaseDifficulty];
    [self.radio addObject:surprise];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *gameFlow = [prefs objectForKey:@"gameFlow"];
    [self disableALL];
    if(!gameFlow)
    {
        self.increaseDifficulty.on = YES;
        [self gameFlow:@"increase"];
        
    }else if([gameFlow isEqualToString:@"main"]){
        self.mainMenu.on = YES;
    }
    else if([gameFlow isEqualToString:@"keep"]){
        self.keepDifficulty.on = YES;
    }
    else if([gameFlow isEqualToString:@"increase"]){
        self.increaseDifficulty.on = YES;
    }
    else if([gameFlow isEqualToString:@"surprise"]){
        self.surprise.on = YES;
    }
}

-(void)disableALL
{
    for(int c=0;c<[self.radio count];c++)
    {
        UISwitch *myswitch = [self.radio objectAtIndex:c];
        myswitch.on = NO;
    }
}

-(void)extendTimeChanged:(UIButton*)sender
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString * autoExtendsTime;
    if (self.autoExtendsTime.on) {
        
        autoExtendsTime = @"YES";
    }else {
        autoExtendsTime = @"NO";
        
        
    }
    [prefs setObject:autoExtendsTime forKey:@"autoExtendsTime"];
    [prefs synchronize];
}

-(void)soundChanged:(UIButton*)sender
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    
    NSString * sound;
    if (self.sound.on) {
        sound = @"YES";
        [prefs setObject:sound forKey:@"sound"];
        [prefs synchronize];
        [[SoundManager sharedSoundManager] playIntro];
    }else {
        sound = @"NO";
        [prefs setObject:sound forKey:@"sound"];
        [prefs synchronize];
        [[SoundManager sharedSoundManager] stopIntro];
    }
}

-(void)socialChanged:(UIButton*)sender
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString * facebookAutoPost;
    if (self.facebookAutoPost.on) {
        facebookAutoPost = @"YES";
    }else {
        facebookAutoPost = @"NO";
    }
    [prefs setObject:facebookAutoPost forKey:@"SocialAutoPost"];
    [prefs synchronize];
}

-(void)mainMenuChanged:(UISwitch*)sender
{
    if(sender.on == NO){
        sender.on = YES;
    }
    else{
        [self disableALL];
        sender.on = YES;
        [self gameFlow:@"main"];
    }
}

-(void)keepDifficultyChanged:(UISwitch*)sender
{
    if(sender.on == NO){
        sender.on = YES;
    }
    else{
        [self disableALL];
        sender.on = YES;
        [self gameFlow:@"keep"];
    }
}

-(void)increaseDifficultyChanged:(UISwitch*)sender
{
    if(sender.on == NO){
        sender.on = YES;
    }
    else{
        [self disableALL];
        sender.on = YES;
        [self gameFlow:@"increase"];
    }
}
 -(void)surpriseChanged:(UISwitch*)sender
{
    if(sender.on == NO){
        sender.on = YES;
    }
    else{
        [self disableALL];
        sender.on = YES;
        [self gameFlow:@"surprise"];
    }
}

-(void)gameFlow:(NSString*)gameFlow
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:gameFlow forKey:@"gameFlow"];
    [prefs synchronize];
}
- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setUserPreferenceView:nil];
    [self setGameFlowView:nil];
    [self setUserPreferenceImageView:nil];
    [self setGameFlowImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)playInterfaceSound
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *sound = [prefs stringForKey:@"sound"];
    
    if ([sound isEqualToString:@"YES"]) {
        [[SoundManager sharedSoundManager] playInterface];
    }
}

-(void)nothingButtonTapped:(UIButton*)sender
{
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

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pagecontrol.currentPage = page;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

@end
