//
//  BuyDetailsViewController.m
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 9/28/12.
//
//

#import "BuyDetailsViewController.h"
#import "ConnectionManager.h"
#import "MyDocumentHandler.h"
#import "SoundManager.h"
#import "UikitFramework.h"
#import "InicialViewController.h"
#import "AppDelegate.h"

@interface BuyDetailsViewController ()<iapProtocol>
@property (nonatomic, weak) IBOutlet UIManagedDocument *document;
@property (nonatomic, weak) UIButton *buyButton;
@end

@implementation BuyDetailsViewController

-(void)setExpectedLenght:(long long)len
{
    expectedLength = len;
	currentLength = 0;
    HUD.mode = MBProgressHUDModeDeterminate;
    HUD.dimBackground = YES;
}

-(void)setCurrentLenght:(long long)len
{
    currentLength += len;
    NSLog(@"%f expectedLength = %f currentLength = %f",currentLength / (float)expectedLength,(float)expectedLength,(float)currentLength);
	HUD.progress = currentLength / (float)expectedLength;
    HUD.labelText = @"Downloading...";
}

-(void)paymentRestore
{
    NSLog(@"payment Restore");
}

-(void)paymentfailed
{
    NSLog(@"payment failed");
    [HUD hide:YES];
    [self makeAAlertView:@"FAILED" message:@"PAYMENT FAILED PLEASE TRY AGAIN LATER"];
}

-(void)payed
{
    NSLog(@"***********payment complete*****************");
    
    //[self makeAAlertView:@"DOWNLOADING..." message:@"WAIT DOWNLOADING IMAGES, CAN TAKE FEW MINUTES..."];
}

-(void)paying
{
  NSLog(@"started to pay");  
}

-(void)doneUnzipping
{
    NSLog(@"delegate call back done unzipping");
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
	HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = @"FINISHED";
    [self performSelector:@selector(goingBack) withObject:nil afterDelay:6];
	[HUD hide:YES afterDelay:6];
    self.buyButton.enabled = NO;
    
    
}

-(void)goingBack
{
    [self.navigationController popViewControllerAnimated:YES];
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
    [[MyDocumentHandler sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document){
        _document = document;
    }];

	// Do any additional setup after loading the view.
    self.imageview.image = [UIImage imageNamed:@"background_clear"];
    
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

    int halfViewSize = [self view].frame.size.width / 2;
    UIImage *bimage = [UIImage imageNamed:@"btn_back"];
    
    UIButton *bbutton = [UikitFramework createButtonWithBackgroudImage:@"btn_back" title:@"" positionX:10 positionY:10];
    [bbutton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bbutton];
    
    UIButton *homeButton = [UikitFramework createButtonWithBackgroudImage:@"btn_home" title:@"" positionX:self.view.frame.size.width - 10 - bimage.size.width positionY:10];
    [homeButton addTarget:self action:@selector(homeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:homeButton];
    
    NSString *imageUrl = [self getimageurl:self.product];
    NSLog(@"%@",imageUrl);
    
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
    
    UIImage *image = [UIImage imageWithData:data];
    
    
    
    UIImageView *imageview = [[UIImageView alloc]init];
    imageview.frame = CGRectMake(10, 70, image.size.width/2, image.size.height/2);
    imageview.image = image;
    //[UikitFramework createImageViewWithImage:fotoPath positionX:10 positionY:70];
    self.imageview = imageview;
    [self.view addSubview:imageview];
    
    UILabel *score_lable = [[UILabel alloc] initWithFrame:CGRectMake(10, 140, image.size.width/2,image.size.height/2)];
    score_lable.text = [[self getName:self.product] capitalizedString];
    score_lable.backgroundColor = [UIColor clearColor];
    score_lable.font = [UIFont fontWithName:[UikitFramework getFontName] size: 15];
    score_lable.textColor = [UIColor grayColor];
    score_lable.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:score_lable];

    UIImage *buyimage = [UIImage imageNamed:@"btn_green"];
    self.buyButton = [UikitFramework createButtonWithBackgroudImage:@"btn_green" title:@"BUY!" positionX:halfViewSize - buyimage.size.width/2 positionY:250];
    [self.buyButton addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.buyButton];
    self.buyButton.enabled = YES;
    
    UILabel *CurrentPoint_lable = [UikitFramework createLableWithText:[self getDescription:self.product] positionX:self.imageview.frame.size.width + 40 positionY:60  width:200 height:100];
    CurrentPoint_lable.textAlignment = UITextAlignmentCenter;
    CurrentPoint_lable.numberOfLines = 0;
    CurrentPoint_lable.font = [UIFont fontWithName:[UikitFramework getFontName] size: 20];
    CurrentPoint_lable.textColor = [UIColor whiteColor];
    [self.view addSubview:CurrentPoint_lable];

    
}

-(NSString*)getimageurl:(NSDictionary*)listProducts
{
    for (NSString* key in listProducts) {
        if ([key isEqualToString:@"thumbnailUrl"]) {
            NSString *element = [listProducts objectForKey:key];
            return element;
        }
        
    }
    return nil;
}

- (void)startAnimating{
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.spinner.frame = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 30, 30);
    
    [self.view addSubview:self.spinner];
    [self.spinner startAnimating];
}

-(void)stopAnimating{
    [self.spinner stopAnimating];
}

-(void)buyButtonTapped:(UIButton*)sender
{
    
    [[AppDelegate retrieveConnectionManager] preparePurchase:self.product with: self];
    [AppDelegate retrieveConnectionManager].delegate = self;
    [AppDelegate retrieveConnectionManager].document = self.document;
    if (![AppDelegate retrieveConnectionManager].transaction) {
        // Replace "Your IAP Product ID" with your actual In-App Purchase Product ID.
        SKProduct *remoteProduct = [self.product objectForKey:@"product"];
        
        SKPayment *paymentRequest = [SKPayment paymentWithProduct: remoteProduct];
        
        // Request a purchase of the selected item.
        //[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
        [[SKPaymentQueue defaultQueue] addPayment:paymentRequest];
        
    }else{
        [self makeAAlertView:@"FAIL" message:@"ALREADY A TRANSACTION IN CURSE"];
    }

    HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
	HUD.delegate = self;
    
}








-(NSString*)getPrice:(NSDictionary*)product
{
    SKProduct* remoteProduct = [product valueForKey:@"product"];
    
    return [remoteProduct.price description];
}

-(NSString*)getexternalId:(NSDictionary*)listProducts
{
    for (NSString* key in listProducts) {
        if ([key isEqualToString:@"externalId"]) {
            NSString *element = [listProducts objectForKey:key];
            return element;
        }
        
    }
    return nil;
}

-(NSString*)getbundleId:(NSDictionary*)listProducts
{
    for (NSString* key in listProducts) {
        if ([key isEqualToString:@"bundleId"]) {
            NSString *element = [listProducts objectForKey:key];
            return element;
        }
        
    }
    return nil;
}

-(NSString*)getDescription:(NSDictionary*)listProducts
{
    for (NSString* key in listProducts) {
        if ([key isEqualToString:@"description"]) {
            NSString *element = [listProducts objectForKey:key];
            return element;
        }
        
    }
    return nil;
}

-(NSString*)getName:(NSDictionary*)listProducts
{
    for (NSString* key in listProducts) {
        if ([key isEqualToString:@"name"]) {
            NSString *element = [listProducts objectForKey:key];
            return element;
        }
        
    }
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)playInterfaceSound
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *sound = [prefs stringForKey:@"sound"];
    
    if ([sound isEqualToString:@"YES"]) {
        [[SoundManager sharedSoundManager] playInterface];
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    //return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
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

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	HUD = nil;
}
@end
