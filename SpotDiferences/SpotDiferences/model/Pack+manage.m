//
//  Pack+manage.m
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 9/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Pack+manage.h"

@implementation Pack (manage)

+ (Pack *)createPack:(NSString *)name
inManagedObjectContext:(NSManagedObjectContext *)context
{
    Pack *pack = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Pack"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError * error = nil;
    NSArray * matches = [context executeFetchRequest:request error:&error];
    
    if(!matches || ([matches count]>1)){
    }else if ([matches count] == 0){
        pack = [NSEntityDescription insertNewObjectForEntityForName:@"Pack" inManagedObjectContext:context];
        pack.name = name;
    }else {
        pack = [matches lastObject];
    } 
    
    
    return pack;
}

+(NSArray *)getAllPacks:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Pack"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError * error = nil;
    NSArray * matches = [context executeFetchRequest:request error:&error];
    
    if([matches count] > 0)
        return matches;
    return nil;
}

@end
