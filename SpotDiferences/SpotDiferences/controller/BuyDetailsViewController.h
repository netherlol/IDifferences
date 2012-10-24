//
//  BuyDetailsViewController.h
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 9/28/12.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"


@interface BuyDetailsViewController : UIViewController <MBProgressHUDDelegate> {
	MBProgressHUD *HUD;
    
	long long expectedLength;
	long long currentLength;
}

@property (nonatomic,weak) IBOutlet UIImageView *imageview;
@property (nonatomic,weak) NSDictionary *product;
@property (nonatomic ,strong) UIActivityIndicatorView *spinner;

@end
