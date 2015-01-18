//
//  ViewController.m
//  DiceRoller
//
//  Created by Rajia  on 9/30/14.
//  Copyright (c) 2014 iSENSE. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@end

//Forward Declared Interface
@interface DLAVAlertViewController ()
+ (instancetype)sharedController;
@end


@implementation ViewController
//UI
@synthesize credentialBarBtn, nameBtn, nameLbl, projNumLbl;

int numTest = 0;

- (void)viewDidLoad{
    [super viewDidLoad];

    // If the Credential Manager was recently active, re-show it
    [self reInstateCredentialManagerDialog];

	api = [API getInstance];
    dataSetName = kDEFAULT_DATA_SET_NAME;

    diceController = [[DiceDataController alloc] init];
    int projectID = 876;
    DataManager *dm = [DataManager getInstance];
    [dm setProjectID:projectID];
    [projNumLbl setText:[NSString stringWithFormat:@"%d",projectID]];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (alertView.tag) {
        case kLOGIN_DIALOG_TAG:
        {
            NSString *user = [alertView textFieldAtIndex:0].text;
            NSString *pass = [alertView textFieldAtIndex:1].text;
            
            if ([user length] != 0 && [pass length] !=0)
                [self login:user withPassword:pass];
            
            break;
        }
        case kNAME_DIALOG_TAG:
        {
            NSString *name = [alertView textFieldAtIndex:0].text;
            
            if (name && [name length] > 0) {
                dataSetName = name;
                [nameLbl setText:dataSetName];
            }
            
            break;
        }
        default:
            break;
    }
}

// restrict length of text entered in the data set name AlertView
// 90 is chosen because 128 is the limit on iSENSE, and theapp will eventually append
// a ~20 character timestamp to the data set name
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    
    NSUInteger newLength = [textField.text length] + [string
                                                      length] - range.length;
    return (newLength <= 90);
}
- (IBAction)rollClicked:(id)sender {
    int firstNum = [diceController getDieNumber];
    int secondNum = [diceController getDieNumber];
    int sum = firstNum + secondNum;
    
    [self.firstDieView showDieNumber:firstNum colorOfDie:WHITE_DICE];
    [self.secondDieView showDieNumber:secondNum colorOfDie:YELLOW_DICE];
    
    self.sumLabel.text = [NSString stringWithFormat:@"The sum is %d", sum];
    //Call uploadData to upload the data set.
    [diceController uploadDatadie1:firstNum die2:secondNum sumOfDies:sum numOfTests:numTest++];

}
//This is for making testing easier, however will be removed in the futer when the app is ready to be pushed to the app store. 
- (IBAction)closeBtnOnClick:(id)sender{
    [self.view makeWaffle:@"Exiting App." duration:WAFFLE_LENGTH_LONG position:WAFFLE_BOTTOM];
    exit(0);
}

#pragma mark - Credentials

- (void) reInstateCredentialManagerDialog {
    // If Credential Manager is called and it’s not shown, we start to display it!
    if (credentialMgrAlert && ![credentialMgrAlert isHidden]) {
        [credentialMgrAlert dismissWithClickedButtonIndex:0 animated:YES];
        [self createCredentialManagerDialog];
    }
}

- (void) createCredentialManagerDialog {
    
    credentialMgr = [[CredentialManager alloc] initWithDelegate:self];
    DLAVAlertViewController *parent = [DLAVAlertViewController sharedController];
    [parent addChildViewController:credentialMgr];
    
    credentialMgrAlert = [[DLAVAlertView alloc] initWithTitle:@"Account Credentials"
                                                      message:@"Need an account? Visit isenseproject.org/users/new to register."
                                                     delegate:nil
                                            cancelButtonTitle:@"Close"
                                            otherButtonTitles:nil];
    
    
    [credentialMgrAlert setContentView:credentialMgr.view];
    [credentialMgrAlert setDismissesOnBackdropTap:YES];
    [credentialMgrAlert show];
}

- (IBAction)credentialBarBtnOnClick:(id)sender {
    
    [self createCredentialManagerDialog];
}

- (void) didPressLogin:(CredentialManager *)mngr {
    
    [credentialMgrAlert dismissWithClickedButtonIndex:0 animated:NO];
    credentialMgrAlert = nil;
    
    // check for connectivity
    if (![API hasConnectivity]) {
        [self.view makeWaffle:@"No internet connectivity - cannot login" duration:WAFFLE_LENGTH_LONG position:WAFFLE_BOTTOM image:WAFFLE_RED_X];
        return;
    }
    
    UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"Login to iSENSE" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [loginAlert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    loginAlert.tag = kLOGIN_DIALOG_TAG;
    
    [loginAlert textFieldAtIndex:0].delegate = self;
    [loginAlert textFieldAtIndex:0].tag = kLOGIN_USER_TEXT;
    [loginAlert textFieldAtIndex:0].placeholder = @"Email";
    
    // since the CredentialManager takes a moment to dismiss and allow the login AlertView become a first responder,
    // we have to sleep the first responder action for 1.5 seconds.  this can be removed once the Credential Manager
    // is rewritten
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [[loginAlert textFieldAtIndex:0] becomeFirstResponder];
    });
    
    [loginAlert textFieldAtIndex:1].delegate = self;
    [loginAlert textFieldAtIndex:1].tag = kLOGIN_PASS_TEXT;
    
    [loginAlert show];
}

// Login to iSENSE
- (void) login:(NSString *)email withPassword:(NSString *)pass {
    
    UIAlertView *spinnerDialog = [self getDispatchDialogWithMessage:@"Logging in..."];
    [spinnerDialog show];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        RPerson *currUser = [api createSessionWithEmail:email andPassword:pass];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (currUser != nil) {
                
                [self.view makeWaffle:[NSString stringWithFormat:@"Login as %@ successful", email]
                             duration:WAFFLE_LENGTH_SHORT
                             position:WAFFLE_BOTTOM
                                image:WAFFLE_CHECKMARK];
            } else {
                
                [self.view makeWaffle:@"Login failed"
                             duration:WAFFLE_LENGTH_SHORT
                             position:WAFFLE_BOTTOM
                                image:WAFFLE_RED_X];
            }
            [spinnerDialog dismissWithClickedButtonIndex:0 animated:YES];
        });
    });
}

// Default dispatch_async dialog with custom spinner
- (UIAlertView *) getDispatchDialogWithMessage:(NSString *)dString {
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:dString
                                                      message:nil
                                                     delegate:self
                                            cancelButtonTitle:nil
                                            otherButtonTitles:nil];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = CGPointMake(139.5, 75.5);
    [message addSubview:spinner];
    [spinner startAnimating];
    return message;
}

#pragma end - Credentials

#pragma mark - Name

- (IBAction)nameBtnOnClick:(id)sender {
    
    UIAlertView *enterNameAlart = [[UIAlertView alloc] initWithTitle:@"Enter a Data Set Name"
                                                             message:@""
                                                            delegate:self
                                                   cancelButtonTitle:@"Cancel"
                                                   otherButtonTitles:@"OK", nil];
    [enterNameAlart setAlertViewStyle:UIAlertViewStylePlainTextInput];
    enterNameAlart.tag = kNAME_DIALOG_TAG;
    [enterNameAlart textFieldAtIndex:0].delegate = self;
    [[enterNameAlart textFieldAtIndex:0] becomeFirstResponder];
    [enterNameAlart textFieldAtIndex:0].placeholder = @"data set name";
    
    [enterNameAlart show];
}

#pragma end - Name


@end