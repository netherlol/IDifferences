//
//  Theme.h
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 9/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Maze;

@interface Theme : NSManagedObject

@property (nonatomic, retain) NSString * available;
@property (nonatomic, retain) NSString * foto;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *fotos;
@end

@interface Theme (CoreDataGeneratedAccessors)

- (void)addFotosObject:(Maze *)value;
- (void)removeFotosObject:(Maze *)value;
- (void)addFotos:(NSSet *)values;
- (void)removeFotos:(NSSet *)values;

@end
