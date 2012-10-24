//
//  Pack.h
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 9/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Maze;

@interface Pack : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *mazes;
@end

@interface Pack (CoreDataGeneratedAccessors)

- (void)addMazesObject:(Maze *)value;
- (void)removeMazesObject:(Maze *)value;
- (void)addMazes:(NSSet *)values;
- (void)removeMazes:(NSSet *)values;

@end
