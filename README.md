# DRPSlidingTabView [![Version](https://img.shields.io/cocoapods/v/DRPSlidingTabView.svg?style=flat)](http://cocoapods.org/pods/DRPSlidingTabView) [![License](https://img.shields.io/cocoapods/l/DRPSlidingTabView.svg?style=flat)](http://cocoapods.org/pods/DRPSlidingTabView) [![Platform](https://img.shields.io/cocoapods/p/DRPSlidingTabView.svg?style=flat)](http://cocoapods.org/pods/DRPSlidingTabView)
### A highly-configurable tab view for iOS with a slider that tweens between tabs as you swipe.

<p align="center">
  <img src="http://giant.gfycat.com/SecondWhoppingGoitered.gif" width="320"/>
</p>

#### Configurable things include:
* Animation curve of the transition
* Height of the slider
* Height of the tab container
* Height of individual tabs
* Background color of the tab container
* Background color of the content area
* Color of title text
* Font of title text
* Color of the divider/slider

#### Plus:
* Receive updates about the state of the tab view as it changes! Simply add a delegate to it.
```objc

/**
 *  @brief Called when an emitter's intrinsic height changes (at the emitter's discretion)
 */
- (void)view:(UIView *)view intrinsicHeightDidChangeTo:(CGFloat)newHeight;

/**
 *  @brief Called when the sliding tab view's selected page index changes.
 */
- (void)slidingTabView:(DRPSlidingTabView *)slidingTabView selectedPageIndexDidChange:(NSInteger)selectedIndex;
```

