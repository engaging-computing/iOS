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
@synthesize credentialBarBtn, nameBtn, projectBtn;

int numTest = 0;

- (void)viewDidAppear:(BOOL)animated{
    //Called anytime we go to the screen
    [super viewDidAppear:animated];
    [projectBtn setTitle:[NSString stringWithFormat:@"Upload to Project: %d", [dm getProjectID]] forState:UIControlStateNormal];
    
}
- (void)viewDidLoad{
    [super viewDidLoad];

    // If the Credential Manager was recently active, re-show it
    [self reInstateCredentialManagerDialog];

	api = [API getInstance];
    dataSetName = kDEFAULT_DATA_SET_NAME;
    // if using the development iSENSE site, turn on development mode
    [api useDev:true];
    [nameBtn setTitle:[NSString stringWithFormat:@"Data Set Name: %@", dataSetName] forState:UIControlStateNormal];
    int projectID = kDEFAULT_PROJ;
    dm = [DataManager getInstance];
    [dm setProjectID:projectID];
    userEmail = @"mobile.fake@example.com";
    password = @"mobile";
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (int) getDieNumber{
    //this uses the arc4random function to generate a random number between 0-6
    int r = (arc4random()%6) + 1;
    return r;
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
                [nameBtn setTitle:[NSString stringWithFormat:@"Data Set Name: %@", dataSetName] forState:UIControlStateNormal];

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
    int firstNum = [self getDieNumber];
    int secondNum = [self getDieNumber];
    int sum = firstNum + secondNum;
    
    [self.firstDieView showDieNumber:firstNum colorOfDie:WHITE_DICE];
    [self.secondDieView showDieNumber:secondNum colorOfDie:YELLOW_DICE];
    
    self.sumLabel.text = [NSString stringWithFormat:@"The sum is %d", sum];
    [self uploadDatadie1:firstNum die2:secondNum sumOfDies:sum numOfTests:numTest++];

}

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
                userEmail = email;
                password = pass;
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

-(void) uploadDatadie1:(int)num1 die2:(int)num2 sumOfDies:(int)sumNum numOfTests:(int)numTest{
    
    
    // operations performed that involve querying the iSENSE website should always be done in a background
    // thread.  in iOS, this is done by creating a dispatch queue.  the "upload_data_to_isense" name is
    // arbitrary, so feel free to change this string.
    
    dispatch_queue_t queue = dispatch_queue_create("upload_data_to_isense", NULL);
    dispatch_async(queue, ^{
        
        int whiteDiceValue = num1;
        int yellowDiceValue = num2;
        int diceRollSum = sumNum;
       
        // login to the iSENSE site
        [api createSessionWithEmail:userEmail andPassword:password];
        
        // pull down fields for the iSENSE project as an array of RProjectField objects
        dm = [DataManager getInstance];
        NSArray *projectFields = [api getProjectFieldsWithId:[dm getProjectID]];
        
        // initialize an array to store your data
        NSMutableArray *rowMajorData = [[NSMutableArray alloc] init];
        
        // each data row is a dictionary, where the keys are the project's field IDs and the values
        // are the data you want to store for each field.  if you want more data rows per data
        // set, you can declare additional dictionaries, populate them as we will below, and also add
        // them to the data array.  PLEASE NOTE that iSENSE only accepts strings as keys and values,
        // however, so when adding the data to the dictionary, store the field ID and value as a string
        NSMutableDictionary *dataRow = [[NSMutableDictionary alloc] init];
        
        // loop through the project fields and store each data point in a dictionary
        for (RProjectField *field in projectFields) {
            
            // see if this field contains "white" or "yellow" in it
            if ([field.name.lowercaseString rangeOfString:@"white"].location != NSNotFound) {
                
                // if we're here, this is our value of the white dice
                // remember, the object and key should be strings!
                [dataRow setObject:[NSString stringWithFormat:@"%d", whiteDiceValue]
                            forKey:[NSString stringWithFormat:@"%d", field.field_id.intValue]];
                
                
            } else if ([field.name.lowercaseString rangeOfString:@"yellow"].location != NSNotFound) {
                
                // if we're here, this is our value of the yellow dice
                [dataRow setObject:[NSString stringWithFormat:@"%d", yellowDiceValue]
                            forKey:[NSString stringWithFormat:@"%d", field.field_id.intValue]];
                
            } else {
                
                // if we're here, this is the dice sum value
                [dataRow setObject:[NSString stringWithFormat:@"%d", diceRollSum]
                            forKey:[NSString stringWithFormat:@"%d", field.field_id.intValue]];
                
            }
        }
        
        // add this data row to our data array
        [rowMajorData addObject:dataRow];
        
        // when storing data, we typically follow the format we did above.  this style is called row-major
        // because we stored one data row in our array at a time.  iSENSE, however, expects data in
        // column-major format.  that is, our data object needs to be a dictionary where the keys are
        // the field IDs and the values are an array of all data points for that key.  luckily, the iSENSE
        // iOS library comes with a DataManager object that will perform this conversion step for us.
        NSDictionary *columnMajorData = [DataManager convertDataToColumnMajor:rowMajorData forProjectID:[dm getProjectID]];
        
        // upload the data to iSENSE
        [api uploadDataToProject:[dm getProjectID] withData:columnMajorData andName:dataSetName];
        
        // you're done! this uploadDataToProject method returns a data set ID number that you can store or check.
        // this dataSetID variable will now contain either a positive integer if the data uploaded
        // successfully (namely the ID of your new data set), or -1 if the upload failed.  if your upload failed,
        // you may have misformatted the data.
    });
}

@end