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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// TODO - implement
- (void) recordingLengthSelected:(int)buttonID {
    switch (buttonID)
    {
        case kBTN_ONE_S:
            break;
        case kBTN_TWO_S:
            break;
        case kBTN_FIVE_S:
            break;
        case kBTN_TEN_S:
            break;
        case kBTN_THIRTY_S:
            break;
        case kBTN_ONE_M:
            break;
        case kBTN_TWO_M:
            break;
        case kBTN_FIVE_M:
            break;
        case kBTN_TEN_M:
            break;
        case kBTN_THIRTY_M:
            break;
        case kBTN_ONE_H:
            break;
        case kBTN_PUSH_TO_STOP:
            break;
    }
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
