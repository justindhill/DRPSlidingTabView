//
//  DRPPagingTabbedContentView.h
//  DRPPagingTabbedContentView
//
//  Created by Justin Hill on 11/5/15.
//  Copyright © 2015 Justin Hill. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DRPSlidingTabView : UIView

/**
 *  @brief The duration of the transition that occurs after tapping a tab. Default is .25.
 */
@property (assign) NSTimeInterval transitionDuration;

/**
 *  @brief The animation curve used in the transition that occurs after tapping a tab. Default is UIViewAnimationCurveEaseOut.
 */
@property (assign) UIViewAnimationCurve transitionAnimationCurve;

/**
 *  @brief The height of the slider.
 */
@property (nonatomic, assign) CGFloat sliderHeight;

/**
 *  @brief The height of the view that contains the tabs and slider. Default is 44.
 */
@property (nonatomic, assign) CGFloat tabContainerHeight;

/**
 *  @brief The color of all the tab titles.
 */
@property (nonatomic, strong) UIColor *titleColor;

/**
 *  @brief The font used for all the tab titles.
 */
@property (nonatomic, strong) UIFont *titleFont;

/**
 *  @brief The color of the bottom dividing line and the slider that runs along the top of it.
 */
@property (nonatomic, strong) UIColor *dividerColor;

/**
 *  @brief Add a page to the tabbed content view.
 */
- (void)addPage:(UIView *)page withTitle:(NSString *)title;

@end
