/*
 * iSENSE Project - isenseproject.org
 * This file is part of the iSENSE iOS API and applications.
 *
 * Copyright (c) 2015, University of Massachusetts Lowell. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this
 * list of conditions and the following disclaimer. Redistributions in binary
 * form must reproduce the above copyright notice, this list of conditions and
 * the following disclaimer in the documentation and/or other materials
 * provided with the distribution. Neither the name of the University of
 * Massachusetts Lowell nor the names of its contributors may be used to
 * endorse or promote products derived from this software without specific
 * prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 *
 * BSD 3-Clause License
 * http://opensource.org/licenses/BSD-3-Clause
 *
 * Our work is supported by grants DRL-0735597, DRL-0735592, DRL-0546513, IIS-1123998,
 * and IIS-1123972 from the National Science Foundation and a gift from Google Inc.
 *
 */

//
// ISMViewController.m
// Motion
//
// Created by Mike Stowell on 9/9/14.
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
@synthesize menuBarBtn, credentialBarBtn, xLbl, yLbl, zLbl, sampleRateBtn;
@synthesize recordingLengthBtn, startStopBtn, nameBtn, uploadBtn, projectBtn;


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
    if (dataSaver == nil) {
        dataSaver = [(ISMAppDelegate *) [[UIApplication sharedApplication] delegate] dataSaver];
    }

    // Initialize API and start separate thread to reload any user that has been saved to preferences
    api = [API getInstance];
    [api useDev:USE_DEV];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [api loadCurrentUserFromKeychain];
    });

    // Set the Z: label to be our secret dev/non-dev switch
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleDev)];
    tapGestureRecognizer.numberOfTapsRequired = 7;
    [zLbl addGestureRecognizer:tapGestureRecognizer];
    zLbl.userInteractionEnabled = YES;

    // Creates a label that states "USING DEV" if the API is in dev mode
    [self checkAPIOnDev];

    // Add long press gesture recognizer to the start-stop button
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(startStopOnLongClick:)];
    [startStopBtn addGestureRecognizer:longPress];

    // Initialize the motion manager
    motionManager = [[CMMotionManager alloc] init];

    // Default sample rate, recording length, and data set name
    sampleRate = kDEFAULT_SAMPLE_RATE;
    recordingLength = kDEFAULT_RECORDING_LENGTH;
    dataSetName = kDEFAULT_DATA_SET_NAME;

    // Ensure isRecording is set to false on loading the view
    isRecording = false;

    // Set navigation bar color
    @try {
        if ([UINavigationBar instancesRespondToSelector:@selector(barTintColor)]) {
            // for iOS 7 and higher devices
            [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
            [self.navigationController.navigationBar setTintColor:UIColorFromHex(cNAV_WHITE_TINT)];
            [self.navigationController.navigationBar setBarTintColor:UIColorFromHex(cNAV_MOTION_PURPLE_TINT)];
        } else {
            // for iOS 6 and lower devices
            [self.navigationController.navigationBar setTintColor:UIColorFromHex(cNAV_MOTION_PURPLE_TINT)];
        }
    } @catch (NSException *e) {
        // could not set navigation color - ignore the error
    }

    // Initialize the DataManager
    dm = [DataManager getInstance];
    [dm retrieveProjectFields];

    // if the tutorial is not being shown, setup the application in its last state using prefs
    [self loadSetupFromPrefs];
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

    // Display one-time tutorial and preset setup
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    BOOL tutorialShown = [prefs boolForKey:pDISPLAYED_TUTORIAL];

    if (!tutorialShown) {

        UIStoryboard *tutorialStoryboard = [UIStoryboard storyboardWithName:@"Tutorial" bundle:nil];
        ISMTutorialViewController *tutorialController = [tutorialStoryboard instantiateViewControllerWithIdentifier:@"TutorialStartController"];
        [tutorialController setDelegate:self];
        [self.parentViewController presentViewController:tutorialController animated:NO completion:nil];

        return;
    }
}

- (void)toggleDev {

    bool devSwitch = ![api isUsingDev];
    [api useDev:devSwitch];

    [self.view makeWaffle:(devSwitch ? @"Using dev" : @"Using production")];
    [self checkAPIOnDev];

    [dm setProjectID:devSwitch ? kDEFAULT_PROJ_DEV : kDEFAULT_PROJ_PRODUCTION];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [dm retrieveProjectFields];
    });
    [self setProjBtnToCurrentProj];
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

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    [self setProjBtnToCurrentProj];

    // Initialize the location manager and register for updates
    [self registerLocationUpdates];
}

- (void)setProjBtnToCurrentProj {

    int curProjID = [dm getProjectID];
    NSString *curProjIDStr = (curProjID > 0) ? [NSString stringWithFormat:@"%d", curProjID] : kNO_PROJECT;
    [projectBtn setTitle:[NSString stringWithFormat:@"Project: %@", curProjIDStr] forState:UIControlStateNormal];
}

- (void)viewWillDisappear:(BOOL)animated {

    [self unregisterLocationUpdates];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
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
        case kNAME_DIALOG_TAG:
        {
            NSString *name = [alertView textFieldAtIndex:0].text;

            if (name && [name length] > 0) {
                dataSetName = name;
                [nameBtn setTitle:dataSetName forState:UIControlStateNormal];
            }

            break;
        }
        case kLOCATION_DIALOG_IOS_8_AND_LATER_TAG:
        case kLOCATION_DIALOG_IOS_7_AND_EARLIER_TAG:
        {
            if (buttonIndex == 0) {

                // user does not wish to have location data recorded, save this choice in prefs
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                [prefs setBool:true forKey:kOPT_OUT_LOCATION];
                [prefs synchronize];

                return;
            }

            if (alertView.tag == kLOCATION_DIALOG_IOS_8_AND_LATER_TAG) {

                // Send the user to the Settings for this app to allow them to change location settings.
                @try {

                    NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    [[UIApplication sharedApplication] openURL:settingsURL options:@{} completionHandler:nil];

                } @catch (NSException *e) {

                    // in the event that versions beyond iOS 8 re-disable the ability to launch app settings, we will
                    // display a dialog to the user
                    alertView = [[UIAlertView alloc] initWithTitle:@"Cannot navigate to settings"
                                                           message:@"We are sorry, but it seems Apple disabled our ability to bring you to the settings.  Please manually go to the Location Services settings and enable location updates for this app."
                                                          delegate:self
                                                 cancelButtonTitle:@"Okay"
                                                 otherButtonTitles:nil];
                    [alertView show];
                }
            }

            break;
        }
        case kVISUALIZE_DIALOG_TAG:
        {
            if (buttonIndex != 0) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:visURL] options:@{} completionHandler:nil];
            }
            
            break;
        }
        case kMENU_DIALOG_TAG:
        {
            switch (buttonIndex) {
                case kBTN_SPLASH:
                {
                    if (!splashView) {
                        // get the splash view from the LaunchScreen xib
                        NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"LaunchScreen" owner:self options:nil];
                        for (id obj in bundle) {
                            if ([obj isKindOfClass:[UIView class]]) {
                                splashView = (UIView *) obj;
                                break;
                            }
                        }
                    }

                    if (!splashView) {
                        [self.view makeWaffle:@"Error loading splash screen"
                                     duration:WAFFLE_LENGTH_LONG
                                     position:WAFFLE_BOTTOM
                                        image:WAFFLE_RED_X];
                        return;
                    }

                    // resize the splash screen to fit the bound of the window
                    splashView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);

                    // replace the current left menu button with a back button
                    self.navigationItem.leftBarButtonItem.title = @"Back";
                    self.navigationItem.rightBarButtonItem.enabled = false;

                    // display the splash screen
                    [self.view addSubview:splashView];
                    isSplashDisplaying = true;

                    return;
                }
                case kBTN_TUTORIALS:
                {
                    // transition to the tutorial storyboard
                    UIStoryboard *tutorialStoryboard = [UIStoryboard storyboardWithName:@"Tutorial" bundle:nil];
                    ISMTutorialViewController *tutorialController = [tutorialStoryboard instantiateViewControllerWithIdentifier:@"TutorialStartController"];
                    [tutorialController setDelegate:self];
                    [self.parentViewController presentViewController:tutorialController animated:YES completion:nil];

                    return;
                }
                case kBTN_PRESETS:
                {
                    UIStoryboard *presetStoryboard = [UIStoryboard storyboardWithName:@"Preset" bundle:nil];
                    ISMPresets *presetController = [presetStoryboard
                        instantiateViewControllerWithIdentifier:@"PresetStartController"];
                    [presetController setDelegate:self];
                    [self.parentViewController presentViewController:presetController animated:YES completion:nil];

                    return;
                }
                default:
                    return;
            }
        }
        default:
            break;
    }
}

// restrict length of text entered in the data set name AlertView
// 90 is chosen because 128 is the limit on iSENSE, and the app will eventually append
// a ~20 character timestamp to the data set name
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength <= 90);
}

#pragma end - View and overriden methods

#pragma mark - Presets and prefs setup

- (void) didFinishSavingPresetWithID:(int)presetID {

    int projID;
    BOOL dev = [api isUsingDev];

    // setup the project, sample rate, and recording length based on the preset selected
    if (presetID == kPRESET_ACCEL) {

        projID = dev ? kDEFAULT_ACCEL_DEV : kDEFAULT_ACCEL_PRODUCTION;
        sampleRate = kS_RATE_FIFTY_MS;
        recordingLength = kREC_LENGTH_TEN_S;

    } else if (presetID == kPRESET_GPS) {

        projID = dev ? kDEFAULT_GPS_DEV : kDEFAULT_GPS_PRODUCTION;
        sampleRate = kS_RATE_ONE_S;
        recordingLength = kREC_LENGTH_PUSH_TO_STOP;

    } else /* presetID == kPRESET_DEFAULT */ {

        return;
    }

    [self setupAppWithProject:projID sampleRate:sampleRate andRecordingLength:recordingLength];
}

- (void)loadSetupFromPrefs {

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    int projID = (int) [prefs integerForKey:pPROJECT_ID];
    double sRate = [prefs doubleForKey:pSAMPLE_RATE];
    int recLength = (int) [prefs integerForKey:pRECORDING_LENGTH];

    if (projID >= 0 && sRate != 0.0 && recLength != 0) {
        [self setupAppWithProject:projID sampleRate:sRate andRecordingLength:recLength];
    }
}

- (void)setupAppWithProject:(int)projID sampleRate:(double)sRate andRecordingLength:(int)recLength {

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    sampleRate = sRate;
    recordingLength = recLength;

    // set and save the project
    [dm setProjectID:projID];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [dm retrieveProjectFields];
    });
    [self setProjBtnToCurrentProj];
    [prefs setInteger:projID forKey:pPROJECT_ID];

    // set and save the sample rate
    [sampleRateBtn setTitle:[self sampleRateAsString:sampleRate] forState:UIControlStateNormal];
    [prefs setDouble:sampleRate forKey:pSAMPLE_RATE];

    // set and save the recording length
    [recordingLengthBtn setTitle:[self recordingLengthAsString:recordingLength] forState:UIControlStateNormal];
    [prefs setInteger:recordingLength forKey:pRECORDING_LENGTH];

    [prefs synchronize];
}

#pragma end - Presets and prefs setup

#pragma mark - Recording data

- (void)startStopOnLongClick:(UILongPressGestureRecognizer *)gesture {

    if (gesture.state == UIGestureRecognizerStateBegan) {

        if (isRecording) {

            [self stopRecordingData];

        } else {

            // check to see if location is authorized for recording data before recording
            if ([self isLocationAuthorized])
                [self beginRecordingData];
        }
    }
}

- (void) emitBeep {

    NSString *beepPath = [NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] resourcePath], @"/button-37.wav"];
    NSURL *filePath = [NSURL fileURLWithPath:beepPath isDirectory:NO];

    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(filePath), &soundID);
    AudioServicesPlaySystemSound(soundID);
}

- (void)beginRecordingData {

    [self emitBeep];

    // start recording data
    isRecording = true;
    [self.view makeWaffle:@"Recording data"];

    // initialize the motion manager sensors, if available
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
    if (motionManager.deviceMotionAvailable) {
        motionManager.deviceMotionUpdateInterval = sampleRate;
        [motionManager startDeviceMotionUpdates];
    }

    // initialize the array of data points and mutex
    dataPoints = [[NSMutableArray alloc] init];
    dataPointsMutex = [NSLock new];

    // begin the data recording timer with the recordDataPoint selector
    dataRecordingTimer = [NSTimer scheduledTimerWithTimeInterval:sampleRate
                                                          target:self
                                                        selector:@selector(recordDataPoint)
                                                        userInfo:nil
                                                         repeats:YES];

    // if the recording length is not -1 (AKA Push to Stop), then set a timer that stops recording
    // data after the recording length interval
    if (recordingLength != -1) {

        countdown = recordingLength;
        [startStopBtn setTitle:[NSString stringWithFormat:@"%d", countdown] forState:UIControlStateNormal];

        recordingLengthTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                                target:self
                                                              selector:@selector(countDownDataRecording)
                                                              userInfo:nil
                                                               repeats:YES];
        return;
    }

    [startStopBtn setTitle:@"Hold to Stop" forState:UIControlStateNormal];
}

- (void)recordDataPoint {

    // cancel the timers if we are not recording data and return if so
    if (!isRecording && dataRecordingTimer) {

        [dataRecordingTimer invalidate];
        dataRecordingTimer = nil;

        // if the recording length has been specified and this timer is still active, invalidate it
        if (recordingLengthTimer) {

            [recordingLengthTimer invalidate];
            recordingLengthTimer = nil;
        }

        return;
    }

    // create a new serial queue with each successive data point recorded to ensure completion order
    dispatch_queue_t queue = dispatch_queue_create("motion_recording_data", NULL);
    dispatch_async(queue, ^{

        NSLog(@"Data point captured");

        // add a new NSDictionary of this current data point to the dataPoints array,
        // and utilize a mutex to ensure only one thread is adding to this array at one time
        [dataPointsMutex lock];
        [dataPoints addObject:[dm writeDataToJSONObject:[self populateDataContainer]]];
        [dataPointsMutex unlock];
    });
}

- (void)countDownDataRecording {

    [startStopBtn setTitle:[NSString stringWithFormat:@"%d", --countdown] forState:UIControlStateNormal];

    if (countdown <= 0) {
        [self stopRecordingData];
    }
}

// populate the data container with sensor values
- (DataContainer *)populateDataContainer {

    DataContainer *dc = [[DataContainer alloc] init];

    // Acceleration, m/s^2
    if (motionManager.accelerometerActive) {
        double accelX = [motionManager.accelerometerData acceleration].x * kGRAVITY;
        [dc addData:[NSString stringWithFormat:@"%f", accelX] forKey:sACCEL_X];

        double accelY = [motionManager.accelerometerData acceleration].y * kGRAVITY;
        [dc addData:[NSString stringWithFormat:@"%f", accelY] forKey:sACCEL_Y];

        double accelZ = [motionManager.accelerometerData acceleration].z * kGRAVITY;
        [dc addData:[NSString stringWithFormat:@"%f", accelZ] forKey:sACCEL_Z];

        double accelTotal = sqrt(pow(accelX, 2) + pow(accelY, 2) + pow(accelZ, 2));
        [dc addData:[NSString stringWithFormat:@"%f", accelTotal] forKey:sACCEL_TOTAL];

        dispatch_async(dispatch_get_main_queue(), ^{
            [xLbl setText:[[NSString stringWithFormat:@"X: %f", accelX] substringToIndex:9]];
            [yLbl setText:[[NSString stringWithFormat:@"Y: %f", accelY] substringToIndex:9]];
            [zLbl setText:[[NSString stringWithFormat:@"Z: %f", accelZ] substringToIndex:9]];
        });
    }

    // Temperature C, F, K - currently there is no open iOS API to the internal
    // temperature sensors of some iOS devices.  We would have to resort to using location
    // data and an external API to obtain the current ambient temperature.

    // Time
    long long timeMillis = (long long) ([[NSDate date] timeIntervalSince1970] * 1000);
    [dc addData:[NSString stringWithFormat:@"u %lld", timeMillis] forKey:sTIME_MILLIS];

    // Ambient light - there are ways to read light data in iOS, but they require private
    // headers that Apple will likely deny when attempting to upload this app to the
    // Apple app store

    // Angle, radians and degrees
    if (motionManager.deviceMotionActive) {
        double motionRad = [motionManager.deviceMotion attitude].pitch;
        [dc addData:[NSString stringWithFormat:@"%f", motionRad] forKey:sANGLE_RAD];

        double motionDeg = motionRad * 180 / M_PI;
        [dc addData:[NSString stringWithFormat:@"%f", motionDeg] forKey:sANGLE_DEG];
    }

    // Geospacial
    CLLocationCoordinate2D lc2d = [[locationManager location] coordinate];
    [dc addData:[NSString stringWithFormat:@"%f", lc2d.latitude] forKey:sLATITUDE];
    [dc addData:[NSString stringWithFormat:@"%f", lc2d.longitude] forKey:sLONGITUDE];

    // Magnetometer, micro-teslas
    if (motionManager.magnetometerActive) {
        double magX = [motionManager.magnetometerData magneticField].x;
        [dc addData:[NSString stringWithFormat:@"%f", magX] forKey:sMAG_X];

        double magY = [motionManager.magnetometerData magneticField].y;
        [dc addData:[NSString stringWithFormat:@"%f", magY] forKey:sMAG_Y];

        double magZ = [motionManager.magnetometerData magneticField].z;
        [dc addData:[NSString stringWithFormat:@"%f", magZ] forKey:sMAG_Z];

        double magTotal = sqrt(pow(magX, 2) + pow(magY, 2) + pow(magZ, 2));
        [dc addData:[NSString stringWithFormat:@"%f", magTotal] forKey:sMAG_TOTAL];
    }

    // Altitude, meters
    CLLocationDistance altitude = [[locationManager location] altitude];
    [dc addData:[NSString stringWithFormat:@"%f", altitude] forKey:sALTITUDE];

    // Pressure - this seems to be a new feature with no APIs yet to retrieve
    // barometric pressure.  Like temperature, this may have to be done based on
    // location and a weather API

    // Gyroscope, radians/s
    if (motionManager.gyroActive) {
        double gyroX = [motionManager.gyroData rotationRate].x;
        [dc addData:[NSString stringWithFormat:@"%f", gyroX] forKey:sGYRO_X];

        double gyroY = [motionManager.gyroData rotationRate].y;
        [dc addData:[NSString stringWithFormat:@"%f", gyroY] forKey:sGYRO_Y];

        double gyroZ = [motionManager.gyroData rotationRate].z;
        [dc addData:[NSString stringWithFormat:@"%f", gyroZ] forKey:sGYRO_Z];
    }

    return dc;
}

- (void)stopRecordingData {

    [self emitBeep];

    // stop recording data
    isRecording = false;
    [startStopBtn setTitle:@"Hold to Start" forState:UIControlStateNormal];

    [xLbl setText:@"X:"];
    [yLbl setText:@"Y:"];
    [zLbl setText:@"Z:"];

    if (dataRecordingTimer)
        [dataRecordingTimer invalidate];
    dataRecordingTimer = nil;

    if (recordingLengthTimer)
        [recordingLengthTimer invalidate];
    recordingLengthTimer = nil;

    if (motionManager.accelerometerActive)
        [motionManager stopAccelerometerUpdates];

    if (motionManager.magnetometerActive)
        [motionManager stopMagnetometerUpdates];

    if (motionManager.gyroActive)
        [motionManager stopGyroUpdates];

    // lock the data points array to ensure the data array is not being mutated
    // while we save it
    [dataPointsMutex lock];
    [self saveData];
    [dataPointsMutex unlock];
}

#pragma end - Recording data

#pragma mark - Location

// Initializes the location manager to begin receiving location updates
- (void) registerLocationUpdates {

    if (!locationManager) {

        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;

        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }

    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }

    [locationManager startUpdatingLocation];
}

// Stops the location manager from receiving location updates
- (void) unregisterLocationUpdates {

    if (locationManager)
        [locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
}

// check to see if the location was authorized for use (iOS 8 and later)
- (BOOL) isLocationAuthorized {

    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    BOOL userOptOutLocation = [prefs boolForKey:kOPT_OUT_LOCATION];

    // If the status is denied and user hasn't yet opted out entirely from being tracked, display an alert that can take the
    // user to the settings to enable location.  Note this only works in iOS 8 and above since the settings access API has been
    // removed in iOS versions 5 and 6.  By checking that this app responds to isOperatingSystemAtLeastVersion, we can tell
    // if this app is running on a device greater than iOS 8.  For all other versions, we will show a dialog that asks the user
    // to manually navigate to settings to enable location.
    if (!userOptOutLocation && status == kCLAuthorizationStatusDenied) {

        NSString *title = @"Location services are off";
        NSString *message;
        UIAlertView *alertView;

        if ([NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)]) {

            message = @"This app requires location data.  To enable location, select 'Settings' and turn on 'While Using the App' in the Location settings.  Select 'Cancel' if you do not wish to have your location recorded.";

            alertView = [[UIAlertView alloc] initWithTitle:title
                                                   message:message
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"Settings", nil];
            alertView.tag = kLOCATION_DIALOG_IOS_8_AND_LATER_TAG;

        } else {

            message = @"This app requires location data.  To enable location, navigate to the Location Services in Settings and turn on location for this application.  To be warned again when location is turned off for this app, select 'Okay'.  If you do not wish to have your location recorded, select 'Cancel'.";

            alertView = [[UIAlertView alloc] initWithTitle:title
                                                   message:message
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"Okay", nil];
            alertView.tag = kLOCATION_DIALOG_IOS_7_AND_EARLIER_TAG;

        }

        [alertView show];
        return false;
    }

    return true;
}

#pragma end - Location

#pragma mark - Upload

// saves the data to the queue
- (void) saveData {

    [dataSaver addDataSetWithContext:managedObjectContext
                                name:dataSetName
                          parentName:PARENT_MOTION
                         description:@"Captured from iOS Motion"
                           projectID:[dm getProjectID]
                                data:[dataPoints copy]
                          mediaPaths:nil
                          uploadable:([dm getProjectID] >= 1)
                   hasInitialProject:([dm getProjectID] >= 1)
                           andFields:[dm getRecognizedFields]];

    [self.view makeWaffle:@"Data set saved"];
}

- (IBAction)uploadBtnOnClick:(id)sender {

    QueueUploaderView *queueUploader = [[QueueUploaderView alloc] initWithParentName:PARENT_MOTION andDelegate:self];
    queueUploader.title = @"Upload";
    [self.navigationController pushViewController:queueUploader animated:YES];
}

- (void) didFinishUploadingDataWithStatus:(QueueUploadStatus *)status {

    int uploadStatus = [status getStatus];
    int project = [status getProject];
    int dataSetID = [status getDataSetID];

    if (uploadStatus == DATA_NONE_UPLOADED) {

        [self.view makeWaffle:@"No data uploaded"];
        return;

    } else if (uploadStatus == DATA_UPLOAD_FAILED && project <= 0) {

        [self.view makeWaffle:@"All data set(s) failed to upload. Data sets may be too large." duration:WAFFLE_LENGTH_LONG position:WAFFLE_BOTTOM image:WAFFLE_RED_X];
        return;

    }

    NSString *prependMessage;
    if (uploadStatus == DATA_UPLOAD_FAILED)
        prependMessage = @"Some data set(s) failed to upload, but at least one succeeded.  Some sets may be too large.";
    else /* uploadedStatus == DATA_UPLOAD_SUCCESS */
        prependMessage = @"All data set(s) uploaded successfully.";

    NSString *message = [NSString stringWithFormat:@"%@ Would you like to visualize the last successfully uploaded data set?", prependMessage];

    UIAlertView *visDataAlert = [[UIAlertView alloc] initWithTitle:@"Visualize Data"
                                                           message:message
                                                          delegate:self
                                                 cancelButtonTitle:@"No"
                                                 otherButtonTitles:@"Yes", nil];
    visDataAlert.tag = kVISUALIZE_DIALOG_TAG;
    [visDataAlert show];

    visURL = [NSString stringWithFormat:@"%@/projects/%d/data_sets/%d?embed=true",
              [api isUsingDev] ? BASE_DEV_URL : BASE_LIVE_URL,
              project, dataSetID];
}

#pragma end - Upload

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

#pragma mark - Menu

- (IBAction)menuBarBtnOnClick:(id)sender {

    if (isSplashDisplaying) {

        // bring back the left menu item
        self.navigationItem.leftBarButtonItem.title = @"Review";
        self.navigationItem.rightBarButtonItem.enabled = true;

        // remove the splash screen
        [splashView removeFromSuperview];
        isSplashDisplaying = false;

        return;
    }

    // display user review menu options
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Which screen would you like to review?"
                                           message:nil
                                          delegate:self
                                 cancelButtonTitle:@"Cancel"
                                 otherButtonTitles:@"Credits", @"Tutorials", @"Presets", nil];
    alertView.tag = kMENU_DIALOG_TAG;
    [alertView show];

}

#pragma end - Menu

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

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setDouble:sampleRate forKey:pSAMPLE_RATE];
    [prefs synchronize];
}

// Called when returning from the recording length selection screen
- (void) didChooseRecordingLength:(int)recordingLengthInSeconds withName:(NSString *)recordingLengthAsString andDelegate:(ISMRecordingLength *)delegateObject {
    
    NSLog(@"Recording length: %d", recordingLengthInSeconds);

    recordingLength = recordingLengthInSeconds;
    [recordingLengthBtn setTitle:recordingLengthAsString forState:UIControlStateNormal];

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:recordingLength forKey:pRECORDING_LENGTH];
    [prefs synchronize];
}

- (void) initSampleRateAndRecLengthDictionaries {

    sampleRateStrings = [[NSDictionary alloc] initWithObjectsAndKeys:
                         sS_RATE_TWENTY_MS,             [NSNumber numberWithDouble:kS_RATE_TWENTY_MS],
                         sS_RATE_FIFTY_MS,              [NSNumber numberWithDouble:kS_RATE_FIFTY_MS],
                         sS_RATE_ONE_HUNDRED_MS,        [NSNumber numberWithDouble:kS_RATE_ONE_HUNDRED_MS],
                         sS_RATE_TWO_HUNDRED_FIFTY_MS,  [NSNumber numberWithDouble:kS_RATE_TWO_HUNDRED_FIFTY_MS],
                         sS_RATE_FIVE_HUNDRED_MS,       [NSNumber numberWithDouble:kS_RATE_FIVE_HUNDRED_MS],
                         sS_RATE_ONE_S,                 [NSNumber numberWithDouble:kS_RATE_ONE_S],
                         sS_RATE_TWO_S,                 [NSNumber numberWithDouble:kS_RATE_TWO_S],
                         sS_RATE_THREE_S,               [NSNumber numberWithDouble:kS_RATE_THREE_S],
                         sS_RATE_FIVE_S,                [NSNumber numberWithDouble:kS_RATE_FIVE_S],
                         sS_RATE_TEN_S,                 [NSNumber numberWithDouble:kS_RATE_TEN_S],
                         sS_RATE_FIFTEEN_S,             [NSNumber numberWithDouble:kS_RATE_FIFTEEN_S],
                         sS_RATE_THIRTY_S,              [NSNumber numberWithDouble:kS_RATE_THIRTY_S],
                         nil];

    recLengthStrings = [[NSDictionary alloc] initWithObjectsAndKeys:
                        sREC_LENGTH_ONE_S,          [NSNumber numberWithInt:kREC_LENGTH_ONE_S],
                        sREC_LENGTH_TWO_S,          [NSNumber numberWithInt:kREC_LENGTH_TWO_S],
                        sREC_LENGTH_FIVE_S,         [NSNumber numberWithInt:kREC_LENGTH_FIVE_S],
                        sREC_LENGTH_TEN_S,          [NSNumber numberWithInt:kREC_LENGTH_TEN_S],
                        sREC_LENGTH_THIRTY_S,       [NSNumber numberWithInt:kREC_LENGTH_THIRTY_S],
                        sREC_LENGTH_ONE_M,          [NSNumber numberWithInt:kREC_LENGTH_ONE_M],
                        sREC_LENGTH_TWO_M,          [NSNumber numberWithInt:kREC_LENGTH_TWO_M],
                        sREC_LENGTH_FIVE_M,         [NSNumber numberWithInt:kREC_LENGTH_FIVE_M],
                        sREC_LENGTH_TEN_M,          [NSNumber numberWithInt:kREC_LENGTH_TEN_M],
                        sREC_LENGTH_THIRTY_M,       [NSNumber numberWithInt:kREC_LENGTH_THIRTY_M],
                        sREC_LENGTH_ONE_H,          [NSNumber numberWithInt:kREC_LENGTH_ONE_H],
                        sREC_LENGTH_PUSH_TO_STOP,   [NSNumber numberWithInt:kREC_LENGTH_PUSH_TO_STOP],
                        nil];
}

- (NSString *) sampleRateAsString:(double)sr {

    if (!sampleRateStrings)
        [self initSampleRateAndRecLengthDictionaries];

    return [sampleRateStrings objectForKey:[NSNumber numberWithDouble:sr]];
}

- (NSString *) recordingLengthAsString:(int)rl {

    if (!recLengthStrings)
        [self initSampleRateAndRecLengthDictionaries];

    return [recLengthStrings objectForKey:[NSNumber numberWithInt:rl]];
}

#pragma end - Sample rate and recording length

@end
