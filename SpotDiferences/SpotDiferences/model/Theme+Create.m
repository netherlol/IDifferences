//
//  Theme+Create.m
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 6/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Theme+Create.h"

@implementation Theme (Create)

+ (Theme *)createTheme:(NSString *)name
                  foto:(NSString *)foto
inManagedObjectContext:(NSManagedObjectContext *)context
{
    Theme *theme = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Theme"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError * error = nil;
    NSArray * matches = [context executeFetchRequest:request error:&error];
    
    if(!matches || ([matches count]>1)){
    }else if ([matches count] == 0){
        theme = [NSEntityDescription insertNewObjectForEntityForName:@"Theme" inManagedObjectContext:context];
        theme.name = name;
        theme.foto = foto;
    }else {
        theme = [matches lastObject];
    } 
    
        
    return theme;
}

+(NSArray *)getAllThemes:(NSManagedObjectContext *)context
{
    NSString *available = @"YES";
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Theme"];
    request.predicate = [NSPredicate predicateWithFormat:@"(available=%@)",available];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError * error = nil;
    NSArray * matches = [context executeFetchRequest:request error:&error];
    
    if([matches count] > 0)
        return matches;
    return nil;
}

+ (Theme *)getTheme:(NSString *)name
inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSString *available = @"YES";
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Theme"];
    request.predicate = [NSPredicate predicateWithFormat:@"(name = %@) AND (available=%@)", name,available];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError * error = nil;
    NSArray * matches = [context executeFetchRequest:request error:&error];
    
    if([matches count] > 0)
        return [matches objectAtIndex:0];
    return nil;
}

@end
