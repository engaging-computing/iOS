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
}

- (void) reInstateCredentialManagerDialog {
    if (credentialMgrAlert != nil && ![credentialMgrAlert isHidden]) {
        [credentialMgrAlert dismissWithClickedButtonIndex:0 animated:YES];
        credentialMgr = [[CredentialManager alloc] initWithDelegate:self];
        DLAVAlertViewController *parent = [DLAVAlertViewController sharedController];
        [parent addChildViewController:credentialMgr];
        credentialMgrAlert = [[DLAVAlertView alloc] initWithTitle:@"Credential Manager" message:@"" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [credentialMgrAlert setContentView:credentialMgr.view];
        [credentialMgrAlert setDismissesOnBackdropTap:YES];
        [credentialMgrAlert show];
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startStopOnClick:(id)sender {
    // TODO implement
}

- (IBAction)uploadBtnOnClick:(id)sender {
    
    QueueUploaderView *queueUploader = [[QueueUploaderView alloc] initWithParentName:PARENT_MOTION];
    queueUploader.title = @"Upload";
    [self.navigationController pushViewController:queueUploader animated:YES];
}

- (IBAction)credentialBarBtnOnClick:(id)sender {
    credentialMgr = [[CredentialManager alloc] initWithDelegate:self];
    DLAVAlertViewController *parent = [DLAVAlertViewController sharedController];
    [parent addChildViewController:credentialMgr];
    credentialMgrAlert = [[DLAVAlertView alloc] initWithTitle:@"Credential Manager" message:@"" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [credentialMgrAlert setContentView:credentialMgr.view];
    [credentialMgrAlert setDismissesOnBackdropTap:YES];
    [credentialMgrAlert show];
}

- (void) didPressLogin:(CredentialManager *)mngr {
    [credentialMgrAlert dismissWithClickedButtonIndex:0 animated:YES];
    credentialMgrAlert = nil;
    
    UIAlertView *loginalert = [[UIAlertView alloc] initWithTitle:@"Login to iSENSE" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [loginalert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    [loginalert textFieldAtIndex:0].delegate = self;
    [loginalert textFieldAtIndex:0].tag = kLOGIN_USER_TEXT;
    [[loginalert textFieldAtIndex:0] becomeFirstResponder];
    [loginalert textFieldAtIndex:1].delegate = self;
    [loginalert textFieldAtIndex:1].tag = kLOGIN_PASS_TEXT;
    [loginalert textFieldAtIndex:0].placeholder = @"Email";
    [loginalert show];
}

@end
