//
//  ISDRTutorialViewController.m
//  DiceRoller
//
//  Created by Rajia  on 1/20/15.
//  Copyright (c) 2015 iSENSE. All rights reserved.
//

#import "ISDRTutorialViewController.h"
#import "ViewController.h"
@interface ISDRTutorialViewController ()
@end

@implementation ISDRTutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pageTitles = @[@"Welcome to iSENSE Dice Roller!",
                    @"Login to Your iSENSE Account:",
                    @"Select a Project to Contribute to:",
                    @"Press Roll to Record Data",
                    @"Data will automatically upload!"];
    
    _pageImages = @[@"tutorial_1.png",
                    @"tutorial_2.png",
                    @"tutorial_3.png",
                    @"tutorial_4.png",
                    @"tutorial_5.png"];

    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
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
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//ViewControllerBeforeViewController
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = ((PageContentViewController *) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

//ViewControllerAfterViewController
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = ((PageContentViewController *) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageTitles count]) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

//ViewControllerAtIndex
- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    PageContentViewController *contentController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    contentController.imageFile = self.pageImages[index];
    contentController.titleLabel = self.pageTitles[index];
    contentController.pageIndex = index;
    
    return contentController;
}

- (IBAction)goToDiceBtnOnClick:(id)sender {
    NSLog(@"Here");
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [board instantiateInitialViewController];
    
    UIWindow *window = (UIWindow *)[[UIApplication sharedApplication].windows firstObject];
    window.rootViewController = vc;
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    
    return [self.pageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    
    return 0;
}

@end
