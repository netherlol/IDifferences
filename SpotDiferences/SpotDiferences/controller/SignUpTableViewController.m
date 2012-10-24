//
//  SignUpTableViewController.m
//  SpotDiferences
//
//  Created by Mobile Team (G4M) on 10/17/12.
//
//

#import "SignUpTableViewController.h"
#import "UikitFramework.h"
#import "ConnectionManager.h"


@interface SignUpTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nickname;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation SignUpTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loginSuccess
{
    [self performSegueWithIdentifier:@"logged in view by login signup" sender:self];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)validateInputs
{
    if ([self.nickname.text length] == 0 || [self.email.text length] == 0 || [self.password.text length] == 0) {
        return NO;
    }
    
    return YES;
}

- (IBAction)signup:(UIButton *)sender {
    if ([self validateInputs]) {
        ConnectionManager *conn = [[ConnectionManager alloc]init];
        conn.delegate = self;
        [conn signUp:self.email.text password:self.password.text nickname:self.nickname.text];
    }else{
        [UikitFramework makeAAlertView:@"ERROR" message:@"Invalid Inputs"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
