//
//  ISMViewController.h
//  Motion
//
//  Created by Mike Stowell on 9/9/14.
//  Copyright (c) 2014 iSENSE. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "API.h"
#import "QueueUploaderView.h"
#import "CredentialManager.h"
#import "DLAVAlertViewController.h"
#import "ISMSampleRate.h"
#import "ISMRecordingLength.h"
#import "Waffle.h"

// Login Constants
#define kLOGIN_DIALOG_TAG 500
#define kLOGIN_USER_TEXT 501
#define kLOGIN_PASS_TEXT 502

@interface ISMViewController : UIViewController
    <UIAlertViewDelegate,
    UITextFieldDelegate,
    CredentialManagerDelegate,
    ISMSampleRateDelegate,
    ISMRecordingLengthDelegate>
{
    
    // API
    API *api;
    
    // Credential Manager
    CredentialManager *credentialMgr;
    DLAVAlertView *credentialMgrAlert;
    
}

// Queue Saver Properties
@property (nonatomic, strong) DataSaver *dataSaver;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

// UI elements and click methods
@property (weak, nonatomic) IBOutlet UIBarButtonItem *credentialBarBtn;
- (IBAction)credentialBarBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *xLbl;
@property (weak, nonatomic) IBOutlet UILabel *yLbl;
@property (weak, nonatomic) IBOutlet UILabel *zLbl;

@property (weak, nonatomic) IBOutlet UIButton *sampleRateBtn;
@property (weak, nonatomic) IBOutlet UIButton *recordingLengthBtn;

@property (weak, nonatomic) IBOutlet UIButton *startStopBtn;
- (IBAction)startStopOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;
- (IBAction)uploadBtnOnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *projectBtn;

@end