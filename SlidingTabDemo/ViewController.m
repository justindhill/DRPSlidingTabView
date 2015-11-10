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
    self.tabbedContentView.backgroundColor = [UIColor lightGrayColor];
    self.tabbedContentView.delegate = self;
    
    [self.view addSubview:self.tabbedContentView];
    
    TextTabView *view1 = [[TextTabView alloc] init];
    view1.textLabel.text = @"Williamsburg distillery freegan cliche yuccie. Before they sold out roof party church-key truffaut echo park. Ennui paleo ugh vinyl. Pop-up photo booth sartorial scenester echo park, wolf brooklyn mumblecore venmo YOLO. Tousled photo booth chillwave fixie church-key selfies helvetica, ennui pug. Salvia mumblecore listicle, cardigan cronut austin 3 wolf moon quinoa VHS authentic tote bag normcore pop-up taxidermy. Cliche jean shorts hammock swag.";
    [self.tabbedContentView addPage:view1 withTitle:@"ABOUT"];
    
    TextTabView *view2 = [[TextTabView alloc] init];
    view2.textLabel.text = @"Venmo typewriter offal salvia, butcher four loko letterpress slow-carb messenger bag. Marfa PBR&B vice tacos small batch celiac, organic readymade. Pabst before they sold out 90's fashion axe, irony banjo pork belly shabby chic kale chips salvia. Franzen bicycle rights microdosing plaid helvetica, roof party XOXO. Vinyl fashion axe semiotics, keytar intelligentsia farm-to-table williamsburg slow-carb sriracha bushwick flannel. Normcore seitan blue bottle lomo, irony fingerstache chambray pabst PBR&B readymade thundercats fap fixie kitsch vice. Typewriter bespoke seitan ennui 3 wolf moon retro, mustache forage vinyl waistcoat listicle bushwick hammock synth.\n\nAsymmetrical craft beer marfa gastropub art party flannel polaroid tumblr pickled. Mlkshk street art literally crucifix, quinoa wayfarers selfies fashion axe bushwick single-origin coffee asymmetrical keffiyeh beard migas VHS. Green juice try-hard portland, crucifix next level aesthetic seitan viral tousled lomo pug wayfarers 3 wolf moon synth. Kombucha meggings banh mi normcore, raw denim schlitz authentic master cleanse.";
    [self.tabbedContentView addPage:view2 withTitle:@"SCHEDULE"];
    
    TextTabView *view3 = [[TextTabView alloc] init];
    view3.textLabel.text = @"Trust fund williamsburg roof party, vice bespoke humblebrag stumptown pork belly mixtape direct trade thundercats keytar church-key. Selvage cred food truck chartreuse organic typewriter. Plaid cray selvage dreamcatcher, next level knausgaard marfa umami YOLO PBR&B synth neutra crucifix.";
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
