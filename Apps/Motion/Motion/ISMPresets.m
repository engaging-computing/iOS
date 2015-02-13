//
// ISMPresets.m
// Motion
//
// Created by Mike Stowell on 12/22/14.
//
// (c) 2015
// University of Massachusetts
// All Rights Reserved
//

#import "ISMPresets.h"
#import "Constants.h"

@interface ISMPresets ()
@end

@implementation ISMPresets

@synthesize delegate;
@synthesize gpsPresetBtn, accelPresetBtn, defaultPresetBtn;

- (id)initWithDelegate: (__weak id<ISMPresetsDelegate>) delegateObject {

    self = [super init];

    if (self)
        delegate = delegateObject;

    return self;
}

- (void)viewDidLoad {

    [super viewDidLoad];
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
