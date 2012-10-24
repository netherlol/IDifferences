//
//  MyDocumentHandler.h
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^OnDocumentReady) (UIManagedDocument *document);

@interface MyDocumentHandler : NSObject

@property (strong, nonatomic) UIManagedDocument *document;

+ (MyDocumentHandler *)sharedDocumentHandler;
- (void)performWithDocument:(OnDocumentReady)onDocumentReady;

@end