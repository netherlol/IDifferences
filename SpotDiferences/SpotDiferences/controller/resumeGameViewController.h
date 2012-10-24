//
//  resumeGameViewController.h
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 8/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "UikitFramework.h"
#import "InicialViewController.h"

@interface resumeGameViewController : UIViewController<iCarouselDataSource,iCarouselDelegate>
@property (nonatomic, retain) IBOutlet iCarousel *carousel;
@property (nonatomic, retain) IBOutlet UINavigationItem *navItem;
@property (nonatomic, weak) UIManagedDocument *document;
@property (nonatomic, weak) IBOutlet UIPageControl *pagecontrol;
@property (nonatomic, retain) NSArray *mazes;


@end
