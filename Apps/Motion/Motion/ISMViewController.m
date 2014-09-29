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

    // Add long press gesture recognizer to the start-stop button
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(startStopOnLongClick:)];
    [startStopBtn addGestureRecognizer:longPress];

    // Friendly reminder the app is on dev - app should never be released in dev mode
    if ([api isUsingDev]) {
        UILabel *devLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 80, 30)];
        devLabel.font = [UIFont fontWithName:@"Helvetica" size:8];
        devLabel.text = @"USING DEV";
        devLabel.textColor = [UIColor redColor];
        [self.view addSubview:devLabel];
    }

    // Initialize the location manager (TODO - may be best to eventually move this so it's only called when needed)
    [self initLocations];

    // Initialize the motion manager
    motionManager = [[CMMotionManager alloc] init];

    // Default sample rate and recording length
    sampleRate = kDEFAULT_SAMPLE_RATE;
    recordingLength = kDEFAULT_RECORDING_LENGTH;

    // Ensure isRecording is set to false on loading the view
    isRecording = false;
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

- (void)startStopOnLongClick:(UILongPressGestureRecognizer *)gesture {

    if (gesture.state == UIGestureRecognizerStateBegan) {

        if (isRecording) {

            // stop recording data
            isRecording = false;

            [startStopBtn setTitle:@"Hold to Start" forState:UIControlStateNormal];
            [self stopRecordingData];
        } else {

            // start recording data
            isRecording = true;

            [startStopBtn setTitle:@"Hold to Stop" forState:UIControlStateNormal];
            [self beginRecordingData];
        }

        // Emit a beep
        NSString *beepPath = [NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] resourcePath], @"/button-37.wav"];
        SystemSoundID soundID;
        NSURL *filePath = [NSURL fileURLWithPath:beepPath isDirectory:NO];
        AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(filePath), &soundID);
        AudioServicesPlaySystemSound(soundID);
    }

}

- (void)beginRecordingData {

    // TODO - may it be better to set the update interval slightly faster than the sampleRate?

    if (motionManager.accelerometerAvailable) {
        motionManager.accelerometerUpdateInterval = sampleRate;
        [motionManager startAccelerometerUpdates];
    }
    if (motionManager.magnetometerActive) {
        motionManager.magnetometerUpdateInterval = sampleRate;
        [motionManager startMagnetometerUpdates];
    }
    if (motionManager.gyroAvailable) {
        motionManager.gyroUpdateInterval = sampleRate;
        [motionManager startGyroUpdates];
    }

    dataRecordingTimer = [NSTimer scheduledTimerWithTimeInterval:sampleRate
                                                          target:self
                                                        selector:@selector(recordDataPoint)
                                                        userInfo:nil
                                                         repeats:YES];
}

- (void)recordDataPoint {

    if (!isRecording && dataRecordingTimer) {

        [dataRecordingTimer invalidate];
        dataRecordingTimer = nil;
    } else {

        dispatch_queue_t queue = dispatch_queue_create("motion_recording_data", NULL);
        dispatch_async(queue, ^{

            // TODO - get data and save it
            NSLog(@"DATAAAAAAAAAAAAAAAAA!!!!!1!!");
        });
    }

}

- (void)stopRecordingData {

    if (dataRecordingTimer)
        [dataRecordingTimer invalidate];

    dataRecordingTimer = nil;

    if (motionManager.accelerometerActive)
        [motionManager stopAccelerometerUpdates];

    if (motionManager.magnetometerActive)
        [motionManager stopMagnetometerUpdates];

    if (motionManager.gyroActive)
        [motionManager stopGyroUpdates];

    // TODO - any further stop-recording code needed (e.g. saving a dataset)
    NSLog(@"Done recording data");
}

#pragma end - Recording data

#pragma mark - Location

// Initializes the location manager to begin receiving location updates
- (void) initLocations {
    if (!locationManager) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;

        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;

        [locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {

    NSLog(@"didFailWithError: %@", error);

}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {

    double newLatitude = newLocation.coordinate.latitude, newLongitude = newLocation.coordinate.longitude;
    double oldLatitude = oldLocation.coordinate.latitude, oldLongitude = oldLocation.coordinate.longitude;

    // only update GPS coordinates when a new point is received
    if (newLatitude != oldLatitude && newLongitude != oldLongitude) {

        NSLog(@"didUpdateToLocation: %@", newLocation);
    }

}

#pragma end - Location

#pragma mark - Motion



#pragma end - Motion

#pragma mark - Upload

- (IBAction)uploadBtnOnClick:(id)sender {

    // TODO test - remove once you are comfortable with uploading data with this app

//    int p = 828;
//
//    [dm setProjectID:p];
//    [dm retrieveProjectFields];
//
//    NSMutableArray *data = [[NSMutableArray alloc] init];
//
//    DataContainer *dc = [[DataContainer alloc] init];
//    [dc addData:[NSNumber numberWithInt:100] forKey:sACCEL_X];
//    [dc addData:[NSNumber numberWithInt:200] forKey:sACCEL_Y];
//    [dc addData:[NSNumber numberWithInt:300] forKey:sACCEL_Z];
//    [data addObject:[dm writeDataToJSONObject:dc]];
//
//    dc = [[DataContainer alloc] init];
//    [dc addData:[NSNumber numberWithInt:400] forKey:sACCEL_X];
//    [dc addData:[NSNumber numberWithInt:500] forKey:sACCEL_Y];
//    [dc addData:[NSNumber numberWithInt:600] forKey:sACCEL_Z];
//    [data addObject:[dm writeDataToJSONObject:dc]];
//
//    [api createSessionWithEmail:@"t@t.t" andPassword:@"t"];
//
//    NSMutableDictionary *colData = [DataManager convertDataToColumnMajor:data forProjectID:p andRecognizedFields:nil];
//    [api uploadDataToProject:p withData:colData andName:@"Data set"];

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
