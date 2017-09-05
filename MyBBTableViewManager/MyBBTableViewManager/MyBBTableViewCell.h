//
//  MyBBTableViewCell.h
//  MyBBTableView
//
//  Created by Gary on 4/22/16.
//  Copyright © 2016 Gary. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class MyBBTableViewManager,MyBBTableViewItem;

@interface MyBBTableViewCell : ASCellNode

@property (nonatomic, weak) MyBBTableViewManager *tableViewManager;
@property (nonatomic, assign) NSInteger rowIndex;
@property (nonatomic, assign) NSInteger sectionIndex;
@property (nonatomic, strong) MyBBTableViewItem *tableViewItem;


- (instancetype)initWithTableViewItem:(MyBBTableViewItem *)tableViewItem;
- (void)initCell;

@end
