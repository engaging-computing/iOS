//
//  ISDRTutorialViewController.h
//  DiceRoller
//
//  Created by Rajia  on 1/20/15.
//  Copyright (c) 2015 iSENSE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageContentViewController.h"

@interface ISDRTutorialViewController : UIViewController
<UIPageViewControllerDataSource>

@property (weak, nonatomic) IBOutlet UIButton *goToDiceBtn;
- (IBAction)goToDiceBtnOnClick:(id)sender;

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;

@end
