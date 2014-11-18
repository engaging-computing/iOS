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

/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
