//
//  ISMSampleRate.h
//  Motion
//
//  Created by Mike Stowell on 9/9/14.
//  Copyright (c) 2014 iSENSE. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kBTN_TWENTY_MS 100
#define kBTN_FIFTY_MS 101
#define kBTN_ONE_HUNDRED_MS 102
#define kBTN_TWO_HUNDRED_FIFTY_MS 103
#define kBTN_FIVE_HUNDRED_MS 104
#define kBTN_ONE_S 105
#define kBTN_TWO_S 106
#define kBTN_THREE_S 107
#define kBTN_FIVE_S 108
#define kBTN_TEN_S 109
#define kBTN_FIFTEEN_S 110
#define kBTN_THIRTY_S 111

@interface ISMSampleRate : UIViewController

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
