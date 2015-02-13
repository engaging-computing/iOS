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
// ISMRecordingLength.h
// Motion
//
// Created by Mike Stowell on 9/9/14.
//

#import <UIKit/UIKit.h>
#import "Constants.h"


@class ISMRecordingLength;

@protocol ISMRecordingLengthDelegate <NSObject>

@required
- (void) didChooseRecordingLength:(int)recordingLengthInSeconds withName:(NSString *)recordingLengthAsString andDelegate:(ISMRecordingLength *)delegateObject;

@end

@interface ISMRecordingLength : UIViewController {
}

@property (weak, nonatomic) id <ISMRecordingLengthDelegate> delegate;
- (void) setDelegateObject:(__weak id<ISMRecordingLengthDelegate>) delegateObject;

@property (weak, nonatomic) IBOutlet UIButton *oneSBtn;
- (IBAction)oneSBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *twoSBtn;
- (IBAction)twoSBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *fiveSBtn;
- (IBAction)fiveSBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *tenSBtn;
- (IBAction)tenSBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *thirtySBtn;
- (IBAction)thirtySBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *oneMBtn;
- (IBAction)oneMBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *twoMBtn;
- (IBAction)twoMBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *fiveMBtn;
- (IBAction)fiveMBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *tenMBtn;
- (IBAction)tenMBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *thirtyMBtn;
- (IBAction)thirtyMBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *oneHBtn;
- (IBAction)oneHBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *pushToStopBtn;
- (IBAction)pushToStopBtnOnClick:(id)sender;

@end
