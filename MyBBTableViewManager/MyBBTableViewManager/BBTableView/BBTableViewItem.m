//
//  BBTableViewItem.m
//  MyBBTableViewManager
//
//  Created by Gary on 2018/5/3.
//  Copyright © 2018 Gary. All rights reserved.
//

#import "BBTableViewItem.h"
#import "BBTableViewSection.h"
#import "BBTableViewManager.h"

@implementation BBTableViewItem

+ (instancetype)item
{
    return [[self alloc] init];
}

+ (instancetype)itemWithTitle:(NSString *)title
{
    return [[self alloc] initWithTitle:title];
}

+ (instancetype)itemWithTitle:(NSString *)title accessoryType:(UITableViewCellAccessoryType)accessoryType selectionHandler:(void(^)(BBTableViewItem *item))selectionHandler
{
    return [[self alloc] initWithTitle:title accessoryType:accessoryType selectionHandler:selectionHandler accessoryButtonTapHandler:nil];
}

+ (instancetype)itemWithTitle:(NSString *)title accessoryType:(UITableViewCellAccessoryType)accessoryType selectionHandler:(void(^)(BBTableViewItem *item))selectionHandler accessoryButtonTapHandler:(void(^)(BBTableViewItem *item))accessoryButtonTapHandler
{
    return [[self alloc] initWithTitle:title accessoryType:accessoryType selectionHandler:selectionHandler accessoryButtonTapHandler:accessoryButtonTapHandler];
}

- (id)initWithTitle:(NSString *)title
{
    self = [self init];
    if (!self)
        return nil;
    
    self.title = title;
    
    return self;
}

- (id)initWithTitle:(NSString *)title accessoryType:(UITableViewCellAccessoryType)accessoryType selectionHandler:(void(^)(BBTableViewItem *item))selectionHandler
{
    return [self initWithTitle:title accessoryType:accessoryType selectionHandler:selectionHandler accessoryButtonTapHandler:nil];
}

- (id)initWithTitle:(NSString *)title accessoryType:(UITableViewCellAccessoryType)accessoryType selectionHandler:(void(^)(BBTableViewItem *item))selectionHandler accessoryButtonTapHandler:(void(^)(BBTableViewItem *item))accessoryButtonTapHandler
{
    self = [self init];
    if (!self)
        return nil;
    
    self.title = title;
    self.accessoryType = accessoryType;
    self.selectionHandler = selectionHandler;
    self.accessoryButtonTapHandler = accessoryButtonTapHandler;
    
    return self;
}

- (id)init
{
    self = [super init];
    if (!self)
        return nil;
    
    self.enabled = YES;
    self.cellHeight = 0;
    self.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    return self;
}

- (NSIndexPath *)indexPath
{
    return [NSIndexPath indexPathForRow:[self.section.items indexOfObject:self] inSection:self.section.index];
}

#pragma mark -
#pragma mark Manipulating table view row

- (void)selectRowAnimated:(BOOL)animated
{
    [self selectRowAnimated:animated scrollPosition:UITableViewScrollPositionNone];
}

- (void)selectRowAnimated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition
{
    [self.section.tableViewManager.tableView selectRowAtIndexPath:self.indexPath animated:animated scrollPosition:scrollPosition];
}

- (void)deselectRowAnimated:(BOOL)animated
{
    [self.section.tableViewManager.tableView deselectRowAtIndexPath:self.indexPath animated:animated];
}

- (void)reloadRowWithAnimation:(UITableViewRowAnimation)animation
{
    [self.section.tableViewManager.tableView reloadRowsAtIndexPaths:@[self.indexPath] withRowAnimation:animation];
}

- (void)deleteRowWithAnimation:(UITableViewRowAnimation)animation
{
    BBTableViewSection *section = self.section;
    NSInteger row = self.indexPath.row;
    [section removeItemAtIndex:self.indexPath.row];
    [section.tableViewManager.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:section.index]] withRowAnimation:animation];
}

@end
