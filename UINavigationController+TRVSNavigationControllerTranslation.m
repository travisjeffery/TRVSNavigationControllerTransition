//
//  UINavigationController+TRVSNavigationControllerTranslation.m
//  Daft Co.
//
//  Created by Travis Jeffery on 2012-10-21.
//
//

#import "UINavigationController+TRVSNavigationControllerTranslation.h"

static CALayer *kOriginalLayer = nil;
static CALayer *kPushedLayer = nil;

@interface TRVSNavigationControllerTranslationAnimiationDelegate : NSObject
- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag;
@end

@implementation TRVSNavigationControllerTranslationAnimiationDelegate
- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag
{
    [kOriginalLayer removeFromSuperlayer];
    [kPushedLayer removeFromSuperlayer];
}
@end

static NSTimeInterval const kTransitionDuration = .3f;
static TRVSNavigationControllerTranslationAnimiationDelegate *kAnimationDelegate = nil;

@implementation UINavigationController (TRVSNavigationControllerTranslation)

- (void)pushViewControllerWithNavigationControllerTranslation:(UIViewController *)viewController
{
    kOriginalLayer = [self _snapshotLayerWithTransform:CATransform3DIdentity];
    kAnimationDelegate = [[TRVSNavigationControllerTranslationAnimiationDelegate alloc] init];
    
    [self pushViewController:viewController animated:NO];
    
    kPushedLayer = [self _snapshotLayerWithTransform:CATransform3DIdentity];
    kPushedLayer.frame = (CGRect){{CGRectGetWidth(self.view.bounds), CGRectGetMinY(self.view.bounds)}, self.view.bounds.size};
    
    [self.view.layer addSublayer:kOriginalLayer];
    [self.view.layer addSublayer:kPushedLayer];
    
    [CATransaction flush];
    
    CABasicAnimation *translationX = [CABasicAnimation animationWithKeyPath:@"transform"];
    translationX.toValue = [NSValue valueWithCATransform3D:CATransform3DTranslate(CATransform3DIdentity, -CGRectGetWidth(self.view.bounds), 0.f, 0.f)];
    translationX.duration = kTransitionDuration;
    translationX.delegate = kAnimationDelegate;
    translationX.removedOnCompletion = NO;
    translationX.fillMode = kCAFillModeForwards;
    translationX.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [kOriginalLayer addAnimation:translationX forKey:nil];
    
    translationX = [CABasicAnimation animationWithKeyPath:@"transform"];
    translationX.toValue = [NSValue valueWithCATransform3D:CATransform3DTranslate(CATransform3DIdentity, -CGRectGetWidth(self.view.bounds), 0.f, 0.f)];
    translationX.duration = kTransitionDuration;
    translationX.delegate = kAnimationDelegate;
    translationX.removedOnCompletion = NO;
    translationX.fillMode = kCAFillModeForwards;
    translationX.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [kPushedLayer addAnimation:translationX forKey:nil];
}

- (void)popViewControllerWithNavigationControllerTranslation
{
    kOriginalLayer = [self _snapshotLayerWithTransform:CATransform3DIdentity];
    kAnimationDelegate = [[TRVSNavigationControllerTranslationAnimiationDelegate alloc] init];
    
    [self popViewControllerAnimated:NO];
    
    kPushedLayer = [self _snapshotLayerWithTransform:CATransform3DIdentity];
    kPushedLayer.frame = (CGRect){{-CGRectGetWidth(self.view.bounds), CGRectGetMinY(self.view.bounds)}, self.view.bounds.size};
    
    [self.view.layer addSublayer:kOriginalLayer];
    [self.view.layer addSublayer:kPushedLayer];
    
    [CATransaction flush];
    
    CABasicAnimation *translationX = [CABasicAnimation animationWithKeyPath:@"transform"];
    translationX.toValue = [NSValue valueWithCATransform3D:CATransform3DTranslate(CATransform3DIdentity, CGRectGetWidth(self.view.bounds), 0.f, 0.f)];
    translationX.duration = kTransitionDuration;
    translationX.delegate = kAnimationDelegate;
    translationX.removedOnCompletion = NO;
    translationX.fillMode = kCAFillModeForwards;
    translationX.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [kOriginalLayer addAnimation:translationX forKey:nil];
    
    translationX = [CABasicAnimation animationWithKeyPath:@"transform"];
    translationX.toValue = [NSValue valueWithCATransform3D:CATransform3DTranslate(CATransform3DIdentity, CGRectGetWidth(self.view.bounds), 0.f, 0.f)];
    translationX.duration = kTransitionDuration;
    translationX.delegate = kAnimationDelegate;
    translationX.removedOnCompletion = NO;
    translationX.fillMode = kCAFillModeForwards;
    translationX.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [kPushedLayer addAnimation:translationX forKey:nil];
}

- (CALayer *)_snapshotLayerWithTransform:(CATransform3D)transform
{
	if (UIGraphicsBeginImageContextWithOptions){
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [UIScreen mainScreen].scale);
    }
	else {
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
