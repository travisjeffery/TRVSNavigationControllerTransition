//
//  UINavigationController+TRVSNavigationControllerTranslation.h
//  Daft Co.
//
//  Created by Travis Jeffery on 2012-10-21.
//
//

#import <UIKit/UIKit.h>

@interface UINavigationController (TRVSNavigationControllerTranslation)
- (void)pushViewControllerWithNavigationControllerTranslation:(UIViewController *)viewController;
- (void)popViewControllerWithNavigationControllerTranslation;
@end
