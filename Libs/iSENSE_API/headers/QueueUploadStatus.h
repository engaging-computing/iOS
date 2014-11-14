//
//  QueueUploadStatus.h
//  iSENSE_API
//
//  Created by Mike Stowell on 11/13/14.
//  Copyright (c) 2014 iSENSE. All rights reserved.
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
