//
//  ImagesForThemeCarouselViewController.m
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 6/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImagesForThemeCarouselViewController.h"
#import "ImageDetailViewController.h"
#import "Maze+Manage.h"
#import "MyDocumentHandler.h"
#import "SoundManager.h"
#import "Theme.h"
#import "Difficulty+Manage.h"
#import "Pack+manage.h"
#import "AppDelegate.h"

#define NUMBER_OF_ITEMS 19
#define ITEM_SPACING 210
#define USE_BUTTONS YES
#define image_holder @"levelimageholder_old"
#define choose_level @"txtselectlevel.png"


@interface ImagesForThemeCarouselViewController () <UIActionSheetDelegate>

@property (nonatomic, assign) BOOL wrap;
@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, weak) NSString *segueValue;
@property (nonatomic, weak) NSString *segueDocumentValue;
@end


@implementation ImagesForThemeCarouselViewController

@synthesize carousel;
@synthesize navItem;
@synthesize wrap;
@synthesize items;
@synthesize segueValue = _segueValue;
@synthesize theme = _theme;
@synthesize document = _document;
@synthesize pagecontrol = _pagecontrol;
@synthesize mazes = _mazes;

- (void)setUp
{
    wrap = NO;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        [self setUp];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        
        [self setUp];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[MyDocumentHandler sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document){
        _document = document;
    }];
    wrap = NO;
	
	UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
	backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	backgroundView.image = [UIImage imageNamed:@"background_clear.png"];
	[self.view addSubview:backgroundView];
	
	self.carousel = [[iCarousel alloc] initWithFrame:self.view.bounds];
	carousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    carousel.type = iCarouselTypeLinear;
	carousel.delegate = self;
	carousel.dataSource = self;
    
	[self.view addSubview:carousel];
    
    self.mazes = [Maze getMaze:self.theme inManagedObjectContext:self.document.managedObjectContext];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.carousel = nil;
    self.navItem = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    for (UIView *view in carousel.visibleViews)
    {
        view.alpha = 1.0;
    }
    carousel.type = buttonIndex;
    navItem.title = [actionSheet buttonTitleAtIndex:buttonIndex];
}

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    int numero = [self.mazes count];

    self.items = [NSMutableArray array];
    for (int i = 0; i < numero; i++)
    {
        [items addObject:[NSNumber numberWithInt:i]];
    }
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *difficulty = [prefs stringForKey:@"difficulty"];
    NSString *gameState = [prefs stringForKey:@"gameState"];
    
    //NSLog(@"inside image for theme theme = %@ difficulty = %@ gameState = %@ ",self.theme,difficulty,gameState);
    
    NSArray *mazeso = [Maze getMazeByThemeDifficultyAndState:self.theme difficulty:difficulty state:gameState inManagedObjectContext:self.document.managedObjectContext]; 

    return [mazeso count] + 1;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{    
    if (!self.mazes) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *difficulty = [prefs stringForKey:@"difficulty"];
        NSString *gameState = [prefs stringForKey:@"gameState"];
        self.mazes = [Maze getMazeByThemeDifficultyAndState:self.theme difficulty:difficulty state:gameState inManagedObjectContext:self.document.managedObjectContext]; 
        //[Maze getMazeByThemeAndDifficulty:self.theme difficulty:difficulty inManagedObjectContext:self.document.managedObjectContext];
    }
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 180, 180)];
    
    if(index == 0){
        UIImage *background = [UIImage imageNamed:@"generic_maze_image"];
        [button setBackgroundImage:background forState:UIControlStateNormal];
        
        button.tag = index;
        button.accessibilityValue = @"buy";

    }else {
        Maze *maze = [self.mazes objectAtIndex:index-1];
        NSLog(@"%d - %@",index,maze.name);
        UIImage *background;
        if (maze.pack) {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *path = [paths objectAtIndex:0];
            NSString *unzipPath = [path stringByAppendingPathComponent:@"unzip"];
            //NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:unzipPath error:NULL];
            NSString *package = [unzipPath stringByAppendingPathComponent:maze.pack.name];
            NSString *images = [package stringByAppendingPathComponent:@"thumbnail"];
            NSString *mazeName = [images stringByAppendingPathComponent:[NSString stringWithFormat:@"thumbnail_%@@2x.png",maze.name]];
            NSLog(@"%@",mazeName);
            
            NSData *imageData = [NSData dataWithContentsOfFile:mazeName options:0 error:nil];
            background = [UIImage imageWithData:imageData];
            button.accessibilityHint = @"YES";
        }else{
            background = [UIImage imageNamed: [NSString stringWithFormat:@"thumbnail_%@",maze.name]];
        }
        
        
        [button setBackgroundImage:background forState:UIControlStateNormal];
        
        button.tag = index;
        button.accessibilityValue = maze.name;
        
        
        
        UILabel *score_lable = [[UILabel alloc] initWithFrame:CGRectMake(0, button.frame.origin.y - button.frame.size.height / 2+ 20, button.frame.size.width,button.frame.size.height)];
        score_lable.text = [maze.theme.name capitalizedString];
        score_lable.backgroundColor = [UIColor clearColor];
        score_lable.font = [UIFont fontWithName:[UikitFramework getFontName] size: 20];
        score_lable.textColor = [UIColor grayColor];
        score_lable.textAlignment = UITextAlignmentCenter;
        
        NSString *labelToShow = maze.showLabel;
        if (!labelToShow) {
            labelToShow = maze.name;
        }
        
        UILabel * score_lable2 = [[UILabel alloc] initWithFrame:CGRectMake(0, button.frame.origin.y + button.frame.size.height / 2- 20, button.frame.size.width,button.frame.size.height)];
        NSString *labelToShowCap = [labelToShow capitalizedString];
        score_lable2.text = [labelToShowCap stringByReplacingOccurrencesOfString:@"_" withString:@" "];
        score_lable2.backgroundColor = [UIColor clearColor];
        score_lable2.font = [UIFont fontWithName:[UikitFramework getFontName] size: 20];
        score_lable2.textColor = [UIColor grayColor];
        score_lable2.textAlignment = UITextAlignmentCenter;
        
        if ([maze.newColection isEqualToString:@"YES"]) {
            UIImageView *imageview = [UikitFramework createImageViewWithImage:@"iConsNew" positionX:button.frame.origin.x -20 + button.frame.size.width positionY:button.frame.origin.y -20];
            [button addSubview:imageview];
        }
        
        [button addSubview:score_lable];
        [button addSubview:score_lable2];
    }
    
    
    [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside]; 
    return button;
}

- (float)carouselItemWidth:(iCarousel *)carousel
{
    return ITEM_SPACING;
}

- (CATransform3D)carousel:(iCarousel *)_carousel transformForItemView:(UIView *)view withOffset:(float)offset
{
    view.alpha = 1.0 - fminf(fmaxf(offset, 0.0), 1.0);
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = self.carousel.perspective;
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0, 1.0, 0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * carousel.itemWidth);
}

- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    return wrap;
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
    self.title = [NSString stringWithFormat:@"%d", self.carousel.currentItemIndex];
    int c = self.carousel.currentItemIndex / 3;
    self.pagecontrol.currentPage = c;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton*)sender
{
    if ([segue.identifier isEqualToString:@"show detail view"]) {
        ImageDetailViewController* idc = segue.destinationViewController;
        //[idc setFoto:[NSString stringWithFormat:@"%@.jpg",self.segueValue]];
        idc.foto = self.segueValue;
        //NSLog(@"segue value is %@",[NSString stringWithFormat:@"%@.jpg",self.segueValue]);
        [idc setDocument:self.document];
        
        if ([self.segueDocumentValue isEqualToString:@"YES"]) {
            idc.documentDirectory = @"YES";
        }
    }
}

-(void)playSound
{
    [[SoundManager sharedSoundManager] playIntro];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[MyDocumentHandler sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document){
        _document = document;
    }];
    [self playSound];

    UIImage *bimage = [UIImage imageNamed:@"btn_back"];
    
    UIButton *bbutton = [UikitFramework createButtonWithBackgroudImage:@"btn_back" title:@"" positionX:10 positionY:10]; 
    [bbutton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bbutton];
    
    UIButton *homeButton = [UikitFramework createButtonWithBackgroudImage:@"btn_home" title:@"" positionX:self.view.frame.size.width - 10 - bimage.size.width positionY:10]; 
    [homeButton addTarget:self action:@selector(homeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:homeButton];
    
    UILabel *label = [UikitFramework createLableWithText:@"SELECT IMAGE" positionX:0 positionY:0 width:self.view.frame.size.width height:60];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:[UikitFramework getFontName] size: 25];
    [self.view addSubview:label];
    
    if(!self.pagecontrol){
        int number_of_itens = self.carousel.numberOfItems;
        UIPageControl *pagecontrol = [[UIPageControl alloc] initWithFrame:CGRectMake(221, 280, 38, 36)];
        if (number_of_itens % 3 == 0)
            pagecontrol.numberOfPages = number_of_itens / 3;
        else {
            pagecontrol.numberOfPages = number_of_itens / 3 +1;
        }
        pagecontrol.currentPage = 0;
        pagecontrol.userInteractionEnabled = NO;
        self.pagecontrol = pagecontrol;
        [self.view addSubview:pagecontrol]; 
    }else {
        [[MyDocumentHandler sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document){
            _document = document;
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            NSString *difficulty = [prefs stringForKey:@"difficulty"];
            NSString *gameState = [prefs stringForKey:@"gameState"];
            self.mazes = [Maze getMazeByThemeDifficultyAndState:self.theme difficulty:difficulty state:gameState inManagedObjectContext:self.document.managedObjectContext];
            [self reloadData];
        }];

    }
}

-(void)reloadData
{
    [self.carousel reloadData];
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.carousel.numberOfItems > 1) {
        [self.carousel scrollToItemAtIndex:1 animated:NO];
    }
}

-(void)makeAAlertView:(NSString*)title
              message:(NSString*)mesage
{
    UIAlertView *alertView = [[UIAlertView alloc] 
                              initWithTitle:title                                                             
                              message:mesage                                                          
                              delegate:self                                              
                              cancelButtonTitle:@"OK"                                                   
                              otherButtonTitles:nil];
    [alertView show];
}

- (void)buttonTapped:(UIButton *)sender
{
    if (sender.tag == 0) {
        [self performSegueWithIdentifier:@"buyviewcontroller" sender:self];
        //[self makeAAlertView:@"SOON" message:@"Not Implemented Yet"];
        //NSLog(@"buy feature no implemented");
    }else {
        [self playInterfaceSound];
        self.segueValue = sender.accessibilityValue;
        self.segueDocumentValue = sender.accessibilityHint;
        [self performSegueWithIdentifier:@"show detail view" sender:self];

    }
}
@end
