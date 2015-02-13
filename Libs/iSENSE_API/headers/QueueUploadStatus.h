//
// QueueUploadStatus.h
// iSENSE_API
//
// Created by Mike Stowell on 11/13/14.
//
// (c) 2015
// University of Massachusetts
// All Rights Reserved
//

#import <UIKit/UIKit.h>

@interface QueueUploadStatus : NSObject {

    int status;
    int project;
    int dataSetID;

}

- (id)initWithStatus:(int)status project:(int)proj andDataSetID:(int) dsid;

- (int)getStatus;
- (int)getProject;
- (int)getDataSetID;

@end
