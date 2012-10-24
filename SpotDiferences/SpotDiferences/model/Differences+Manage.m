//
//  Differences+Manage.m
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Differences+Manage.h"

@implementation Differences (Manage)
+ (Differences *)createDifference:(NSNumber*)topleftX
                             topleftY:(NSNumber*)topleftY
                           downrightX:(NSNumber*)downrightX
                           downrightY:(NSNumber*)downrightY
                           differenceFoto:(DifferenceSet*)diffFoto
                   inManagedObjectContext:(NSManagedObjectContext *)context
{
    Differences * diff = [NSEntityDescription insertNewObjectForEntityForName:@"Differences" inManagedObjectContext:context];
    diff.upleftX = topleftX;
    diff.upleftY = topleftY;
    diff.downrightX = downrightX;
    diff.downrightY = downrightY;
    diff.foto = diffFoto;
    return diff;
}
@end
