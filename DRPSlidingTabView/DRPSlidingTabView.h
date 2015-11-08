//
//  DRPPagingTabbedContentView.h
//  DRPPagingTabbedContentView
//
//  Created by Justin Hill on 11/5/15.
//  Copyright © 2015 Justin Hill. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DRPSlidingTabView;

/**
 *  @brief Declares the ability to listen for intrinsic height changes.
 */
@protocol DRPIntrinsicHeightChangeListener <NSObject>

/**
 *  @brief Called when an emitter's intrinsic height changes (at the emitter's discretion)
 */
- (void)view:(UIView *)view intrinsicHeightDidChangeTo:(CGFloat)newHeight;

@end

/**
 *  @brief Declares a field for holding an intrinsic height change listener.
 */
@protocol DRPIntrinsicHeightChangeEmitter <NSObject>

/**
 *  @brief The listener awaiting intrinsic height change notifications.
 */
@property (weak) id<DRPIntrinsicHeightChangeListener> heightChangeListener;

/**
 *  @brief Computes the intrinsic height of the view provided a width
 */
- (CGFloat)intrinsicHeightWithWidth:(CGFloat)width;

@end

/**
 *  @brief A delegate capable of handling events occurring in the tab view.
 */
@protocol DRPSlidingTabViewDelegate <DRPIntrinsicHeightChangeListener>

@optional
/**
 *  @brief Called when the sliding tab view's selected page index changes.
 */
- (void)slidingTabView:(DRPSlidingTabView *)slidingTabView selectedPageIndexDidChange:(NSInteger)selectedIndex;

@end

@interface DRPSlidingTabView : UIView <DRPIntrinsicHeightChangeListener>

/**
 *  @brief The sliding tab view's delegate.
 *
 *  @warning If you do not assign a delegate to the tab view, it will not make layout adjustments 
 *           when new pages are selected!
 */
@property (weak) id<DRPSlidingTabViewDelegate> delegate;

/**
 *  @brief The default height of the tab view. If a page you add to the tab view doesn't conform to
 *         DRPIntrinsicHeightChangeEmitter, it will adjust to this size when that page becomes the
 *         selected page. Default is 150.
 *
 *  @warning If you do not assign a delegate to the tab view, this value will be ignored and the
 *           tab view will not make layout adjustments when new pages are selected!
 */
@property CGFloat defaultHeight;

/**
 *  @brief The intrinsic height of the tab view. This is dependent on what the current page is. If the
 *         current page returns CGSizeZero from sizeThatFits:, returns defaultHeight.
 */
@property (readonly) CGFloat intrinsicHeight;

/**
 *  @brief The index of the selected page
 */
@property (readonly) NSInteger selectedPageIndex;

/**
 *  @brief The duration of the transition that occurs after tapping a tab. Default is .25.
 */
@property (assign) NSTimeInterval transitionDuration;

/**
 *  @brief The animation curve used in the transition that occurs after tapping a tab. Default is UIViewAnimationCurveEaseOut.
 */
@property (assign) UIViewAnimationCurve transitionAnimationCurve;

/**
 *  @brief The background color of the content view (the page container)
 */
@property (nonatomic, strong) UIColor *contentBackgroundColor;

/**
 *  @brief The background color of the tab container
 */
@property (nonatomic, strong) UIColor *tabContainerBackgroundColor;

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
