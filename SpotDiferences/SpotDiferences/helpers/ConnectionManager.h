//
//  ConnectionManager.h
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 8/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

#import "BuyViewController.h"
#import "BuyDetailsViewController.h"
#import "NSData+Base64.h"

@interface ConnectionManager : NSObject <SKPaymentTransactionObserver> 
@property (nonatomic,strong)id<iapProtocol> delegate;
@property (nonatomic, weak) IBOutlet UIManagedDocument *document;
@property (nonatomic,strong) NSMutableDictionary *registData;
@property (nonatomic,strong) SKPaymentTransaction * transaction;
-(void)getProductList;
- (void)preparePurchase:(NSDictionary*) product
                   with:(BuyDetailsViewController*) controller;
-(void)signUp:(NSString*)username
     password:(NSString *)password
     nickname:(NSString *)nickname;
-(void)recoverPass:(NSString*)email;
@end
