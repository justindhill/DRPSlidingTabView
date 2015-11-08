## Changelog

#### 0.1.2
- Fixed a crash that could occur when adding a page if the view's frame was CGRectZero
- Fixed initial tint color state of first tab added

#### 0.1.1
- Layout fixes

#### 0.1.0
- Added the ability for each page in the content area to have a unique intrinsic height. When switching pages, DRPSlidingTabView's delegate will be notified of the change to its intrinsic height.
- Title text of the selected index now adopts the tab view's tintColor
