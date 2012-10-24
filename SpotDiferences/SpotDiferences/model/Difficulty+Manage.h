//
//  Difficulty+Manage.h
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Difficulty.h"

@interface Difficulty (Manage)
+ (Difficulty *)createDifficulty:(NSString *)name
inManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSArray *)getAllDifficultys:(NSManagedObjectContext *)context;
+ (Difficulty *)getDifficulty:(NSString *)name
          inManagedObjectContext:(NSManagedObjectContext *)context;
@end
