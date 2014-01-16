//
//  UINavigationController+TRVSNavigationControllerTranslation.m
//  Daft Co.
//
//  Created by Travis Jeffery on 2012-10-21.
//
//

#import <QuartzCore/QuartzCore.h>
#import "UINavigationController+TRVSNavigationControllerTransition.h"

static CALayer *TRVSStillLayer = nil;
static CALayer *TRVSTransitioningLayer = nil;
static NSTimeInterval const TRVSTransitionDuration = .3f;

@interface TRVSNavigationControllerTransitionAnimiationDelegate : NSObject

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag;
+ (TRVSNavigationControllerTransitionAnimiationDelegate *)sharedDelegate;

@end

@implementation TRVSNavigationControllerTransitionAnimiationDelegate

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag {
  [TRVSStillLayer removeFromSuperlayer];
  [TRVSTransitioningLayer removeFromSuperlayer];
}

+ (TRVSNavigationControllerTransitionAnimiationDelegate *)sharedDelegate {
  static dispatch_once_t onceToken;
  __strong static id sharedDelegate = nil;
  dispatch_once(&onceToken, ^{ sharedDelegate = [[self alloc] init]; });
  return sharedDelegate;
}

@end

@implementation UINavigationController (TRVSNavigationControllerTransition)

- (void)trvs_pushViewControllerWithNavigationControllerTransition:
            (UIViewController *)viewController {
  TRVSStillLayer = [self trvs_layerSnapshotWithTransform:CATransform3DIdentity];

  [self pushViewController:viewController animated:NO];

  TRVSTransitioningLayer =
      [self trvs_layerSnapshotWithTransform:CATransform3DIdentity];
  TRVSTransitioningLayer.frame = (CGRect) {
      {CGRectGetWidth(self.view.bounds), CGRectGetMinY(self.view.bounds)},
      self.view.bounds.size};

  [self.view.layer addSublayer:TRVSStillLayer];
  [self.view.layer addSublayer:TRVSTransitioningLayer];

  [CATransaction flush];

  [TRVSStillLayer addAnimation:
          [self trvs_animationWithTranslation:-CGRectGetWidth(self.view.bounds)]
                        forKey:nil];
  [TRVSTransitioningLayer addAnimation:
          [self trvs_animationWithTranslation:-CGRectGetWidth(self.view.bounds)]
                                forKey:nil];
}

- (void)trvs_popViewControllerWithNavigationControllerTransition {
  TRVSStillLayer = [self trvs_layerSnapshotWithTransform:CATransform3DIdentity];

  [self popViewControllerAnimated:NO];

  TRVSTransitioningLayer =
      [self trvs_layerSnapshotWithTransform:CATransform3DIdentity];
  TRVSTransitioningLayer.frame = (CGRect) {
      {-CGRectGetWidth(self.view.bounds), CGRectGetMinY(self.view.bounds)},
      self.view.bounds.size};

  [self.view.layer addSublayer:TRVSStillLayer];
  [self.view.layer addSublayer:TRVSTransitioningLayer];

  [CATransaction flush];

  [TRVSStillLayer addAnimation:
          [self trvs_animationWithTranslation:CGRectGetWidth(self.view.bounds)]
                        forKey:nil];
  [TRVSTransitioningLayer addAnimation:
          [self trvs_animationWithTranslation:CGRectGetWidth(self.view.bounds)]
                                forKey:nil];
}

#pragma mark - Private

- (CABasicAnimation *)trvs_animationWithTranslation:(CGFloat)translation {
  CABasicAnimation *animation =
      [CABasicAnimation animationWithKeyPath:@"transform"];
  animation.toValue = [NSValue
      valueWithCATransform3D:CATransform3DTranslate(
                                 CATransform3DIdentity, translation, 0.f, 0.f)];
  animation.duration = TRVSTransitionDuration;
  animation.delegate =
      [TRVSNavigationControllerTransitionAnimiationDelegate sharedDelegate];
  animation.removedOnCompletion = NO;
  animation.fillMode = kCAFillModeForwards;
  animation.timingFunction =
      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];

  return animation;
}

- (CALayer *)trvs_layerSnapshotWithTransform:(CATransform3D)transform {
  if (UIGraphicsBeginImageContextWithOptions) {
    UIGraphicsBeginImageContextWithOptions(
        self.view.bounds.size, NO, [UIScreen mainScreen].scale);
  } else {
    UIGraphicsBeginImageContext(self.view.bounds.size);
  }

  [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];

  UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();

  UIGraphicsEndImageContext();

  CALayer *snapshotLayer = [CALayer layer];
  snapshotLayer.transform = transform;
  snapshotLayer.anchorPoint = CGPointMake(1.f, 1.f);
  snapshotLayer.frame = self.view.bounds;
  snapshotLayer.contents = (id)snapshot.CGImage;

  return snapshotLayer;
}

@end
