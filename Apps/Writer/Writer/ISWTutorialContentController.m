//
//  ISWTutorialContentController.m
//  Writer
//
//  Created by Mike Stowell on 12/09/14.
//  Copyright (c) 2014 iSENSE. All rights reserved.
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
