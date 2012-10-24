//
//  AccountLogoutViewController.m
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 8/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AccountLogoutViewController.h"
#import "UikitFramework.h"
#import "SoundManager.h"
#import "InicialViewController.h"
#import "ConnectionManager.h"
#import "SettingsViewController.h"
#define fontSize 15
#define fontName @"junegull"

@interface AccountLogoutViewController ()
@property (nonatomic,weak) IBOutlet UIImageView *imageview;
@property (nonatomic,weak) IBOutlet UILabel *username;
@property (nonatomic,weak) IBOutlet UILabel *usernameaux;
@end

@implementation AccountLogoutViewController
@synthesize imageview = _imageview;
@synthesize username = _username;
@synthesize user = _user;

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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIImage *image = [UIImage imageNamed:@"iDifferences-Logout-box"];
    UIImage *bimage = [UIImage imageNamed:@"btn_back"];
    int halfViewSize = [self view].frame.size.width / 2;

    
    UIButton *bbutton = [UikitFramework createButtonWithBackgroudImage:@"btn_back" title:@"" positionX:10 positionY:10]; 
    [bbutton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bbutton];
    
    UIButton *homeButton = [UikitFramework createButtonWithBackgroudImage:@"btn_home" title:@"" positionX:self.view.frame.size.width - 10 - bimage.size.width positionY:10]; 
    [homeButton addTarget:self action:@selector(homeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:homeButton];

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    self.username.textAlignment = UITextAlignmentCenter;
    self.username.numberOfLines = 0;
    self.username.font = [UIFont fontWithName:[UikitFramework getFontName] size: 25];
    self.username.text =[NSString stringWithFormat:@"LOGGED IN AS"];
    //self.usernameaux.text = [prefs objectForKey:@"loggedinUsername"];
    
    UIImage * vimage = [UIImage imageNamed:@"V"];
    UIImageView *vimageview = [[UIImageView alloc]init];
    vimageview.frame = CGRectMake(self.view.frame.size.width - vimage.size.width - 30, 140, vimage.size.width, vimage.size.height);
    vimageview.image = vimage;
    [self.view addSubview:vimageview];
    
    UILabel *userLabel = [[UILabel alloc]init];
    userLabel.frame = CGRectMake(0, 140, self.view.frame.size.width, vimage.size.height);
    userLabel.textAlignment = UITextAlignmentCenter;
    userLabel.font = [UIFont fontWithName:[UikitFramework getFontName] size: 25];
    userLabel.text = [prefs objectForKey:@"nickname"];
    userLabel.textColor = [UIColor brownColor];
    userLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:userLabel];
    
    UIButton *logoutButton = [UikitFramework createButtonWithBackgroudImage:@"iDifferences-Logout-box" title:@"LOGOUT" positionX:halfViewSize - image.size.width/2  positionY:250];
    [logoutButton addTarget:self action:@selector(logoutButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    logoutButton.titleLabel.font = [UIFont fontWithName:fontName size: fontSize];
    [self.view addSubview:logoutButton];
    
    UILabel *label = [UikitFramework createLableWithText:@"ACCOUNT SETTINGS" positionX:0 positionY:0 width:self.view.frame.size.width height:100];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:[UikitFramework getFontName] size: 25];
    [self.view addSubview:label];
}

-(void)logoutButtonClicked:(UIButton*)sender
{
    NSLog(@"logout");
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:@"NO" forKey:@"loggedinUser"];
    [prefs setObject:@"" forKey:@"loggedinUsername"];
    [prefs synchronize];
    [self backToSettings];
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
    [self backToSettings];
}

- (IBAction) backToSettings {
    NSArray *viewControllers = [[self navigationController] viewControllers];
    for (int c=0; c < [viewControllers count]; c++) {
        id obj = [viewControllers objectAtIndex:c];
        if([obj isKindOfClass:[SettingsViewController class]])
            [self.navigationController popToViewController:obj animated:YES];
    }
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
}

@end
