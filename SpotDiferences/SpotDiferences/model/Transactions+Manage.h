//
//  Transactions+Manage.h
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 10/3/12.
//
//

#import "Transactions.h"

@interface Transactions (Manage)
+ (Transactions *)createTransaction:(NSString *)transactionID
       inManagedObjectContext:(NSManagedObjectContext *)context;
+(NSArray *)getAllTransactions:(NSManagedObjectContext *)context;
+ (Transactions *)getTransaction:(NSString *)transactionID
             inManagedObjectContext:(NSManagedObjectContext *)context;
@end
