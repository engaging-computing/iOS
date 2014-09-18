//
//  ISMSampleRate.m
//  Motion
//
//  Created by Mike Stowell on 9/9/14.
//  Copyright (c) 2014 iSENSE. All rights reserved.
//

#import "ISMSampleRate.h"

@interface ISMSampleRate ()

@end

@implementation ISMSampleRate

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
- (void) sampleRateSelected:(int)buttonID {
    switch (buttonID)
    {
        case kBTN_TWENTY_MS:
            break;
        case kBTN_FIFTY_MS:
            break;
        case kBTN_ONE_HUNDRED_MS:
            break;
        case kBTN_TWO_HUNDRED_FIFTY_MS:
            break;
        case kBTN_FIVE_HUNDRED_MS:
            break;
        case kBTN_ONE_S:
            break;
        case kBTN_TWO_S:
            break;
        case kBTN_THREE_S:
            break;
        case kBTN_FIVE_S:
            break;
        case kBTN_TEN_S:
            break;
        case kBTN_FIFTEEN_S:
            break;
        case kBTN_THIRTY_S:
            break;
    }
}

- (IBAction)twentyMSBtnOnClick:(id)sender {
    [self sampleRateSelected:kBTN_TWENTY_MS];
}

- (IBAction)fiftyMSBtnOnClick:(id)sender {
    [self sampleRateSelected:kBTN_FIFTY_MS];
}

- (IBAction)oneHundredMSBtnOnClick:(id)sender {
    [self sampleRateSelected:kBTN_ONE_HUNDRED_MS];
}

- (IBAction)twoHundredFiftyMSBtnOnClick:(id)sender {
    [self sampleRateSelected:kBTN_TWO_HUNDRED_FIFTY_MS];
}

- (IBAction)fiveHundredMSBtnOnClick:(id)sender {
    [self sampleRateSelected:kBTN_FIVE_HUNDRED_MS];
}

- (IBAction)oneSBtnOnClick:(id)sender {
    [self sampleRateSelected:kBTN_ONE_S];
}

- (IBAction)twoSBtnOnClick:(id)sender {
    [self sampleRateSelected:kBTN_TWO_S];
}

- (IBAction)threeSBtnOnClick:(id)sender {
    [self sampleRateSelected:kBTN_THREE_S];
}

- (IBAction)fiveSBtnOnClick:(id)sender {
    [self sampleRateSelected:kBTN_FIVE_S];
}

- (IBAction)tenSBtnOnClick:(id)sender {
    [self sampleRateSelected:kBTN_TEN_S];
}

- (IBAction)fifteenSBtnOnClick:(id)sender {
    [self sampleRateSelected:kBTN_FIFTEEN_S];
}

- (IBAction)thirtySBtnOnClick:(id)sender {
    [self sampleRateSelected:kBTN_THIRTY_S];
}

@end
