//
//  SettingsViewController.m
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "UikitFramework.h"
#import "InicialViewController.h"
#import "SoundManager.h"
#import "AppDelegate.h"

#define back_button_image @"btn_back"
#define fontSize 15

#define settings_accounts_image @"btn_wine"
#define settings_accounts_lable @"ACCOUNTS"
#define settings_TIMER_image @"btn_orange"
#define settings_TIMER_lable @"GAME"


@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize imageview = _imageview;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    int halfViewSize = [self view].frame.size.width / 2;
    int offset = 20;
    
    UIImage *bimage = [UIImage imageNamed:back_button_image];

    UIButton *bbutton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, bimage.size.width, bimage.size.height)];
    [bbutton setBackgroundImage:bimage forState:UIControlStateNormal];
    [bbutton setTitle:@"" forState:UIControlStateNormal];
    [bbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bbutton.titleLabel.font = [bbutton.titleLabel.font fontWithSize:50];
    [bbutton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    bbutton.tag = 1111;
    [self.view addSubview:bbutton];
    
    UIButton *homeButton = [UikitFramework createButtonWithBackgroudImage:@"btn_home" title:@"" positionX:self.view.frame.size.width - 10 - bimage.size.width positionY:10]; 
    [homeButton addTarget:self action:@selector(homeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:homeButton];
    
    UIImage *image = [UIImage imageNamed:settings_accounts_image];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(halfViewSize - image.size.width - offset, 150, image.size.width, image.size.height)];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setTitle: settings_accounts_lable forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:[UikitFramework getFontName] size: fontSize];    button.titleLabel.textColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(accountsButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    UIImage *image3 = [UIImage imageNamed:settings_TIMER_image];

    UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(halfViewSize + offset, 150, image3.size.width, image3.size.height)];
    [button3 setBackgroundImage:image3 forState:UIControlStateNormal];
    [button3 setTitle:settings_TIMER_lable forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button3.titleLabel.font = [UIFont fontWithName:[UikitFramework getFontName] size: fontSize];    button3.titleLabel.textColor = [UIColor whiteColor];
    [button3 addTarget:self action:@selector(timerButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    
    UILabel *label = [UikitFramework createLableWithText:@"SETTINGS" positionX:0 positionY:0 width:self.view.frame.size.width height:100];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:[UikitFramework getFontName] size: 25];
    [self.view addSubview:label];
    
}

-(void)playInterfaceSound
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *sound = [prefs stringForKey:@"sound"];
    
    if ([sound isEqualToString:@"YES"]) {
        [[SoundManager sharedSoundManager] playInterface];
    }
}

-(void)homeButtonTapped:(UIButton*)sender
{
    [self playInterfaceSound];
    [self backToHome];
}

- (IBAction) backToHome {
    NSArray *viewControllers = [[self navigationController] viewControllers];
    for (int c=0; c < [viewControllers count]; c++) {
        id obj = [viewControllers objectAtIndex:c];
        if([obj isKindOfClass:[InicialViewController class]])
            [self.navigationController popToViewController:obj animated:YES];    
    }
}

-(void)accountsButtonTapped:(UIButton*)sender
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *user =  [prefs objectForKey:@"loggedinUser"];
    if ([user isEqualToString:@"YES"]) {
        [self performSegueWithIdentifier:@"logout view" sender:self];
    }else 
        [self performSegueWithIdentifier:@"account settings" sender:self];
}

-(void)timerButtonTapped:(UIButton*)sender
{
    [self performSegueWithIdentifier:@"testeSettingView" sender:self];
    //[self performSegueWithIdentifier:@"settings timer" sender:self];
}

-(void)backButtonTapped:(UIButton*)sender
{
    [[self navigationController]popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.imageview.image = [UIImage imageNamed:@"background_clear"]; 
	// Do any additional setup after loading the view.
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
