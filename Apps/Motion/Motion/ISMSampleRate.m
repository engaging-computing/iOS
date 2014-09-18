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

- (void) sampleRateSelected:(double)sampleRate {
    [self.delegate didChooseSampleRate:sampleRate withDelegate:self];
    [self.navigationController popViewControllerAnimated:YES];
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
