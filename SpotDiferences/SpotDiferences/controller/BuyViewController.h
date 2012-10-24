//
//  BuyViewController.h
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 8/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "MBProgressHUD.h"

#import "iCarousel.h"
#import "UikitFramework.h"
#import "InicialViewController.h"


@protocol iapProtocol <NSObject>

@optional

-(void)returnListOfProducts:(NSArray*)products;
-(void)doneUnzipping;
-(void)paying;
-(void)paymentRestore;
-(void)paymentfailed;
-(void)payed;
-(void)setExpectedLenght:(long long)len;
-(void)setCurrentLenght:(long long)len;
-(void)registSuccess;
-(void)registfailed;
-(void)loginSuccess;
-(void)recoverSuccess;
@end


@interface BuyViewController : UIViewController <iCarouselDelegate,iCarouselDataSource,SKProductsRequestDelegate,MBProgressHUDDelegate> {
	MBProgressHUD *HUD;
    
	long long expectedLength;
	long long currentLength;
}

@property (nonatomic, retain) IBOutlet iCarousel *carousel;
@property (nonatomic, retain) IBOutlet UINavigationItem *navItem;
@property (nonatomic, weak) IBOutlet UIManagedDocument *document;
@property (nonatomic, weak) IBOutlet UIPageControl *pagecontrol;


-(void)returnListOfProducts:(NSSet*)products;
@end