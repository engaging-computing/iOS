//
//  ISMViewController.h
//  Motion
//
//  Created by Mike Stowell on 9/9/14.
//  Copyright (c) 2014 iSENSE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueueUploaderView.h"
#import "CredentialManager.h"
#import "DLAVAlertViewController.h"

// Constants
#define kLOGIN_USER_TEXT 500
#define kLOGIN_PASS_TEXT 501

@interface ISMViewController : UIViewController <UIAlertViewDelegate, UITextFieldDelegate, CredentialManagerDelegate> {
    
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