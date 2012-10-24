//
//  Theme+Create.h
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 6/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Theme.h"

@interface Theme (Create)
+ (Theme *)createTheme:(NSString *)name
                  foto:(NSString *)foto
inManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSArray *)getAllThemes:(NSManagedObjectContext *)context;
+ (Theme *)getTheme:(NSString *)name
inManagedObjectContext:(NSManagedObjectContext *)context;
@end
