//
//  ISMRecordingLength.m
//  Motion
//
//  Created by Mike Stowell on 9/9/14.
//  Copyright (c) 2014 iSENSE. All rights reserved.
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

- (void) recordingLengthSelected:(int)recordingLength {
    [self.delegate didChooseRecordingLength:recordingLength withDelegate:self];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)oneSBtnOnClick:(id)sender {
    [self recordingLengthSelected:kBTN_ONE_S];
}

- (IBAction)twoSBtnOnClick:(id)sender {
    [self recordingLengthSelected:kBTN_TWO_S];
}

- (IBAction)fiveSBtnOnClick:(id)sender {
    [self recordingLengthSelected:kBTN_FIVE_S];
}

- (IBAction)tenSBtnOnClick:(id)sender {
    [self recordingLengthSelected:kBTN_TEN_S];
}

- (IBAction)oneMBtnOnClick:(id)sender {
    [self recordingLengthSelected:kBTN_ONE_M];
}

- (IBAction)thirtySBtnOnClick:(id)sender {
    [self recordingLengthSelected:kBTN_THIRTY_S];
}

- (IBAction)twoMBtnOnClick:(id)sender {
    [self recordingLengthSelected:kBTN_TWO_M];
}

- (IBAction)fiveMBtnOnClick:(id)sender {
    [self recordingLengthSelected:kBTN_FIVE_M];
}

- (IBAction)tenMBtnOnClick:(id)sender {
    [self recordingLengthSelected:kBTN_TEN_M];
}

- (IBAction)thirtyMBtnOnClick:(id)sender {
    [self recordingLengthSelected:kBTN_THIRTY_M];
}

- (IBAction)oneHBtnOnClick:(id)sender {
    [self recordingLengthSelected:kBTN_ONE_H];
}

- (IBAction)pushToStopBtnOnClick:(id)sender {
    [self recordingLengthSelected:kBTN_PUSH_TO_STOP];
}

@end
