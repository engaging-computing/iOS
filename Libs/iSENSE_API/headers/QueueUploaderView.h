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
// QueueUploaderView.h
// iSENSE_API
//
// Created by Jeremy Poulin on 6/26/13.
// Modified by Mike Stowell
//

#import <UIKit/UIKit.h>

#import "DataSaver.h"
#import "API.h"
#import "ProjectBrowserViewController.h"
#import "Waffle.h"
#import "ISKeys.h"

#import "QueueConstants.h"
#import "QueueCell.h"
#import "QueueUploadStatus.h"

#import "DataManager.h"
#import "FieldMatchingViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVCaptureDevice.h>

// Parent name constants: add a new one for each app
#define PARENT_AUTOMATIC    @"Automatic"
#define PARENT_MANUAL       @"Manual"
#define PARENT_DATA_WALK    @"DataWalk"
#define PARENT_CAR_RAMP     @"CarRampPhysics"
#define PARENT_CANOBIE      @"CanobiePhysics"
#define PARENT_MOTION       @"ISMotion"
#define PARENT_WRITER       @"ISWriter"

@class QueueUploaderView;
@protocol QueueUploaderDelegate <NSObject>

@required
- (void) didFinishUploadingDataWithStatus:(QueueUploadStatus *)status;

@end

@interface QueueUploaderView : UIViewController <UIGestureRecognizerDelegate, UIActionSheetDelegate, UITextFieldDelegate, ProjectBrowserDelegate> {

    int projID;
    NSMutableArray *lastSelectedFields;
    
    // bundle for resource files in the iSENSE_API_Bundle
    NSBundle *isenseBundle;
}

- (IBAction) upload:(id)sender;

- (id) initWithParentName:(NSString *)parentName andDelegate:(id <QueueUploaderDelegate>)delegateObj;

@property (nonatomic, weak) id <QueueUploaderDelegate> delegate;

@property (nonatomic, assign) API *api;
@property (nonatomic, copy)   NSString *parent;
@property (nonatomic, strong) DataSaver *dataSaver;
@property (nonatomic, assign) IBOutlet UITableView *mTableView;
@property (assign)            int currentIndex;
@property (nonatomic, strong) NSIndexPath *lastClickedCellIndex;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSMutableDictionary *limitedTempQueue;

@end
