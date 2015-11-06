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

@end

@implementation DRPSlidingTabView

- (instancetype)init {
    if (self = [super init]) {
        self.tabContainer = [[UIView alloc] init];
        self.contentView = [[UIScrollView alloc] init];
        self.contentView.pagingEnabled = YES;
        self.contentView.delegate = self;
        
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
    }
    
    return self;
}

#pragma mark - Accessors
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
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleButton setTitle:title forState:UIControlStateNormal];
    [titleButton setTitleColor:self.titleColor forState:UIControlStateNormal];
    [titleButton.titleLabel setFont:self.titleFont];
    [titleButton addTarget:self action:@selector(tabButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.titleButtons addObject:titleButton];
    [self.tabContainer addSubview:titleButton];
    
    [self.contentView addSubview:page];
    [self.pages addObject:page];
    
    [self setNeedsLayout];
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
    self.contentView.contentSize = CGSizeMake(self.frame.size.width * self.pages.count, self.contentView.frame.size.height);
    
    [self.pages enumerateObjectsUsingBlock:^(UIView * _Nonnull page, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!page.superview) {
            [self.contentView addSubview:page];
        }
        
        page.frame = (CGRect){{self.contentView.frame.size.width * idx, 0}, self.contentView.frame.size};
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
}

@end
