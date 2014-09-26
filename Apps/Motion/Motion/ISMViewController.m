//
//  ISMViewController.m
//  Motion
//
//  Created by Mike Stowell on 9/9/14.
//  Copyright (c) 2014 iSENSE. All rights reserved.
//

#import "ISMViewController.h"

@interface ISMViewController ()
@end

// Forward declared interface
@interface DLAVAlertViewController ()
+ (instancetype)sharedController;
- (void)setBackdropColor:(UIColor *)color;
- (void)addAlertView:(DLAVAlertView *)alertView;
- (void)removeAlertView:(DLAVAlertView *)alertView;
@end

@implementation ISMViewController

// Queue Saver Properties
@synthesize dataSaver, managedObjectContext;
// UI
@synthesize credentialBarBtn, xLbl, yLbl, zLbl, sampleRateBtn, recordingLengthBtn, startStopBtn, uploadBtn, projectBtn;


#pragma mark - View and overriden methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
	
    // If the Credential Manager was recently active, re-show it
    [self reInstateCredentialManagerDialog];
    
    // Managed Object Context for Data_CollectorAppDelegate
    if (managedObjectContext == nil) {
        managedObjectContext = [(ISMAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    
    // DataSaver from Data_CollectorAppDelegate
    if (dataSaver == nil)
        dataSaver = [(ISMAppDelegate *) [[UIApplication sharedApplication] delegate] dataSaver];
    
    // Initialize API
    api = [API getInstance];
    [api useDev:true];

    // Friendly reminder the app is on dev - app should never be released in dev mode
    if ([api isUsingDev]) {
        UILabel *devLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 80, 30)];
        devLabel.font = [UIFont fontWithName:@"Helvetica" size:8];
        devLabel.text = @"USING DEV";
        devLabel.textColor = [UIColor redColor];
        [self.view addSubview:devLabel];
    }
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    dm = [DataManager getInstance];
    [projectBtn setTitle:[NSString stringWithFormat:@"To Project: %d", [dm getProjectID]] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma end - View and overriden methods

#pragma mark - Recording data

- (IBAction)startStopOnClick:(id)sender {
    
    // TODO implement
}

#pragma end - Recording data

#pragma mark - Upload

- (IBAction)uploadBtnOnClick:(id)sender {

    // TODO test - remove once you are comfortable with uploading data with this app

    int p = 828;

    [dm setProjectID:p];
    [dm retrieveProjectFields];

    NSMutableArray *data = [[NSMutableArray alloc] init];

    DataContainer *dc = [[DataContainer alloc] init];
    [dc addData:[NSNumber numberWithInt:100] forKey:sACCEL_X];
    [dc addData:[NSNumber numberWithInt:200] forKey:sACCEL_Y];
    [dc addData:[NSNumber numberWithInt:300] forKey:sACCEL_Z];
    [data addObject:[dm writeDataToJSONObject:dc]];

    dc = [[DataContainer alloc] init];
    [dc addData:[NSNumber numberWithInt:400] forKey:sACCEL_X];
    [dc addData:[NSNumber numberWithInt:500] forKey:sACCEL_Y];
    [dc addData:[NSNumber numberWithInt:600] forKey:sACCEL_Z];
    [data addObject:[dm writeDataToJSONObject:dc]];

    [api createSessionWithEmail:@"t@t.t" andPassword:@"t"];

    NSMutableDictionary *colData = [DataManager convertDataToColumnMajor:data forProjectID:p andRecognizedFields:nil];
    [api uploadDataToProject:p withData:colData andName:@"Data set"];

    // END test

    QueueUploaderView *queueUploader = [[QueueUploaderView alloc] initWithParentName:PARENT_MOTION];
    queueUploader.title = @"Upload";
    [self.navigationController pushViewController:queueUploader animated:YES];
}

#pragma end - Upload

#pragma mark - Credentials

- (void) reInstateCredentialManagerDialog {
    
    if (credentialMgrAlert && ![credentialMgrAlert isHidden]) {
        [credentialMgrAlert dismissWithClickedButtonIndex:0 animated:YES];
        [self createCredentialManagerDialog];
    }
}

- (void) createCredentialManagerDialog {
    
    credentialMgr = [[CredentialManager alloc] initWithDelegate:self];
    DLAVAlertViewController *parent = [DLAVAlertViewController sharedController];
    [parent addChildViewController:credentialMgr];
    credentialMgrAlert = [[DLAVAlertView alloc] initWithTitle:@"Credential Manager" message:@"" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [credentialMgrAlert setContentView:credentialMgr.view];
    [credentialMgrAlert setDismissesOnBackdropTap:YES];
    [credentialMgrAlert show];
}

- (IBAction)credentialBarBtnOnClick:(id)sender {
    
    [self createCredentialManagerDialog];
}

- (void) didPressLogin:(CredentialManager *)mngr {
    
    [credentialMgrAlert dismissWithClickedButtonIndex:0 animated:YES];
    credentialMgrAlert = nil;
    
    UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"Login to iSENSE" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [loginAlert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    loginAlert.tag = kLOGIN_DIALOG_TAG;
    
    [loginAlert textFieldAtIndex:0].delegate = self;
    [loginAlert textFieldAtIndex:0].tag = kLOGIN_USER_TEXT;
    [[loginAlert textFieldAtIndex:0] becomeFirstResponder];
    [loginAlert textFieldAtIndex:0].placeholder = @"Email";
    
    [loginAlert textFieldAtIndex:1].delegate = self;
    [loginAlert textFieldAtIndex:1].tag = kLOGIN_PASS_TEXT;
    
    [loginAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (alertView.tag) {
        case kLOGIN_DIALOG_TAG:
        {
            NSString *user = [alertView textFieldAtIndex:0].text;
            NSString *pass = [alertView textFieldAtIndex:1].text;
            
            if ([user length] != 0 && [pass length] !=0)
                [self login:user withPassword:pass];
            
            break;
        }
        default:
            NSLog(@"Unrecognized dialog!");
            break;
    }
}

// Login to iSENSE
- (void) login:(NSString *)email withPassword:(NSString *)pass {
    
    UIAlertView *spinnerDialog = [self getDispatchDialogWithMessage:@"Logging in..."];
    [spinnerDialog show];
    
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog_login", NULL);
    dispatch_async(queue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            RPerson *currUser = [api createSessionWithEmail:email andPassword:pass];
            if (currUser != nil) {
                [self.view makeWaffle:[NSString stringWithFormat:@"Login as %@ successful", email]
                             duration:WAFFLE_LENGTH_SHORT
                             position:WAFFLE_BOTTOM
                                image:WAFFLE_CHECKMARK];
                
                // save the username and password in prefs
                NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
                [prefs setObject:email forKey:pLOGIN_USERNAME];
                [prefs setObject:pass forKey:pLOGIN_PASSWORD];
                [prefs synchronize];
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

#pragma mark - Sample rate and recording length

// Called before performing a transition segue in the storyboard
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"segueSampleRate"]) {
        ISMSampleRate *destController = (ISMSampleRate *) [segue destinationViewController];
        [destController setDelegateObject:self];
    } else if ([[segue identifier] isEqualToString:@"segueRecordingLength"]) {
        ISMRecordingLength *destController = (ISMRecordingLength *) [segue destinationViewController];
        [destController setDelegateObject:self];
    }
    
}

// Called when returning from the sample rate selection screen
- (void) didChooseSampleRate:(double)sampleRateInSeconds withName:(NSString *)sampleRateAsString andDelegate:(ISMSampleRate *)delegateObject {
    
    NSLog(@"Sample rate: %lf", sampleRateInSeconds);
    
    sampleRate = sampleRateInSeconds;
    [sampleRateBtn setTitle:sampleRateAsString forState:UIControlStateNormal];
}

// Called when returning from the recording length selection screen
- (void) didChooseRecordingLength:(int)recordingLengthInSeconds withName:(NSString *)recordingLengthAsString andDelegate:(ISMRecordingLength *)delegateObject {
    
    NSLog(@"Recording length: %d", recordingLengthInSeconds);

    recordingLength = recordingLengthInSeconds;
    [recordingLengthBtn setTitle:recordingLengthAsString forState:UIControlStateNormal];
}

#pragma end - Sample rate and recording length

@end
