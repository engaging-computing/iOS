//
//  ISMTutorialContentController.m
//  Motion
//
//  Created by Mike Stowell on 11/18/14.
//  Copyright (c) 2014 iSENSE. All rights reserved.
//

#import "ISMTutorialContentController.h"

@interface ISMTutorialContentController ()

@end

@implementation ISMTutorialContentController

- (void)viewDidLoad {

    [super viewDidLoad];

    self.backgroundImg.image = [UIImage imageNamed:self.imageFile];
    self.titleTxt.text = self.titleLabel;
}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
}

@end
