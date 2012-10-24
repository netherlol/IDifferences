//
//  UikitFramework.m
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 8/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UikitFramework.h"

#define fontSize 15
#define fontName @"junegull"

@implementation UikitFramework

+(UIImageView*)createImageViewWithImage:(NSString*)image
                              positionX:(float)positionX
                              positionY:(float)positionY
{
    UIImage *logo = [UIImage imageNamed:image]; 
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(positionX, positionY, logo.size.width, logo.size.height)];
    imageview.image = logo;
    return imageview;
}

+(UIButton*)createButtonWithBackgroudImage:(NSString*)image
                                     title:(NSString*)title
                                 positionX:(float)positionX
                                 positionY:(float)positionY
{
    UIImage *ButtonImage = [UIImage imageNamed:image];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(positionX, positionY, ButtonImage.size.width,ButtonImage.size.height)];
    [button setBackgroundImage:ButtonImage forState:UIControlStateNormal];
    [button setTitle: title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:fontName size: fontSize];
    button.titleLabel.textColor = [UIColor whiteColor];
    
    return button;
}

+(UILabel*)createLableWithText:(NSString*)text
                     positionX:(float)positionX
                     positionY:(float)positionY
                         width:(float)width
                        height:(float)height
{
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(positionX, positionY, width, height)];
    lable.text = text;
    lable.backgroundColor = [UIColor clearColor];
    lable.font = [UIFont fontWithName:fontName size: fontSize];
    lable.textColor = [UIColor whiteColor];
    lable.textAlignment = UITextAlignmentRight;

    return lable;
}

+(NSString*)getStripeByDifficulty:(NSString*)difficulty
{
    if([difficulty isEqualToString:@"beginner"])
        return @"beginner_stripe";
    else if ([difficulty isEqualToString:@"intermediate"]) {
        return @"intermediate_stripe";
    }
    else if ([difficulty isEqualToString:@"expert"]) {
        return @"expert_stripe";
    }
    else {
        return @"detective_stripe";
    }
}
+(void)makeAAlertView:(NSString*)title
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
+(NSString*)getFontName{return @"junegull";}
@end
