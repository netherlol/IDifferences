//
//  Difficulty.h
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 9/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Maze;

@interface Difficulty : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *maze;
@end

@interface Difficulty (CoreDataGeneratedAccessors)

- (void)addMazeObject:(Maze *)value;
- (void)removeMazeObject:(Maze *)value;
- (void)addMaze:(NSSet *)values;
- (void)removeMaze:(NSSet *)values;

@end
