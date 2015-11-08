//
//  DRPPagingTabbedContentView.m
//  DRPPagingTabbedContentView
//
//  Created by Justin Hill on 11/5/15.
//  Copyright © 2015 Justin Hill. All rights reserved.
//

#import "DRPSlidingTabView.h"

@interface DRPSlidingTabView () <UIScrollViewDelegate>

@property UIView *tabContainer;
@property UIScrollView *contentView;

@property NSMutableArray<UIView *> *pages;
@property NSMutableArray<UIButton *> *titleButtons;

@property UIView *divider;
@property UIView *slider;

@property BOOL isFirstLayout;
@property NSInteger lastSelectedPageIndex;

@end

@implementation DRPSlidingTabView

#pragma mark - Life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    
    return self;
}

- (void)setup {
    self.tabContainer = [[UIView alloc] init];
        
    // initial bounds' height is incorrect, but we need the width to be correct
    // for page calculation. this will be fixed on first layout.
    self.contentView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.contentView.pagingEnabled = YES;
    self.contentView.delegate = self;
    self.contentView.showsHorizontalScrollIndicator = NO;
    self.contentView.showsVerticalScrollIndicator = NO;
    
    self.tabContainerBackgroundColor = [UIColor clearColor];
    self.contentBackgroundColor = [UIColor clearColor];
    
    self.pages = [NSMutableArray array];
    self.titleButtons = [NSMutableArray array];
    
    self.divider = [[UIView alloc] init];
    self.slider = [[UIView alloc] init];
    
    self.dividerColor = [UIColor lightGrayColor];
    self.titleColor = [UIColor lightGrayColor];
    
    self.titleFont = [UIFont systemFontOfSize:16];
    self.sliderHeight = 2.;
    self.tabContainerHeight = 44.;
    self.transitionAnimationCurve = UIViewAnimationCurveEaseOut;
    self.transitionDuration = .25;
    
    self.isFirstLayout = YES;
    self.lastSelectedPageIndex = 0;
    self.defaultHeight = 150.;
}

- (void)tintColorDidChange {
    [self.titleButtons[self.selectedPageIndex] setTitleColor:self.tintColor forState:UIControlStateNormal];
}

#pragma mark - Accessors
- (NSInteger)selectedPageIndex {
    NSInteger gapIndex = (NSInteger)(self.contentView.contentOffset.x / self.contentView.frame.size.width);
    CGFloat percentGapTraversed = fmodf(self.contentView.contentOffset.x, self.contentView.frame.size.width) / self.contentView.frame.size.width;
    
    if (self.pages.count == 0) {
        return NSNotFound;
        
    } else if (self.isFirstLayout) {
        return 0;
    
    } else if (gapIndex == 0 && percentGapTraversed < 0) {
        return 0;
        
    } else if (gapIndex >= self.pages.count - 1) {
        return self.pages.count - 1;
        
    } else {
        
        if (percentGapTraversed >= .5) {
            return gapIndex + 1;
            
        } else {
            return gapIndex;
        }
    }
}

- (CGFloat)intrinsicHeight {
    UIView *page = self.pages[self.selectedPageIndex];
    
    if ([page conformsToProtocol:@protocol(DRPIntrinsicHeightChangeEmitter)]) {
        id<DRPIntrinsicHeightChangeEmitter> emitter = (id<DRPIntrinsicHeightChangeEmitter>)page;
        
        return [emitter intrinsicHeightWithWidth:self.frame.size.width] + self.tabContainer.frame.size.height;
    } else {
        return self.defaultHeight;
    }
}

- (void)setContentBackgroundColor:(UIColor *)contentBackgroundColor {
    _contentBackgroundColor = contentBackgroundColor;
    self.contentView.backgroundColor = contentBackgroundColor;
}

- (void)setTabContainerBackgroundColor:(UIColor *)tabContainerBackgroundColor {
    _tabContainerBackgroundColor = tabContainerBackgroundColor;
    self.tabContainer.backgroundColor = tabContainerBackgroundColor;
}

- (void)setSliderHeight:(CGFloat)sliderHeight {
    _sliderHeight = sliderHeight;
    [self setNeedsLayout];
}

- (void)setTabContainerHeight:(CGFloat)tabContainerHeight {
    _tabContainerHeight = tabContainerHeight;
    [self setNeedsLayout];
}

- (void)setDividerColor:(UIColor *)dividerColor {
    _dividerColor = dividerColor;
    self.divider.backgroundColor = dividerColor;
    self.slider.backgroundColor = dividerColor;
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    
    [self.titleButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull titleButton, NSUInteger idx, BOOL * _Nonnull stop) {
        [titleButton setTitleColor:titleColor forState:UIControlStateNormal];
    }];
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    
    [self.titleButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull titleButton, NSUInteger idx, BOOL * _Nonnull stop) {
        [titleButton.titleLabel setFont:titleFont];
    }];
    
    [self setNeedsLayout];
}

#pragma mark - Page management
- (void)addPage:(UIView *)page withTitle:(NSString *)title {
    NSAssert(page, @"Attempted to add a nil page to DRPSlidingTabView");
    NSAssert(title, @"Attempted to add a page with nil title to DRPSlidingTabView");
    
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [titleButton setTitle:title forState:UIControlStateNormal];
    [titleButton setTitleColor:self.titleColor forState:UIControlStateNormal];
    [titleButton.titleLabel setFont:self.titleFont];
    [titleButton addTarget:self action:@selector(tabButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.titleButtons addObject:titleButton];
    [self.tabContainer addSubview:titleButton];
    
    if ([page conformsToProtocol:@protocol(DRPIntrinsicHeightChangeEmitter)]) {
        id<DRPIntrinsicHeightChangeEmitter> emitter = (id<DRPIntrinsicHeightChangeEmitter>)page;
        emitter.heightChangeListener = self;
    }
    
    [self.contentView addSubview:page];
    [self.pages addObject:page];
    
    [self layoutSubviews];
}

#pragma mark - Layout
- (void)layoutSubviews {
    
    if (self.isFirstLayout) {
        [self addSubview:self.tabContainer];
        [self.tabContainer addSubview:self.divider];
        [self.tabContainer addSubview:self.slider];
        
        [self addSubview:self.contentView];
    }
    
    self.tabContainer.frame = CGRectMake(0, 0, self.frame.size.width, self.tabContainerHeight);
    
    CGFloat contentHeight = self.frame.size.height - self.tabContainerHeight;
    self.contentView.frame = CGRectMake(0, self.tabContainerHeight, self.frame.size.width, contentHeight);
    
    [self layoutTitleButtons];
    
    self.divider.frame = CGRectMake(0, self.tabContainer.frame.size.height - 2., self.tabContainer.frame.size.width, 2);
    
    [self positionSlider];
    [self layoutPages];
    
    self.isFirstLayout = NO;
}

- (void)layoutTitleButtons {
    CGFloat totalButtonWidth = 0.;
    
    for (UILabel *titleButton in self.titleButtons) {
        [titleButton sizeToFit];
        totalButtonWidth += titleButton.frame.size.width;
    }
    
    CGFloat remainingSpace = (self.tabContainer.frame.size.width - totalButtonWidth);
    CGFloat buttonSpacing =  remainingSpace / (CGFloat)(self.titleButtons.count + 1);
    
    UILabel *previousLabel;
    for (UILabel *titleButton in self.titleButtons) {
        CGFloat xOffset = previousLabel.frame.origin.x + previousLabel.frame.size.width + buttonSpacing;
        CGFloat height = self.tabContainer.frame.size.height - self.sliderHeight - 2.;
        
        titleButton.frame = CGRectMake(xOffset, 0, titleButton.frame.size.width, height);
        
        previousLabel = titleButton;
    }
}

- (void)positionSlider {
    UIScrollView *scrollView = self.contentView;
    
    NSInteger gapIndex = (NSInteger)(scrollView.contentOffset.x / scrollView.frame.size.width);
    CGFloat percentGapTraversed = fmodf(scrollView.contentOffset.x, scrollView.frame.size.width) / scrollView.frame.size.width;
    UIButton *leftOfGap = self.titleButtons[gapIndex];
    
    if (gapIndex == 0 && percentGapTraversed < 0.) {
        // Beyond left endcap
        self.slider.frame = (CGRect){{leftOfGap.frame.origin.x, self.divider.frame.origin.y - self.sliderHeight},
                                     {leftOfGap.frame.size.width, self.sliderHeight}};
        return;
        
    } else if (gapIndex >= self.pages.count - 1) {
        // Special case for when we're EXACTLY on the far-right end
        self.slider.frame = (CGRect){{self.titleButtons.lastObject.frame.origin.x, self.divider.frame.origin.y - self.sliderHeight},
                                     {self.titleButtons.lastObject.frame.size.width, self.sliderHeight}};
        
        return;
    }
    
    UIButton *rightOfGap = self.titleButtons[gapIndex + 1];
    
    CGFloat originOffset = (rightOfGap.frame.origin.x - leftOfGap.frame.origin.x) * percentGapTraversed;
    CGFloat widthDifference = (rightOfGap.frame.size.width - leftOfGap.frame.size.width) * percentGapTraversed;
    
    self.slider.frame = (CGRect){{leftOfGap.frame.origin.x + originOffset, self.divider.frame.origin.y - self.sliderHeight},
                                 {leftOfGap.frame.size.width + widthDifference, self.sliderHeight}};
}

- (void)layoutPages {
    if (self.pages.count == 0) {
        return;
    }
    
    self.contentView.contentSize = CGSizeMake(self.frame.size.width * self.pages.count, self.intrinsicHeight - self.tabContainer.frame.size.height);
    
    [self.pages enumerateObjectsUsingBlock:^(UIView * _Nonnull page, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!page.superview) {
            [self.contentView addSubview:page];
        }
        
        page.frame = (CGRect){{self.contentView.frame.size.width * idx, 0}, self.contentView.frame.size};
        [page layoutSubviews];
    }];
}

#pragma mark - Button actions
- (void)tabButtonAction:(UIButton *)button {
    NSInteger buttonIndex = [self.titleButtons indexOfObject:button];
    
    if (buttonIndex != NSNotFound) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationCurve:self.transitionAnimationCurve];
        [UIView setAnimationDuration:self.transitionDuration];
        
        [self.contentView setContentOffset:CGPointMake(self.contentView.frame.size.width * buttonIndex, 0) animated:NO];
        
        [UIView commitAnimations];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self positionSlider];
    
    NSInteger selectedPageIndex = self.selectedPageIndex;
    if (selectedPageIndex != self.lastSelectedPageIndex) {
        [self.titleButtons[self.lastSelectedPageIndex] setTitleColor:self.titleColor forState:UIControlStateNormal];
        [self.titleButtons[selectedPageIndex] setTitleColor:self.tintColor forState:UIControlStateNormal];
        self.lastSelectedPageIndex = selectedPageIndex;
        
        if ([self.delegate respondsToSelector:@selector(slidingTabView:selectedPageIndexDidChange:)]) {
            [self.delegate slidingTabView:self selectedPageIndexDidChange:selectedPageIndex];
        }
        
        [self.delegate view:self intrinsicHeightDidChangeTo:self.intrinsicHeight];
    }
}

#pragma mark - Intrinsic content height listener
- (void)view:(UIView *)view intrinsicHeightDidChangeTo:(CGFloat)newHeight {
    if ([self.pages indexOfObject:view] == self.selectedPageIndex) {
        if (!self.isFirstLayout) {
            [self.delegate view:self intrinsicHeightDidChangeTo:self.intrinsicHeight];
        }
    }
}

@end
