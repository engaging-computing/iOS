//
//  ISMTutorialViewController.m
//  Motion
//
//  Created by Mike Stowell on 11/18/14.
//  Copyright (c) 2014 iSENSE. All rights reserved.
//

#import "ISMTutorialViewController.h"

@interface ISMTutorialViewController ()
@end

@implementation ISMTutorialViewController

@synthesize delegate;

- (void)viewDidLoad {

    [super viewDidLoad];

    // Create the data model
    _pageTitles = @[@"Welcome to iSENSE Motion",
                    @"Login to your isenseproject.org account",
                    @"Select a project to contribute to",
                    @"Customize data set options",
                    @"Press and hold to record data",
                    @"View your data sets ready to upload",
                    @"Edit and upload data sets"];

    _pageImages = @[@"tutorial_1.png",
                    @"tutorial_2.png",
                    @"tutorial_3.png",
                    @"tutorial_4.png",
                    @"tutorial_5.png",
                    @"tutorial_6.png",
                    @"tutorial_7.png"];

    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TutorialController"];
    self.pageViewController.dataSource = self;

    ISMTutorialContentController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 60);

    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
}

- (IBAction)goToMotionBtnOnClick:(id)sender {

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool:true forKey:pDISPLAYED_TUTORIAL];
    [prefs synchronize];

    // dismiss the tutorial controller and launch the preset setup
    [self.pageViewController dismissViewControllerAnimated:NO completion:^{

        UIStoryboard *presetStoryboard = [UIStoryboard storyboardWithName:@"Preset" bundle:nil];
        ISMPresets *presetController = [presetStoryboard instantiateViewControllerWithIdentifier:@"PresetStartController"];
        [presetController setDelegate:delegate];
        [[[[[UIApplication sharedApplication] delegate] window]
          rootViewController] presentViewController:presetController animated:NO completion:nil];
    }];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {

    NSUInteger index = ((ISMTutorialContentController *) viewController).pageIndex;

    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }

    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {

    NSUInteger index = ((ISMTutorialContentController *) viewController).pageIndex;

    if (index == NSNotFound) {
        return nil;
    }

    index++;
    if (index == [self.pageTitles count]) {
        return nil;
    }

    return [self viewControllerAtIndex:index];
}

- (ISMTutorialContentController *)viewControllerAtIndex:(NSUInteger)index {

    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }

    // Create a new view controller and pass suitable data.
    ISMTutorialContentController *contentController = [self.storyboard instantiateViewControllerWithIdentifier:@"TutorialContentController"];
    contentController.imageFile = self.pageImages[index];
    contentController.titleLabel = self.pageTitles[index];
    contentController.pageIndex = index;

    return contentController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {

    return [self.pageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {

    return 0;
}

@end
