//
//  ISMSampleRate.h
//  Motion
//
//  Created by Mike Stowell on 9/9/14.
//  Copyright (c) 2014 iSENSE. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kBTN_TWENTY_MS 0.02
#define kBTN_FIFTY_MS 0.05
#define kBTN_ONE_HUNDRED_MS 0.1
#define kBTN_TWO_HUNDRED_FIFTY_MS 0.25
#define kBTN_FIVE_HUNDRED_MS 0.5
#define kBTN_ONE_S 1
#define kBTN_TWO_S 2
#define kBTN_THREE_S 3
#define kBTN_FIVE_S 5
#define kBTN_TEN_S 10
#define kBTN_FIFTEEN_S 15
#define kBTN_THIRTY_S 30

@class ISMSampleRate;

@protocol ISMSampleRateDelegate <NSObject>

@required
- (void) didChooseSampleRate:(double)sampleRateInSeconds withName:(NSString *)sampleRateAsString andDelegate:(ISMSampleRate *)delegateObject;

@end

@interface ISMSampleRate : UIViewController {
}

@property (weak, nonatomic) id <ISMSampleRateDelegate> delegate;
- (void) setDelegateObject:(__weak id<ISMSampleRateDelegate>) delegateObject;

@property (weak, nonatomic) IBOutlet UIButton *twentyMSBtn;
- (IBAction)twentyMSBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *fiftyMSBtn;
- (IBAction)fiftyMSBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *oneHundredMSBtn;
- (IBAction)oneHundredMSBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *twoHundredFiftyMSBtn;
- (IBAction)twoHundredFiftyMSBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *fiveHundredMSBtn;
- (IBAction)fiveHundredMSBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *oneSBtn;
- (IBAction)oneSBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *twoSBtn;
- (IBAction)twoSBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *threeSBtn;
- (IBAction)threeSBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *fiveSBtn;
- (IBAction)fiveSBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *tenSBtn;
- (IBAction)tenSBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *fifteenSBtn;
- (IBAction)fifteenSBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *thirtySBtn;
- (IBAction)thirtySBtnOnClick:(id)sender;

@end
