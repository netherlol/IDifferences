//
//  Pack+manage.h
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 9/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Pack.h"

@interface Pack (manage)
+ (Pack *)createPack:(NSString *)name
inManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSArray *)getAllPacks:(NSManagedObjectContext *)context;
@end
