//
//  QueueUploadStatus.m
//  iSENSE_API
//
//  Created by Mike Stowell on 11/13/14.
//  Copyright (c) 2014 iSENSE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QueueUploadStatus.h"

@implementation QueueUploadStatus

-(id) initWithStatus:(int)stat project:(int)proj andDataSetID:(int)dsid {

    if (self = [super init]) {
        status = stat;
        project = proj;
        dataSetID = dsid;
    }

    return self;
}

- (int)getStatus {
    return status;
}

- (int)getProject {
    return project;
}

- (int)getDataSetID {
    return dataSetID;
}

@end