//
//  DifferenceSet+Manage.m
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 8/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DifferenceSet+Manage.h"

@implementation DifferenceSet (Manage)

+ (DifferenceSet *)createDifferenceFoto:(NSString *)name
                                  forMaze:(Maze *)maze
                   inManagedObjectContext:(NSManagedObjectContext *)context {
    
    DifferenceSet *differenceFotos = nil;
    
    NSFetchRequest *request = 
    [NSFetchRequest fetchRequestWithEntityName:@"DifferenceSet"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    NSSortDescriptor *sortDescriptor = 
    [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError * error = nil;
    NSArray * matches = [context executeFetchRequest:request error:&error];
    
    if(!matches || ([matches count]>1)){
        
    } else if ([matches count] == 0){
        differenceFotos = [NSEntityDescription insertNewObjectForEntityForName:@"DifferenceSet" inManagedObjectContext:context];
        differenceFotos.name = name;
        differenceFotos.maze = maze;
    } else {
        differenceFotos = [matches lastObject];
    } 
    
    
    return differenceFotos;
}


/**
 *
 *
 **/
+ (NSSet*)getDiffs:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context {
    
    NSFetchRequest *request = 
    [NSFetchRequest fetchRequestWithEntityName:@"DifferenceSet"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    NSSortDescriptor *sortDescriptor = 
    [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError * error = nil;
    NSArray * matches = [context executeFetchRequest:request error:&error];
    
    if([matches count] > 0) {
        DifferenceSet *foto = [matches objectAtIndex:0];
        return foto.differences;
    }
    
    return nil;
    
}


@end
