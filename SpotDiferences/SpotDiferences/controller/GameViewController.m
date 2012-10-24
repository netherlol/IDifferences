/*
 *  GameViewController.m
 *  SpotDiferences
 *
 *  Copyright 2012 Go4Mobility
 *
 */

#import "GameViewController.h"
#import "ThemeViewController.h"
#import "InicialViewController.h"
#import "resumeGameViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AccountSettingsViewController.h"
#import "Pack+manage.h"

#import "MazeView.h"

#import "MyDocumentHandler.h"
#import "ImagesForThemeCarouselViewController.h"
#import "AppDelegate.h"

#import "DifferenceSet+Manage.h"
#import "Differences.h"
#import "Theme+Create.h"
#import "Difficulty.h"
#import "Maze+Manage.h"

#import <Twitter/Twitter.h>
#import <math.h>

#import "SoundManager.h"
#import "MazeHelper.h"
#import "CGMarkerHelper.h"

#define starOffset 10
#define starToLeftOffset 30
#define numberOfErrorsOffSet 30
#define offset 7
#define timeUnitNumber 15
#define fontSize 15
#define intervalTimer 30
#define errorImage @"erro"



/**
 * Esta classe é Controlador principal do jogo
 *
 */

@interface GameViewController () <UIScrollViewDelegate,FBLoginViewDelegate>

// ScrollViews
@property (weak, nonatomic) IBOutlet UIScrollView *rightScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *leftScrollView;

// ImageViews
@property (weak, nonatomic) IBOutlet MazeView *rightImageView;
@property (weak, nonatomic) IBOutlet MazeView *leftImageView;


// Timer and ProgressionView
@property (weak, nonatomic) NSTimer *timer;
@property (weak, nonatomic) NSTimer *timerForRealTime;
@property (nonatomic,weak) IBOutlet UIProgressView *slider;

// Navigation Bar (?)
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;


@property (nonatomic,strong) NSMutableArray *timerUnits;
@property (nonatomic,strong) NSMutableArray *timerUnitsUsed;
@property (nonatomic,strong) NSMutableArray *stars;
@property (nonatomic,strong) NSMutableArray *redstars;
@property (nonatomic,strong) NSMutableArray *numberOfErrors;
@property (nonatomic,strong) NSMutableArray *numberOfErrorsRed;
@property (nonatomic) int numberOfExtendedTimes;

@property (nonatomic,weak) UILabel *score;
@property (nonatomic,strong) NSMutableArray *pauseViews;

@property (nonatomic,strong) NSString* fetchFoto;

@property (nonatomic) int clickError;
@property (nonatomic) int clickOk;

@property (nonatomic) Maze *maze;
@property (nonatomic) NSManagedObjectContext *context;

@property (nonatomic) int step_for_testing;
@property (nonatomic) float positionX_For_Testing;
@property (nonatomic) float positionY_For_Testing;

@property (nonatomic) int followUp;
@property (nonatomic) int timerForReal;
@property (strong, nonatomic) id<FBGraphUser> loggedInUser;

@property (nonatomic,weak) NSString *facebookShare;
@property (nonatomic,weak) NSString *twitterShare;
@property (nonatomic,weak) NSString *lastShare;
@end

@implementation GameViewController

@synthesize timerForRealTime = _timerForRealTime;
@synthesize rightScrollView = _rightScrollView;
@synthesize leftScrollView = _leftScrollView;
@synthesize rightImageView = _rightImageView;
@synthesize leftImageView = _leftImageView;

//(?)
@synthesize navigationBar = _navigationBar;
@synthesize document = _document;
@synthesize slider = _slider;
@synthesize timer = _timer;
@synthesize timerUnits = _timerUnits;
@synthesize stars = _stars;
@synthesize score =_score;
@synthesize pauseViews = _pauseViews;
@synthesize redstars = _redstars;
@synthesize numberOfExtendedTimes = _numberOfExtendedTimes;

@synthesize fetchFoto = _fetchFoto;
@synthesize clickError = _clickError;
@synthesize clickOk = _clickOk;

@synthesize mazeHelper = _mazeHelper;

@synthesize maze = _maze;
@synthesize context = _context;

@synthesize step_for_testing = _step_for_testing;
@synthesize positionX_For_Testing = _positionX_For_Testing;
@synthesize positionY_For_Testing = _positionY_For_Testing;

@synthesize timerUnitsUsed = _timerUnitsUsed;
@synthesize numberOfErrors = _numberOfErrors;
@synthesize numberOfErrorsRed = _numberOfErrorsRed;
@synthesize followUp = _followUp;
@synthesize timerForReal = _timerForReal;
@synthesize loggedInUser = _loggedInUser;
#pragma mark - Setup


/**
 * 
 *
 **/

-(void)playCheckSound{    
        [[SoundManager sharedSoundManager] playCheck];
}

-(void)playErrorSound{
        [[SoundManager sharedSoundManager] playErro];
}

-(void)checkDiffMatchs:(CGPoint)position inView:(MazeView*)view {
    
    //NSLog(@"checkDiffMatchs %f - %f", position.x, position.y);
    Differences *difference = [_mazeHelper differenceFound:position];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *gameState = [prefs stringForKey:@"gameState"];
    if (difference && !([difference.discovered isEqualToString:@"YES"] && [gameState isEqualToString:@"paused"])) { 
        [self playCheckSound];
        
        
        [CGMarkerHelper drawMarker:difference 
                            inView:_leftImageView 
                      insecundView:_rightImageView
                          inBounds:[_mazeHelper viewSize]];
        
        
        [self updateScores];
        [self updateStars];
        self.clickOk++;
        difference.discovered = @"YES";
        [self saveContext];
        return;
    } else {
        [self playErrorSound];
        [self errorImageAnimation:position];    
        [self updateScoresError];
        self.clickError++;
        self.maze.missedAtLeastOneTime = @"YES";
        [self updateNumberOfErrors];
        if (self.clickError == 3) {
            [self stopTimer];
            [self gameLosed];
        }
    }
}


- (void) setupWithHelper:(Maze*)maze andContext:(NSManagedObjectContext *) context {
    
    NSLog(@"maze name is %@", maze.name);
    NSMutableArray *differences = [[[DifferenceSet getDiffs:[NSString stringWithFormat:@"%@A",maze.name] 
                                     inManagedObjectContext:context] allObjects] mutableCopy];
    
    _mazeHelper = [MazeHelper initWith:maze mazeDifferences:differences];
    NSLog(@"mazeHelper Set!");
}

- (void) setupWith:(Maze*)maze andContext:(NSManagedObjectContext *) context {
    
    self.maze = maze;
    self.context = context;
}



#pragma mark - Clean


-(void)clearBothScreens {
    [_mazeHelper reset];
    [_rightImageView reset];
    [_leftImageView reset];
}



-(void)restartScore {
    self.score.text = @"000000";
    self.score.tag = 0;
}



-(void)removeAllStars {
    while ([self.stars count]> 0) {
        UIView *view = [self.stars lastObject];
        [view removeFromSuperview];
        [self.stars removeLastObject];
    }
    while ([self.redstars count]> 0) {
        UIView *view = [self.redstars lastObject];
        [view removeFromSuperview];
        [self.redstars removeLastObject];
    }
}



-(void)restartStar {
    [self removeAllStars];
    for (int c = 2; c > -3; c--) {
        UIImage *starimage = [UIImage imageNamed:@"differences_white_star"];
        UIImageView *starimageview = [UikitFramework createImageViewWithImage:@"differences_white_star" positionX:self.view.frame.size.width/2-starimage.size.width/2 + starOffset * c - starToLeftOffset positionY:15];
        [self.view addSubview:starimageview];
        [self.stars addObject:starimageview];
    }
}



#pragma mark - Getters and Setters

- (NSMutableArray*) numberOfErrors {
    if (!_numberOfErrors) {
        _numberOfErrors = [[NSMutableArray alloc] init];
    }
    return _numberOfErrors;
}

- (NSMutableArray*) numberOfErrorsRed {
    if (!_numberOfErrorsRed) {
        _numberOfErrorsRed = [[NSMutableArray alloc] init];
    }
    return _numberOfErrorsRed;
}
/**
 * Redstars Getter, instantiates the array if not defined
 *
 **/
- (NSMutableArray*) redstars {
    if (!_redstars) {
        _redstars = [[NSMutableArray alloc] init];
    }
    return _redstars;
}



/**
 * PauseViews Getter, instantiates the array if not defined
 *
 **/
- (NSMutableArray*) pauseViews {
    if(!_pauseViews){
        _pauseViews = [[NSMutableArray alloc]init];
    }
    return _pauseViews;
}



/**
 * Stars Getter, instantiates the array if not defined
 *
 **/
- (NSMutableArray*) stars {
    if (!_stars) {
        _stars = [[NSMutableArray alloc] init];
    }
    return _stars;
}



/**
 * TimerUnits Getter, instantiates the array if not defined
 *
 **/
- (NSMutableArray*) timerUnits {
    if (!_timerUnits) {
        _timerUnits = [[NSMutableArray alloc] init];
    }
    return _timerUnits;
}

#pragma mark - Actions

/**
 * backToMenu Action (?)
 *
 **/
- (IBAction) backToMenu:(UIBarButtonItem *) sender {
    NSArray *viewControllers = [[self navigationController] viewControllers];
    for (int c=0; c < [viewControllers count]; c++) {
        id obj = [viewControllers objectAtIndex:c];
        if([obj isKindOfClass:[ThemeViewController class]])
            [self.navigationController popToViewController:obj animated:YES];    
    }
}

/**
 * clearButtonPressed Action (?)
 *
 **/
- (IBAction)ClearButtonPressed:(id)sender {
    [_mazeHelper reset];
    [self.slider setProgress:0.0];
}

-(void)pauseButtonTapped:(UIButton*)sender {
    [self stopTimer];
    UIView *pauseView = [self makeAPauseView];
    UIImage *messagebox;
    /*
    NSString *dialog_box = [NSString stringWithFormat:@"dialog_box_%@",self.maze.name];
    NSLog(@"%@",dialog_box);*/
    
    if (self.maze.pack) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [paths objectAtIndex:0];
        NSString *unzipPath = [path stringByAppendingPathComponent:@"unzip"];
        //NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:unzipPath error:NULL];
        NSString *package = [unzipPath stringByAppendingPathComponent:self.maze.pack.name];
        NSString *images = [package stringByAppendingPathComponent:@"box"];
        NSString *mazeName = [images stringByAppendingPathComponent:[NSString stringWithFormat:@"dialog_box_%@@2x.png",self.maze.name]];
        NSLog(@"%@",mazeName);
        
        NSData *imageData = [NSData dataWithContentsOfFile:mazeName options:0 error:nil];
        messagebox = [UIImage imageWithData:imageData];

    }else
    {
        NSString *dialog_box = [NSString stringWithFormat:@"dialog_box_%@",self.maze.name];
        messagebox = [UIImage imageNamed:dialog_box];
    }
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:messagebox];
    imageView.frame = CGRectMake(self.view.frame.size.width/2-311/2 , self.view.frame.size.height/2-162/2, 311, 162);

    //[UikitFramework createImageViewWithImage:dialog_box positionX:self.view.frame.size.width/2-messagebox.size.width/2 positionY:self.view.frame.size.height/2-messagebox.size.height/2];
    [self.view addSubview:imageView];
    
    UILabel *pause_lable = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-messagebox.size.width/2 + 50, self.view.frame.size.height/2-messagebox.size.height/2, messagebox.size.width, messagebox.size.height)];
    pause_lable.text = @"GAME PAUSED";
    pause_lable.backgroundColor = [UIColor clearColor];
    pause_lable.font = [UIFont fontWithName:[UikitFramework getFontName] size: 15];
    pause_lable.textColor = [UIColor whiteColor];
    pause_lable.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:pause_lable];
    
    int halfViewSize = [self view].frame.size.width / 2;
    UIImage *image2 = [UIImage imageNamed:@"btn_green"];
    
    UIButton *continueButton = [[UIButton alloc] initWithFrame:CGRectMake(halfViewSize - image2.size.width -15, self.view.frame.size.height/2+162/2, image2.size.width, image2.size.height)];
    [continueButton setBackgroundImage:image2 forState:UIControlStateNormal];
    [continueButton setTitle:@"CONTINUE" forState:UIControlStateNormal];
    continueButton.titleLabel.font = [UIFont fontWithName:[UikitFramework getFontName] size: fontSize];
    continueButton.titleLabel.textColor = [UIColor whiteColor];
    [continueButton addTarget:self action:@selector(continueButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:continueButton];
    
    UIImage *image = [UIImage imageNamed:@"btn_red"];
    
    UIButton *quitButton = [[UIButton alloc] initWithFrame:CGRectMake(halfViewSize +15, self.view.frame.size.height/2+162/2, image2.size.width, image2.size.height)];    
    [quitButton setBackgroundImage:image forState:UIControlStateNormal];
    [quitButton setTitle:@"QUIT" forState:UIControlStateNormal];
    quitButton.titleLabel.font = [UIFont fontWithName:[UikitFramework getFontName] size: fontSize];
    quitButton.titleLabel.textColor = [UIColor whiteColor];
    [quitButton addTarget:self action:@selector(quitButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:quitButton];
    
    [self.pauseViews addObject:pauseView];
    [self.pauseViews addObject:imageView];
    [self.pauseViews addObject:continueButton];
    [self.pauseViews addObject:quitButton];
    [self.pauseViews addObject:pause_lable];
}

-(void)continueButtonTapped:(UIButton*)sender {
    [self clearPauseWinLoseScreens];
    [self startTimer];
}

-(void)quitButtonTapped:(UIButton*)sender {
    //[self backToMenu];
    NSLog(@"%d",[self.pauseViews count]);
    for(int c=0;c<4;c++)
    {
        id obj = [self.pauseViews lastObject];
        [obj removeFromSuperview];
        [self.pauseViews removeLastObject];
    }
    
    UIImage *messagebox;
    /*
     NSString *dialog_box = [NSString stringWithFormat:@"dialog_box_%@",self.maze.name];
     NSLog(@"%@",dialog_box);*/
    
    if (self.maze.pack) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [paths objectAtIndex:0];
        NSString *unzipPath = [path stringByAppendingPathComponent:@"unzip"];
        //NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:unzipPath error:NULL];
        NSString *package = [unzipPath stringByAppendingPathComponent:self.maze.pack.name];
        NSString *images = [package stringByAppendingPathComponent:@"box"];
        NSString *mazeName = [images stringByAppendingPathComponent:[NSString stringWithFormat:@"dialog_box_%@@2x.png",self.maze.name]];
        NSLog(@"%@",mazeName);
        
        NSData *imageData = [NSData dataWithContentsOfFile:mazeName options:0 error:nil];
        messagebox = [UIImage imageWithData:imageData];
        
    }else
    {
        NSString *dialog_box = [NSString stringWithFormat:@"dialog_box_%@",self.maze.name];
        messagebox = [UIImage imageNamed:dialog_box];
    }
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:messagebox];
    imageView.frame = CGRectMake(self.view.frame.size.width/2-311/2 , self.view.frame.size.height/2-162/2, 311, 162);
    
    //[UikitFramework createImageViewWithImage:dialog_box positionX:self.view.frame.size.width/2-messagebox.size.width/2 positionY:self.view.frame.size.height/2-messagebox.size.height/2];
    [self.view addSubview:imageView];

    
    
    //NSString *dialog_box = [NSString stringWithFormat:@"dialog_box_%@",self.maze.name];
    //UIImage *messagebox = [UIImage imageNamed:dialog_box];
    //UIImageView *imageView = [UikitFramework createImageViewWithImage:dialog_box positionX:self.view.frame.size.width/2-messagebox.size.width/2 positionY:self.view.frame.size.height/2-messagebox.size.height/2];
    //[self.view addSubview:imageView];
    
    UILabel *quit_lable = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-messagebox.size.width/2 + 50, self.view.frame.size.height/2-messagebox.size.height/2, messagebox.size.width, messagebox.size.height)];
    quit_lable.text = @"DO YOU REALLY WANT TO\n QUIT THIS GAME?";
    quit_lable.backgroundColor = [UIColor clearColor];
    quit_lable.numberOfLines = 0;
    quit_lable.font = [UIFont fontWithName:[UikitFramework getFontName] size: 15];
    quit_lable.textColor = [UIColor whiteColor];
    quit_lable.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:quit_lable];
    
    int halfViewSize = [self view].frame.size.width / 2;
    UIImage *image2 = [UIImage imageNamed:@"btn_green"];
    
    UIButton *continueButton = [[UIButton alloc] initWithFrame:CGRectMake(halfViewSize - image2.size.width -15, self.view.frame.size.height/2+162/2, image2.size.width, image2.size.height)];
    [continueButton setBackgroundImage:image2 forState:UIControlStateNormal];
    [continueButton setTitle:@"YES" forState:UIControlStateNormal];
    continueButton.titleLabel.font = [UIFont fontWithName:[UikitFramework getFontName] size: fontSize];
    continueButton.titleLabel.textColor = [UIColor whiteColor];
    [continueButton addTarget:self action:@selector(wantToQuitButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:continueButton];
    
    UIImage *image = [UIImage imageNamed:@"btn_red"];
    
    UIButton *quitButton = [[UIButton alloc] initWithFrame:CGRectMake(halfViewSize +15, self.view.frame.size.height/2+162/2, image2.size.width, image2.size.height)];    
    [quitButton setBackgroundImage:image forState:UIControlStateNormal];
    [quitButton setTitle:@"NO" forState:UIControlStateNormal];
    quitButton.titleLabel.font = [UIFont fontWithName:[UikitFramework getFontName] size: fontSize];
    quitButton.titleLabel.textColor = [UIColor whiteColor];
    [quitButton addTarget:self action:@selector(continueButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:quitButton];
    
    [self.pauseViews addObject:imageView];
    [self.pauseViews addObject:continueButton];
    [self.pauseViews addObject:quitButton];
    [self.pauseViews addObject:quit_lable];

}

-(void)onlyQuit:(UIButton*)sender{
    self.facebookShare = @"NO";
    self.twitterShare = @"NO";
    [self decideWhereToGo];
    //[self backToMenu];
}

-(void)wantToQuitButtonTapped:(UIButton*)sender {
    if(self.clickError >= 3)
        self.clickError = 0;
    int time = timeUnitNumber-[self.timerUnits count];
    if ([self.timerUnits count] == 0) {
        time = 0;
    }
    if (![self.maze.state isEqualToString:@"finished"]) {
        self.maze.state = @"paused";
        self.maze.differencesMissed = [NSNumber numberWithInt:self.clickError];
        int score = self.score.tag;
        self.maze.personalscore = [NSNumber numberWithInt:score];

        self.maze.personalTime =  [NSNumber numberWithInt:self.timerForReal];
        NSLog(@"inside wants to quit %d",self.timerForReal);
        self.maze.timeRemaining = [NSNumber numberWithInt:time];
        [self saveContext];
        [self backToMenu];
    }else {
        [self backToMenu];
    }
}

-(void)ShareButtonTapped:(UIButton*)sender {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *facebookAutoPost = [prefs stringForKey:@"facebookAutoPost"];
    if ([facebookAutoPost isEqualToString:@"YES"]) {
        [self loginFacebook];
        [self postOnwallWithoutAsking];
    }else {
        [self loginFacebook];
        [self postOnFacebook];
    }
}




-(void)menuButtonTapped:(UIButton*)sender {
    [self backToMenu];
}



-(void)changeLevelButtonTapped:(UIButton*)sender {
    [self backToMazeView];
}



-(void)restartButtonTapped:(UIButton*)sender {
    [self clearPauseWinLoseScreens];
    [self clearTimer];
    [self addTimerUnitsToScreen];
    [self restartStar];
    [self restartScore];
    [self restartNumberOfErrors];
    [self clearBothScreens];
    [self backToNormalScale];
    self.clickError = 0;
    self.clickOk = 0;
    [self startTimer];
}



#pragma mark - Gestures


/**
 * addGestures
 * 
 **/ 

-(void)addGestures {
    NSLog(@"addGestures Set!");
    
    UITapGestureRecognizer *tapGestureForLeftImage = 
    [[UITapGestureRecognizer alloc] 
     initWithTarget:self action:@selector(tapGestureHandlerForLeftView:)];
    UITapGestureRecognizer *tapGestureForRightImage = 
    [[UITapGestureRecognizer alloc] 
     initWithTarget:self action:@selector(tapGestureHandlerForRightView:)];
    
    /*
    [_rightScrollView addGestureRecognizer:tapGestureForRightImage];
    [_leftScrollView addGestureRecognizer:tapGestureForLeftImage];
     */
    [_rightImageView addGestureRecognizer:tapGestureForRightImage];
    [_leftImageView addGestureRecognizer:tapGestureForLeftImage];
}



/**
 * tapGestureHandlerForLeftView
 * 
 **/ 
-(void)tapGestureHandlerForLeftView:(UITapGestureRecognizer*)gesture  {
    
    CGPoint touchPosition = [gesture locationInView:_leftImageView];
    //NSLog(@"Left Touch %f - %f", touchPosition.x, touchPosition.y);
    [self checkDiffMatchs:touchPosition inView:_leftImageView];
}



/**
 * tapGestureHandlerForRightView
 * 
 **/ 
-(void)tapGestureHandlerForRightView:(UITapGestureRecognizer*)gesture  {
    CGPoint touchPosition = [gesture locationInView:_rightImageView];
    if (self.step_for_testing == 1) {
        NSLog(@"[Seed insertDiffs:%f topY:%f downX:%f downY:%f  diffFotos:%@ inContext:context];",self.positionX_For_Testing,self.positionY_For_Testing,touchPosition.x/[_mazeHelper viewSize].width*100,touchPosition.y/[_mazeHelper viewSize].height*100,[NSString stringWithFormat:@"%@A",[_mazeHelper mazeImage]]);
        self.step_for_testing = 0;
    }else {
        self.positionX_For_Testing = touchPosition.x/[_mazeHelper viewSize].width*100;
        self.positionY_For_Testing = touchPosition.y/[_mazeHelper viewSize].height*100;
        self.step_for_testing++;
    }
    
    //NSLog(@"Right Touch %f - %f", touchPosition.x/[_mazeHelper viewSize].width*100, touchPosition.y/[_mazeHelper viewSize].height*100);
    [self checkDiffMatchs:touchPosition inView:_rightImageView];
}



#pragma mark - Maze aware Methods

/*
 *
 * check if the clicked position matchs any spot predefined
 *
 */


-(void)errorImageAnimation:(CGPoint)position {
    
    //NSLog(@" Error in %f - %f", position.x, position.y);
    //float ratio = (_rightScrollView.frame.size.width / [_mazeHelper viewSize].width); 
    float positionX =  (position.x *[_rightScrollView zoomScale]) - _rightScrollView.contentOffset.x;
    float positionY = (position.y *[_rightScrollView zoomScale]) - _rightScrollView.contentOffset.y;
    float rightOriginX = _rightScrollView.frame.origin.x;
    float rightOriginY = _rightScrollView.frame.origin.y;
    
    UIImage *errorImg = [UIImage imageNamed:errorImage]; 
    UIImageView *imageview = [[UIImageView alloc] 
                              initWithFrame:CGRectMake(positionX+rightOriginX - errorImg.size.width/2, 
                                                       positionY+rightOriginY - errorImg.size.height/2, 
                                                       errorImg.size.width, 
                                                       errorImg.size.height)];
    [imageview setImage: errorImg];
    [self.view addSubview:imageview];
    
    UIImageView *imageviewLeft = [[UIImageView alloc] initWithFrame:CGRectMake(positionX - errorImg.size.width/2, positionY+29 -errorImg.size.height/2, errorImg.size.width, errorImg.size.height)];
    
    [imageviewLeft setImage: errorImg];
    [self.view addSubview:imageviewLeft];
    
    [UIView animateWithDuration:1.5 
                          delay:0.0 
                        options:UIViewAnimationOptionBeginFromCurrentState 
                     animations:^{imageviewLeft.alpha = 0.0;} 
                     completion:^(BOOL fin){
                         if (fin) 
                             [imageviewLeft removeFromSuperview];
                     }];
    
    [UIView animateWithDuration:1.5 
                          delay:0.0 
                        options:UIViewAnimationOptionBeginFromCurrentState 
                     animations:^{imageview.alpha = 0.0;} 
                     completion:^(BOOL fin){
                         if (fin) 
                             [imageview removeFromSuperview];
                     }];
}

-(void)updateWinScore{
    int score = self.score.tag;
    if (![self.maze.missedAtLeastOneTime isEqualToString:@"YES"]) {
        score = score + [_mazeHelper getMazeNoErrorBonusByDifficulty];
    }
    if (![self.maze.extendedAtLeastOneTime isEqualToString:@"YES"]) {
        score = score + [self getScoreByRemainingTime];
        
    }

    NSString *newScore = [self getNewScore:score];
    if (score < 0) {
        score = 0;
    }
    self.score.tag = score;
    self.score.text = newScore;
    
    if (![self.maze.state isEqualToString:@"finished"]) {
        NSLog(@"before saving %d",self.score.tag);
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *loggedinUser = [prefs stringForKey:@"loggedinUser"];
        self.maze.scoreSubmeted = @"NO";
        if ([loggedinUser isEqualToString:@"YES"]) {
            AccountSettingsViewController *scoreSender = [[AccountSettingsViewController alloc]init];
            scoreSender.document = self.document;
            [scoreSender submitScore:self.score.tag scoreboard:self.maze.uniqueID];
            [scoreSender submitScore:self.timerForReal scoreboard:[NSString stringWithFormat:@"%@.TIME",self.maze.uniqueID]];
            NSLog(@"%d --- %@ ---%d ---%d",self.score.tag,self.maze.uniqueID,[_mazeHelper getMazeAvailableTime],self.timerForReal);
            
        }
        self.maze.personalscore = [NSNumber numberWithInt:self.score.tag];
        self.maze.firstScore = [NSNumber numberWithInt:self.score.tag];
        
        self.maze.personalTime = [NSNumber numberWithInt:self.timerForReal];
        self.maze.firstTime = [NSNumber numberWithInt:self.timerForReal];
    }else{
        self.maze.personalscore = [NSNumber numberWithInt:self.score.tag];
        self.maze.personalTime = [NSNumber numberWithInt:self.timerForReal];
    }
}

-(void)updateScores {
    int score = self.score.tag + [_mazeHelper getValueByDifficulty];
    self.score.tag = score;
    self.score.text = [self getNewScore:score];
}

-(void)updateScoresError{
    int score = self.score.tag - [_mazeHelper getErrorValueByDifficulty];
    self.score.tag = score;
    self.score.text = [self getNewScore:score];
}

-(void)updateScoresExtendedTime{
    int score = self.score.tag - [_mazeHelper getExtraTimeValueByDifficulty];
    self.score.tag = score;
    self.score.text = [self getNewScore:score];
}

-(int)getScoreByRemainingTime {
    return ([_mazeHelper getMazeAvailableTime] - self.timerForReal) * [_mazeHelper getMazeRemainingTimeScoreByDifficulty];//[self.timerUnits count] * [_mazeHelper getMazeAvailableTime] / 15 * [_mazeHelper getMazeRemainingTimeScoreByDifficulty];
}



-(NSString*)getNewScore:(int)score {
    int length = (abs(score) ==0) ? 1 : (int)log10(abs(score)) + 1;
    NSString *newScore = @" ";
    if (score <0) {
        newScore = @"-";
    }
    
    for (int c = 0; c < 6 - length; c++) {
        newScore = [newScore stringByAppendingString:@"0"];
    }
    return [newScore stringByAppendingString:[NSString stringWithFormat:@"%d", abs(score)]];
}

-(void)updateNumberOfErrors{
    UIImageView *numberOfErrors = [self.numberOfErrors lastObject];
    //NSLog(@"%f - %f",numberOfErrors.frame.origin.x,numberOfErrors.frame.origin.y);
    UIImageView *starimageview = [UikitFramework createImageViewWithImage:@"differences_red_cross" positionX:numberOfErrors.frame.origin.x positionY:numberOfErrors.frame.origin.y];
    
    [self.view addSubview:starimageview];
    
    [self.numberOfErrorsRed addObject:starimageview];
    
    numberOfErrors.hidden = YES;
    [numberOfErrors removeFromSuperview];
    [self.numberOfErrors removeLastObject];
}

-(void)updateStars {
    UIImageView *star = [self.stars lastObject];
    
    UIImageView *starimageview = [UikitFramework createImageViewWithImage:@"differences_red_star" positionX:star.frame.origin.x positionY:star.frame.origin.y];
    
    [self.view addSubview:starimageview];
    
    [self.redstars addObject:starimageview];
    
    star.hidden = YES;
    [star removeFromSuperview];
    [self.stars removeLastObject];
    
    if([self.stars count] == 0)
    {
        [self stopTimer];
        
        [self gameWon];
    }
}

-(void)saveContext{
    [self.document saveToURL:self.document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
}

-(void)changeStateToFinished{
    self.maze.state = @"finished";   
    [self saveContext];
}

-(void)playWinSound
{
    [[SoundManager sharedSoundManager] playFinal];
}

-(void)playLoseSound
{
    [[SoundManager sharedSoundManager] playFinal];
}

-(void)gameWon {
    [self playWinSound];
    [self clearPauseView];
    [self updateWinScore];
    self.maze.state = @"finished";
    self.maze.newColection = @"NO";
    UIView *pauseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    pauseView.backgroundColor = [UIColor blackColor];
    pauseView.alpha = 0.5;
    [self.view addSubview:pauseView];
    
    NSMutableArray *gameWonViews = [[NSMutableArray alloc]init];
    
    UIImage *messagebox;
    UIImageView *imageView;
    /*
     NSString *dialog_box = [NSString stringWithFormat:@"dialog_box_%@",self.maze.name];
     NSLog(@"%@",dialog_box);*/
    
    if (self.maze.pack) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [paths objectAtIndex:0];
        NSString *unzipPath = [path stringByAppendingPathComponent:@"unzip"];
        //NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:unzipPath error:NULL];
        NSString *package = [unzipPath stringByAppendingPathComponent:self.maze.pack.name];
        NSString *images = [package stringByAppendingPathComponent:@"box"];
        NSString *mazeName = [images stringByAppendingPathComponent:[NSString stringWithFormat:@"dialog_box_%@@2x.png",self.maze.name]];
        NSLog(@"%@",mazeName);
        
        NSData *imageData = [NSData dataWithContentsOfFile:mazeName options:0 error:nil];
        messagebox = [UIImage imageWithData:imageData];
        
    }else
    {
        NSString *dialog_box = [NSString stringWithFormat:@"dialog_box_%@",self.maze.name];
        messagebox = [UIImage imageNamed:dialog_box];
    }

    imageView = [[UIImageView alloc]initWithImage:messagebox];
    imageView.frame = CGRectMake(self.view.frame.size.width/2-311/2 , self.view.frame.size.height/2-162/2, 311, 162);
    [self.view addSubview:imageView];
    
    //NSString *dialog_box = [NSString stringWithFormat:@"dialog_box_%@",self.maze.name];
    //UIImage *messagebox = [UIImage imageNamed:dialog_box];
    //UIImageView *imageView = [UikitFramework createImageViewWithImage:dialog_box positionX:self.view.frame.size.width/2-messagebox.size.width/2 positionY:self.view.frame.size.height/2-messagebox.size.height/2];
    //[self.view addSubview:imageView];
    
    UILabel *pause_lable = [UikitFramework createLableWithText:[NSString stringWithFormat:@"YOU SCORED\n%d POINTS",self.score.tag] 
                                                     positionX:self.view.frame.size.width/2-messagebox.size.width/2 + 50 
                                                     positionY:self.view.frame.size.height/2-messagebox.size.height/2 
                                                         width:messagebox.size.width 
                                                        height:messagebox.size.height];

    pause_lable.numberOfLines = 0;
    pause_lable.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:pause_lable];
    
    [gameWonViews addObject:pauseView];
    [gameWonViews addObject:imageView];
    [gameWonViews addObject:pause_lable];
    
    for (int c = 0; c < [gameWonViews count]; c++) {
        id obj = [gameWonViews objectAtIndex:c];
        [obj setAlpha:0];
        [self.pauseViews addObject:obj];
    }
    
    [UIView animateWithDuration:1.5 
                          delay:0.0 
                        options:UIViewAnimationOptionBeginFromCurrentState 
                     animations:^{
                         /*for (int c = 0; c < [gameWonViews count]; c++) {
                             id obj = [gameWonViews objectAtIndex:c];
                             [obj setAlpha:1];
                         }*/
                         pauseView.alpha = 0.9;
                         imageView.alpha = 1;
                         pause_lable.alpha = 1;
                     } 
                     completion:^(BOOL fin){
                     }];
    
    [UIView animateWithDuration:1.5 
                          delay:3.0 
                        options:UIViewAnimationOptionBeginFromCurrentState 
                     animations:^{
                         for (int c = 0; c < [gameWonViews count]; c++) {
                             id obj = [gameWonViews objectAtIndex:c];
                             [obj setAlpha:0];
                         }
                     } 
                     completion:^(BOOL fin){
                         for(int c = 0; c < [self.pauseViews count] ; c++){
                             id obj = [self.pauseViews lastObject];
                             [obj removeFromSuperview];
                             [self.pauseViews removeLastObject];
                         }
                         [self sharingView];
                     }];

}

-(void)resetAndChangeImage
{
    self.followUp = 1;
    [self restartButtonTapped:nil];
    [self setupImage];
}

-(void)decideWhereToGo
{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *gameFlow = [prefs objectForKey:@"gameFlow"];
    NSString *gameState = [prefs stringForKey:@"gameState"];
    if ([gameState isEqualToString:@"paused"]) {
        [self backToResumeGames];
    }
    
    if ([gameFlow isEqualToString:@"main"]) {
        [self backToMenu];
    }else if([gameFlow isEqualToString:@"keep"])
    {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *difficulty = [prefs stringForKey:@"difficulty"];
        NSString *gameState = [prefs stringForKey:@"gameState"];
        NSLog(@"Theme = %@ difficulty = %@ old state = %@ new state = %@",self.maze.theme.name,difficulty,gameState,self.maze.state);
        
        NSArray *allMazeByDifficulty = [Maze getMazeByDifficulty:difficulty state:gameState inManagedObjectContext:self.document.managedObjectContext];
        if ([allMazeByDifficulty count] == 0) {
            [self backToMazeView];
        }
        
        NSArray *mazeso = [Maze getMazeByThemeDifficultyAndState:self.maze.theme.name difficulty:difficulty state:gameState inManagedObjectContext:self.document.managedObjectContext];
        if ([mazeso count] == 0) {
            mazeso =[self chooseAnotherTheme];
        }
        if ([mazeso count] >0) {
            Maze *maze = [mazeso objectAtIndex:0];
            [self setupWith:maze andContext:self.document.managedObjectContext];
            [self setupWithHelper:self.maze andContext:self.context];
            [self resetAndChangeImage];
        }else
            [self backToMazeView];
    }
    else if([gameFlow isEqualToString:@"increase"])
    {
        NSString *difficulty = [self increaseDifficulty];
        NSArray *mazeso;
        NSLog(@"%@",difficulty);
        if ([difficulty isEqualToString:@"detective"]) {
            NSArray *allMazeByDifficulty = [Maze getMazeByDifficulty:difficulty state:gameState inManagedObjectContext:self.document.managedObjectContext];
            if ([allMazeByDifficulty count] == 0) {
                [self backToMazeView];
            }
            
            mazeso = [Maze getMazeByThemeDifficultyAndState:self.maze.theme.name difficulty:difficulty state:gameState inManagedObjectContext:self.document.managedObjectContext];
            
            if ([mazeso count] == 0) {
                mazeso =[self chooseAnotherTheme];
            }
        }else {
            mazeso = [Maze getMazeByThemeDifficultyAndState:self.maze.theme.name difficulty:difficulty state:gameState inManagedObjectContext:self.document.managedObjectContext];
            
            if ([mazeso count] == 0) {
                [self decideWhereToGo];
                return;
            }

        }
        
        NSLog(@"aray got %d itens",[mazeso count]);
        if ([mazeso count] >0) {
            Maze *maze = [mazeso objectAtIndex:0];
            [self setupWith:maze andContext:self.document.managedObjectContext];
            [self setupWithHelper:self.maze andContext:self.context];
            [self resetAndChangeImage];
        }else
            [self backToMazeView];
    }else {
        
        NSArray *allMAzes = [Maze getMazeByState:gameState inManagedObjectContext:self.document.managedObjectContext];
        if ([allMAzes count] == 0) {
            [self backToMazeView];
        }else {
            int number = (arc4random()%[allMAzes count]);
            Maze *maze = [allMAzes objectAtIndex:number];
            [self setupWith:maze andContext:self.document.managedObjectContext];
            [self setupWithHelper:self.maze andContext:self.context];
            [self resetAndChangeImage];

        }
        
    }
}

-(NSArray*)chooseAnotherTheme
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *difficulty = [prefs stringForKey:@"difficulty"];
    NSString *gameState = [prefs stringForKey:@"gameState"];
    NSArray *themes = [Theme getAllThemes:self.document.managedObjectContext];
    for (int c=0; c<[themes count]; c++) {
        Theme *theme = [themes objectAtIndex:c];
        NSArray *mazesByTheme = [Maze getMazeByThemeDifficultyAndState:theme.name difficulty:difficulty state:gameState inManagedObjectContext:self.document.managedObjectContext];
        if ([mazesByTheme count] > 0) {
            return mazesByTheme;
        }
    }
    return nil;
}

-(NSString*)increaseDifficulty
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *difficulty = [prefs stringForKey:@"difficulty"];
    if ([difficulty isEqualToString:@"beginner"]) {
        [self dificultyChosed:@"intermediate"];    
        return @"intermediate";
    }else if ([difficulty isEqualToString:@"intermediate"]) {
        [self dificultyChosed:@"expert"];  
        return @"expert";
    }
    else{
        [self dificultyChosed:@"detective"];  
        return @"detective";
    }
}

-(void)dificultyChosed:(NSString*)difficulty
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:difficulty forKey:@"difficulty"];
    [prefs synchronize];
}

-(void)sharingView
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *difficulty = [prefs stringForKey:@"SocialAutoPost"];
    if ([difficulty isEqualToString:@"YES"]) 
    {
        //[self logoutFacebook];
        [self loginFacebook];
        //[self postOnwallWithoutAsking];
        [self sucessShared:self];           
    }else {
        [self askToShare];
    }

}

-(void)shareToFacebook:(id)sender
{
    [self loginFacebook];
    //[self sendTwitter];
    //[self postOnFacebook];
    [self sucessShared:self];
}

-(void)facebookShare:(id)sender
{
    self.lastShare = @"facebook";
    self.facebookShare = @"YES";
    [self loginFacebook];
    [self sucessShared:nil];
}

-(void)twitterShare:(id)sender
{
    self.lastShare = @"twitter";
    self.twitterShare = @"YES";
    [self sendTwitter];
    [self sucessShared:nil];
}

-(void)sucessShared:(id)sender
{
    [self clearPauseView];
    int halfViewSize = [self view].frame.size.width / 2;

    UIView *pauseView = [self makeAPauseView];
    UIImage *image2 = [UIImage imageNamed:@"btn_short_green"];
    NSMutableArray *gameWonViews = [[NSMutableArray alloc]init];
    UIImage *messagebox = [UIImage imageNamed:@"dialog_share"];
    
    
    UIImageView *imageView = [UikitFramework createImageViewWithImage:@"dialog_share" positionX:self.view.frame.size.width/2-messagebox.size.width/2 positionY:self.view.frame.size.height/2-messagebox.size.height/2];
    [self.view addSubview:imageView];
    
    UILabel *pause_lable = [UikitFramework createLableWithText:[NSString stringWithFormat:@"CONGRATULATIONS!\n\nYOU SCORE WAS POSTED ON"] 
                                                     positionX:self.view.frame.size.width/2-messagebox.size.width/2 + 50 
                                                     positionY:self.view.frame.size.height/2-messagebox.size.height/4 -55 
                                                         width:messagebox.size.width 
                                                        height:messagebox.size.height];
    
    pause_lable.numberOfLines = 0;
    pause_lable.textAlignment = UITextAlignmentCenter;
    pause_lable.font = [UIFont fontWithName:[UikitFramework getFontName] size: 13];
    [self.view addSubview:pause_lable];
    
    UIImageView *facebook = [UikitFramework createImageViewWithImage:@"icon_social_facebook" positionX:self.view.frame.size.width/2 + 15 positionY:self.view.frame.size.height/2 + 15];
    UIImageView *twitter = [UikitFramework createImageViewWithImage:@"icon_social_twitter" positionX:self.view.frame.size.width/2 + 65 positionY:self.view.frame.size.height/2 + 15];
    
    if ([self.lastShare isEqualToString:@"facebook"]) {
        [self.view addSubview:facebook];
    }else if ([self.lastShare isEqualToString:@"twitter"]) {
        [self.view addSubview:twitter];
    }
    
    
    UIButton *OKButton = [UikitFramework createButtonWithBackgroudImage:@"btn_short_green" title:@"OK" positionX:halfViewSize - image2.size.width / 2 positionY:self.view.frame.size.height/2+messagebox.size.height/2];
    [OKButton addTarget:self action:@selector(beforeAsk:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:OKButton];
    
    [gameWonViews addObject:pauseView];
    [gameWonViews addObject:imageView];
    [gameWonViews addObject:pause_lable];
    [gameWonViews addObject:facebook];
    [gameWonViews addObject:twitter];
    [gameWonViews addObject:OKButton];
    
    for (int c = 0; c < [gameWonViews count]; c++) {
        id obj = [gameWonViews objectAtIndex:c];
        [obj setAlpha:0];
        [self.pauseViews addObject:obj];
    }
    
    [UIView animateWithDuration:0.5 
                          delay:0.0 
                        options:UIViewAnimationOptionBeginFromCurrentState 
                     animations:^{
                         /*
                         for (int c = 0; c < [gameWonViews count]; c++) {
                             id obj = [gameWonViews objectAtIndex:c];
                             [obj setAlpha:1];
                         }*/
                         pauseView.alpha = 0.9;
                         imageView.alpha = 1;
                         pause_lable.alpha = 1;
                         facebook.alpha = 1;
                         twitter.alpha = 1;
                         OKButton.alpha = 1;
                     } 
                     completion:^(BOOL fin){
                     }];
    /*
    [UIView animateWithDuration:0.5 
                          delay:3.0 
                        options:UIViewAnimationOptionBeginFromCurrentState 
                     animations:^{
                         for (int c = 0; c < [gameWonViews count]; c++) {
                             id obj = [gameWonViews objectAtIndex:c];
                             [obj setAlpha:0];
                         }
                     } 
                     completion:^(BOOL fin){
                         for(int c = 0; c < [self.pauseViews count] ; c++){
                             id obj = [self.pauseViews lastObject];
                             [obj removeFromSuperview];
                             [self.pauseViews removeLastObject];
                         }
                         [self decideWhereToGo];
                     }];
     */
}

-(void)beforeAsk:(UIButton*)sender
{
    if ([self.facebookShare isEqualToString:@"YES"] && [self.twitterShare isEqualToString:@"YES"]) {
        [self onlyQuit:nil];
    }else
        [self askToShare];
}

-(void)askToShare
{
    [self clearPauseView];

    UIView *pauseView = [self makeAPauseView];
    
    int halfViewSize = [self view].frame.size.width / 2;
    UIImage *image2 = [UIImage imageNamed:@"btn_short_green"];
    NSMutableArray *gameWonViews = [[NSMutableArray alloc]init];
    UIImage *messagebox = [UIImage imageNamed:@"dialog_share"];
    
    
    UIImageView *imageView = [UikitFramework createImageViewWithImage:@"dialog_share" positionX:self.view.frame.size.width/2-messagebox.size.width/2 positionY:self.view.frame.size.height/2-messagebox.size.height/2];
    [self.view addSubview:imageView];
    
    UILabel *pause_lable = [UikitFramework createLableWithText:[NSString stringWithFormat:@"DO YOU WANT TO\n SHARE YOUR SCORES?"] 
                                                     positionX:self.view.frame.size.width/2-messagebox.size.width/2 + 50 
                                                     positionY:self.view.frame.size.height/2-messagebox.size.height/4 -55 
                                                         width:messagebox.size.width 
                                                        height:messagebox.size.height];
    
    pause_lable.numberOfLines = 0;
    pause_lable.textAlignment = UITextAlignmentCenter;
    pause_lable.font = [UIFont fontWithName:[UikitFramework getFontName] size: 15];
    [self.view addSubview:pause_lable];
    
    //UIImageView *facebook = [UikitFramework createImageViewWithImage:@"icon_social_facebook" positionX:self.view.frame.size.width/2 + 15 positionY:self.view.frame.size.height/2 + 15];
    //UIImageView *twitter = [UikitFramework createImageViewWithImage:@"icon_social_twitter" positionX:self.view.frame.size.width/2 + 65 positionY:self.view.frame.size.height/2 + 15];
    
    UIButton *facebook = [UikitFramework createButtonWithBackgroudImage:@"icon_social_facebook" title:@"" positionX:self.view.frame.size.width/2 + 15 positionY:self.view.frame.size.height/2 + 15];
    UIButton *twitter = [UikitFramework createButtonWithBackgroudImage:@"icon_social_twitter" title:@"" positionX:self.view.frame.size.width/2 + 65 positionY:self.view.frame.size.height/2 + 15];
    
    [facebook addTarget:self action:@selector(facebookShare:) forControlEvents:UIControlEventTouchUpInside];
    [twitter addTarget:self action:@selector(twitterShare:) forControlEvents:UIControlEventTouchUpInside];

    if ([self.facebookShare isEqualToString:@"YES"]) {
        facebook.enabled = NO;
    }
    if ([self.twitterShare isEqualToString:@"YES"]) {
        twitter.enabled = NO;
    }
    
    [self.view addSubview:facebook];
    [self.view addSubview:twitter];
    
    /*UIButton *continueButton = [UikitFramework createButtonWithBackgroudImage:@"btn_short_green" title:@"YES" positionX:halfViewSize - image2.size.width -15 positionY:self.view.frame.size.height/2+messagebox.size.height/2];
    [continueButton addTarget:self action:@selector(shareToFacebook:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:continueButton];
    */
    UIButton *quitButton = [UikitFramework createButtonWithBackgroudImage:@"btn_short_red" title:@"NO" positionX:halfViewSize - image2.size.width/2 positionY:self.view.frame.size.height/2+messagebox.size.height/2];
    [quitButton addTarget:self action:@selector(onlyQuit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:quitButton];

    
    [gameWonViews addObject:pauseView];
    [gameWonViews addObject:imageView];
    [gameWonViews addObject:pause_lable];
    [gameWonViews addObject:facebook];
    [gameWonViews addObject:twitter];
    //[gameWonViews addObject:continueButton];
    [gameWonViews addObject:quitButton];
    
    for (int c = 0; c < [gameWonViews count]; c++) {
        id obj = [gameWonViews objectAtIndex:c];
        [obj setAlpha:0];
        [self.pauseViews addObject:obj];
    }
    
    [UIView animateWithDuration:0.5 
                          delay:0.0 
                        options:UIViewAnimationOptionBeginFromCurrentState 
                     animations:^{
                         /*for (int c = 0; c < [gameWonViews count]; c++) {
                             id obj = [gameWonViews objectAtIndex:c];
                             [obj setAlpha:1];
                         }*/
                         pauseView.alpha=0.9;
                         imageView.alpha=1;
                         pause_lable.alpha=1;
                         facebook.alpha=1;
                         twitter.alpha=1;
                         //continueButton.alpha=1;
                         quitButton.alpha=1;
                     } 
                     completion:^(BOOL fin){
                     }];

}

-(void)clearPauseView
{
    int conta = [self.pauseViews count];
    for(int c = 0; c < conta ; c++)
    {
        id obj = [self.pauseViews lastObject];
        [obj setAlpha:0];
        [obj removeFromSuperview];
        [self.pauseViews removeLastObject];
    }
}

#pragma mark - Social Integration

-(NSString*)getSocialText
{
    NSString *text;
    if (self.score.tag <=100) {
        text = [NSString stringWithFormat:@"Playing iDifferences... This is very difficult! I just scored %d points in the %@ level!",self.score.tag,self.maze.dificulty.name];
    }else if(self.score.tag >100 && self.score.tag <=250)
    {
        text = [NSString stringWithFormat:@"Playing iDifferences... Alright! Nice one! I just scored %d points in the %@ level!",self.score.tag,self.maze.dificulty.name];
    }else if(self.score.tag >250 && self.score.tag <=450)
    {
        text = [NSString stringWithFormat:@"Playing iDifferences... Wow! Well done! I just scored %d points in the %@ level!",self.score.tag,self.maze.dificulty.name];
    }if(self.score.tag > 450)
    {
        text = [NSString stringWithFormat:@"Playing iDifferences... Brilliant, great score! I just scored %d points in the %@ level!",self.score.tag,self.maze.dificulty.name];
    }

    return text;
}

-(void)sendTwitter {
    
    if ([TWTweetComposeViewController canSendTweet])
    {
        NSString *text = [self getSocialText];

        
        TWTweetComposeViewController *tweetSheet = 
        [[TWTweetComposeViewController alloc] init];
        [tweetSheet setInitialText:text];
        [tweetSheet addURL:[NSURL URLWithString:@"http://www.idifferences.com/"]];
	    [self presentModalViewController:tweetSheet animated:YES];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] 
                                  initWithTitle:@"Sorry"                                                             
                                  message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"                                                          
                                  delegate:self                                              
                                  cancelButtonTitle:@"OK"                                                   
                                  otherButtonTitles:nil];
        [alertView show];
    }
}


-(void)postOnwallWithoutAsking {

}


-(void)logoutFacebook {

}

-(void)saveFacebookData
{
    NSString *data = [self getSocialText];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:data forKey:@"facebookdata"];
    [prefs synchronize];

}

-(void)loginFacebook 
{
    [self saveFacebookData];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    // The user has initiated a login, so call the openSession method
    // and show the login UX if necessary.
    [appDelegate openSessionWithAllowLoginUI:YES];
}


-(void)postOnFacebook {
    NSMutableDictionary *postParams =
    [[NSMutableDictionary alloc] initWithObjectsAndKeys:
     @"http://www.pdmfc.com", @"link",
     @"https://developers.facebook.com/attachment/iossdk_logo.png", @"picture",
     @"IDIFFERENCE", @"name",
     @"Go4Mobility.", @"caption",
     @"The Best Game In The World.", @"description",
     nil];
    
    [FBRequestConnection startWithGraphPath:@"me/feed"
                                 parameters:postParams
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error) {
                              NSString *alertText;
                              if (error) {
                                  alertText = [NSString stringWithFormat:
                                               @"error: domain = %@, code = %d",
                                               error.domain, error.code];
                              } else {
                                  alertText = [NSString stringWithFormat:
                                               @"Posted action, id: %@",
                                               [result objectForKey:@"id"]];
                              }
                              // Show the result in an alert
                              [[[UIAlertView alloc] initWithTitle:@"Result"
                                                          message:alertText
                                                         delegate:self
                                                cancelButtonTitle:@"OK!"
                                                otherButtonTitles:nil]
                               show];
                          }
     ];

}

- (void)showAlert:(NSString *)message
           result:(id)result
            error:(NSError *)error {
    
    NSString *alertMsg;
    NSString *alertTitle;
    if (error) {
        alertMsg = error.localizedDescription;
        alertTitle = @"Error";
    } else {
        NSDictionary *resultDict = (NSDictionary *)result;
        alertMsg = [NSString stringWithFormat:@"Successfully posted '%@'.\nPost ID: %@", 
                    message, [resultDict valueForKey:@"id"]];
        alertTitle = @"Success";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:alertMsg
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}


-(void)backToNormalScale {
    
    [self.leftScrollView setZoomScale: [_mazeHelper initialZoomScale]];
    [self.rightScrollView setZoomScale: [_mazeHelper initialZoomScale]];
}


#pragma mark - ScrollView Delegate 

/**
 * 
 *
 */
-(void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if (scrollView.tag == 1 && scrollView.zooming) {
        [_leftScrollView setZoomScale: scrollView.zoomScale];
        [_leftScrollView setContentOffset: scrollView.contentOffset]; 
        
    } else if(scrollView.tag == 2 && scrollView.zooming) {
        [_rightScrollView setZoomScale: scrollView.zoomScale];    
        [_rightScrollView setContentOffset: scrollView.contentOffset];
    }
}


/*
 *
 *  timer actions
 *
 */
-(void)timerCall:(NSTimer *)timer 
{
    [self updateTimerUnits];
}

-(void)updateTimerUnits
{
    if ([self.timerUnits count] > 0) {
        UIImageView *timerunit = [self.timerUnits lastObject];
        UIImageView *timerunitused = [UikitFramework createImageViewWithImage:@"time_unit_black" positionX:timerunit.frame.origin.x positionY:timerunit.frame.origin.y];
        [self.view addSubview:timerunitused];
        [self.timerUnitsUsed addObject:timerunitused];                
        timerunit.hidden = YES;
        [timerunit removeFromSuperview];
        [self.timerUnits removeLastObject];
        
        if ([self.timerUnits count] == 0) {
            self.maze.extendedAtLeastOneTime = @"YES";
            [self updateScoresExtendedTime];
            if(self.numberOfExtendedTimes < 3){
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                NSString *remainingTime = [prefs stringForKey:@"autoExtendsTime"];
                if ([remainingTime isEqualToString:@"YES"]) {
                    self.numberOfExtendedTimes++;
                    [self stopTimer];
                    [self addTimerUnitsToScreen];
                    [self timeExtendedView];    
                }else {
                    [self stopTimer];
                    [self askForExtendTime];
                    
                    //[self gameLosed];
                }
            }else {
                [self gameLosedWithTimer];
            }
            
        }
    }

}

-(void)timeExtendedView
{
    NSLog(@"timeExtendedView");
    [self clearPauseView];
    UIView *pauseView = [self makeAPauseView];
    UIImageView *imageView;
    UIImage *messagebox;
    /*
     NSString *dialog_box = [NSString stringWithFormat:@"dialog_box_%@",self.maze.name];
     NSLog(@"%@",dialog_box);*/
    
    if (self.maze.pack) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [paths objectAtIndex:0];
        NSString *unzipPath = [path stringByAppendingPathComponent:@"unzip"];
        //NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:unzipPath error:NULL];
        NSString *package = [unzipPath stringByAppendingPathComponent:self.maze.pack.name];
        NSString *images = [package stringByAppendingPathComponent:@"box"];
        NSString *mazeName = [images stringByAppendingPathComponent:[NSString stringWithFormat:@"dialog_box_%@@2x.png",self.maze.name]];
        NSLog(@"%@",mazeName);
        
        NSData *imageData = [NSData dataWithContentsOfFile:mazeName options:0 error:nil];
        messagebox = [UIImage imageWithData:imageData];
        
    }else
    {
        NSString *dialog_box = [NSString stringWithFormat:@"dialog_box_%@",self.maze.name];
        messagebox = [UIImage imageNamed:dialog_box];
    }
    
    
    imageView = [[UIImageView alloc]initWithImage:messagebox];
    imageView.frame = CGRectMake(self.view.frame.size.width/2-311/2 , self.view.frame.size.height/2-162/2, 311, 162);
    [self.view addSubview:imageView];
    
    //NSString *dialog_box = [NSString stringWithFormat:@"dialog_box_%@",self.maze.name];
    //UIImage *messagebox = [UIImage imageNamed:dialog_box];
    //UIImageView * messageBox = [UikitFramework createImageViewWithImage:dialog_box positionX:self.view.frame.size.width/2-messagebox.size.width/2 positionY:self.view.frame.size.height/2-messagebox.size.height/2];
    //[self.view addSubview:messageBox];
    
    UILabel *pause_lable = [UikitFramework createLableWithText:@"YOUR TIME TO COMPLETE\nTHE IMAGE HAS ENDED.\n\nWE WILL EXTEND IT" positionX:self.view.frame.size.width/2-messagebox.size.width/2 - 40 positionY:self.view.frame.size.height/2-messagebox.size.height/2 + 20  width:messagebox.size.width height:messagebox.size.height/2];
    pause_lable.numberOfLines = 0;
    pause_lable.font = [UIFont fontWithName:[UikitFramework getFontName] size:15];
    [self.view addSubview:pause_lable];
    [self.pauseViews addObject:pauseView];
    [self.pauseViews addObject:messagebox];
    [self.pauseViews addObject:pause_lable];
    
    [UIView animateWithDuration:0.5 
                          delay:2.0 
                        options:UIViewAnimationOptionBeginFromCurrentState 
                     animations:^{
                         pauseView.alpha=0;
                         imageView.alpha=0;
                         pause_lable.alpha=0;
                     } 
                     completion:^(BOOL fin){
                        [self startTimer];
                     }];

}

-(void)askForExtendTime
{
    NSLog(@"askForExtendTime");
    [self clearPauseView];
    UIView *pauseView = [self makeAPauseView];
    UIImage *image2 = [UIImage imageNamed:@"btn_short_green"];
    
    
    UIImage *messagebox;
    /*
     NSString *dialog_box = [NSString stringWithFormat:@"dialog_box_%@",self.maze.name];
     NSLog(@"%@",dialog_box);*/
    
    if (self.maze.pack) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [paths objectAtIndex:0];
        NSString *unzipPath = [path stringByAppendingPathComponent:@"unzip"];
        //NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:unzipPath error:NULL];
        NSString *package = [unzipPath stringByAppendingPathComponent:self.maze.pack.name];
        NSString *images = [package stringByAppendingPathComponent:@"box"];
        NSString *mazeName = [images stringByAppendingPathComponent:[NSString stringWithFormat:@"dialog_box_%@@2x.png",self.maze.name]];
        NSLog(@"%@",mazeName);
        
        NSData *imageData = [NSData dataWithContentsOfFile:mazeName options:0 error:nil];
        messagebox = [UIImage imageWithData:imageData];
        
    }else
    {
        NSString *dialog_box = [NSString stringWithFormat:@"dialog_box_%@",self.maze.name];
        messagebox = [UIImage imageNamed:dialog_box];
    }
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:messagebox];
    imageView.frame = CGRectMake(self.view.frame.size.width/2-311/2 , self.view.frame.size.height/2-162/2, 311, 162);
    [self.view addSubview:imageView];

    int halfViewSize = [self view].frame.size.width / 2;
    UILabel *pause_lable = [UikitFramework createLableWithText:@"YOUR TIME TO COMPLETE\nTHE IMAGE HAS ENDED.\n\nDO YOU WANT TO EXTEND IT?" positionX:self.view.frame.size.width/2-311/2 - 40 positionY:self.view.frame.size.height/2-162/2 + 20  width:311 height:162/2];
    pause_lable.font = [UIFont fontWithName:[UikitFramework getFontName] size:10];
    pause_lable.numberOfLines = 0;
    [self.view addSubview:pause_lable];
    UIButton * continueButton = [UikitFramework createButtonWithBackgroudImage:@"btn_short_green" title:@"YES" positionX:halfViewSize - image2.size.width -15 positionY:self.view.frame.size.height/2+162/2];
    [continueButton addTarget:self action:@selector(wantToExtendTimeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:continueButton];
    
    UIButton *quitButton = [UikitFramework createButtonWithBackgroudImage:@"btn_short_red" title:@"NO" positionX:halfViewSize +15 positionY:self.view.frame.size.height/2+162/2];
    [quitButton addTarget:self action:@selector(wantToQuitButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:quitButton];

    [self.pauseViews addObject:pauseView];
    [self.pauseViews addObject:imageView];
    [self.pauseViews addObject:pause_lable];
    [self.pauseViews addObject:continueButton];
    [self.pauseViews addObject:quitButton];
    
}

-(void)wantToExtendTimeButtonTapped:(UIButton*)sender
{
    self.numberOfExtendedTimes++;
    [self clearPauseView];
    [self addTimerUnitsToScreen];
    [self startTimer];

}

-(void)gameLosedWithTimer
{
    NSLog(@"gameLosedWithTimer");
    [self clearPauseView];
    UIView *pauseView = [self makeAPauseView];
    
    UIImage *messagebox;
    /*
     NSString *dialog_box = [NSString stringWithFormat:@"dialog_box_%@",self.maze.name];
     NSLog(@"%@",dialog_box);*/
    
    if (self.maze.pack) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [paths objectAtIndex:0];
        NSString *unzipPath = [path stringByAppendingPathComponent:@"unzip"];
        //NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:unzipPath error:NULL];
        NSString *package = [unzipPath stringByAppendingPathComponent:self.maze.pack.name];
        NSString *images = [package stringByAppendingPathComponent:@"box"];
        NSString *mazeName = [images stringByAppendingPathComponent:[NSString stringWithFormat:@"dialog_box_%@@2x.png",self.maze.name]];
        NSLog(@"%@",mazeName);
        
        NSData *imageData = [NSData dataWithContentsOfFile:mazeName options:0 error:nil];
        messagebox = [UIImage imageWithData:imageData];
        
    }else
    {
        NSString *dialog_box = [NSString stringWithFormat:@"dialog_box_%@",self.maze.name];
        messagebox = [UIImage imageNamed:dialog_box];
    }
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:messagebox];
    imageView.frame = CGRectMake(self.view.frame.size.width/2-311/2 , self.view.frame.size.height/2-162/2, 311, 162);
    [self.view addSubview:imageView];

    int halfViewSize = [self view].frame.size.width / 2;
    UILabel *pause_lable = [UikitFramework createLableWithText:@"YOUR TIME TO COMPLETE\nTHE IMAGE HAS ENDED.\n\nRETURN TO MENU." positionX:self.view.frame.size.width/2-311/2 - 40 positionY:self.view.frame.size.height/2-162/2 + 20  width:311 height:162/2];
    pause_lable.numberOfLines = 0;
    pause_lable.font = [UIFont fontWithName:[UikitFramework getFontName] size:10];
    [self.view addSubview:pause_lable];
    UIButton *quitButton = [UikitFramework createButtonWithBackgroudImage:@"btn_short_green" title:@"GO TO MENU" positionX:halfViewSize +15 positionY:self.view.frame.size.height/2+162/2];
    quitButton.titleLabel.font = [UIFont fontWithName:[UikitFramework getFontName] size: 10];
    [quitButton addTarget:self action:@selector(wantToQuitButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:quitButton];

    [self.pauseViews addObject:pauseView];
    [self.pauseViews addObject:messagebox];
    [self.pauseViews addObject:quitButton];

}

-(UIView *)makeAPauseView
{
    UIView *pauseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    pauseView.backgroundColor = [UIColor blackColor];
    pauseView.alpha = 0.9;
    [self.view addSubview:pauseView];
    
    return pauseView;
}

-(UIImageView *)makeAMessageBox:(NSString*)name
{
    UIImage *messagebox = [UIImage imageNamed:@"dialog_time_up"];
    
    UIImageView * imageView = [UikitFramework createImageViewWithImage:@"dialog_time_up" positionX:self.view.frame.size.width/2-messagebox.size.width/2 positionY:self.view.frame.size.height/2-messagebox.size.height/2];
    [self.view addSubview:imageView];
    return imageView;
}

-(void)gameLosed {
    UIView *pauseView = [self makeAPauseView];
    UIImageView *imageView;
    UILabel *pause_lable;
    UIButton *continueButton;
    UIButton *quitButton;
    NSMutableArray *gameLostElements = [[NSMutableArray alloc]init];
    
    int halfViewSize = [self view].frame.size.width / 2;
    UIImage *image2 = [UIImage imageNamed:@"btn_green"];
    
    UIImage *messagebox;
    /*
     NSString *dialog_box = [NSString stringWithFormat:@"dialog_box_%@",self.maze.name];
     NSLog(@"%@",dialog_box);*/
    
    if (self.maze.pack) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [paths objectAtIndex:0];
        NSString *unzipPath = [path stringByAppendingPathComponent:@"unzip"];
        //NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:unzipPath error:NULL];
        NSString *package = [unzipPath stringByAppendingPathComponent:self.maze.pack.name];
        NSString *images = [package stringByAppendingPathComponent:@"box"];
        NSString *mazeName = [images stringByAppendingPathComponent:[NSString stringWithFormat:@"dialog_box_%@@2x.png",self.maze.name]];
        NSLog(@"%@",mazeName);
        
        NSData *imageData = [NSData dataWithContentsOfFile:mazeName options:0 error:nil];
        messagebox = [UIImage imageWithData:imageData];
        
    }else
    {
        NSString *dialog_box = [NSString stringWithFormat:@"dialog_box_%@",self.maze.name];
        messagebox = [UIImage imageNamed:dialog_box];
    }
    
    
    imageView = [[UIImageView alloc]initWithImage:messagebox];
    imageView.frame = CGRectMake(self.view.frame.size.width/2-311/2 , self.view.frame.size.height/2-162/2, 311, 162);
    [self.view addSubview:imageView];
    
    if (self.clickError >= 3) 
    {
        
        
        pause_lable = [UikitFramework createLableWithText:@"UPS...\nALMOST THERE!\n\nDO YOU WANT\nTO\nCONTINUE?" positionX:self.view.frame.size.width/2-messagebox.size.width/2 + 50 positionY:self.view.frame.size.height/2-messagebox.size.height/2  width:messagebox.size.width height:messagebox.size.height];
        pause_lable.numberOfLines = 0;
        pause_lable.textAlignment = UITextAlignmentCenter;
        pause_lable.font = [UIFont fontWithName:[UikitFramework getFontName] size: 15];
        [self.view addSubview:pause_lable];

        continueButton = [UikitFramework createButtonWithBackgroudImage:@"btn_green" title:@"YES" positionX:halfViewSize - image2.size.width -15 positionY:self.view.frame.size.height/2+162/2];
        [continueButton addTarget:self action:@selector(gameLostResumeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:continueButton];

        quitButton = [UikitFramework createButtonWithBackgroudImage:@"btn_red" title:@"NO" positionX:halfViewSize +15 positionY:self.view.frame.size.height/2+162/2];
        [quitButton addTarget:self action:@selector(wantToQuitButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:quitButton];
        
        
        [gameLostElements addObject:pauseView];
        [gameLostElements addObject:imageView];
        [gameLostElements addObject:pause_lable];
        [gameLostElements addObject:continueButton];
        [gameLostElements addObject:quitButton];
        
    }else 
    {
        
    }
    
    for (int c = 0; c < [gameLostElements count]; c++) {
        id obj = [gameLostElements objectAtIndex:c];
        [obj setAlpha:0];
        [self.pauseViews addObject:obj];
    }
    
        
    
    [UIView animateWithDuration:0.5 
                          delay:0.0 
                        options:UIViewAnimationOptionBeginFromCurrentState 
                     animations:^{
                         /*for (int c = 0; c < [gameLostElements count]; c++) {
                             id obj = [gameLostElements objectAtIndex:c];
                             [obj setAlpha:1];
                         }*/
                         pauseView.alpha = 0.9;
                         imageView.alpha=1;
                         pause_lable.alpha=1;
                         continueButton.alpha=1;
                         quitButton.alpha=1;

                    } 
                     completion:^(BOOL fin){
                    
                     }];
}

-(void)gameLostResumeButtonTapped:(UIButton*)sender{
    [self clearPauseWinLoseScreens];
    [self clearTimer];
    [self addTimerUnitsToScreen];
    [self restartNumberOfErrors];
    self.clickError = 0;
    [self startTimer];
}

-(void)backToMenu {
    NSArray *viewControllers = [[self navigationController] viewControllers];
    for (int c=0; c < [viewControllers count]; c++) {
        id obj = [viewControllers objectAtIndex:c];
        if([obj isKindOfClass:[InicialViewController class]])
            [self.navigationController popToViewController:obj animated:YES];    
    }
}

-(void)backToResumeGames {
    NSArray *viewControllers = [[self navigationController] viewControllers];
    for (int c=0; c < [viewControllers count]; c++) {
        id obj = [viewControllers objectAtIndex:c];
        if([obj isKindOfClass:[resumeGameViewController class]])
            [self.navigationController popToViewController:obj animated:YES];    
    }
}

-(void)backToMazeView {
    NSArray *viewControllers = [[self navigationController] viewControllers];
    for (int c=0; c < [viewControllers count]; c++) {
        id obj = [viewControllers objectAtIndex:c];
        if([obj isKindOfClass:[ImagesForThemeCarouselViewController class]])
            [self.navigationController popToViewController:obj animated:YES];    
    }
}


#pragma mark - Timer 

-(void)timerCallForReal:(NSTimer *)timer 
{
    self.timerForReal ++;
}

-(void)startTimer {
    float interval = [_mazeHelper getMazeAvailableTime] / timeUnitNumber;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:interval 
                                                  target:self 
                                                selector:@selector(timerCall:) 
                                                userInfo:nil 
                                                 repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    

    self.timerForRealTime = [NSTimer scheduledTimerWithTimeInterval:1 
                                                  target:self 
                                                selector:@selector(timerCallForReal:) 
                                                userInfo:nil 
                                                 repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}



-(void)stopTimer {
    [self.timer invalidate];
    [self.timerForRealTime invalidate];
}



-(void)clearTimer {
    while ([self.timerUnits count]> 0) {
        UIView *view = [self.timerUnits lastObject];
        [view removeFromSuperview];
        [self.timerUnits removeLastObject];
    }
    while ([self.timerUnitsUsed count]> 0) {
        UIView *view = [self.timerUnitsUsed lastObject];
        [view removeFromSuperview];
        [self.timerUnitsUsed removeLastObject];
    }
}



-(void)addTimerUnitsToScreen {
    for (int c =0; c<timeUnitNumber; c++) {
        UIImageView *timerimageview = [UikitFramework createImageViewWithImage:@"time_unit_white" positionX:30+offset*c positionY:10];
        [self.view addSubview:timerimageview];
        [self.timerUnits addObject:timerimageview];
    } 
}



-(void)clearPauseWinLoseScreens {
    while ([self.pauseViews count]> 0) {
        UIView *view = [self.pauseViews lastObject];
        [view removeFromSuperview];
        [self.pauseViews removeLastObject];
    }
}

-(void)setupImage
{
    UIImage *rightImage;
    UIImage *leftImage;
    
    if (self.maze.pack) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [paths objectAtIndex:0];
        NSString *unzipPath = [path stringByAppendingPathComponent:@"unzip"];
        //NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:unzipPath error:NULL];
        NSString *package = [unzipPath stringByAppendingPathComponent:self.maze.pack.name];
        NSString *images = [package stringByAppendingPathComponent:@"images"];
        NSString *difficulty = [images stringByAppendingPathComponent:self.maze.dificulty.name];
        NSString *mazeName = [difficulty stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",self.maze.name]];
        NSString *mazeNameright = [difficulty stringByAppendingPathComponent:[NSString stringWithFormat:@"%@A.jpg",self.maze.name]];
        NSLog(@"%@ - %@",mazeName,mazeNameright);
        
        NSData *imageData = [NSData dataWithContentsOfFile:mazeName options:0 error:nil];
        NSData *imageDataright = [NSData dataWithContentsOfFile:mazeNameright options:0 error:nil];
        leftImage = [UIImage imageWithData:imageData];
        rightImage = [UIImage imageWithData:imageDataright];

    }else{
        rightImage = [_mazeHelper getRightImage];
        leftImage = [_mazeHelper getLeftImage];
    }
    [_rightImageView setImage:rightImage];
    [_leftImageView setImage:leftImage];
    
    float minimumScale = _rightImageView.frame.size.width / rightImage.size.width;
     NSLog(@"_rightImageView.frame.size.width = %frightImage.size.width = %f",_rightImageView.frame.size.width,rightImage.size.width);
    
    [_mazeHelper setInitialZoomScale:minimumScale];
    [_mazeHelper setViewSize:rightImage.size];
    
    if (self.followUp == 0) {
        _rightImageView.frame = CGRectMake(0, 0, rightImage.size.width, rightImage.size.height);
        _leftImageView.frame = CGRectMake(0, 0, leftImage.size.width, leftImage.size.height);

    }
        
    self.timerForReal = 0;
    float initialZoomScale = [_mazeHelper initialZoomScale];
    float maximumZoomScale = (initialZoomScale * [_mazeHelper getMazeZoomFactor]);
    
    NSLog(@"inicial zoomscale = %f max zoomscale = %f",initialZoomScale,maximumZoomScale);
    
    
    [_leftScrollView setMaximumZoomScale:maximumZoomScale];
    [_leftScrollView setMinimumZoomScale: minimumScale];
    [_leftScrollView setZoomScale:initialZoomScale];
    
    [_rightScrollView setMaximumZoomScale:maximumZoomScale];
    [_rightScrollView setMinimumZoomScale:minimumScale];
    [_rightScrollView setZoomScale:initialZoomScale];

    
    for (int c=0; c < [_mazeHelper.mazeDifferences count]; c++) {
        Differences *difference = [_mazeHelper.mazeDifferences objectAtIndex:c];
        [CGMarkerHelper drawMarker:difference inView:_rightImageView insecundView:_leftImageView inBounds:[_mazeHelper viewSize]];
    }
}


#pragma mark - View Specific Methods 

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    /*
    FBLoginView *loginview = 
    [[FBLoginView alloc] initWithPermissions:[NSArray arrayWithObject:@"status_update"]];//@"publish_actions"]];
    
    loginview.frame = CGRectOffset(loginview.frame, self.view.frame.size.width / 2 - loginview.frame.size.width / 2, 5);
    loginview.delegate = self;
    
    [self.view addSubview:loginview];
     */
    
    self.step_for_testing = 0;
    self.positionX_For_Testing = 0;
    self.positionY_For_Testing = 0;
    self.numberOfExtendedTimes = 0;
    
    [self.slider setProgress:1.0];
    
    [self setupImage];    
    
    self.clickOk = 0;
    self.clickError = 0;
    
    UIImageView *imageview = [UikitFramework createImageViewWithImage:@"topbar_game_new" positionX:0 positionY:0];
    [self.view addSubview:imageview];
    
    
    [self addTimerUnitsToScreen];

    
    UIButton *pausebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    pausebutton.frame = CGRectMake(self.view.frame.size.width - 50,0 , 50, 32);
    [pausebutton addTarget:self action:@selector(pauseButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [pausebutton setTitle:@"PAUSE" forState:UIControlStateNormal];
    pausebutton.backgroundColor = [UIColor clearColor];
    pausebutton.titleLabel.font = [UIFont fontWithName:[UikitFramework getFontName] size: 10];
    pausebutton.titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:pausebutton];

    
    
    UILabel *SCORE_lable = [UikitFramework createLableWithText:@"SCORE" positionX:self.view.frame.size.width/2 + 55 positionY:0 width:50 height:30];
    SCORE_lable.font = [UIFont fontWithName:[UikitFramework getFontName] size: 10];
    [self.view addSubview:SCORE_lable];
       
    UILabel *score_lable = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 + 120, 0, 50, 30)];
    score_lable.text = @"000000";
    score_lable.backgroundColor = [UIColor clearColor];
    //score_lable.font = [UIFont fontWithName:fontName size: fontSize+5];
    score_lable.font = [UIFont fontWithName:[UikitFramework getFontName] size: 10];
    score_lable.textColor = [UIColor whiteColor];
    score_lable.tag = 0;
    [self.view addSubview:score_lable];
    self.score = score_lable;
    [self restartStar];
    [self restartNumberOfErrors];
    
    
     
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *gameState = [prefs stringForKey:@"gameState"];
    if ([gameState isEqualToString:@"paused"]) {
        for (int c=0; c < [_mazeHelper.mazeDifferences count]; c++) {
            Differences *difference = [_mazeHelper.mazeDifferences objectAtIndex:c];
            
            //Helper
            if([difference.discovered isEqualToString:@"YES"]){
                [CGMarkerHelper drawMarker:difference inView:_rightImageView insecundView:_leftImageView inBounds:[_mazeHelper viewSize]];
                [self updateStars];
            }
        }
        int errors = [self.maze.differencesMissed intValue]; 
        for (int c=0; c<errors; c++) {
            [self updateNumberOfErrors];
        }
        int score = [self.maze.personalscore intValue];
        self.score.text = [self getNewScore:score];
        self.score.tag = score;
        int time = [self.maze.timeRemaining intValue];
        for (int c=0; c<time; c++) {
            [self updateTimerUnits];
        }
        self.clickError = errors;
        self.timerForReal = [self.maze.personalTime intValue];
        NSLog(@"timer is %d",self.timerForReal);
    }
    [self startTimer];
}

-(void)removeAllNumberOfErrors {
    while ([self.numberOfErrors count]> 0) {
        UIView *view = [self.numberOfErrors lastObject];
        [view removeFromSuperview];
        [self.numberOfErrors removeLastObject];
    }
    while ([self.numberOfErrorsRed count]> 0) {
        UIView *view = [self.numberOfErrorsRed lastObject];
        [view removeFromSuperview];
        [self.numberOfErrorsRed removeLastObject];
    }
}

-(void)restartNumberOfErrors{
    [self removeAllNumberOfErrors];
    for (int c = 1; c > -2; c--) {
        UIImage *starimage = [UIImage imageNamed:@"differences_white_cross"];
        UIImageView *starimageview = [UikitFramework createImageViewWithImage:@"differences_white_cross" positionX:self.view.frame.size.width/2 + 10 -starimage.size.width/2 + starOffset * c + numberOfErrorsOffSet positionY:15];
        [self.view addSubview:starimageview];
        [self.numberOfErrors addObject:starimageview];
    }

}

-(void)viewWillDisappear:(BOOL)animated {
    [self stopTimer];
    [super viewWillDisappear:animated];
}

-(void)registerFacebookNotification
{
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(sessionStateChanged:)
     name:FBSessionStateChangedNotification
     object:nil];

}

-(void)unRegisterFacebookNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidLoad {
    [super viewDidLoad];     
    
    [[MyDocumentHandler sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document){
        _document = document;
    }];
    
    [self setupWithHelper:self.maze andContext:self.context];

    self.followUp = 0;
    _rightScrollView.delegate = self;
    _leftScrollView.delegate = self;
    [_rightScrollView setScrollEnabled:YES];
    [_leftScrollView setScrollEnabled:YES];
    [self addGestures];
    //[self registerFacebookNotification];
    
}

-(void)viewDidUnload {
    //[self unRegisterFacebookNotification];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

/**
 * 
 *
 */

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!scrollView.zooming) {
        if (scrollView.tag == 1 && scrollView.dragging) {
            [_leftScrollView setContentOffset: scrollView.contentOffset];
        } else if (scrollView.tag == 2 && scrollView.dragging) {
            [_rightScrollView setContentOffset: scrollView.contentOffset];
        }
    }
}

- (CGRect)zoomRectForScrollView:(UIScrollView *)scrollView 
                      withScale:(float)scale withCenter:(CGPoint)center {
    CGRect zoomRect;
    
    zoomRect.size.height = scrollView.frame.size.height / scale;
    zoomRect.size.width  = scrollView.frame.size.width  / scale;
    
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    UIView* result = _rightImageView;
    if (scrollView.tag != 1) {
        result = _leftImageView;
    }
    
    return result;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

@end
