//
//  ViewController.m
//  Writer
//
//  Created by Mike Stowell on 11/4/14.
//  Copyright (c) 2014 iSENSE. All rights reserved.
//

#import "ISWViewController.h"
#import "ISWAppDelegate.h"

@interface ISWViewController ()
@end

// Forward declared interface
@interface DLAVAlertViewController ()
+ (instancetype)sharedController;
- (void)setBackdropColor:(UIColor *)color;
- (void)addAlertView:(DLAVAlertView *)alertView;
- (void)removeAlertView:(DLAVAlertView *)alertView;
@end

@implementation ISWViewController

// Queue Saver Properties
@synthesize dataSaver, managedObjectContext;
// UI
@synthesize credentialBarBtn, dataSetNameLbl, dataSetNameTxt, projectBtn, saveRowBtn, saveDataSetBtn, contentView, uploadBtn;

- (void)viewDidLoad {

    [super viewDidLoad];

    // Managed Object Context for Data_CollectorAppDelegate
    if (managedObjectContext == nil) {
        managedObjectContext = [(ISWAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }

    // DataSaver from Data_CollectorAppDelegate
    if (dataSaver == nil) {
        dataSaver = [(ISWAppDelegate *) [[UIApplication sharedApplication] delegate] dataSaver];
    }

    // Initialize API and start separate thread to reload any user that has been saved to preferences
    api = [API getInstance];
    [api useDev:USE_DEV];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [api loadCurrentUserFromPrefs];
    });

    // Set the data set name label to be our secret dev/non-dev switch
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleDev)];
    tapGestureRecognizer.numberOfTapsRequired = 7;
    [dataSetNameLbl addGestureRecognizer:tapGestureRecognizer];
    dataSetNameLbl.userInteractionEnabled = YES;

    // Attach the data set name text field to the application delegate to restrict character input
    dataSetNameTxt.delegate = self;

    // Set navigation bar color
    @try {
        if ([UINavigationBar instancesRespondToSelector:@selector(barTintColor)]) {
            // for iOS 7 and higher devices
            [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
            [self.navigationController.navigationBar setTintColor:UIColorFromHex(0xFFFFFF)];
            [self.navigationController.navigationBar setBarTintColor:UIColorFromHex(0x89D986)];
        } else {
            // for iOS 6 and lower devices
            [self.navigationController.navigationBar setTintColor:UIColorFromHex(0x89D986)];
        }
    } @catch (NSException *e) {
        // could not set navigation color - ignore the error
    }
}

- (void)toggleDev {

    [api useDev:![api isUsingDev]];
    [self.view makeWaffle:([api isUsingDev] ? @"Using dev" : @"Using production")];
    [self checkAPIOnDev];
}

- (void)checkAPIOnDev {

    if ([api isUsingDev]) {
        devLbl = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 80, 30)];
        devLbl.font = [UIFont fontWithName:@"Helvetica" size:8];
        devLbl.backgroundColor = [UIColor clearColor];
        devLbl.text = @"USING DEV";
        devLbl.textColor = [UIColor redColor];
        [self.view addSubview:devLbl];
    } else if (devLbl) {
        [devLbl removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
}

- (IBAction)saveRowBtnOnClick:(id)sender {
    // TODO
}

- (IBAction)saveDataSetBtnOnClick:(id)sender {
    // TODO
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    // TODO add cases for alert dialogs
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
        {
            break;
        }
    }
}

// restrict length of text entered
// 90 is chosen because 128 is the limit on iSENSE, and the app will eventually append
// a ~20 character timestamp to the data set name
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 90) ? NO : YES;

    return YES;
}

- (IBAction)uploadBtnOnClick:(id)sender {

    QueueUploaderView *queueUploader = [[QueueUploaderView alloc] initWithParentName:PARENT_MOTION andDelegate:self];
    queueUploader.title = @"Upload";
    [self.navigationController pushViewController:queueUploader animated:YES];
}

- (void) didFinishUploadingDataWithStatus:(int)status {

    switch (status) {
        case DATA_NONE_UPLOADED:
            [self.view makeWaffle:@"No data uploaded"];
            break;

        case DATA_UPLOAD_FAILED:
            [self.view makeWaffle:@"One or more data sets failed to upload" duration:WAFFLE_LENGTH_LONG position:WAFFLE_BOTTOM image:WAFFLE_RED_X];
            break;

        case DATA_UPLOAD_SUCCESS:
            [self.view makeWaffle:@"Data set(s) uploaded successfully" duration:WAFFLE_LENGTH_LONG position:WAFFLE_BOTTOM image:WAFFLE_CHECKMARK];
            break;

        default:
            NSLog(@"Unrecognized upload status received from QueueUploadViewController in ISMViewController");
            break;
    }
}

- (void) createCredentialManagerDialog {

    credentialMgr = [[CredentialManager alloc] initWithDelegate:self];
    DLAVAlertViewController *parent = [DLAVAlertViewController sharedController];
    [parent addChildViewController:credentialMgr];
    credentialMgrAlert = [[DLAVAlertView alloc] initWithTitle:@"Account Credentials" message:@"" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
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

    UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"Login to iSENSE"
                                                         message:@""
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                               otherButtonTitles:@"OK", nil];
    [loginAlert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    loginAlert.tag = kLOGIN_DIALOG_TAG;

    [loginAlert textFieldAtIndex:0].delegate = self;
    [loginAlert textFieldAtIndex:0].placeholder = @"Email";

    // since the CredentialManager takes a moment to dismiss and allow the login AlertView become a first responder,
    // we have to sleep the first responder action for 1.5 seconds.  this can be removed once the Credential Manager
    // is rewritten
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [[loginAlert textFieldAtIndex:0] becomeFirstResponder];
    });

    [loginAlert textFieldAtIndex:1].delegate = self;

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


@end
