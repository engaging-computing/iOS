//
// QueueConstants.h
// iSENSE_API
//
// Created by Michael Stowell on 9/6/13.
//
// (c) 2015
// University of Massachusetts
// All Rights Reserved
//

#ifndef Data_Walk_QueueConstants_h
#define Data_Walk_QueueConstants_h

// constants for QueueUploaderView's actionSheet
#define QUEUE_RENAME             0
#define QUEUE_CHANGE_DESC        1
#define QUEUE_SELECT_PROJ        2

#define QUEUE_LOGIN              500
#define QUEUE_SELECT_USER_OR_KEY 501
#define QUEUE_CONTRIB_KEY        502

// options for menu and action sheet
#define OPTION_CANCELED              0
#define OPTION_ENTER_PROJECT         1
#define OPTION_BROWSE_PROJECTS       2
#define OPTION_SCAN_PROJECT_QR       3
#define OPTION_PROJECT_MANUAL_ENTRY  4
#define OPTION_APPLY_PROJ_AND_FIELDS 5

// other character restriction text field tags
#define TAG_QUEUE_RENAME    700
#define TAG_QUEUE_DESC      701
#define TAG_QUEUE_PROJ      702
#define TAG_STEPONE_PROJ    703
#define TAG_AUTO_LOGIN      704
#define TAG_MANUAL_LOGIN    705
#define TAG_MANUAL_PROJ     706

// indices for contributor key and login in the selection dialog
#define INDEX_CONTRIB_KEY 1
#define INDEX_LOGIN       2

#endif
