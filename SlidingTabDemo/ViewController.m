//
//  ViewController.m
//  DRPPagingTabbedContentView
//
//  Created by Justin Hill on 11/5/15.
//  Copyright © 2015 Justin Hill. All rights reserved.
//

#import "ViewController.h"
#import "DRPSlidingTabView.h"
#import "TextTabView.h"

@interface ViewController () <DRPSlidingTabViewDelegate>

@property DRPSlidingTabView *tabbedContentView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabbedContentView = [[DRPSlidingTabView alloc] init];
    self.tabbedContentView.contentBackgroundColor = [UIColor lightGrayColor];
    self.tabbedContentView.delegate = self;
    
    [self.view addSubview:self.tabbedContentView];
    
    TextTabView *view1 = [[TextTabView alloc] init];
    view1.backgroundColor = [UIColor lightGrayColor];
    view1.textLabel.text = @"Williamsburg distillery freegan cliche yuccie. Before they sold out roof party church-key truffaut echo park. Ennui paleo ugh vinyl. Pop-up photo booth sartorial scenester echo park, wolf brooklyn mumblecore venmo YOLO. Tousled photo booth chillwave fixie church-key selfies helvetica, ennui pug. Salvia mumblecore listicle, cardigan cronut austin 3 wolf moon quinoa VHS authentic tote bag normcore pop-up taxidermy. Cliche jean shorts hammock swag.";
    [self.tabbedContentView addPage:view1 withTitle:@"ABOUT"];
    
    TextTabView *view2 = [[TextTabView alloc] init];
    view2.backgroundColor = [UIColor lightGrayColor];
    view2.textLabel.text = @"Williamsburg distillery freegan cliche yuccie. Chillwave fixie church-key selfies helvetica, ennui pug. Salvia mumblecore listicle, cardigan cronut austin 3 wolf moon quinoa VHS authentic tote bag normcore pop-up taxidermy. Cliche jean shorts hammock swag.";
    [self.tabbedContentView addPage:view2 withTitle:@"SCHEDULE"];
    
    TextTabView *view3 = [[TextTabView alloc] init];
    view3.backgroundColor = [UIColor lightGrayColor];
    view3.textLabel.text = @"Williamsburg distillery freegan cliche yuccie. Before they sold out roof party church-key truffaut echo park. Ennui paleo ugh vinyl. Pop-up photo booth sartorial scenester echo park, wolf brooklyn mumblecore venmo YOLO. Tousled photo booth chillwave fixie church-key selfies helvetica, ennui pug. Salvia mumblecore listicle, cardigan cronut austin 3 wolf moon quinoa VHS authentic tote bag normcore pop-up taxidermy. Cliche jean shorts hammock swag.";
    [self.tabbedContentView addPage:view3 withTitle:@"RELATED"];
}

- (void)viewWillAppear:(BOOL)animated {
    // Set the width, then size to fit! This will adjust the height to match the content. If you don't care about this,
    // just set the frame as desired and be on your way.
    self.tabbedContentView.frame = CGRectMake(0, 20, self.view.frame.size.width, 0);
    [self.tabbedContentView sizeToFit];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.tabbedContentView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20);
    } completion:nil];
}

#pragma mark - DRPSlidingTabbedViewDelegate
- (void)view:(UIView *)view intrinsicHeightDidChangeTo:(CGFloat)newHeight {
    [UIView animateWithDuration:.25 delay:0 options:0 animations:^{
        view.frame = (CGRect){{0, 20}, {view.frame.size.width, newHeight}};
    } completion:nil];
}

@end
