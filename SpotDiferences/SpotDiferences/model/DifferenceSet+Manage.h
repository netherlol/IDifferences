//
//  DifferenceSet+Manage.h
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 8/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DifferenceSet.h"

@interface DifferenceSet (Manage)

+ (DifferenceSet *)createDifferenceFoto:(NSString *)name
                                  forMaze:(Maze *)maze
                   inManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSSet*)getDiffs:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context;


@end
