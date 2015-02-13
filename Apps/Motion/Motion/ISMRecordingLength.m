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
// ISMRecordingLength.m
// Motion
//
// Created by Mike Stowell on 9/9/14.
//

#import "ISMRecordingLength.h"

@interface ISMRecordingLength ()

@end

@implementation ISMRecordingLength

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) setDelegateObject:(__weak id<ISMRecordingLengthDelegate>)delegateObject {
    self.delegate = delegateObject;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) recordingLengthSelected:(int)recordingLength withName:(NSString *)recordingLengthAsString {
    [self.delegate didChooseRecordingLength:recordingLength withName:recordingLengthAsString andDelegate:self];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)oneSBtnOnClick:(id)sender {
    [self recordingLengthSelected:kREC_LENGTH_ONE_S withName:[(UIButton *)sender titleLabel].text];
}

- (IBAction)twoSBtnOnClick:(id)sender {
    [self recordingLengthSelected:kREC_LENGTH_TWO_S withName:[(UIButton *)sender titleLabel].text];
}

- (IBAction)fiveSBtnOnClick:(id)sender {
    [self recordingLengthSelected:kREC_LENGTH_FIVE_S withName:[(UIButton *)sender titleLabel].text];
}

- (IBAction)tenSBtnOnClick:(id)sender {
    [self recordingLengthSelected:kREC_LENGTH_TEN_S withName:[(UIButton *)sender titleLabel].text];
}

- (IBAction)oneMBtnOnClick:(id)sender {
    [self recordingLengthSelected:kREC_LENGTH_ONE_M withName:[(UIButton *)sender titleLabel].text];
}

- (IBAction)thirtySBtnOnClick:(id)sender {
    [self recordingLengthSelected:kREC_LENGTH_THIRTY_S withName:[(UIButton *)sender titleLabel].text];
}

- (IBAction)twoMBtnOnClick:(id)sender {
    [self recordingLengthSelected:kREC_LENGTH_TWO_M withName:[(UIButton *)sender titleLabel].text];
}

- (IBAction)fiveMBtnOnClick:(id)sender {
    [self recordingLengthSelected:kREC_LENGTH_FIVE_M withName:[(UIButton *)sender titleLabel].text];
}

- (IBAction)tenMBtnOnClick:(id)sender {
    [self recordingLengthSelected:kREC_LENGTH_TEN_M withName:[(UIButton *)sender titleLabel].text];
}

- (IBAction)thirtyMBtnOnClick:(id)sender {
    [self recordingLengthSelected:kREC_LENGTH_THIRTY_M withName:[(UIButton *)sender titleLabel].text];
}

- (IBAction)oneHBtnOnClick:(id)sender {
    [self recordingLengthSelected:kREC_LENGTH_ONE_H withName:[(UIButton *)sender titleLabel].text];
}

- (IBAction)pushToStopBtnOnClick:(id)sender {
    [self recordingLengthSelected:kREC_LENGTH_PUSH_TO_STOP withName:[(UIButton *)sender titleLabel].text];
}

@end
