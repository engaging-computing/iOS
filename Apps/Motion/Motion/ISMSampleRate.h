//
// ISMSampleRate.h
// Motion
//
// Created by Mike Stowell on 9/9/14.
//
// (c) 2015
// University of Massachusetts
// All Rights Reserved
//

#import <UIKit/UIKit.h>

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
