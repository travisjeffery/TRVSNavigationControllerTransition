//
//  HidesNavigationBarViewController.m
//  Basic Example
//
//  Created by Travis Jeffery on 2012-10-22.
//  Copyright (c) 2012 Daft Co. All rights reserved.
//

#import "UINavigationController+TRVSNavigationControllerTransition.h"
#import "HidesNavigationBarViewController.h"

@interface HidesNavigationBarViewController ()

@end

@implementation HidesNavigationBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGSize boundsSize = self.view.bounds.size;
    self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectZero];
    self.toolBar.frame = CGRectMake(0.f, boundsSize.height - 44.f, boundsSize.width, 44.f);
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *badPushBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Bad Push", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(pushBadAction:)];
    UIBarButtonItem *goodPushBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Good Push", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(pushGoodAction:)];
    UIBarButtonItem *showNavigationBarBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Show Navigation Bar", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(showNavigationBar:)];
    UIBarButtonItem *spaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.toolBar.items = @[showNavigationBarBarButtonItem, spaceBarButtonItem, badPushBarButtonItem, spaceBarButtonItem, goodPushBarButtonItem];
    
    [self.view addSubview:self.toolBar];
    
    self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Steve"]];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.backgroundImageView.frame = CGRectMake(0.f, 0.f, boundsSize.width, boundsSize.height - CGRectGetHeight(self.toolBar.frame));
    [self.view addSubview:self.backgroundImageView];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0.f, -CGRectGetHeight(self.navigationController.navigationBar.frame));
}


- (void)pushBadAction:(id)sender
{
    HidesNavigationBarViewController *viewController = [[HidesNavigationBarViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)pushGoodAction:(id)sender
{
    HidesNavigationBarViewController *viewController = [[HidesNavigationBarViewController alloc] init];
    [self.navigationController pushViewControllerWithNavigationControllerTransition:viewController];
}

- (void)showNavigationBar:(id)sender
{
    self.navigationController.navigationBar.transform = CGAffineTransformIdentity;
}


@end
