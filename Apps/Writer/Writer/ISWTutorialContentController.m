//
// ISWTutorialContentController.m
// Writer
//
// Created by Mike Stowell on 12/09/14.
//
// (c) 2015
// University of Massachusetts
// All Rights Reserved
//

#import "ISWTutorialContentController.h"

@interface ISWTutorialContentController ()

@end

@implementation ISWTutorialContentController

- (void)viewDidLoad {

    [super viewDidLoad];

    self.backgroundImg.image = [UIImage imageNamed:self.imageFile];
    self.titleTxt.text = self.titleLabel;
}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
}

@end
