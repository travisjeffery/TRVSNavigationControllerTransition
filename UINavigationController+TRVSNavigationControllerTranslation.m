//
//  UINavigationController+TRVSNavigationControllerTranslation.m
//  Daft Co.
//
//  Created by Travis Jeffery on 2012-10-21.
//
//

#import "UINavigationController+TRVSNavigationControllerTranslation.h"

static CALayer *kTRVSOriginalLayer = nil;
static CALayer *kTRVSTranslationLayer = nil;

@interface TRVSNavigationControllerTranslationAnimiationDelegate : NSObject
- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag;
@end

@implementation TRVSNavigationControllerTranslationAnimiationDelegate
- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag
{
    [kTRVSOriginalLayer removeFromSuperlayer];
    [kTRVSTranslationLayer removeFromSuperlayer];
}
@end

static NSTimeInterval const kTransitionDuration = .3f;
static TRVSNavigationControllerTranslationAnimiationDelegate *kTRVSAnimationDelegate = nil;

@implementation UINavigationController (TRVSNavigationControllerTranslation)

- (void)pushViewControllerWithNavigationControllerTranslation:(UIViewController *)viewController
{
    kTRVSOriginalLayer = [self _snapshotLayerWithTransform:CATransform3DIdentity];
    
    if (kTRVSAnimationDelegate == nil){
        kTRVSAnimationDelegate = [[TRVSNavigationControllerTranslationAnimiationDelegate alloc] init];
    }
    
    [self pushViewController:viewController animated:NO];
    
    kTRVSTranslationLayer = [self _snapshotLayerWithTransform:CATransform3DIdentity];
    kTRVSTranslationLayer.frame = (CGRect){{CGRectGetWidth(self.view.bounds), CGRectGetMinY(self.view.bounds)}, self.view.bounds.size};
    
    [self.view.layer addSublayer:kTRVSOriginalLayer];
    [self.view.layer addSublayer:kTRVSTranslationLayer];
    
    [CATransaction flush];
    
    CABasicAnimation *translationX = [CABasicAnimation animationWithKeyPath:@"transform"];
    translationX.toValue = [NSValue valueWithCATransform3D:CATransform3DTranslate(CATransform3DIdentity, -CGRectGetWidth(self.view.bounds), 0.f, 0.f)];
    translationX.duration = kTransitionDuration;
    translationX.delegate = kTRVSAnimationDelegate;
    translationX.removedOnCompletion = NO;
    translationX.fillMode = kCAFillModeForwards;
    translationX.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [kTRVSOriginalLayer addAnimation:translationX forKey:nil];
    
    translationX = [CABasicAnimation animationWithKeyPath:@"transform"];
    translationX.toValue = [NSValue valueWithCATransform3D:CATransform3DTranslate(CATransform3DIdentity, -CGRectGetWidth(self.view.bounds), 0.f, 0.f)];
    translationX.duration = kTransitionDuration;
    translationX.delegate = kTRVSAnimationDelegate;
    translationX.removedOnCompletion = NO;
    translationX.fillMode = kCAFillModeForwards;
    translationX.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [kTRVSTranslationLayer addAnimation:translationX forKey:nil];
}

- (void)popViewControllerWithNavigationControllerTranslation
{
    kTRVSOriginalLayer = [self _snapshotLayerWithTransform:CATransform3DIdentity];
    
    if (kTRVSAnimationDelegate == nil){
        kTRVSAnimationDelegate = [[TRVSNavigationControllerTranslationAnimiationDelegate alloc] init];
    }
    
    [self popViewControllerAnimated:NO];
    
    kTRVSTranslationLayer = [self _snapshotLayerWithTransform:CATransform3DIdentity];
    kTRVSTranslationLayer.frame = (CGRect){{-CGRectGetWidth(self.view.bounds), CGRectGetMinY(self.view.bounds)}, self.view.bounds.size};
    
    [self.view.layer addSublayer:kTRVSOriginalLayer];
    [self.view.layer addSublayer:kTRVSTranslationLayer];
    
    [CATransaction flush];
    
    CABasicAnimation *translationX = [CABasicAnimation animationWithKeyPath:@"transform"];
    translationX.toValue = [NSValue valueWithCATransform3D:CATransform3DTranslate(CATransform3DIdentity, CGRectGetWidth(self.view.bounds), 0.f, 0.f)];
    translationX.duration = kTransitionDuration;
    translationX.delegate = kTRVSAnimationDelegate;
    translationX.removedOnCompletion = NO;
    translationX.fillMode = kCAFillModeForwards;
    translationX.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [kTRVSOriginalLayer addAnimation:translationX forKey:nil];
    
    translationX = [CABasicAnimation animationWithKeyPath:@"transform"];
    translationX.toValue = [NSValue valueWithCATransform3D:CATransform3DTranslate(CATransform3DIdentity, CGRectGetWidth(self.view.bounds), 0.f, 0.f)];
    translationX.duration = kTransitionDuration;
    translationX.delegate = kTRVSAnimationDelegate;
    translationX.removedOnCompletion = NO;
    translationX.fillMode = kCAFillModeForwards;
    translationX.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [kTRVSTranslationLayer addAnimation:translationX forKey:nil];
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
