//
//  ConnectionManager.m
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 8/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ConnectionManager.h"
#import "NSData+Base64.h"
#import "ZipArchive.h"
#import "MyDocumentHandler.h"
#import "Theme+Create.h"
#import "Maze+Manage.h"
#import "Difficulty+Manage.h"
#import "Pack+manage.h"
#import "DifferenceSet+Manage.h"
#import "Seed.h"
#import "Transactions+Manage.h"
#import "AppDelegate.h"

#define SIGN_UP @"SIGN_UP"
#define RECOVERPASS @"RECOVERPASS"
#define Product_Listing @"ProductListing"
#define Product_Acquire @"ProductAcquire"
#define Request_Resource @"RequestResource"
#define START_CONNECTION @"START_CONNECTION"

#define myAppExternalId @"com.go4mobility.iDifferences"

@interface ConnectionManager()
@property (nonatomic,strong) NSURLConnection *connection;
@property (nonatomic,strong)NSMutableDictionary *receivedData;

@property (nonatomic,strong)NSDictionary *purchaseProduct;
@property (nonatomic,strong)BuyDetailsViewController *purchaseController;
@property (nonatomic,strong)NSString *zipName;
@property (nonatomic,strong) NSString *G4MPurchaseCenterUrl;

@end

@implementation ConnectionManager

@synthesize purchaseProduct = _purchaseProduct;
@synthesize purchaseController = _purchaseController;

-(NSString*)G4MPurchaseCenterUrl
{
    if (!_G4MPurchaseCenterUrl) {
        _G4MPurchaseCenterUrl = [[NSBundle mainBundle]
                                 objectForInfoDictionaryKey:@"G4MPurchaseCenterUrl"];

    }
    
    return _G4MPurchaseCenterUrl;
}

-(NSMutableDictionary*)receivedData
{
    if (!_receivedData) {
        _receivedData = [[NSMutableDictionary alloc]init];
        
    }
    return _receivedData;
}

-(NSData*)generateJsonForProductAcquire:(NSString*)appId
                              productId:(NSString*)productId
                            appleReceipt:(NSData*)receipt
{
    NSMutableDictionary* info = [[NSMutableDictionary alloc]init];
    [info setObject:appId forKey:@"appId"];
    [info setObject:productId forKey:@"productId"];
    [info setObject:[receipt base64EncodedString] forKey:@"appleReceipt"];
    NSArray *transactions = [Transactions getAllTransactions:self.document.managedObjectContext];
    NSString *transactionStrings = @"[";
    NSMutableArray *transactionmultable = [[NSMutableArray alloc]init];
    
    for (int c = 0; c < [transactions count]; c++) {
        Transactions * trans = [transactions objectAtIndex:c];
        [transactionmultable addObject:trans.transactionID];
        if (c >=1) {
            transactionStrings =[transactionStrings stringByAppendingString:@","];
        }
        
        transactionStrings =[transactionStrings stringByAppendingString:[NSString stringWithFormat:@"%@",trans.transactionID]];
    }
    transactionStrings =[transactionStrings stringByAppendingString:@"]"];
    NSLog(@"%@",transactionStrings);
    
    [info setObject:transactionmultable forKey:@"transactionIdList"];
    NSError* error;
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:info
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    return jsonData;
}

-(void)getProductList
{
    NSString *url=[NSString stringWithFormat:@"%@rest/products/list?appId=com.go4mobility.iDifferences&platform=ios",self.G4MPurchaseCenterUrl];
    NSArray *transactions = [Transactions getAllTransactions:self.document.managedObjectContext];
    for (int c = 0; c < [transactions count]; c++) {
        Transactions * trans = [transactions objectAtIndex:c];
        url =[url stringByAppendingString:[NSString stringWithFormat:@"&transactionId=%@",trans.transactionID]];
    }
    NSLog(@"%@",url);
    [self createGetConnection:url type:Product_Listing];
}

-(void)login
{
    NSString *nickname = [self.registData objectForKey:@"nickname"];
    NSString *email = [self.registData objectForKey:@"email"];
    NSString *password = [self.registData objectForKey:@"password"];
    
    NSString *url = [NSString stringWithFormat:@"%@rest/session/start",self.G4MPurchaseCenterUrl];
    
    [self createConnectionWithType:START_CONNECTION url:url data:[self generateJsonForStart:email password:password]];
}

-(void)recoverPass:(NSString*)email
{
    NSString *url = [NSString stringWithFormat:@"%@rest/session/recover",self.G4MPurchaseCenterUrl];
    [self createConnectionWithType:RECOVERPASS url:url data: [self generateJsonForRecover:email appID:myAppExternalId]];
}

-(NSData*)generateJsonForStart:(NSString*)username
                      password:(NSString*)password
{
    NSMutableDictionary* info = [[NSMutableDictionary alloc]init];
    [info setObject:username forKey:@"username"];
    [info setObject:password forKey:@"password"];
    
    NSError* error;
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:info
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    
    return jsonData;
}

-(void)signUp:(NSString*)username
     password:(NSString *)password
     nickname:(NSString *)nickname
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:nickname,@"nickname",username , @"email", password,@"password", nil];
    self.registData = dict;
    NSString *url = [NSString stringWithFormat:@"%@rest/session/register",self.G4MPurchaseCenterUrl];
    [self createConnectionWithType:SIGN_UP url:url data: [self generateJsonForRegister:username nickname:nickname password:password appID:myAppExternalId]];
    
}

-(NSData*)generateJsonForRecover:(NSString*)email
                           appID:(NSString*)appID
{
    NSMutableDictionary* info = [[NSMutableDictionary alloc]init];
    [info setObject:email forKey:@"email"];
    [info setObject:appID forKey:@"appId"];
    
    NSError* error;
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:info
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    
    return jsonData;
}


-(NSData*)generateJsonForRegister:(NSString*)username
                         nickname:(NSString*)nickname
                         password:(NSString*)password
                            appID:(NSString*)appID
{
    NSMutableDictionary* info = [[NSMutableDictionary alloc]init];
    [info setObject:username forKey:@"username"];
    [info setObject:password forKey:@"password"];
    [info setObject:nickname forKey:@"nickname"];
    [info setObject:appID forKey:@"appId"];
    
    NSError* error;
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:info
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    
    return jsonData;
}


-(void)productAcquire:(NSString*)productId
         appleReceipt:(NSData *)appleReceipt
{
    NSString *url = [NSString stringWithFormat:@"%@rest/products/acquire",self.G4MPurchaseCenterUrl];
    [self createConnectionWithType:Product_Acquire url:url data: [self generateJsonForProductAcquire:myAppExternalId productId:productId appleReceipt:appleReceipt]];      
    
}


-(void)createGetConnection:(NSString*)url
                      type:(NSString*)type
{
    
    NSURL *aUrl = [NSURL URLWithString:url];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request
                                                                 delegate:self];
    [connection setAccessibilityValue:type];
    if (connection) {
        if (![self.receivedData objectForKey:type]) {
            [self.receivedData setObject:[NSMutableData data] forKey:type] ;
        }
    } else {
        [self makeAAlertView:@"Error" message:@"Connection Error Check Your Network Connections."];
    }
    
}

-(void)createConnectionWithType:(NSString*)type
                            url:(NSString*)url
                           data:(NSData*)data
{
    NSURL *aUrl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    [request setHTTPBody:data];
    
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request 
                                                                 delegate:self];
    [connection setAccessibilityValue:type];
    if (connection) {
        if (![self.receivedData objectForKey:type]) {
            [self.receivedData setObject:[NSMutableData data] forKey:type] ;
        }
        
    }else {
        [self makeAAlertView:@"Error" message:@"Connection Error Check Your Network Connections."];
        // Inform the user that the connection failed.
    }
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    if ([connection.accessibilityValue isEqualToString:Request_Resource])
    {
        [self.delegate paymentfailed];
    }else if ([connection.accessibilityValue isEqualToString:Product_Acquire])
    {
        [self.delegate paymentfailed];
    }


    self.connection = nil;
    self.receivedData = nil;
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if ([connection.accessibilityValue isEqualToString:Request_Resource])
    {
        [self.delegate setCurrentLenght:data.length];
    }
    [[self.receivedData objectForKey:connection.accessibilityValue] appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString* myString= [[NSString alloc] initWithData:[self.receivedData  objectForKey:connection.accessibilityValue] encoding:NSASCIIStringEncoding];
    NSLog(@"Succeeded! connection was %@ Received %d bytes of data --- %@",connection.accessibilityValue,[[self.receivedData  objectForKey:connection.accessibilityValue] length], myString);
    
    if ([connection.accessibilityValue isEqualToString:Product_Listing])
    {
        NSString *code = [self getConnectionStatus:[self.receivedData  objectForKey:connection.accessibilityValue]];
        NSLog(@"%@",code);
        
        if ([code isEqualToString:@"200"]) {
            //[self makeAAlertView:@"SUCCESS" message:[NSString stringWithFormat:@"Product Listing With Success %@",connection.accessibilityValue]];
            NSArray *productList = [self getProductList:[self.receivedData  objectForKey:connection.accessibilityValue]];
            //NSSet *products = [self productsValidation:productList];
            
            [self.delegate returnListOfProducts:productList];
        }

    }else if ([connection.accessibilityValue isEqualToString:Product_Acquire])
    {
        NSString *code = [self getConnectionStatus:[self.receivedData  objectForKey:connection.accessibilityValue]];
        NSLog(@"%@",code);
        
        if ([code isEqualToString:@"200"]) {
            NSArray *resourceList = [self getresourceList:[self.receivedData objectForKey:connection.accessibilityValue]];
            NSString *transactionID = [self getTransactionId:[self.receivedData objectForKey:connection.accessibilityValue]];
            NSDictionary* stamp = [resourceList objectAtIndex:0];
            NSLog(@"stamp == %@",[stamp objectForKey:@"stamp"]);
            
            
            NSString *urlResource=[NSString stringWithFormat:@"%@rest/products/resource?appId=com.go4mobility.iDifferences&resourceStamp=%@&transactionId=%@",self.G4MPurchaseCenterUrl,[stamp objectForKey:@"stamp"],transactionID];
            NSLog(@"url = %@",urlResource);
            [self createGetConnection:urlResource type:Request_Resource];
            
            [self persistPackage:[self getartifacts:[self.receivedData objectForKey:connection.accessibilityValue]]];
        }else
        {
            [self.delegate paymentfailed];
        }
    
    }else if ([connection.accessibilityValue isEqualToString:Request_Resource])
    {
        [self doSomethingWithDownloadedZip:[self.receivedData objectForKey:connection.accessibilityValue]];
    }else if ([connection.accessibilityValue isEqualToString:SIGN_UP])
    {
        NSString *code = [self getConnectionStatus:[self.receivedData  objectForKey:connection.accessibilityValue]];
        NSLog(@"%@",code);
        
        if ([code isEqualToString:@"200"]) {
            [self login];
        }else
        {
            NSString *errorInfo = [self getOperationFailedInfo:[self.receivedData objectForKey:connection.accessibilityValue]];
            [UikitFramework makeAAlertView:@"ERROR" message:errorInfo];
        }
        
    }else if ([connection.accessibilityValue isEqualToString:START_CONNECTION])
    {
        NSString *code = [self getConnectionStatus:[self.receivedData  objectForKey:connection.accessibilityValue]];
        NSLog(@"%@",code);
        
        if ([code isEqualToString:@"200"]) {
            NSString *token = [self getusernameToken:[self.receivedData  objectForKey:connection.accessibilityValue]];
            if (! (token == (NSString*)[NSNull null])) {
                NSString *nickname = [self.registData objectForKey:@"nickname"];
                NSString *email = [self.registData objectForKey:@"email"];
                NSString *password = [self.registData objectForKey:@"password"];
                if (!nickname) {
                    nickname = [self getnickname:[self.receivedData  objectForKey:connection.accessibilityValue]];
                }
                [self saveUserInfo:email password:password token:token];

                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                [prefs setObject:nickname forKey:@"nickname"];
                [prefs setObject:email forKey:@"loggedinUsername"];
                [prefs setObject:@"YES" forKey:@"loggedinUser"];
                [prefs synchronize];

                [self.delegate loginSuccess];
            }

        }else
        {
            NSString *errorInfo = [self getOperationFailedInfo:[self.receivedData objectForKey:connection.accessibilityValue]];
            [UikitFramework makeAAlertView:@"ERROR" message:errorInfo];
        }
        
    }else if ([connection.accessibilityValue isEqualToString:RECOVERPASS])
    {
        NSString *code = [self getConnectionStatus:[self.receivedData  objectForKey:connection.accessibilityValue]];
        NSLog(@"%@",code);
        
        if ([code isEqualToString:@"200"]) {
            [UikitFramework makeAAlertView:@"SUCCESS" message:@"Message Was Send To Your Email."];
            [self.delegate recoverSuccess];
        }else
        {
            NSString *errorInfo = [self getOperationFailedInfo:[self.receivedData objectForKey:connection.accessibilityValue]];
            [UikitFramework makeAAlertView:@"ERROR" message:errorInfo];
        }
        
    }

}

-(NSString*)getnickname:(NSMutableData*)responseData
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];
    
    NSDictionary* code = [json objectForKey:@"response"];
    for (NSString* key in code) {
        if ([key isEqualToString:@"nickname"]) {
            id value = [code objectForKey:key];
            //NSLog(@" finnaly got it ! %@",value);
            return value;
        }
        
    }
    
    return @"";
}

-(void)saveUserInfo:(NSString*)username
           password:(NSString*)password
              token:(NSString*)token
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:username forKey:@"username"];
    [prefs setObject:password forKey:@"password"];
    [prefs setObject:token forKey:@"userToken"];
    [prefs synchronize];
}

-(NSString*)getusernameToken:(NSMutableData*)responseData
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];
    
    NSDictionary* code = [json objectForKey:@"response"];
    for (NSString* key in code) {
        if ([key isEqualToString:@"usernameToken"]) {
            id value = [code objectForKey:key];
            //NSLog(@" finnaly got it ! %@",value);
            return value;
        }
        
    }
    
    return @"";
}


-(void)doit:(NSString*)responseData{
    //NSLog(@"persistPackage -----------%@",responseData);
    NSData* data = [responseData dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error;
    
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:data //1
                          
                          options:kNilOptions
                          error:&error];
    //NSLog(@"json ----------------%@",json);
    NSString *themeId = [json objectForKey:@"themeId"];
    NSString *package = [json objectForKey:@"package"];
    self.zipName = package;
    NSArray *imageset = [json objectForKey:@"imageSet"];
    
    Theme *theme = [Theme getTheme:themeId inManagedObjectContext:self.document.managedObjectContext];
    
    for (int c = 0; c < [imageset count]; c++) {
        NSDictionary *perdifficulty = [imageset objectAtIndex:c];
        NSString *difficulty = [perdifficulty objectForKey:@"difficulty"];
        if ([difficulty isEqualToString:@"BEGGINER"]) {
            difficulty = @"beginner";
        }
        Difficulty *diff = [Difficulty getDifficulty:difficulty inManagedObjectContext:self.document.managedObjectContext];
        
        NSArray *imageList = [perdifficulty objectForKey:@"imageList"];
        for (int c = 0; c < [imageList count]; c++) {
            NSDictionary *image = [imageList objectAtIndex:c];
            NSString *img = [image objectForKey:@"image"];
            NSString *name = [image objectForKey:@"name"];
            NSString *uid = [image objectForKey:@"uid"];
            NSArray *differences = [image objectForKey:@"differences"];
            
            DifferenceSet *mazediference = [self createMaze:theme package:package uid:uid image:img name:name difficulty:diff];
            
            for (int c = 0; c < [differences count]; c++) {
                NSArray *diference = [differences objectAtIndex:c];
                int c1 = [[diference objectAtIndex:0] integerValue];
                int c2 = [[diference objectAtIndex:1] integerValue];
                int c3 = [[diference objectAtIndex:2] integerValue];
                int c4 = [[diference objectAtIndex:3] integerValue];
                
                [Seed insertDiffs:c1 topY:c2 downX:c3 downY:c4  diffFotos:mazediference inContext:self.document.managedObjectContext];
                
            }
            
            
            
        }
        
        //NSLog(@"%d persistPackage imageset-----------%@",c,[imageset objectAtIndex:c]);
    }
    [self.document saveToURL:self.document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];

}

-(void) persistPackage:(NSString*)responseData {
    if (!self.document) {
        [[MyDocumentHandler sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document){
            _document = document;
            [self doit:responseData];
        }];
    }else{
        [self doit:responseData];
    }

    
    
}

-(DifferenceSet *)createMaze:(Theme*)theme
          package:(NSString*)package
              uid:(NSString*)uid
            image:(NSString*)image
             name:(NSString*)name
       difficulty:(Difficulty*)difficulty
{
    NSManagedObjectContext *context = self.document.managedObjectContext;
    Pack *pack = [Pack createPack:package inManagedObjectContext:context];
    NSString *normalState = @"normal";
    //NSString *avalable = @"YES";
    NSString *NewFotosAvalable = @"YES";
    //NSString *NewThemeAvalable = @"YES";
    
    Maze *maze = [Maze createMaze:image forTheme:theme inManagedObjectContext:context];
    maze.dificulty = difficulty;
    maze.state = normalState;
    maze.uniqueID = uid;
    maze.available = NewFotosAvalable;
    maze.pack = pack;
    maze.newColection = @"YES";
    maze.showLabel = name;
    DifferenceSet *mazeA = [DifferenceSet createDifferenceFoto:[NSString stringWithFormat:@"%@A",image] forMaze:maze inManagedObjectContext:context];
    
    return mazeA;
}

-(void)doSomethingWithDownloadedZip:(NSMutableData*)responseData
{
    [self saveToDisk:responseData];
}

-(void)saveToDisk:(NSMutableData*)responseData
{
    NSError *error = nil;
    NSData *data = responseData;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *zipPath = [path stringByAppendingPathComponent:@"zipfile.zip"];
    NSString *unzipPath = [path stringByAppendingPathComponent:@"unzip"];
    [data writeToFile:zipPath options:0 error:&error];
    
    if(!error)
    {
        // TODO: Unzip
        ZipArchive *za = [[ZipArchive alloc] init];
        // 1
        if ([za UnzipOpenFile: zipPath]) {
            // 2
            BOOL ret = [za UnzipFileTo: unzipPath overWrite: YES];
            if (NO == ret){} [za UnzipCloseFile];
            NSLog(@"file Unzipped");
            
            //[self.delegate doneUnzipping];
            if ([self.delegate respondsToSelector:@selector(doneUnzipping)]) {
                [self.delegate doneUnzipping];
            } else {
                [self makeAAlertView:@"SUCCESS" message:@"TRANSACTION COMPLETE NEW IMAGES ARE AVAILABLE."];
            }
            [self finishTransaction:self.transaction];
            [self recordTransaction:self.transaction];
            self.transaction = nil;
            
            //NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:unzipPath error:NULL];
            NSLog(@"[directoryContent objectAtIndex:0] = %@",self.zipName);
            
            NSString *package = [unzipPath stringByAppendingPathComponent:self.zipName];
            [self listFileAtPath:package];
            NSString *box = [package stringByAppendingPathComponent:@"box"];
            NSString *images = [package stringByAppendingPathComponent:@"images"];
            NSString *thumbnail = [package stringByAppendingPathComponent:@"thumbnail"];
            
            [self listFileAtPath:images];
            NSString *beginner = [images stringByAppendingPathComponent:@"beginner"];
            NSString *intermediate = [images stringByAppendingPathComponent:@"intermediate"];
            NSString *expert = [images stringByAppendingPathComponent:@"expert"];
            NSString *detective = [images stringByAppendingPathComponent:@"detective"];
            [self listFileAtPath:beginner];
            [self listFileAtPath:intermediate];
            [self listFileAtPath:expert];
            [self listFileAtPath:detective];
            
            [self listFileAtPath:box];
            [self listFileAtPath:thumbnail];
                     
        }
    }
    else
    {
        NSLog(@"Error saving file %@",error);
    }
}

-(NSArray *)listFileAtPath:(NSString *)path
{
    //-----> LIST ALL FILES <-----//
    NSLog(@"LISTING ALL FILES FOUND");
    
    int count;
    
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    for (count = 0; count < (int)[directoryContent count]; count++)
    {
        NSLog(@"File %d: %@", (count + 1), [directoryContent objectAtIndex:count]);
    }
    return directoryContent;
}


-(NSString*)getOperationFailedInfo:(NSMutableData*)responseData
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];
    
    NSDictionary* code = [json objectForKey:@"meta"];
    for (NSString* key in code) {
        if ([key isEqualToString:@"errorDetail"]) {
            NSString *value = [code objectForKey:key];
            return value;
        }
        
    }
    
    return nil;
}

-(NSString*)getartifacts:(NSMutableData*)responseData
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];
    
    NSDictionary* code = [json objectForKey:@"response"];
    for (NSString* key in code) {
        if ([key isEqualToString:@"artifacts"]) {
            NSString *value = [code objectForKey:key];
            return value;
        }
        
    }
    
    return nil;
}

-(NSArray*)getresourceList:(NSMutableData*)responseData
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];
    
    NSDictionary* code = [json objectForKey:@"response"];
    for (NSString* key in code) {
        if ([key isEqualToString:@"resourceList"]) {
            NSArray *value = [code objectForKey:key];
            return value;
        }
        
    }
    
    return nil;
}

-(NSString*)getTransactionId:(NSMutableData*)responseData
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];
    
    NSDictionary* code = [json objectForKey:@"response"];
    for (NSString* key in code) {
        if ([key isEqualToString:@"transactionId"]) {
            NSString *value = [code objectForKey:key];
            return value;
        }
        
    }
    
    return nil;
}

-(NSString*)getproductBundleId:(NSMutableData*)responseData
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];
    
    NSDictionary* code = [json objectForKey:@"response"];
    for (NSString* key in code) {
        if ([key isEqualToString:@"productBundleId"]) {
            NSString *value = [code objectForKey:key];
            return value;
        }
        
    }
    
    return nil;
}

-(NSSet*)productsValidation:(NSArray*)productList
{
    NSMutableDictionary *availableList = [NSMutableDictionary dictionary];
    
    for (int c = 0; c < [productList count]; c++) {
        NSDictionary* productData = [productList objectAtIndex:c];
        for (NSString* key in productData) {
            if ([key isEqualToString:@"externalId"]) {
                NSString *value = [productData objectForKey:key];
                [availableList setObject:[key mutableCopy] forKey:value];
            }
        }
    }
    NSLog(@"Added %d products", [availableList count] );
    return [NSSet setWithArray:[availableList allKeys]];
}

-(NSArray*)getProductList:(NSMutableData*)responseData
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];
    
    NSDictionary* code = [json objectForKey:@"response"];
    for (NSString* key in code) {
        if ([key isEqualToString:@"productList"]) {
            NSArray *value = [code objectForKey:key];
            return value;
        }
        
    }
    
    return nil;
}


-(NSString*)getConnectionStatus:(NSMutableData*)responseData
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];
    
    NSDictionary* code = [json objectForKey:@"meta"];
    for (NSString* key in code) {
        if ([key isEqualToString:@"code"]) {
            id value = [code objectForKey:key];
            return value;
        }
        
    }
    
    return nil;
}


- (void) paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions {
    for(SKPaymentTransaction *transaction in transactions) {
        NSLog(@"MAC removedTransactions %@",transaction);

    }
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
    self.transaction = transaction;
    // Your application should implement these two methods.
    //[self recordTransaction:transaction];
    [self provideContent:transaction];
    
    // Remove the transaction from the payment queue.
}

-(void)finishTransaction:(SKPaymentTransaction *)transaction
{
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

-(void)provideContent: (SKPaymentTransaction *)transaction
{

    NSData *receipt = [transaction transactionReceipt];
        
    [self productAcquire:transaction.payment.productIdentifier
                appleReceipt:receipt];

}

-(void)recordTransaction : (SKPaymentTransaction *)transaction
{
    NSString *transactionID = transaction.transactionIdentifier;
    [Transactions createTransaction:transactionID inManagedObjectContext:self.document.managedObjectContext];
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
    //[self recordTransaction: transaction];
    [self provideContent: transaction];
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled) {
        self.transaction = nil;
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

-(void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"COMPLETED TRANSACTION RESTORED");
    [self makeAAlertView:@"SUCCESS" message:@"COMPLETED TRANSACTION RESTORED"];
}

- (void)paymentQueue:(SKPaymentQueue *)queue
{
    NSLog(@"TRANSACTION RESTORE FAILED");
    [self makeAAlertView:@"FAIL" message:@"TRANSACTION RESTORE FAILED"];
}

// The transaction status of the SKPaymentQueue is sent here.
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
	for(SKPaymentTransaction *transaction in transactions) {
		switch (transaction.transactionState) {
				
			case SKPaymentTransactionStatePurchasing:
                NSLog(@"%@",transaction.payment.productIdentifier);
                [self.delegate paying];
                break;
				
			case SKPaymentTransactionStatePurchased: {
				[self completeTransaction:transaction];
                [self.delegate payed];
				break;
            }
			case SKPaymentTransactionStateRestored:
				[self restoreTransaction:transaction];
                [self.delegate paymentRestore];
				break;
				
			case SKPaymentTransactionStateFailed:
				[self failedTransaction:transaction];
                [self.delegate paymentfailed];
				break;
		}
	}
    
    [_purchaseController.spinner stopAnimating];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    if ([connection.accessibilityValue isEqualToString:Request_Resource])
    {
        [self.delegate setExpectedLenght:[response expectedContentLength]];
    }
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = [httpResponse statusCode];
    NSLog(@"%d",code);
    [[self.receivedData  objectForKey:connection.accessibilityValue] setLength:0];
}


-(void)makeAAlertView:(NSString*)title
              message:(NSString*)mesage
{
    UIAlertView *alertView = [[UIAlertView alloc] 
                              initWithTitle:title                                                             
                              message:mesage                                                          
                              delegate:self                                              
                              cancelButtonTitle:@"OK"                                                   
                              otherButtonTitles:nil];
    [alertView show];
}

-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace

{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}



- (void)preparePurchase:(NSDictionary*) product with:(BuyDetailsViewController *) controller {
    _purchaseProduct = product;
    _purchaseController = controller;
}

@end
