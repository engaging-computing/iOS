//
// ISWTutorialViewController.h
// Writer
//
// Created by Mike Stowell on 12/09/14.
//
// (c) 2015
// University of Massachusetts
// All Rights Reserved
//

#import <UIKit/UIKit.h>
#import "ISWTutorialContentController.h"

@interface ISWTutorialViewController : UIViewController <UIPageViewControllerDataSource>

@property (weak, nonatomic) IBOutlet UIButton *goToWriterBtn;
- (IBAction)goToWriterBtnOnClick:(id)sender;

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;

@end
