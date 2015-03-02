/*
 * iSENSE Project - isenseproject.org
 * This file is part of the iSENSE iOS API and applications.
 *
 * Copyright (c) 2015, University of Massachusetts Lowell. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this
 * list of conditions and the following disclaimer. Redistributions in binary
 * form must reproduce the above copyright notice, this list of conditions and
 * the following disclaimer in the documentation and/or other materials
 * provided with the distribution. Neither the name of the University of
 * Massachusetts Lowell nor the names of its contributors may be used to
 * endorse or promote products derived from this software without specific
 * prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 *
 * BSD 3-Clause License
 * http://opensource.org/licenses/BSD-3-Clause
 *
 * Our work is supported by grants DRL-0735597, DRL-0735592, DRL-0546513, IIS-1123998,
 * and IIS-1123972 from the National Science Foundation and a gift from Google Inc.
 *
 */

//
// ISMTutorialViewController.m
// Motion
//
// Created by Mike Stowell on 11/18/14.
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
