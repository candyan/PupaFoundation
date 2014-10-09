//
//  PAViewController.m
//  PupaDemo
//
//  Created by liuyan on 14-3-4.
//  Copyright (c) 2014年 Douban.Inc. All rights reserved.
//

#import "PADViewController.h"

@interface PADViewController ()

@end

@implementation PADViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//  [self.insideNavigationBar setBarTintColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:0.3]];
//  [self.insideNavigationBar setTranslucent:YES];
  [self.insideNavigationBar setBarStyle:UIBarStyleBlackTranslucent];
  [self.insideNavigationItem setTitle:@"Hello"];
  [self.insideNavigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"done" style:UIBarButtonItemStyleDone target:nil action:NULL]];
}

@end
