//
// ISWTutorialViewController.m
// Writer
//
// Created by Mike Stowell on 12/09/14.
//
// (c) 2015
// University of Massachusetts
// All Rights Reserved
//

#import "ISWTutorialViewController.h"
#import "Constants.h"

@interface ISWTutorialViewController ()
@end

@implementation ISWTutorialViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    // Create the data model
    _pageTitles = @[@"Welcome to iSENSE Writer",
                    @"Login to your isenseproject.org account",
                    @"Select a project to contribute to",
                    @"Enter a name and a row of data",
                    @"Save a row of data, repeat as desired",
                    @"Save a data set, a collection of rows",
                    @"View your data sets ready to upload",
                    @"Edit and upload data sets"];

    _pageImages = @[@"tutorial1.png",
                    @"tutorial2.png",
                    @"tutorial3.png",
                    @"tutorial4.png",
                    @"tutorial5.png",
                    @"tutorial6.png",
                    @"tutorial7.png",
                    @"tutorial8.png"];

    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TutorialController"];
    self.pageViewController.dataSource = self;

    ISWTutorialContentController *startingViewController = [self viewControllerAtIndex:0];
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

- (IBAction)goToWriterBtnOnClick:(id)sender {

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool:true forKey:kDISPLAYED_TUTORIAL];
    [prefs synchronize];

    [self.pageViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {

    NSUInteger index = ((ISWTutorialContentController *) viewController).pageIndex;

    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }

    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {

    NSUInteger index = ((ISWTutorialContentController *) viewController).pageIndex;

    if (index == NSNotFound) {
        return nil;
    }

    index++;
    if (index == [self.pageTitles count]) {
        return nil;
    }

    return [self viewControllerAtIndex:index];
}

- (ISWTutorialContentController *)viewControllerAtIndex:(NSUInteger)index {

    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }

    // Create a new view controller and pass suitable data.
    ISWTutorialContentController *contentController = [self.storyboard instantiateViewControllerWithIdentifier:@"TutorialContentController"];
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
