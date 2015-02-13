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
// ISMSampleRate.m
// Motion
//
// Created by Mike Stowell on 9/9/14.
//

#import "ISMSampleRate.h"
#import "Constants.h"

@interface ISMSampleRate ()

@end

@implementation ISMSampleRate

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) setDelegateObject:(__weak id<ISMSampleRateDelegate>) delegateObject {
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

- (void) sampleRateSelected:(double)sampleRate withName:(NSString *)sampleRateAsString {
    [self.delegate didChooseSampleRate:sampleRate withName:sampleRateAsString andDelegate:self];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)twentyMSBtnOnClick:(id)sender {
    [self sampleRateSelected:kS_RATE_TWENTY_MS withName:[(UIButton *)sender titleLabel].text];
}

- (IBAction)fiftyMSBtnOnClick:(id)sender {
    [self sampleRateSelected:kS_RATE_FIFTY_MS withName:[(UIButton *)sender titleLabel].text];
}

- (IBAction)oneHundredMSBtnOnClick:(id)sender {
    [self sampleRateSelected:kS_RATE_ONE_HUNDRED_MS withName:[(UIButton *)sender titleLabel].text];
}

- (IBAction)twoHundredFiftyMSBtnOnClick:(id)sender {
    [self sampleRateSelected:kS_RATE_TWO_HUNDRED_FIFTY_MS withName:[(UIButton *)sender titleLabel].text];
}

- (IBAction)fiveHundredMSBtnOnClick:(id)sender {
    [self sampleRateSelected:kS_RATE_FIVE_HUNDRED_MS withName:[(UIButton *)sender titleLabel].text];
}

- (IBAction)oneSBtnOnClick:(id)sender {
    [self sampleRateSelected:kS_RATE_ONE_S withName:[(UIButton *)sender titleLabel].text];
}

- (IBAction)twoSBtnOnClick:(id)sender {
    [self sampleRateSelected:kS_RATE_TWO_S withName:[(UIButton *)sender titleLabel].text];
}

- (IBAction)threeSBtnOnClick:(id)sender {
    [self sampleRateSelected:kS_RATE_THREE_S withName:[(UIButton *)sender titleLabel].text];
}

- (IBAction)fiveSBtnOnClick:(id)sender {
    [self sampleRateSelected:kS_RATE_FIVE_S withName:[(UIButton *)sender titleLabel].text];
}

- (IBAction)tenSBtnOnClick:(id)sender {
    [self sampleRateSelected:kS_RATE_TEN_S withName:[(UIButton *)sender titleLabel].text];
}

- (IBAction)fifteenSBtnOnClick:(id)sender {
    [self sampleRateSelected:kS_RATE_FIFTEEN_S withName:[(UIButton *)sender titleLabel].text];
}

- (IBAction)thirtySBtnOnClick:(id)sender {
    [self sampleRateSelected:kS_RATE_THIRTY_S withName:[(UIButton *)sender titleLabel].text];
}

@end
