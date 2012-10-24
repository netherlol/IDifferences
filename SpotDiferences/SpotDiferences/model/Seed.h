//
//  Seed.h
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DifferenceSet+Manage.h"

@interface Seed : NSObject
+(void)populateDatabase:(NSManagedObjectContext *)context;
+(void)insertDiffs:(int)topX
              topY:(int)topY
             downX:(int)downX
             downY:(int)downY
         diffFotos:(DifferenceSet*)differenceSet
         inContext:(NSManagedObjectContext*)context;
@end
