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

- (void) recordingLengthSelected:(int)recordingLength withName:(NSString *)recordingLengthAsString {
    [self.delegate didChooseRecordingLength:recordingLength withName:recordingLengthAsString andDelegate:self];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)oneSBtnOnClick:(id)sender {
    [self recordingLengthSelected:kBTN_ONE_S withName:[(UIButton *)sender titleLabel].text];
}

- (IBAction)twoSBtnOnClick:(id)sender {
    [self recordingLengthSelected:kBTN_TWO_S withName:[(UIButton *)sender titleLabel].text];
}

- (IBAction)fiveSBtnOnClick:(id)sender {
    [self recordingLengthSelected:kBTN_FIVE_S withName:[(UIButton *)sender titleLabel].text];
}

- (IBAction)tenSBtnOnClick:(id)sender {
    [self recordingLengthSelected:kBTN_TEN_S withName:[(UIButton *)sender titleLabel].text];
}

- (IBAction)oneMBtnOnClick:(id)sender {
    [self recordingLengthSelected:kBTN_ONE_M withName:[(UIButton *)sender titleLabel].text];
}

- (IBAction)thirtySBtnOnClick:(id)sender {
    [self recordingLengthSelected:kBTN_THIRTY_S withName:[(UIButton *)sender titleLabel].text];
}

- (IBAction)twoMBtnOnClick:(id)sender {
    [self recordingLengthSelected:kBTN_TWO_M withName:[(UIButton *)sender titleLabel].text];
}

- (IBAction)fiveMBtnOnClick:(id)sender {
    [self recordingLengthSelected:kBTN_FIVE_M withName:[(UIButton *)sender titleLabel].text];
}

- (IBAction)tenMBtnOnClick:(id)sender {
    [self recordingLengthSelected:kBTN_TEN_M withName:[(UIButton *)sender titleLabel].text];
}

- (IBAction)thirtyMBtnOnClick:(id)sender {
    [self recordingLengthSelected:kBTN_THIRTY_M withName:[(UIButton *)sender titleLabel].text];
}

- (IBAction)oneHBtnOnClick:(id)sender {
    [self recordingLengthSelected:kBTN_ONE_H withName:[(UIButton *)sender titleLabel].text];
}

- (IBAction)pushToStopBtnOnClick:(id)sender {
    [self recordingLengthSelected:kBTN_PUSH_TO_STOP withName:[(UIButton *)sender titleLabel].text];
}

@end
