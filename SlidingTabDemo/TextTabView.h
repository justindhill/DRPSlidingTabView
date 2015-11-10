//
//  TextTabView.h
//  SlidingTabDemo
//
//  Created by Justin Hill on 11/9/15.
//  Copyright © 2015 Justin Hill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRPSlidingTabView.h"

@interface TextTabView : UIView <DRPIntrinsicHeightChangeEmitter>

@property UILabel *textLabel;

@end
