//
//  AccountLoginTableViewController.m
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 9/26/12.
//
//

#import "AccountSettingsViewController.h"
#import "UikitFramework.h"
#import "SoundManager.h"
#import "InicialViewController.h"
#import "AccountLogoutViewController.h"
#import "ConnectionManager.h"
#import "Maze+Manage.h"
#import "GameCenterManager.h"

#define fontSize 15
#define fontName @"junegull"

#define REGISTER_CONNECTION  @"register"
#define START_CONNECTION  @"start"
#define END_CONNECTION  @"end"
#define GETSCORE_CONNECTION @"get"
#define GET_RANKING @"ranking"
#define GET_TOP_PLAYER_POINTS @"topPlayer"
#define GET_WOLRD_AVARAGE_TIME @"worldAvarageTime"
#define WORLD_RECORD_TIME @"worldrecordtime"
#define WORLD_RECORD_POINTS @"worldrecordpoints"
#define GET_STATISTICS @"GET_STATISTICS"

#define myAppExternalId @"com.go4mobility.iDifferences"

@interface AccountSettingsViewController ()
@property (nonatomic,weak) IBOutlet UIImageView *imageview;
@property (nonatomic,weak) IBOutlet UITextField *username;
@property (nonatomic,weak) IBOutlet UITextField *password;
@property (nonatomic,weak) IBOutlet UITextField *verifyPassword;
@property (nonatomic,strong) NSURLConnection *connection;
//@property (nonatomic,strong)NSMutableData *receivedData;
@property (nonatomic,strong)NSMutableDictionary *receivedData;
@property (nonatomic,weak) IBOutlet UILabel *usernameLabel;
@property (nonatomic,weak) IBOutlet UILabel *passwordLable;
@property (nonatomic ,weak) UIActivityIndicatorView *spinner;
@property (nonatomic,strong) NSString *G4MPurchaseCenterUrl;
@property (weak, nonatomic) IBOutlet UILabel *forgotpassword;
@end

@implementation AccountSettingsViewController

-(NSString*)G4MPurchaseCenterUrl
{
    if (!_G4MPurchaseCenterUrl) {
        _G4MPurchaseCenterUrl = [[NSBundle mainBundle]
                                 objectForInfoDictionaryKey:@"G4MPurchaseCenterUrl"];
        
    }
    
    return _G4MPurchaseCenterUrl;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView setOpaque:NO];
    [self.tableView setBackgroundColor:[UIColor clearColor]];

    self.username.delegate = self;
    self.password.delegate = self;
    self.password.secureTextEntry = YES;
    
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTappedOnLink:)];

    [self.forgotpassword setUserInteractionEnabled:YES];
    [self.forgotpassword addGestureRecognizer:gesture];
}

- (IBAction)userTappedOnLink:(UIButton*)sender
{
    NSLog(@"link clicked");
    [self performSegueWithIdentifier:@"recover password" sender:self];
}

- (IBAction)signinButtonClicked:(UIButton*)sender {
    if ([self verifyInputs]) {
        NSString *url = [NSString stringWithFormat:@"%@rest/session/register",self.G4MPurchaseCenterUrl];
        [self createConnectionWithType:REGISTER_CONNECTION url:url data: [self generateJsonForRegister:self.username.text password:self.password.text appID:myAppExternalId]];
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinner.frame = CGRectMake(self.view.frame.size.width/2-150, self.view.frame.size.height/2-150, 300, 300);
        
        [self.view addSubview:spinner];
        [spinner startAnimating];
        self.spinner = spinner;
        
    }else {
        [self makeAAlertView:@"Error" message:@"Inputs Invalid."];
    }

}

- (IBAction)signup:(UIButton *)sender {
    [self performSegueWithIdentifier:@"sign up" sender:self];
}


@synthesize imageview = _imageView;
@synthesize username = _username;
@synthesize password = _password;
@synthesize verifyPassword = _verifyPassword;
@synthesize connection = _connection;
@synthesize receivedData = _receivedData;
@synthesize usernameLabel = _usernameLabel;
@synthesize passwordLable = _passwordLable;

-(NSMutableDictionary*)receivedData
{
    if (!_receivedData) {
        _receivedData = [[NSMutableDictionary alloc]init];
    }
    return _receivedData;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(NSData*)generateJsonForSubmitScore:(NSString*)usernameToken
                               appId:(NSString*)appId
                          scoreboard:(NSString*)scoreboard
                               value:(int)value
{
    NSMutableDictionary* info = [[NSMutableDictionary alloc]init];
    [info setObject:usernameToken forKey:@"usernameToken"];
    [info setObject:appId forKey:@"appId"];
    [info setObject:scoreboard forKey:@"scoreboard"];
    [info setObject:[NSNumber numberWithInt:value] forKey:@"value"];
    NSError* error;
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:info
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    NSLog(@"usernametoken = %@ appId = %@ scoreboard = %@ value = %d",usernameToken,appId,scoreboard,value);
    return jsonData;
}

-(NSData*)generateJsonForRegister:(NSString*)username
                         password:(NSString*)password
                            appID:(NSString*)appID
{
    NSMutableDictionary* info = [[NSMutableDictionary alloc]init];
    [info setObject:username forKey:@"username"];
    [info setObject:password forKey:@"password"];
    [info setObject:appID forKey:@"appId"];
    
    NSError* error;
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:info
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    
    return jsonData;
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

-(BOOL)verifyInputs
{
    if ([self.username.text isEqualToString:@""] || [self.password.text isEqualToString:@""]) {
        return false;
    }
    
    return YES;
}

-(void)submitScore:(int)score
        scoreboard:(NSString*)scoreboard
{
    NSString *url =[NSString stringWithFormat:@"%@rest/scoreboard/submit",self.G4MPurchaseCenterUrl];
    
    [self createConnectionWithType:GETSCORE_CONNECTION url:url data: [self generateJsonForSubmitScore:[self getUserToken] appId:myAppExternalId scoreboard:scoreboard value:score]];
}

-(void)getWorldRecordTime:(NSString*)uniqueID
{
    NSString *url= [NSString stringWithFormat:@"%@rest/scoreboard/get?appId=com.go4mobility.iDifferences&scoreboard=%@.TIME",self.G4MPurchaseCenterUrl,uniqueID];
    [self createGetConnection:url type:WORLD_RECORD_TIME];
}

-(void)getWorldRecordPoint:(NSString*)uniqueID
{
    NSString *url= [NSString stringWithFormat:@"%@rest/scoreboard/get?appId=com.go4mobility.iDifferences&scoreboard=%@.SCORE",self.G4MPurchaseCenterUrl,uniqueID];
    [self createGetConnection:url type:WORLD_RECORD_POINTS];
}

-(void)getTopPlayerPoints
{
    NSString *url= [NSString stringWithFormat:@"%@rest/scoreboard/get?appId=com.go4mobility.iDifferences&scoreboard=TOTAL.SCORE",self.G4MPurchaseCenterUrl];
    [self createGetConnection:url type:GET_TOP_PLAYER_POINTS];
}

-(void)getWorldAvarageTime
{
    NSString *url= [NSString stringWithFormat:@"%@rest/scoreboard/get?appId=com.go4mobility.iDifferences&scoreboard=TOTAL.TIME&operator=avg",self.G4MPurchaseCenterUrl];
    [self createGetConnection:url type:GET_WOLRD_AVARAGE_TIME];
}

-(void)getMyRanking
{
    NSString *url=[NSString stringWithFormat:@"%@rest/scoreboard/stats?appId=com.go4mobility.iDifferences&usernameToken=%@",self.G4MPurchaseCenterUrl,[self getUserToken]];
    [self createGetConnection:url type:GET_RANKING];
}

-(void)getStatistic
{
    NSString * userToken = [self getUserToken];
    NSString *url;
    if (userToken) {
        url = [NSString stringWithFormat:@"%@rest/scoreboard/stats?appId=com.go4mobility.iDifferences&usernameToken=%@",self.G4MPurchaseCenterUrl,[self getUserToken]];
    }else
        url = [NSString stringWithFormat:@"%@rest/scoreboard/stats?appId=com.go4mobility.iDifferences",self.G4MPurchaseCenterUrl];
    
    NSLog(@"%@",url);
    [self createGetConnection:url type:GET_STATISTICS];
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

- (IBAction)registerButtonClicked:(UIButton *)sender
{
    if ([self verifyInputs]) {
        NSString *url = [NSString stringWithFormat:@"%@rest/session/register",self.G4MPurchaseCenterUrl];
        //NSString *data = @"{'username' : 'xuan1','password' : '1234', 'appId':'com.go4mobility.iDifferences'}";
        [self createConnectionWithType:REGISTER_CONNECTION url:url data: [self generateJsonForRegister:self.username.text password:self.password.text appID:myAppExternalId]];
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinner.frame = CGRectMake(self.view.frame.size.width/2-150, self.view.frame.size.height/2-150, 300, 300);
        
        [self.view addSubview:spinner];
        [spinner startAnimating];
        self.spinner = spinner;
        
    }else {
        [self makeAAlertView:@"Error" message:@"Inputs Invalid."];
    }
}

- (IBAction)loginButtonClicked:(UIButton *)sender
{
    if ([self verifyInputs]) {
        NSString *url = [NSString stringWithFormat:@"%@rest/session/start",self.G4MPurchaseCenterUrl];
        
        [self createConnectionWithType:START_CONNECTION url:url data:[self generateJsonForStart:self.username.text password:self.password.text]];
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinner.frame = CGRectMake(self.view.frame.size.width/2-150, self.view.frame.size.height/2-150, 300, 300);
        
        [self.view addSubview:spinner];
        [spinner startAnimating];
        self.spinner = spinner;
        
    }else {
        [self makeAAlertView:@"Error" message:@"Inputs Invalid."];
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace

{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
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

-(NSString*)getMessage:(NSMutableData*)responseData
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];
    
    NSDictionary* code = [json objectForKey:@"response"];
    for (NSString* key in code) {
        if ([key isEqualToString:@"message"]) {
            id value = [code objectForKey:key];
            //NSLog(@" finnaly got it ! %@",value);
            return value;
        }
        
    }
    
    return @"";
}

-(NSString*)getRanking:(NSMutableData*)responseData
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];
    
    NSDictionary* code = [json objectForKey:@"response"];
    for (NSString* key in code) {
        if ([key isEqualToString:@"ranking"]) {
            id value = [code objectForKey:key];
            //NSLog(@" finnaly got it ! %@",value);
            return value;
        }
        
    }
    
    return @"";
}

-(NSString*)getTopPlayerPoints:(NSMutableData*)responseData
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];
    
    NSDictionary* code = [json objectForKey:@"response"];
    for (NSString* key in code) {
        if ([key isEqualToString:@"value"]) {
            id value = [code objectForKey:key];
            //NSLog(@" finnaly got it ! %@",value);
            return value;
        }
        
    }
    
    return @"";
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
            //NSLog(@" finnaly got it ! %@",value);
            return value;
        }
        
    }
    
    return @"";
}

-(NSString*)getErrorDetail:(NSMutableData*)responseData
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];
    
    NSDictionary* code = [json objectForKey:@"meta"];
    for (NSString* key in code) {
        if ([key isEqualToString:@"errorDetail"]) {
            id value = [code objectForKey:key];
            //NSLog(@" finnaly got it ! %@",value);
            return value;
        }
        
    }
    
    return @"";
}

-(NSDictionary*)getStatisticaData:(NSMutableData*)responseData
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];
    
    NSDictionary* code = [json objectForKey:@"response"];
    
    
    return code;
}

-(void)createGetConnection:(NSString*)type
                       url:(NSString*)url
{
    NSURL *aUrl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:@"GET"];
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request
                                                                 delegate:self];
    [connection setAccessibilityValue:type];
    if (connection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        if (![self.receivedData objectForKey:type]) {
            [self.receivedData setObject:[NSMutableData data] forKey:type] ;
        }
        
    } else {
        [self makeAAlertView:@"Error" message:@"Connection Error Check Your Network Connections."];
        // Inform the user that the connection failed.
    }
    
}

-(void)LogoutButtonClicked:(UIButton*)sender
{
}

-(void)getScore:(UIButton*)sender
{
    NSString *url = [NSString stringWithFormat:@"%@rest/score/get?appId=com.go4mobility.iDifferences&scoreboard=T-0001.M-0001",self.G4MPurchaseCenterUrl];
    [self createGetConnection:GETSCORE_CONNECTION url:url];
}

-(void)createConnectionWithType:(NSString*)type
                            url:(NSString*)url
                           data:(NSData*)data
{
    NSLog(@"username = %@  password = %@  verifyPassword = %@",self.username.text,self.password.text,self.verifyPassword.text);
    
    NSURL *aUrl = [NSURL URLWithString:url];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //NSString *postString = data;
    [request setHTTPBody:data];//[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request
                                                                 delegate:self];
    [connection setAccessibilityValue:type];
    if (connection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        if (![self.receivedData objectForKey:type]) {
            [self.receivedData setObject:[NSMutableData data] forKey:type] ;
        }
        
    } else {
        [self makeAAlertView:@"Error" message:@"Connection Error Check Your Network Connections."];
        // Inform the user that the connection failed.
    }
    
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    if ([connection.accessibilityValue isEqualToString:GET_STATISTICS]){
        [self.delegate connectionFailed];
    }

    // release the connection, and the data object
    self.connection = nil;
    // receivedData is declared as a method instance elsewhere
    self.receivedData = nil;
    [self.spinner stopAnimating];
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if ([connection.accessibilityValue isEqualToString:GET_STATISTICS]){
        [self.delegate startedConnection];
    }
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [[self.receivedData objectForKey:connection.accessibilityValue] appendData:data];
    NSLog(@"inside didreceivedata %@",[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
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

-(void)testUserInfo
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString*username = [prefs objectForKey:@"username"];
    NSString*password = [prefs objectForKey:@"password"];
    NSString*token = [prefs objectForKey:@"userToken"];
    NSLog(@"username = %@ password = %@ token = %@",username,password,token);
}

-(NSString*)getUserToken
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString*token = [prefs objectForKey:@"userToken"];
    return token;
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSString* myString= [[NSString alloc] initWithData:[self.receivedData  objectForKey:connection.accessibilityValue] encoding:NSASCIIStringEncoding];
    NSLog(@"Succeeded! connection was %@ Received %d bytes of data --- %@",connection.accessibilityValue,[[self.receivedData  objectForKey:connection.accessibilityValue] length], myString);
    
    if ([connection.accessibilityValue isEqualToString:REGISTER_CONNECTION]) {
        NSString *code = [self getConnectionStatus:[self.receivedData  objectForKey:connection.accessibilityValue]];
        NSLog(@"%@",code);
        if ([code isEqualToString:@"200"]) {
            //[self makeAAlertView:@"SUCCESS" message:[NSString stringWithFormat:@"Register With Success %@",connection.accessibilityValue]];
            [self loginButtonClicked:nil];
        }
        else{
            [self makeAAlertView:@"ERROR" message:[NSString stringWithFormat:[self getErrorDetail:[self.receivedData  objectForKey:connection.accessibilityValue]],connection.accessibilityValue]];
            [self.spinner stopAnimating];
            
        }
        
    }else if ([connection.accessibilityValue isEqualToString:START_CONNECTION]) {
        NSString *code = [self getConnectionStatus:[self.receivedData  objectForKey:connection.accessibilityValue]];
        NSLog(@"%@",code);
        if ([code isEqualToString:@"200"]) {
            NSString *token = [self getusernameToken:[self.receivedData  objectForKey:connection.accessibilityValue]];
            if (! (token == (NSString*)[NSNull null])) {
                [self saveUserInfo:self.username.text password:self.password.text token:token];
                //[self makeAAlertView:@"SUCCESS" message:[NSString stringWithFormat:@"Login With Success %@",connection.accessibilityValue]];
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                [prefs setObject:[self getnickname:[self.receivedData  objectForKey:connection.accessibilityValue]] forKey:@"nickname"];
                [prefs setObject:self.username.text forKey:@"loggedinUsername"];
                [prefs setObject:@"YES" forKey:@"loggedinUser"];
                [prefs synchronize];
                [self.spinner stopAnimating];
                //[self getTopPlayerPoints];
                //[self getWorldAvarageTime];
                //[self getMyRanking];
                //[self submitScore:2323 scoreboard:@"T-0001.M-0001"];
                [self performSegueWithIdentifier:@"logged in view by login" sender:self];
                
            }
            
        }
        else{
            [self makeAAlertView:@"ERROR" message:[NSString stringWithFormat:[self getErrorDetail:[self.receivedData  objectForKey:connection.accessibilityValue]],connection.accessibilityValue]];
            [self.spinner stopAnimating];
            
        }
    }else if ([connection.accessibilityValue isEqualToString:GET_RANKING]){
        NSString *code = [self getConnectionStatus:[self.receivedData  objectForKey:connection.accessibilityValue]];
        NSLog(@"%@",code);
        if ([code isEqualToString:@"200"]) {
            NSString *ranking = [self getRanking:[self.receivedData  objectForKey:connection.accessibilityValue]];
            NSLog(@"%@",ranking);
            [self.delegate updateRanking:ranking];
        }
    }else if ([connection.accessibilityValue isEqualToString:GET_TOP_PLAYER_POINTS]){
        NSString *code = [self getConnectionStatus:[self.receivedData  objectForKey:connection.accessibilityValue]];
        NSLog(@"%@",code);
        if ([code isEqualToString:@"200"]) {
            NSString *topPlayerPoints = [self getTopPlayerPoints:[self.receivedData  objectForKey:connection.accessibilityValue]];
            NSLog(@"%@",topPlayerPoints);
            [self.delegate updateTopPlayerPoints:topPlayerPoints];
        }
    }else if ([connection.accessibilityValue isEqualToString:GET_WOLRD_AVARAGE_TIME]){
        NSString *code = [self getConnectionStatus:[self.receivedData  objectForKey:connection.accessibilityValue]];
        NSLog(@"%@",code);
        if ([code isEqualToString:@"200"]) {
            NSString *topPlayerPoints = [self getTopPlayerPoints:[self.receivedData  objectForKey:connection.accessibilityValue]];
            NSLog(@"%@",topPlayerPoints);
            [self.delegate updateWorldAvarageTime:topPlayerPoints];
        }
    }else if ([connection.accessibilityValue isEqualToString:WORLD_RECORD_TIME]){
        NSString *code = [self getConnectionStatus:[self.receivedData  objectForKey:connection.accessibilityValue]];
        NSLog(@"%@",code);
        if ([code isEqualToString:@"200"]) {
            NSString *topPlayerPoints = [self getTopPlayerPoints:[self.receivedData  objectForKey:connection.accessibilityValue]];
            if (topPlayerPoints == (NSString*)[NSNull null]) {
                topPlayerPoints = @"N/A";
            }
            NSLog(@"%@",topPlayerPoints);
            [self.delegate updateWorldRecordTime:topPlayerPoints];
        }
    }else if ([connection.accessibilityValue isEqualToString:WORLD_RECORD_POINTS]){
        NSString *code = [self getConnectionStatus:[self.receivedData  objectForKey:connection.accessibilityValue]];
        NSLog(@"%@",code);
        if ([code isEqualToString:@"200"]) {
            NSString *topPlayerPoints = [self getTopPlayerPoints:[self.receivedData  objectForKey:connection.accessibilityValue]];
            if (topPlayerPoints == (NSString*)[NSNull null]) {
                topPlayerPoints = @"N/A";
            }
            NSLog(@"%@",topPlayerPoints);
            [self.delegate updateWorldRecordPoints:topPlayerPoints];
        }
    }else if ([connection.accessibilityValue isEqualToString:GET_STATISTICS]){
        NSString *code = [self getConnectionStatus:[self.receivedData  objectForKey:connection.accessibilityValue]];
        NSLog(@"%@",code);
        if ([code isEqualToString:@"200"]) {
            NSDictionary *statisticData = [self getStatisticaData:[self.receivedData  objectForKey:connection.accessibilityValue]];
            [self.delegate updateStatistics:statisticData];
            [self.delegate connectionFinished];
        }

    }else if ([connection.accessibilityValue isEqualToString:GETSCORE_CONNECTION]){
        NSString *code = [self getConnectionStatus:[self.receivedData  objectForKey:connection.accessibilityValue]];
        NSLog(@"%@",code);
        if ([code isEqualToString:@"200"]) {
            NSString *scoreboard = [self getscoreboard:[self.receivedData  objectForKey:connection.accessibilityValue]];
            Maze *maze = [Maze getMazeByUniqueID:scoreboard inManagedObjectContext:self.document.managedObjectContext];
            maze.scoreSubmeted = @"YES";
            
            NSString * leaderboardCategory = @"iDifferences.Global";
            NSNumber *total = [self getTotal:[self.receivedData  objectForKey:connection.accessibilityValue]];
            
            int64_t score = [total intValue];
            GKScore * submitScore = [[GKScore alloc] initWithCategory:leaderboardCategory];
            [submitScore setValue:score];
            [submitScore setShouldSetDefaultLeaderboard:YES];
            [[GameCenterManager sharedGameCenterManager] submitScore:submitScore];

        }
        
    }
    
}


-(id)getTotal:(NSMutableData*)responseData
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];
    
    NSDictionary* code = [json objectForKey:@"response"];
    for (NSString* key in code) {
        if ([key isEqualToString:@"total"]) {
            id value = [code objectForKey:key];
            //NSLog(@" finnaly got it ! %@",value);
            return value;
        }
        
    }
    
    return 0;
}


-(NSString*)getscoreboard:(NSMutableData*)responseData
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];
    
    NSDictionary* code = [json objectForKey:@"response"];
    for (NSString* key in code) {
        if ([key isEqualToString:@"scoreboard"]) {
            id value = [code objectForKey:key];
            //NSLog(@" finnaly got it ! %@",value);
            return value;
        }
        
    }
    
    return @"";
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"logged in view by login"]) {
        AccountLogoutViewController *iftvc = (AccountLogoutViewController *)segue.destinationViewController;
        iftvc.user = self.username.text;
    }
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{

    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = [httpResponse statusCode];
    NSLog(@"%d",code);
    [[self.receivedData  objectForKey:connection.accessibilityValue] setLength:0];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

-(void)backButtonTapped:(UIButton*)sender
{
    [[self navigationController]popViewControllerAnimated:YES];
}

- (IBAction) backToHome {
    NSArray *viewControllers = [[self navigationController] viewControllers];
    for (int c=0; c < [viewControllers count]; c++) {
        id obj = [viewControllers objectAtIndex:c];
        if([obj isKindOfClass:[InicialViewController class]])
            [self.navigationController popToViewController:obj animated:YES];
    }
}

-(void)homeButtonTapped:(UIButton*)sender
{
    [self backToHome];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)viewDidUnload {
    [self setForgotpassword:nil];
    [super viewDidUnload];
}
@end
