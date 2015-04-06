//
//  PageContentViewController.m
//  DiceRoller
//
//  Created by Rajia  on 1/20/15.
//  Copyright (c) 2015 iSENSE. All rights reserved.
//

#import "PageContentViewController.h"

@interface PageContentViewController ()

@end

@implementation PageContentViewController
@synthesize backgroundImg;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backgroundImg.image = [UIImage imageNamed:self.imageFile];
    self.titleTxt.text = self.titleLabel;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
