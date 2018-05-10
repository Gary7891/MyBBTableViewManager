//
//  BBActionBar.m
//  MyBBTableViewManager
//
//  Created by Gary on 2018/5/3.
//  Copyright © 2018 Gary. All rights reserved.
//

#import "BBActionBar.h"
#import "BBTableViewManager.h"
#import "NSBundle+BBTableViewManager.h"



@interface BBActionBar ()

@property (strong, readwrite, nonatomic) UISegmentedControl *navigationControl;

@end

@implementation BBActionBar

- (id)initWithDelegate:(id)delegate
{
    self = [super init];
    if (!self)
        return nil;
    
    [self sizeToFit];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(handleActionBarDone:)];
    
    self.navigationControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:NSLocalizedString(@"Previous", @""), NSLocalizedString(@"Next", @""), nil]];
    self.navigationControl.momentary = YES;
    [self.navigationControl addTarget:self action:@selector(handleActionBarPreviousNext:) forControlEvents:UIControlEventValueChanged];
    
    [self.navigationControl setImage:[UIImage imageNamed:@"UIButtonBarArrowLeft" inBundle:[NSBundle BBTableViewManagerBundle] compatibleWithTraitCollection:nil] forSegmentAtIndex:0];
    [self.navigationControl setImage:[UIImage imageNamed:@"UIButtonBarArrowRight" inBundle:[NSBundle BBTableViewManagerBundle] compatibleWithTraitCollection:nil] forSegmentAtIndex:1];
    
    [self.navigationControl setDividerImage:[[UIImage alloc] init]
                        forLeftSegmentState:UIControlStateNormal
                          rightSegmentState:UIControlStateNormal
                                 barMetrics:UIBarMetricsDefault];
    
    [self.navigationControl setBackgroundImage:[UIImage imageNamed:@"Transparent" inBundle:[NSBundle BBTableViewManagerBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.navigationControl setWidth:40.0f forSegmentAtIndex:0];
    [self.navigationControl setWidth:40.0f forSegmentAtIndex:1];
    [self.navigationControl setContentOffset:CGSizeMake(-4, 0) forSegmentAtIndex:0];
    
    UIBarButtonItem *prevNextWrapper = [[UIBarButtonItem alloc] initWithCustomView:self.navigationControl];
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [self setItems:[NSArray arrayWithObjects:prevNextWrapper, flexible, doneButton, nil]];
    self.actionBarDelegate = delegate;
    
    return self;
}

- (void)handleActionBarPreviousNext:(UISegmentedControl *)segmentedControl
{
    if ([self.actionBarDelegate respondsToSelector:@selector(actionBar:navigationControlValueChanged:)])
        [self.actionBarDelegate actionBar:self navigationControlValueChanged:segmentedControl];
}

- (void)handleActionBarDone:(UIBarButtonItem *)doneButtonItem
{
    if ([self.actionBarDelegate respondsToSelector:@selector(actionBar:doneButtonPressed:)])
        [self.actionBarDelegate actionBar:self doneButtonPressed:doneButtonItem];
}

@end
