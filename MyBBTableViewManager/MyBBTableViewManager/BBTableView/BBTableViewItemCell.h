//
//  BBTableViewItemCell.h
//  MyBBTableViewManager
//
//  Created by Gary on 2018/5/3.
//  Copyright © 2018 Gary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBTableViewSection.h"
#import "BBActionBar.h"


@class BBTableViewManager;
@class BBTableViewItem;

typedef NS_ENUM(NSInteger, BBTableViewCellType) {
    BBTableViewCellTypeFirst,
    BBTableViewCellTypeMiddle,
    BBTableViewCellTypeLast,
    BBTableViewCellTypeSingle,
    BBTableViewCellTypeAny
};


@interface BBTableViewItemCell : UITableViewCell


///-----------------------------
/// @name Accessing Table View and Table View Manager
///-----------------------------

@property (weak, readwrite, nonatomic) UITableView *parentTableView;
@property (weak, readwrite, nonatomic) BBTableViewManager *tableViewManager;

///-----------------------------
/// @name Managing Cell Height
///-----------------------------

+ (CGFloat)heightWithItem:(BBTableViewItem *)item tableViewManager:(BBTableViewManager *)tableViewManager;

///-----------------------------
/// @name Working With Keyboard
///-----------------------------

+ (BOOL)canFocusWithItem:(BBTableViewItem *)item;

@property (strong, readonly, nonatomic) UIResponder *responder;
@property (strong, readonly, nonatomic) NSIndexPath *indexPathForPreviousResponder;
@property (strong, readonly, nonatomic) NSIndexPath *indexPathForNextResponder;

///-----------------------------
/// @name Managing Cell Appearance
///-----------------------------

@property (strong, readonly, nonatomic) UIImageView *backgroundImageView;
@property (strong, readonly, nonatomic) UIImageView *selectedBackgroundImageView;
@property (strong, readwrite, nonatomic) BBActionBar *actionBar;

- (void)updateActionBarNavigationControl;
//- (void)layoutDetailView:(UIView *)view minimumWidth:(CGFloat)minimumWidth;

///-----------------------------
/// @name Accessing Row and Section
///-----------------------------

@property (assign, readwrite, nonatomic) NSInteger rowIndex;
@property (assign, readwrite, nonatomic) NSInteger sectionIndex;
@property (weak, readwrite, nonatomic) BBTableViewSection *section;
@property (strong, readwrite, nonatomic) BBTableViewItem *item;
@property (assign, readonly, nonatomic) BBTableViewCellType type;

///-----------------------------
/// @name Handling Cell Events
///-----------------------------

- (void)cellDidLoad;
- (void)cellWillAppear;
- (void)cellDidDisappear;

@property (assign, readonly, nonatomic) BOOL loaded;

@end
