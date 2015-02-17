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
// ISMViewController.h
// Motion
//
// Created by Mike Stowell on 9/9/14.
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
#import "QueueUploadStatus.h"
#import "ISMTutorialViewController.h"
#import "GlobalColors.h"
#import "ISMPresets.h"

#define USE_DEV false

@interface ISMViewController : UIViewController
    <UIAlertViewDelegate,
    UITextFieldDelegate,
    CredentialManagerDelegate,
    ISMSampleRateDelegate,
    ISMRecordingLengthDelegate,
    CLLocationManagerDelegate,
    QueueUploaderDelegate,
    ISMPresetsDelegate>
{
    // API and DataManager
    API *api;
    DataManager *dm;

    // Label for when in dev mode
    UILabel *devLbl;
    
    // Credential Manager
    CredentialManager *credentialMgr;
    DLAVAlertView *credentialMgrAlert;
    
    // Sample rate, recording length, and data set name
    double sampleRate;
    int recordingLength;
    int countdown;
    NSString *dataSetName;

    // Recording state, timer, and sensor objects
    bool isRecording;
    NSTimer *dataRecordingTimer;
    NSTimer *recordingLengthTimer;
    CLLocationManager *locationManager;
    CMMotionManager *motionManager;

    // Data for a single run session and a corresponding mutex lock
    NSMutableArray *dataPoints;
    NSLock *dataPointsMutex;

    // Visualization URL constructed after data is uploaded
    NSString *visURL;

    // Dictionaries of sample rate and recording lengths whose key is an int/double
    // and value is the respective sample rate/recording length as a string
    NSDictionary *sampleRateStrings;
    NSDictionary *recLengthStrings;

    // UIView to display the splash screen and a boolean to track if it is displaying
    UIView *splashView;
    bool isSplashDisplaying;
}

// Queue Saver Properties
@property (nonatomic, strong) DataSaver *dataSaver;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

// UI elements and click methods
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuBarBtn;
- (IBAction)menuBarBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *credentialBarBtn;
- (IBAction)credentialBarBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *xLbl;
@property (weak, nonatomic) IBOutlet UILabel *yLbl;
@property (weak, nonatomic) IBOutlet UILabel *zLbl;

@property (weak, nonatomic) IBOutlet UIButton *sampleRateBtn;
@property (weak, nonatomic) IBOutlet UIButton *recordingLengthBtn;

@property (weak, nonatomic) IBOutlet UIButton *startStopBtn;

@property (weak, nonatomic) IBOutlet UIButton *nameBtn;
- (IBAction)nameBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;
- (IBAction)uploadBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *projectBtn;

@end