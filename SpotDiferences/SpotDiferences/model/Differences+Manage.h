//
//  Differences+Manage.h
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Differences.h"

@interface Differences (Manage)
+ (Differences *)createDifference:(NSNumber*)topleftX
                             topleftY:(NSNumber*)topleftY
                           downrightX:(NSNumber*)downrightX
                           downrightY:(NSNumber*)downrightY
                           differenceFoto:(DifferenceSet*)diffFoto
                   inManagedObjectContext:(NSManagedObjectContext *)context;

@end
