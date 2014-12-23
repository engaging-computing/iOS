//
//  ISMTutorialViewController.h
//  Motion
//
//  Created by Mike Stowell on 11/18/14.
//  Copyright (c) 2014 iSENSE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISMTutorialContentController.h"
#import "ISMPresets.h"

@interface ISMTutorialViewController : UIViewController <UIPageViewControllerDataSource>

@property (nonatomic, weak) id <ISMPresetsDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *goToMotionBtn;
- (IBAction)goToMotionBtnOnClick:(id)sender;

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;

@end
