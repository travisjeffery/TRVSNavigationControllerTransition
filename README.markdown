# UINavigationController+TRVSNavigationControllerTransition Category

<hr />

This category provides two methods on UINavigationControllers to push and pop
view controllers with an animated transition of the entire UINavigationController's view, rather just the view controller's.

## Author: Travis Jeffery 

- [@travisjeffery on Twitter](http://twitter.com/travisjeffery)
- [@travisjeffery on GitHub](http://github.com/travisjeffery)
- travisjeffery@gmail.com

### API

``` objective-c 
- (void)pushViewControllerWithNavigationControllerTransition:(UIViewController *)viewController;
- (void)popViewControllerWithNavigationControllerTransition;
```

### Usages

One usage of this is when you push a view controller onto your
UINavigationController and that view controller wants to have the
UINavigationController's navigationBar hidden as the UINavigationController's
view translates in without hiding the navigationBar in the current
view. Make sure you link your binary with the QuartzCore.framework library.

The left photo below is using `pushViewController:animated:`, notice how the navigationBar
in the current view is hidden before the transition is finished. The right photo is using `pushViewControllerWithNavigationControllerTransition:`, now by
using multiple layers we can keep the navigationBar visible in the current view
until the transition completes.

![Bad](https://raw.github.com/travisjeffery/TRVSNavigationControllerTransition/master/Bad.gif) ![Good](https://raw.github.com/travisjeffery/TRVSNavigationControllerTransition/master/Good.gif)

MIT License, see the LICENSE file for details.

