//
//  TextTabView.m
//  SlidingTabDemo
//
//  Created by Justin Hill on 11/9/15.
//  Copyright © 2015 Justin Hill. All rights reserved.
//

#import "TextTabView.h"

const CGFloat contentPadding = 16;

@interface TextTabView ()

@property BOOL isFirstLayout;

@end

@implementation TextTabView

@synthesize heightChangeListener;

- (instancetype)init {
    if (self = [super init]) {
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.numberOfLines = 0;
        self.isFirstLayout = YES;
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.isFirstLayout) {
        [self addSubview:self.textLabel];
    }
    
    self.textLabel.frame = CGRectMake(contentPadding, contentPadding, self.frame.size.width - (contentPadding * 2), 0);
    [self.textLabel sizeToFit];
    
    self.isFirstLayout = NO;
}

- (CGFloat)intrinsicHeightWithWidth:(CGFloat)width {
    
    static TextTabView *sizingView;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingView = [[TextTabView alloc] init];
    });
    
    sizingView.bounds = CGRectMake(0, 0, width, 0);
    sizingView.textLabel.text = self.textLabel.text;
    [sizingView layoutSubviews];
    
    CGFloat height = sizingView.textLabel.frame.origin.y + sizingView.textLabel.frame.size.height + contentPadding;
    
    return height;
}

@end
