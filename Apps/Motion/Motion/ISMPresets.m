//
//  ISMPresets.m
//  Motion
//
//  Created by Mike Stowell on 12/22/14.
//  Copyright (c) 2014 iSENSE. All rights reserved.
//

#import "ISMPresets.h"
#import "Constants.h"

#ifdef __IPHONE_6_0
# define LINE_BREAK_WORD_WRAP NSLineBreakByWordWrapping
#else
# define LINE_BREAK_WORD_WRAP UILineBreakModeWordWrap
#endif

@interface ISMPresets ()
@end

@implementation ISMPresets

@synthesize delegate;
@synthesize titleLbl, gpsPresetBtn, accelPresetBtn, defaultPresetBtn;

- (id)initWithDelegate: (__weak id<ISMPresetsDelegate>) delegateObject {

    self = [super init];

    if (self)
        delegate = delegateObject;

    return self;
}

- (void)viewDidLoad {

    [super viewDidLoad];

    // set # of lines for the title label
    [titleLbl setNumberOfLines:0];
    [titleLbl setLineBreakMode:LINE_BREAK_WORD_WRAP];
    [titleLbl sizeToFit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)gpsPresetBtnOnClick:(id)sender {
    [self savePreset:kPRESET_GPS];
}

- (IBAction)accelPresetBtnOnClick:(id)sender {
    [self savePreset:kPRESET_ACCEL];
}

- (IBAction)defaultPresetBtnOnClick:(id)sender {
    [self savePreset:kPRESET_DEFAULT];
}

- (void)savePreset:(int)presetID {

    // send the preset to the main view controller
    [self.delegate didFinishSavingPresetWithID:presetID];

    // pop the navigation controller and return
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
