//
//  ViewController.m
//  Basic Example
//
//  Created by Travis Jeffery on 2012-10-22.
//  Copyright (c) 2012 Daft Co. All rights reserved.
//

#import "ViewController.h"
#import "HidesNavigationBarViewController.h"
#import "UINavigationController+TRVSNavigationControllerTransition.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"Basic Example", nil);

    CGSize boundsSize = self.view.bounds.size;
    self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectZero];
    self.toolBar.frame = CGRectMake(0.f, boundsSize.height - 44.f, boundsSize.width, 44.f);
    
    self.view.backgroundColor = [UIColor blackColor];
    
    UIBarButtonItem *badPushBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Bad Push", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(pushBadAction:)];
    UIBarButtonItem *goodPushBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Good Push", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(pushGoodAction:)];
    UIBarButtonItem *showNavigationBarBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Show Navigation Bar", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(showNavigationBar:)];
    UIBarButtonItem *spaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.toolBar.items = @[showNavigationBarBarButtonItem, spaceBarButtonItem, badPushBarButtonItem, spaceBarButtonItem, goodPushBarButtonItem];
    
    [self.view addSubview:self.toolBar];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectZero];
    self.textView.font = [UIFont fontWithName:@"HelveticaNeue" size:20.f];
    self.textView.textColor = [UIColor colorWithRed:102.f/255.f green:102.f/255.f blue:102.f/255.f alpha:1.f];
    self.textView.editable = NO;
    self.textView.scrollEnabled = NO;
    self.textView.dataDetectorTypes = UIDataDetectorTypeLink;
    self.textView.text = @"Hey! Play around with the buttons below and be sure to keep an eye on how the navigation bar transitions.\n\n- Travis Jeffery on GitHub: github.com/travisjeffery\n- Travis Jeffery on Twitter: twitter.com/travisjeffery\n\nThanks!";
    self.textView.frame = CGRectMake(0.f, 0.f, boundsSize.width, boundsSize.height - (CGRectGetHeight(self.navigationController.navigationBar.frame) + CGRectGetHeight(self.toolBar.frame)));
    self.textView.center = CGPointMake(roundf(boundsSize.width/2.f), roundf(boundsSize.height/2.f));
    
    [self.view addSubview:self.textView];
}

- (void)pushBadAction:(id)sender
{
    HidesNavigationBarViewController *viewController = [[HidesNavigationBarViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)pushGoodAction:(id)sender
{
    HidesNavigationBarViewController *viewController = [[HidesNavigationBarViewController alloc] init];
    [self.navigationController trvs_pushViewControllerWithNavigationControllerTransition:viewController];
}

- (void)showNavigationBar:(id)sender
{
    self.navigationController.navigationBar.transform = CGAffineTransformIdentity;
}


@end
