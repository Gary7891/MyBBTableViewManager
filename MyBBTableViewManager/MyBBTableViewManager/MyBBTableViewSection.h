//
//  MyBBTableViewSection.h
//  MyBBTableView
//
//  Created by Gary on 4/22/16.
//  Copyright © 2016 Gary. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MyBBTableViewManager;

extern CGFloat const MyBBTableViewSectionHeaderHeightAutomatic;
extern CGFloat const MyBBTableViewSectionFooterHeightAutomatic;

@interface MyBBTableViewSection : NSObject

@property (strong, readonly, nonatomic) NSArray *items;

@property (copy, readwrite, nonatomic) NSString *headerTitle;

@property (copy, readwrite, nonatomic) NSString *footerTitle;

@property (assign, readwrite, nonatomic) CGFloat headerHeight;

@property (assign, readwrite, nonatomic) CGFloat footerHeight;


@property (strong, readwrite, nonatomic) UIView *headerView;

@property (strong, readwrite, nonatomic) UIView *footerView;

@property (weak, readwrite, nonatomic) MyBBTableViewManager *tableViewManager;

@property (assign, readonly, nonatomic) NSUInteger index;

@property (copy, readwrite, nonatomic) NSString *indexTitle;

@property (assign, readwrite, nonatomic) CGFloat cellTitlePadding;

+ (instancetype)section;

+ (instancetype)sectionWithHeaderView:(UIView *)headerView;

+ (instancetype)sectionWithHeaderView:(UIView *)headerView footerView:(UIView *)footerView;

- (id)initWithHeaderView:(UIView *)headerView;

- (id)initWithHeaderView:(UIView *)headerView footerView:(UIView *)footerView;


- (void)addItem:(id)item;

- (void)addItemsFromArray:(NSArray *)array;

- (void)insertItem:(id)item atIndex:(NSUInteger)index;

- (void)insertItems:(NSArray *)items atIndexes:(NSIndexSet *)indexes;

- (void)removeItem:(id)item;

- (void)removeAllItems;

- (void)removeItemIdenticalTo:(id)item inRange:(NSRange)range;

- (void)removeItemIdenticalTo:(id)item;

- (void)removeItemsInArray:(NSArray *)otherArray;

- (void)removeItemsInRange:(NSRange)range;

- (void)removeItem:(id)item inRange:(NSRange)range;

- (void)removeLastItem;

- (void)removeItemAtIndex:(NSUInteger)index;

- (void)removeItemsAtIndexes:(NSIndexSet *)indexes;

- (void)replaceItemAtIndex:(NSUInteger)index withItem:(id)item;

- (void)replaceItemsWithItemsFromArray:(NSArray *)otherArray;

- (void)replaceItemsAtIndexes:(NSIndexSet *)indexes withItems:(NSArray *)items;

- (void)replaceItemsInRange:(NSRange)range withItemsFromArray:(NSArray *)otherArray range:(NSRange)otherRange;

- (void)replaceItemsInRange:(NSRange)range withItemsFromArray:(NSArray *)otherArray;

- (void)exchangeItemAtIndex:(NSUInteger)idx1 withItemAtIndex:(NSUInteger)idx2;

- (void)sortItemsUsingFunction:(NSInteger (*)(id, id, void *))compare context:(void *)context;

- (void)sortItemsUsingSelector:(SEL)comparator;

- (void)reloadSectionWithAnimation:(UITableViewRowAnimation)animation;

@end
