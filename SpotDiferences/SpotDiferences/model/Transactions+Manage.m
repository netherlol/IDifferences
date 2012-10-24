//
//  Transactions+Manage.m
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 10/3/12.
//
//

#import "Transactions+Manage.h"

@implementation Transactions (Manage)
+ (Transactions *)createTransaction:(NSString *)transactionID
       inManagedObjectContext:(NSManagedObjectContext *)context
{
    Transactions *transaction = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Transactions"];
    request.predicate = [NSPredicate predicateWithFormat:@"transactionID = %@", transactionID];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"transactionID" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError * error = nil;
    NSArray * matches = [context executeFetchRequest:request error:&error];
    
    if(!matches || ([matches count]>1)){
    }else if ([matches count] == 0){
        transaction = [NSEntityDescription insertNewObjectForEntityForName:@"Transactions" inManagedObjectContext:context];
        transaction.transactionID = transactionID;

    }else {
        transaction = [matches lastObject];
    }
    
    
    return transaction;
}

+(NSArray *)getAllTransactions:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Transactions"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"transactionID" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError * error = nil;
    NSArray * matches = [context executeFetchRequest:request error:&error];
    
    if([matches count] > 0)
        return matches;
    return nil;

}

+ (Transactions *)getTransaction:(NSString *)transactionID
          inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Transactions"];
    request.predicate = [NSPredicate predicateWithFormat:@"(transactionID = %@) ", transactionID];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"transactionID" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError * error = nil;
    NSArray * matches = [context executeFetchRequest:request error:&error];
    
    if([matches count] > 0)
        return [matches objectAtIndex:0];
    return nil;

}

@end
