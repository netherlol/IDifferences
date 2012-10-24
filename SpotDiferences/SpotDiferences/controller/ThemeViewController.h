//
//  ThemeViewController.h
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 6/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "UikitFramework.h"
#import "InicialViewController.h"

@interface ThemeViewController : UIViewController <iCarouselDelegate,iCarouselDataSource>
@property (nonatomic, retain) IBOutlet iCarousel *carousel;
@property (nonatomic, retain) IBOutlet UINavigationItem *navItem;
@property (nonatomic, weak) IBOutlet UIManagedDocument *document;
@property (nonatomic, retain) NSArray *themes;
@property (nonatomic, weak) IBOutlet UIPageControl *pagecontrol;
@end
