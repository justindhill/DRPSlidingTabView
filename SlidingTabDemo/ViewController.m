//
//  ViewController.m
//  DRPPagingTabbedContentView
//
//  Created by Justin Hill on 11/5/15.
//  Copyright © 2015 Justin Hill. All rights reserved.
//

#import "ViewController.h"
#import "DRPSlidingTabView.h"

@interface ViewController ()

@property DRPSlidingTabView *tabbedContentView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabbedContentView = [[DRPSlidingTabView alloc] init];
//    self.tabbedContentView.tabContainerHeight = 30.;
    
    [self.view addSubview:self.tabbedContentView];
    
    UIView *view1 = [[UIView alloc] init];
    view1.backgroundColor = [UIColor lightGrayColor];
    [self.tabbedContentView addPage:view1 withTitle:@"ABOUT"];
    
    UIView *view2 = [[UIView alloc] init];
    view2.backgroundColor = [UIColor grayColor];
    [self.tabbedContentView addPage:view2 withTitle:@"SCHEDULE"];
    
    UIView *view3 = [[UIView alloc] init];
    view3.backgroundColor = [UIColor darkGrayColor];
    [self.tabbedContentView addPage:view3 withTitle:@"RELATED"];
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabbedContentView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20);
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.tabbedContentView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20);
    } completion:nil];
}

@end
