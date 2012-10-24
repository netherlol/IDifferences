//
//  Difficulty+Manage.m
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Difficulty+Manage.h"

@implementation Difficulty (Manage)
+ (Difficulty *)createDifficulty:(NSString *)name
          inManagedObjectContext:(NSManagedObjectContext *)context
{
    
    Difficulty *difficulty = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Difficulty"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError * error = nil;
    NSArray * matches = [context executeFetchRequest:request error:&error];
    if(!matches || ([matches count]>1)){
        
    }else if ([matches count] == 0){
        difficulty = [NSEntityDescription insertNewObjectForEntityForName:@"Difficulty" inManagedObjectContext:context];
        difficulty.name = name;
    }else {
        difficulty = [matches lastObject];
    } 
    
    
    return difficulty;

}

+ (NSArray *)getAllDifficultys:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Difficulty"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError * error = nil;
    NSArray * matches = [context executeFetchRequest:request error:&error];
    
    if([matches count] > 0)
        return matches;
    return nil;
}
+ (Difficulty *)getDifficulty:(NSString *)name
       inManagedObjectContext:(NSManagedObjectContext *)context
{

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Difficulty"];
    request.predicate = [NSPredicate predicateWithFormat:@"(name = %@)", [name lowercaseString]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError * error = nil;
    NSArray * matches = [context executeFetchRequest:request error:&error];
    
    if([matches count] > 0)
        return [matches objectAtIndex:0];
    return nil;

}
@end
