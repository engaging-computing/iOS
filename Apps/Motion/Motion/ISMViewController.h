//
//  ISMViewController.h
//  Motion
//
//  Created by Mike Stowell on 9/9/14.
//  Copyright (c) 2014 iSENSE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>

#import "API.h"
#import "QueueUploaderView.h"
#import "CredentialManager.h"
#import "DLAVAlertViewController.h"
#import "ISMSampleRate.h"
#import "ISMRecordingLength.h"
#import "Waffle.h"
#import "DataManager.h"

@interface ISMViewController : UIViewController
    <UIAlertViewDelegate,
    UITextFieldDelegate,
    CredentialManagerDelegate,
    ISMSampleRateDelegate,
    ISMRecordingLengthDelegate,
    CLLocationManagerDelegate,
    QueueUploaderDelegate>
{
    // API and DataManager
    API *api;
    DataManager *dm;
    
    // Credential Manager
    CredentialManager *credentialMgr;
    DLAVAlertView *credentialMgrAlert;
    
    // Sample rate and recording length
    double sampleRate;
    int recordingLength;

    // Recording state, timer, and sensor objects
    bool isRecording;
    NSTimer *dataRecordingTimer;
    CLLocationManager *locationManager;
    CMMotionManager *motionManager;

    // Data for a single run session
    NSMutableArray *dataPoints;
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

@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;
- (IBAction)uploadBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *projectBtn;

@end