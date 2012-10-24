//
//  Differences.h
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 9/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DifferenceSet;

@interface Differences : NSManagedObject

@property (nonatomic, retain) NSString * discovered;
@property (nonatomic, retain) NSNumber * downrightX;
@property (nonatomic, retain) NSNumber * downrightY;
@property (nonatomic, retain) NSNumber * upleftX;
@property (nonatomic, retain) NSNumber * upleftY;
@property (nonatomic, retain) DifferenceSet *foto;

@end
