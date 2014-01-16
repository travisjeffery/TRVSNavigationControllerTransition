//
//  UINavigationController+TRVSNavigationControllerTranslation.h
//  Daft Co.
//
//  Created by Travis Jeffery on 2012-10-21.
//
//

#import <UIKit/UIKit.h>

@interface UINavigationController (TRVSNavigationControllerTransition)
- (void)trvs_pushViewControllerWithNavigationControllerTransition:(UIViewController *)viewController;
- (void)trvs_popViewControllerWithNavigationControllerTransition;
@end
