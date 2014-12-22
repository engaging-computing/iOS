//
//  Constants.h
//  Motion
//
//  Created by Mike Stowell on 9/17/14.
//  Copyright (c) 2014 iSENSE. All rights reserved.
//

#ifndef Motion_Constants_h
#define Motion_Constants_h

// NSUserDefault (preferences) constants
#define pPROJECT_ID @"curr_project_id_as_nsnumber"
#define pDISPLAYED_TUTORIAL @"displayed_tutorial"

// Dialog constants
#define kLOGIN_DIALOG_TAG 500
#define kLOGIN_USER_TEXT 501
#define kLOGIN_PASS_TEXT 502

#define kNAME_DIALOG_TAG 600
#define kLOCATION_DIALOG_IOS_8_AND_LATER_TAG 601
#define kLOCATION_DIALOG_IOS_7_AND_EARLIER_TAG 602

#define kVISUALIZE_DIALOG_TAG 700

// Recording length
#define kBTN_ONE_S 1
#define kBTN_TWO_S 2
#define kBTN_FIVE_S 5
#define kBTN_TEN_S 10
#define kBTN_THIRTY_S 30
#define kBTN_ONE_M 60
#define kBTN_TWO_M 120
#define kBTN_FIVE_M 300
#define kBTN_TEN_M 600
#define kBTN_THIRTY_M 1800
#define kBTN_ONE_H 3600
#define kBTN_PUSH_TO_STOP -1

// Earth's gravity constant
#define kGRAVITY 9.80665

// Default sample rate, recording length, and data set name
#define kDEFAULT_SAMPLE_RATE 0.05
#define kDEFAULT_RECORDING_LENGTH kBTN_TEN_S
#define kDEFAULT_DATA_SET_NAME @"My Data Set"

// Project constants
#define kNO_PROJECT @"Not Set"

// Preferences location constant
#define kOPT_OUT_LOCATION @"user_opt_out_location"

// Default projects for production and dev
#define kDEFAULT_PROJ_PRODUCTION 570
#define kDEFAULT_PROJ_DEV 12

// Preset constants
#define kPRESET_GPS 0
#define kPRESET_ACCEL 1
#define kPRESET_DEFAULT 2

#endif
