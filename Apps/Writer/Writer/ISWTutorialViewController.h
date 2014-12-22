//
//  ISWTutorialViewController.h
//  Writer
//
//  Created by Mike Stowell on 12/09/14.
//  Copyright (c) 2014 iSENSE. All rights reserved.
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
