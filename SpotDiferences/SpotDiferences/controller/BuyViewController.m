//
//  BuyViewController.m
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 8/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BuyViewController.h"
#import "MyDocumentHandler.h"
#import "Maze+Manage.h"
#import "SoundManager.h"
#import "Pack+manage.h"
#import "ConnectionManager.h"
#import "BuyDetailsViewController.h"
#import "AppDelegate.h"

#define NUMBER_OF_ITEMS 3
#define ITEM_SPACING 210
#define USE_BUTTONS YES

@interface BuyViewController ()<UIActionSheetDelegate,iapProtocol>
@property (nonatomic, assign) BOOL wrap;
@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic ,weak) UIActivityIndicatorView *spinner;
@property (nonatomic,strong) NSMutableArray *validProducts;
@property (nonatomic,strong) NSArray *products;
@property (nonatomic,weak) UILabel *Noproducts;
@property (nonatomic) int timeout;
@end

@implementation BuyViewController

@synthesize carousel;
@synthesize navItem;
@synthesize wrap;
@synthesize items;

-(NSMutableArray*)validProducts {
    if (!_validProducts) {
        _validProducts = [[NSMutableArray alloc]init];
    }
    return _validProducts;
}

-(void)returnListOfProducts:(NSArray*)products
{
        
    self.products = products;
    NSSet *productsaux = [self productsValidation:products];
    [self makeProductRequest:productsaux];
    self.timeout = 1;
}

-(NSSet*)productsValidation:(NSArray*)productList
{
    NSMutableDictionary *availableList = [NSMutableDictionary dictionary];
    
    for (int c = 0; c < [productList count]; c++) {
        NSDictionary* productData = [productList objectAtIndex:c];
        for (NSString* key in productData) {
            if ([key isEqualToString:@"externalId"]) {
                NSString *value = [productData objectForKey:key];
                [availableList setObject:[key mutableCopy] forKey:value];
            }
        }
    }
    NSLog(@"Added %d products", [availableList count] );
    return [NSSet setWithArray:[availableList allKeys]];
    
}


-(void)makeProductRequest:(NSSet*)products
{
    if ([SKPaymentQueue canMakePayments]) {
		// Yes, In-App Purchase is enabled on this device!
		// Proceed to fetch available In-App Purchase items.
		NSLog(@"Can make Payments");
        
        NSArray *testarray = [products allObjects];
        for (int c = 0; c < [testarray count]; c++) {
            NSString *e = [testarray objectAtIndex:c];
            NSLog(@"%@",e);
        }
        //Fetch ProductList
        
		// Replace "Your IAP Product ID" with your actual In-App Purchase Product ID,
		// fetched from either a remote server or stored locally within your app.
		SKProductsRequest *prodRequest= [[SKProductsRequest alloc] initWithProductIdentifiers: products];
		prodRequest.delegate = self;
		[prodRequest start];
        
		
	} else {
		// Notify user that In-App Purchase is disabled via button text.
        NSLog(@"Can not make Payments");
	}

}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    self.timeout = 2;
    // TODO: method refactoring needed
    int count = [response.products count];
    NSLog(@"Reponse Products %@ - %@" , response.products,response.invalidProductIdentifiers);
    [self.validProducts removeAllObjects];
    if (count>0) {
        
        for (SKProduct *product in response.products ) {
            NSLog(@"Remote identifier is %@",product.productIdentifier);
            int found = 0;
            for (int c = 0; c < [self.products count]; c++) {
                NSMutableDictionary* element = [[self.products objectAtIndex:c] mutableCopy];
                for (NSString* key in element) {
                    if ([key isEqualToString:@"externalId"]) {
                        NSLog(@"%@ - %@",[element objectForKey:key],product.productIdentifier);
                        if ([[element objectForKey:key] isEqualToString:product.productIdentifier]) {
                            [element setObject:product forKey:@"product"];
                            [self.validProducts addObject:element];
                            found = 1;
                        }
                    }
                }
                if (found == 1) {
                    break;
                }
            }
        }
        
	}
    if (count == 0) {
        //self.Noproducts = [UikitFramework createLableWithText:@"NO PACK AVAILABLE" positionX:50 positionY:150 width:260 height:50];
        //[self.view addSubview:self.Noproducts];
    
    }
    [self.carousel reloadData];
    
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
	HUD.mode = MBProgressHUDModeCustomView;
	[HUD hide:YES afterDelay:1];
    //[self.spinner stopAnimating];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{
    UIImage *image = [UIImage imageNamed: @"ios_buy_more_box"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    UILabel *score_lable = [[UILabel alloc] initWithFrame:CGRectMake(5, 70, image.size.width,image.size.height)];

    
    if (index == self.carousel.numberOfItems -1)
    {
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setTitle:@"" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = index;
        
        score_lable.text = @"RESTORE";
        score_lable.backgroundColor = [UIColor clearColor];
        score_lable.font = [UIFont fontWithName:[UikitFramework getFontName] size: 15];
        score_lable.textColor = [UIColor grayColor];
        score_lable.textAlignment = UITextAlignmentCenter;

    }else
    {
        NSDictionary *product = [[self validProducts] objectAtIndex:index];
        
        NSString *imageUrl = [self getimageurl:product];
        NSLog(@"%@",imageUrl);
        
        
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        image = [UIImage imageWithData:data];
        
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setTitle:@"" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = index;
        
        score_lable.text = [[self getName:product] capitalizedString];
        score_lable.backgroundColor = [UIColor clearColor];
        score_lable.font = [UIFont fontWithName:[UikitFramework getFontName] size: 15];
        score_lable.textColor = [UIColor grayColor];
        score_lable.textAlignment = UITextAlignmentCenter;

    }
    
        
    [button addSubview:score_lable];
    return button;
    
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

-(NSString*)getPrice:(NSDictionary*)product
{
    SKProduct* remoteProduct = [product valueForKey:@"product"];
    
    return [remoteProduct.price description];
}

-(void)awakeFromNib
{
    //NSLog(@"inside awakeFromNib%d",[[self themes] count]);
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    
    
    if ((self = [super initWithCoder:aDecoder]))
    {
        //code here
        [[MyDocumentHandler sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document){
            _document = document;
        }];
    }
    return self;
}

-(void)setDocumentHelper:(UIManagedDocument *)document
{
    [AppDelegate retrieveConnectionManager].document = self.document;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    wrap = YES;
	
	UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
	backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	backgroundView.image = [UIImage imageNamed:@"background_clear"];
	[self.view addSubview:backgroundView];
	
	self.carousel = [[iCarousel alloc] initWithFrame:self.view.bounds];
	carousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    carousel.type = iCarouselTypeLinear;
	carousel.delegate = self;
	carousel.dataSource = self;
    
	[self.view addSubview:carousel];
    
    
    
        
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    self.timeout = 0;
    [[MyDocumentHandler sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document){
        _document = document;
        [self setDocumentHelper:_document];
    }];
    
    [AppDelegate retrieveConnectionManager].delegate = self;
    [[AppDelegate retrieveConnectionManager] getProductList];
    if (self.carousel.numberOfItems > 1) {
        [self.carousel scrollToItemAtIndex:1 animated:NO];
    }
    /*
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    spinner.frame = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 30, 30);
    self.spinner = spinner;
    
    [self.view addSubview:self.spinner];
    [self.spinner startAnimating];
     */
    HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
	HUD.delegate = self;
    
    [self performSelector:@selector(timeoutCall) withObject:nil afterDelay:10];
}

-(void)timeoutCall
{
    NSLog(@"timer called %d",self.timeout);
    if (self.timeout == 0) {
        [HUD hide:YES];
        [self makeAAlertView:@"FAIL" message:@"SERVER ERROR TRY AGAIN LATER..."];
    }else if(self.timeout == 1){
        [HUD hide:YES];
        [self makeAAlertView:@"FAIL" message:@"APPLE STORE ERROR TRY AGAIN LATER..."];
    }
    
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
    
    int count = [self.validProducts count];
    for (int i = 0; i < count; i++)
    {
        [items addObject:[NSNumber numberWithInt:i]];
    }
    
    
    
    
    return count+1;
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

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
    int c = self.carousel.currentItemIndex / 3;
    self.pagecontrol.currentPage = c;
}

-(void)playSound
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *sound = [prefs stringForKey:@"sound"];
    //NSLog(@"%@",sound);
    if ([sound isEqualToString:@"YES"]) {
        [[SoundManager sharedSoundManager] playIntro];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self playSound];
    
    UIImage *bimage = [UIImage imageNamed:@"btn_back"];
    
    UIButton *bbutton = [UikitFramework createButtonWithBackgroudImage:@"btn_back" title:@"" positionX:10 positionY:10]; 
    [bbutton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bbutton];
    
    UIButton *homeButton = [UikitFramework createButtonWithBackgroudImage:@"btn_home" title:@"" positionX:self.view.frame.size.width - 10 - bimage.size.width positionY:10]; 
    [homeButton addTarget:self action:@selector(homeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:homeButton];
    
    UILabel *label = [UikitFramework createLableWithText:@"SELECT PACK" positionX:0 positionY:0 width:self.view.frame.size.width height:60];
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)sender
{
    BuyDetailsViewController *controller = (BuyDetailsViewController*)segue.destinationViewController;
    controller.product = [self.validProducts objectAtIndex:sender.tag];
}

-(void)performSegueForActivity
{
}

- (void)buttonTapped:(UIButton *)sender
{
    if (sender.tag == self.carousel.numberOfItems -1)
    {
        [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];

    }else
        [self performSegueWithIdentifier:@"buy detail view controller" sender:sender];
        
}


-(void)viewDidDisappear:(BOOL)animated
{

    [super viewDidDisappear:animated];
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
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alertView show];
}

@end
