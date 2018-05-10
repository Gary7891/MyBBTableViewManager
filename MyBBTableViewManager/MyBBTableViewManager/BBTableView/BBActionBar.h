//
//  BBActionBar.h
//  MyBBTableViewManager
//
//  Created by Gary on 2018/5/3.
//  Copyright © 2018 Gary. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BBActionBarDelegate;

@interface BBActionBar : UIToolbar

@property (strong, readonly, nonatomic) UISegmentedControl *navigationControl;
@property (weak, readwrite, nonatomic) id<BBActionBarDelegate> actionBarDelegate;

- (id)initWithDelegate:(id)delegate;

@end

@protocol BBActionBarDelegate <NSObject>

- (void)actionBar:(BBActionBar *)actionBar navigationControlValueChanged:(UISegmentedControl *)navigationControl;
- (void)actionBar:(BBActionBar *)actionBar doneButtonPressed:(UIBarButtonItem *)doneButtonItem;

@end
