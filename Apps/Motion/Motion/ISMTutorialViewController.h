//
// ISMTutorialViewController.h
// Motion
//
// Created by Mike Stowell on 11/18/14.
//
// (c) 2015
// University of Massachusetts
// All Rights Reserved
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
