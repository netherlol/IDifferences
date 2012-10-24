//
//  Maze+Manage.m
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Maze+Manage.h"

@implementation Maze (Manage)

+ (Maze *)createMaze:(NSString *)name
            forTheme:(Theme *)theme
inManagedObjectContext:(NSManagedObjectContext *)context
{
    Maze *maze = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Maze"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError * error = nil;
    NSArray * matches = [context executeFetchRequest:request error:&error];
     if(!matches || ([matches count]>1)){
   
    }else if ([matches count] == 0){
        maze = [NSEntityDescription insertNewObjectForEntityForName:@"Maze" inManagedObjectContext:context];
        maze.name = name;
        maze.theme = theme;
    }else {
        maze = [matches lastObject];
    } 
    
    
    return maze;
}

+ (NSArray *)getAllMazes:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Maze"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError * error = nil;
    NSArray * matches = [context executeFetchRequest:request error:&error];
    
    if([matches count] > 0)
        return matches;
    return nil;

}

+ (NSArray *)getMazeByDifficulty:(NSString *)difficulty
                           state:(NSString *)state
          inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSString *available = @"YES";
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Maze"];
    request.predicate = [NSPredicate predicateWithFormat:@"(dificulty.name = %@) AND (state=%@) AND (available=%@)",difficulty,state,available];
    //request.predicate = [NSPredicate predicateWithFormat:@"theme.name = %@",theme];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError * error = nil;
    NSArray * matches = [context executeFetchRequest:request error:&error];
    
    if([matches count] > 0)
        return matches;
    return nil;
}

+ (NSArray *)getMazeByThemeAndDifficulty:(NSString *)theme
                              difficulty:(NSString *)difficulty
                  inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSString *available = @"YES";
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Maze"];
    request.predicate = [NSPredicate predicateWithFormat:@"(dificulty.name = %@) AND (theme.name = %@) AND (available=%@)",difficulty,theme,available];
    //request.predicate = [NSPredicate predicateWithFormat:@"theme.name = %@",theme];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError * error = nil;
    NSArray * matches = [context executeFetchRequest:request error:&error];
    
    if([matches count] > 0)
        return matches;
    return nil;
}

+ (NSArray *)getMazeByResumedGames:(NSManagedObjectContext *)context
{
    NSString *state = @"paused";
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Maze"];
    request.predicate = [NSPredicate predicateWithFormat:@"state=%@",state];
    //request.predicate = [NSPredicate predicateWithFormat:@"theme.name = %@",theme];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError * error = nil;
    NSArray * matches = [context executeFetchRequest:request error:&error];
    
    if([matches count] > 0)
        return matches;
    return nil;
}

+ (NSArray *)getMazeByState:(NSString*)state
     inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSString *available = @"YES";
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Maze"];
    request.predicate = [NSPredicate predicateWithFormat:@"(state=%@) AND (available=%@)",state,available];
    //request.predicate = [NSPredicate predicateWithFormat:@"theme.name = %@",theme];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError * error = nil;
    NSArray * matches = [context executeFetchRequest:request error:&error];
    
    if([matches count] > 0)
        return matches;
    return nil;
}

+ (NSArray *)getMazeByThemeDifficultyAndState:(NSString *)theme
                                   difficulty:(NSString *)difficulty
                                        state:(NSString*)state
                       inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSString *available = @"YES";
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Maze"];
    request.predicate = [NSPredicate predicateWithFormat:@"(dificulty.name = %@) AND (theme.name = %@) AND (state=%@) AND (available=%@)",difficulty,theme,state,available];
    //request.predicate = [NSPredicate predicateWithFormat:@"theme.name = %@",theme];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError * error = nil;
    NSArray * matches = [context executeFetchRequest:request error:&error];
    
    if([matches count] > 0)
        return matches;
    return nil;
}

+ (NSArray *)getMaze:(NSString *)theme
inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSString *available = @"YES";
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Maze"];
    request.predicate = [NSPredicate predicateWithFormat:@"(theme.name = %@) AND (available=%@)", theme,available];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError * error = nil;
    NSArray * matches = [context executeFetchRequest:request error:&error];
    
    if([matches count] > 0)
        return matches;
    return nil;
}
+ (Maze *)getMazeByName:(NSString *)name
    inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSString *available = @"YES";
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Maze"];
    request.predicate = [NSPredicate predicateWithFormat:@"(name = %@) AND (available=%@)", name,available];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError * error = nil;
    NSArray * matches = [context executeFetchRequest:request error:&error];
    
    if([matches count] > 0)
        return [matches objectAtIndex:0];
    return nil;

}

+ (Maze *)getMazeByUniqueID:(NSString*)uniqueID
        inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Maze"];
    request.predicate = [NSPredicate predicateWithFormat:@"(uniqueID = %@)", uniqueID];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError * error = nil;
    NSArray * matches = [context executeFetchRequest:request error:&error];
    
    if([matches count] > 0)
        return [matches objectAtIndex:0];
    return nil;

    
}

+ (NSArray *)getMazeByPack:(NSString*)pack
    inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Maze"];
    request.predicate = [NSPredicate predicateWithFormat:@"(pack.name = %@) ", pack];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError * error = nil;
    NSArray * matches = [context executeFetchRequest:request error:&error];
    
    if([matches count] > 0)
        return matches;
    return nil;

}

+ (NSArray *)getNewCollections:(NSManagedObjectContext *)context
{
    NSString *newColl = @"YES";
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Maze"];
    request.predicate = [NSPredicate predicateWithFormat:@"newColection = %@ ", newColl];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError * error = nil;
    NSArray * matches = [context executeFetchRequest:request error:&error];
    
    if([matches count] > 0)
        return matches;
    return nil;

}

+ (NSArray *)getUnSubmetedMazes:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Maze"];
    request.predicate = [NSPredicate predicateWithFormat:@"scoreSubmeted = %@ ", @"NO"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError * error = nil;
    NSArray * matches = [context executeFetchRequest:request error:&error];
    
    if([matches count] > 0)
        return matches;
    return nil;

}
@end
