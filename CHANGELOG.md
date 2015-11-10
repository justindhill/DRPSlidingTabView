## Changelog

#### 0.2.0
- Deprecated contentBackgroundColor. You should use backgroundColor now.
- Default tabContainerBackgroundColor changed to UIColor.whiteColor
- Page content view no longer clips to bounds. This makes DRPSlidingTabView much more animation-friendly.
- Updated the sample app to reflect these changes

#### 0.1.3
- Added text example pages to sample app
- Added a call to [super layoutSubviews]
- Tab view clips to bounds by default now to make it a little more animation-friendly
- Added sizeToFit implementation. Add some pages, set a width, and the tab view will size itself when sizeToFit is called
- Pages are no longer resized to fill the entire content height of the tab view's containing scroll view. This wasn't necessary and could cause some weird state for pages with custom size if they were the first page.

#### 0.1.2
- Fixed a crash that could occur when adding a page if the view's frame was CGRectZero
- Fixed initial tint color state of first tab added

#### 0.1.1
- Layout fixes

#### 0.1.0
- Added the ability for each page in the content area to have a unique intrinsic height. When switching pages, DRPSlidingTabView's delegate will be notified of the change to its intrinsic height.
- Title text of the selected index now adopts the tab view's tintColor
