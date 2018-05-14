//
//  MyBBTableViewManager.m
//  MyBBTableView
//
//  Created by Gary on 4/22/16.
//  Copyright © 2016 Gary. All rights reserved.
//

#import "MyBBTableViewManager.h"

@interface MyBBTableViewManager ()

@property (nonatomic, strong) NSMutableArray *mutableSections;
@property (nonatomic, assign) CGFloat defaultTableViewSectionHeight;
@property (atomic, assign) BOOL dataSourceLocked;

@end

@implementation MyBBTableViewManager

- (instancetype)initWithTableView:(ASTableNode *)tableNode delegate:(id<MyBBTableViewManagerDelegate>)delegate {
    self = [self initWithTableView:tableNode];
    if (!self)
        return nil;
    
    self.delegate = delegate;
    
    return self;
}

- (id)initWithTableView:(ASTableNode *)tableView
{
    self = [super init];
    if (!self)
        return nil;
    
    tableView.delegate = self;
    tableView.dataSource = self;
//    tableView.view.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
    
    self.mutableSections = [[NSMutableArray alloc] init];
    self.registeredClasses = [[NSMutableDictionary alloc] init];
    
    [self registerDefaultClasses];
    
    return self;
}

- (void)registerDefaultClasses
{
    self[@"__NSCFConstantString"] = @"MyBBTableViewCell";
    self[@"__NSCFString"] = @"MyBBTableViewCell";
    self[@"NSString"] = @"MyBBTableViewCell";
    self[@"MyBBTableViewItem"] = @"MyBBTableViewCell";
}


- (void)registerClass:(NSString *)objectClass forCellWithReuseIdentifier:(NSString *)identifier {
    NSAssert(NSClassFromString(objectClass), ([NSString stringWithFormat:@"Item class '%@' does not exist.", objectClass]));
    NSAssert(NSClassFromString(identifier), ([NSString stringWithFormat:@"Cell class '%@' does not exist.", identifier]));
    self.registeredClasses[(id <NSCopying>)NSClassFromString(objectClass)] = NSClassFromString(identifier);
}

- (id)objectAtKeyedSubscript:(id <NSCopying>)key
{
    return [self.registeredClasses objectForKey:key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key
{
    [self registerClass:(NSString *)key forCellWithReuseIdentifier:obj];
}

- (Class)classForCellAtIndexPath:(NSIndexPath *)indexPath {
    MyBBTableViewSection *section = [self.mutableSections objectAtIndex:indexPath.section];
    NSObject *item = [section.items objectAtIndex:indexPath.row];
    return [self.registeredClasses objectForKey:item.class];
}
- (NSArray *)sections
{
    return self.mutableSections;
}

- (CGFloat)defaultTableViewSectionHeight
{
    return self.tableView.view.style == UITableViewStyleGrouped ? 44 : 22;
}


#pragma mark -
#pragma mark ASTableViewDataSource.

- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode {
    return self.mutableSections.count;
}


- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    if (self.mutableSections.count <= section) {
        return 0;
    }
    return ((MyBBTableViewSection *)[self.mutableSections objectAtIndex:section]).items.count;
}


- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyBBTableViewSection *section = [self.mutableSections objectAtIndex:indexPath.section];
    MyBBTableViewItem *item = [section.items objectAtIndex:indexPath.row];
    
    MyBBTableViewCell* (^cellblock)() = ^MyBBTableViewCell*(){
        Class cellClass = [self classForCellAtIndexPath:indexPath];
        MyBBTableViewCell *cell = [[cellClass alloc] initWithTableViewItem:item];
        
        
        cell.rowIndex = indexPath.row;
        cell.sectionIndex = indexPath.section;
        return cell;
    };
    return cellblock;
}

- (void)tableViewLockDataSource:(ASTableView *)tableView
{
    self.dataSourceLocked = YES;
}

- (void)tableViewUnlockDataSource:(ASTableView *)tableView
{
    self.dataSourceLocked = NO;
}

#pragma mark -
#pragma mark - ASTableViewDelegate.



- (BOOL)shouldBatchFetchForTableNode:(ASTableNode *)tableNode {
    if ([self.delegate respondsToSelector:@selector(shouldBatchFetchForTableNode:)]) {
        return [self.delegate shouldBatchFetchForTableNode:tableNode];
    }
    return NO;
}


- (void)tableNode:(ASTableNode *)tableNode willBeginBatchFetchWithContext:(ASBatchContext *)context {
    if ([self.delegate respondsToSelector:@selector(tableNode:willBeginBatchFetchWithContext:)]) {
        [self.delegate tableNode:tableNode willBeginBatchFetchWithContext:context];
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(ASTableView *)tableView {
    NSMutableArray *titles;
    for (MyBBTableViewSection *section in self.mutableSections) {
        if (section.indexTitle) {
            titles = [NSMutableArray array];
            break;
        }
    }
    if (titles) {
        for (MyBBTableViewSection *section in self.mutableSections) {
            [titles addObject:section.indexTitle ? section.indexTitle : @""];
        }
    }
    
    return titles;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.mutableSections.count <= section) {
        return nil;
    }
    MyBBTableViewSection *tableViewSection = [self.mutableSections objectAtIndex:section];
    return tableViewSection.headerTitle;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (self.mutableSections.count <= section) {
        return nil;
    }
    MyBBTableViewSection *tableViewSection = [self.mutableSections objectAtIndex:section];
    return tableViewSection.footerTitle;
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    MyBBTableViewSection *sourceSection = [self.mutableSections objectAtIndex:sourceIndexPath.section];
    MyBBTableViewItem *item = [sourceSection.items objectAtIndex:sourceIndexPath.row];
    [sourceSection removeItemAtIndex:sourceIndexPath.row];
    
    MyBBTableViewSection *destinationSection = [self.mutableSections objectAtIndex:destinationIndexPath.section];
    [destinationSection insertItem:item atIndex:destinationIndexPath.row];
    
    if (item.moveCompletionHandler)
        item.moveCompletionHandler(item, sourceIndexPath, destinationIndexPath);
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.mutableSections.count <= indexPath.section) {
        return NO;
    }
    MyBBTableViewSection *section = [self.mutableSections objectAtIndex:indexPath.section];
    MyBBTableViewItem *item = [section.items objectAtIndex:indexPath.row];
    return item.moveHandler != nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < [self.mutableSections count]) {
        MyBBTableViewSection *section = [self.mutableSections objectAtIndex:indexPath.section];
        if (indexPath.row < [section.items count]) {
            MyBBTableViewItem *item = [section.items objectAtIndex:indexPath.row];
            if ([item isKindOfClass:[MyBBTableViewItem class]]) {
                return item.editingStyle != UITableViewCellEditingStyleNone || item.moveHandler;
            }
        }
    }
    
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        MyBBTableViewSection *section = [self.mutableSections objectAtIndex:indexPath.section];
        MyBBTableViewItem *item = [section.items objectAtIndex:indexPath.row];
        if (item.deletionHandlerWithCompletion) {
            item.deletionHandlerWithCompletion(item, ^{
                [section removeItemAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                
                for (NSInteger i = indexPath.row; i < section.items.count; i++) {
                    MyBBTableViewItem *afterItem = [[section items] objectAtIndex:i];
                    MyBBTableViewCell *cell = (MyBBTableViewCell *)[tableView cellForRowAtIndexPath:afterItem.indexPath];
                    cell.rowIndex--;
                }
            });
        } else {
            if (item.deletionHandler)
                item.deletionHandler(item);
            [section removeItemAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            for (NSInteger i = indexPath.row; i < section.items.count; i++) {
                MyBBTableViewItem *afterItem = [[section items] objectAtIndex:i];
                MyBBTableViewCell *cell = (MyBBTableViewCell *)[tableView cellForRowAtIndexPath:afterItem.indexPath];
                cell.rowIndex--;
            }
        }
    }
    
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        MyBBTableViewSection *section = [self.mutableSections objectAtIndex:indexPath.section];
        MyBBTableViewItem *item = [section.items objectAtIndex:indexPath.row];
        if (item.insertionHandler)
            item.insertionHandler(item);
    }
}

//- (void)tableView:(ASTableView *)tableView willDisplayNodeForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ([self.delegate respondsToSelector:@selector(mybb_tableView:willLoadCell:forRowAtIndexPath:)]) {
//        MyBBTableViewCell *cell = (MyBBTableViewCell *)[tableView nodeForRowAtIndexPath:indexPath];
//        [self.delegate mybb_tableView:tableView willLoadCell:cell forRowAtIndexPath:indexPath];
//    }
//    if ([self.delegate respondsToSelector:@selector(tableView:willDisplayNodeForRowAtIndexPath:)]) {
//        [self.delegate tableView:tableView willDisplayNodeForRowAtIndexPath:indexPath];
//    }
//}

- (void)tableNode:(ASTableNode *)tableNode willDisplayRowWithNode:(ASCellNode *)node {
    if ([self.delegate respondsToSelector:@selector(tableNode:willDisplayRowWithNode:)]) {
        [self.delegate tableNode:tableNode willDisplayRowWithNode:node];
    }
}

//- (void)tableView:(ASTableView *)tableView didEndDisplayingNode:(ASCellNode *)node forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ([self.delegate respondsToSelector:@selector(tableView:didEndDisplayingNode:forRowAtIndexPath:)]) {
//        [self.delegate tableView:tableView didEndDisplayingNode:node forRowAtIndexPath:indexPath];
//    }
//}

- (void)tableNode:(ASTableNode *)tableNode didEndDisplayingRowWithNode:(ASCellNode *)node {
    if ([self.delegate respondsToSelector:@selector(tableNode:didEndDisplayingRowWithNode:)]) {
        [self.delegate tableNode:tableNode didEndDisplayingRowWithNode:node];
    }
}


#pragma mark -
#pragma mark Table view delegate

- (ASSizeRange)tableNode:(ASTableNode *)tableNode constrainedSizeForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section >= self.mutableSections.count) {
        return ASSizeRangeMake(CGSizeZero) ;
    }
    
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableNode:constrainedSizeForRowAtIndexPath:)]) {
        return [self.delegate tableNode:tableNode constrainedSizeForRowAtIndexPath:indexPath];
    }
    
    MyBBTableViewSection *section = [self.mutableSections objectAtIndex:indexPath.section];
    MyBBTableViewItem *item = [section.items objectAtIndex:indexPath.row];
    CGSize size = item.preferredSize;
    if (!CGSizeEqualToSize(size, CGSizeZero)) {
        return ASSizeRangeMake(size);
    }
    return ASSizeRangeUnconstrained;
}

// Display customization
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:willDisplayHeaderView:forSection:)])
        [self.delegate tableView:tableView willDisplayHeaderView:view forSection:section];
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:willDisplayFooterView:forSection:)])
        [self.delegate tableView:tableView willDisplayFooterView:view forSection:section];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didEndDisplayingHeaderView:forSection:)])
        [self.delegate tableView:tableView didEndDisplayingHeaderView:view forSection:section];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section
{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didEndDisplayingFooterView:forSection:)])
        [self.delegate tableView:tableView didEndDisplayingFooterView:view forSection:section];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    if (self.mutableSections.count <= sectionIndex) {
        return UITableViewAutomaticDimension;
    }
    MyBBTableViewSection *section = [self.mutableSections objectAtIndex:sectionIndex];
    
    if (section.headerHeight != MyBBTableViewSectionHeaderHeightAutomatic) {
        return section.headerHeight;
    }
    
    if (section.headerView) {
        return section.headerView.frame.size.height;
    } else if (section.headerTitle.length) {
        if (!UITableViewStyleGrouped) {
            return self.defaultTableViewSectionHeight;
        } else {
            CGFloat headerHeight = 0;
            CGFloat headerWidth = CGRectGetWidth(CGRectIntegral(tableView.bounds)) - 40.0f; // 40 = 20pt horizontal padding on each side
            
            CGSize headerRect = CGSizeMake(headerWidth, MyBBTableViewSectionHeaderHeightAutomatic);
            
            CGRect headerFrame = [section.headerTitle boundingRectWithSize:headerRect
                                                                   options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                attributes:@{ NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline] }
                                                                   context:nil];
            
            headerHeight = headerFrame.size.height;
            
            return headerHeight + 20.0f;
        }
    }
    
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)])
        return [self.delegate tableView:tableView heightForHeaderInSection:sectionIndex];
    
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)sectionIndex
{
    if (self.mutableSections.count <= sectionIndex) {
        return UITableViewAutomaticDimension;
    }
    MyBBTableViewSection *section = [self.mutableSections objectAtIndex:sectionIndex];
    
    if (section.footerHeight != MyBBTableViewSectionFooterHeightAutomatic) {
        return section.footerHeight;
    }
    
    if (section.footerView) {
        return section.footerView.frame.size.height;
    } else if (section.footerTitle.length) {
        if (!UITableViewStyleGrouped) {
            return self.defaultTableViewSectionHeight;
        } else {
            CGFloat footerHeight = 0;
            CGFloat footerWidth = CGRectGetWidth(CGRectIntegral(tableView.bounds)) - 40.0f; // 40 = 20pt horizontal padding on each side
            
            CGSize footerRect = CGSizeMake(footerWidth, MyBBTableViewSectionFooterHeightAutomatic);
            
            CGRect footerFrame = [section.footerTitle boundingRectWithSize:footerRect
                                                                   options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                attributes:@{ NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote] }
                                                                   context:nil];
            
            footerHeight = footerFrame.size.height;
            
            return footerHeight + 10.0f;
        }
    }
    
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:heightForFooterInSection:)])
        return [self.delegate tableView:tableView heightForFooterInSection:sectionIndex];
    
    return UITableViewAutomaticDimension;
}


// Section header & footer information. Views are preferred over title should you decide to provide both

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    if (self.mutableSections.count <= sectionIndex) {
        return nil;
    }
    MyBBTableViewSection *section = [self.mutableSections objectAtIndex:sectionIndex];
    
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)])
        return [self.delegate tableView:tableView viewForHeaderInSection:sectionIndex];
    
    return section.headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)sectionIndex
{
    if (self.mutableSections.count <= sectionIndex) {
        return nil;
    }
    MyBBTableViewSection *section = [self.mutableSections objectAtIndex:sectionIndex];
    
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:viewForFooterInSection:)])
        return [self.delegate tableView:tableView viewForFooterInSection:sectionIndex];
    
    return section.footerView;
}

// Accessories (disclosures).

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    MyBBTableViewSection *section = [self.mutableSections objectAtIndex:indexPath.section];
    id item = [section.items objectAtIndex:indexPath.row];
    if ([item respondsToSelector:@selector(setAccessoryButtonTapHandler:)]) {
        MyBBTableViewItem *actionItem = (MyBBTableViewItem *)item;
        if (actionItem.accessoryButtonTapHandler)
            actionItem.accessoryButtonTapHandler(item);
    }
    
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:)])
        [self.delegate tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
}

// Selection

//- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Forward to UITableView delegate
//    //
//    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:shouldHighlightRowAtIndexPath:)])
//        return [self.delegate tableView:tableView shouldHighlightRowAtIndexPath:indexPath];
//    
//    return YES;
//}

- (BOOL)tableNode:(ASTableNode *)tableNode shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableNode:shouldHighlightRowAtIndexPath:)]) {
        return [self.delegate tableNode:tableNode shouldHighlightRowAtIndexPath:indexPath];
    }
    return YES;
}

//- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Forward to UITableView delegate
//    //
//    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didHighlightRowAtIndexPath:)])
//        [self.delegate tableView:tableView didHighlightRowAtIndexPath:indexPath];
//}

- (void)tableNode:(ASTableNode *)tableNode didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableNode:didHighlightRowAtIndexPath:)]) {
        [self.delegate tableNode:tableNode didHighlightRowAtIndexPath:indexPath];
    }
}

//- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Forward to UITableView delegate
//    //
//    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didUnhighlightRowAtIndexPath:)])
//        [self.delegate tableView:tableView didUnhighlightRowAtIndexPath:indexPath];
//}

- (void)tableNode:(ASTableNode *)tableNode didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableNode:didUnhighlightRowAtIndexPath:)]){
        [self.delegate tableNode:tableNode didUnhighlightRowAtIndexPath:indexPath];
    }
}

//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Forward to UITableView delegate
//    //
//    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)])
//        return [self.delegate tableView:tableView willSelectRowAtIndexPath:indexPath];
//    
//    return indexPath;
//}

- (NSIndexPath*)tableNode:(ASTableNode *)tableNode willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate) ]  && [self.delegate respondsToSelector:@selector(tableNode:willSelectRowAtIndexPath:)]) {
        return [self.delegate tableNode:tableNode willSelectRowAtIndexPath:indexPath];
    }
    return indexPath;
}

//- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Forward to UITableView delegate
//    //
//    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:willDeselectRowAtIndexPath:)])
//        return [self.delegate tableView:tableView willDeselectRowAtIndexPath:indexPath];
//    
//    return indexPath;
//}

- (NSIndexPath*)tableNode:(ASTableNode *)tableNode willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableNode:willDeselectRowAtIndexPath:)]) {
        return [self.delegate tableNode:tableNode willDeselectRowAtIndexPath:indexPath];
    }
    return indexPath;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [_tableView beginUpdates];
//    MyBBTableViewSection *section = [self.mutableSections objectAtIndex:indexPath.section];
//    id item = [section.items objectAtIndex:indexPath.row];
//    if ([item respondsToSelector:@selector(setSelectionHandler:)]) {
//        MyBBTableViewItem *actionItem = (MyBBTableViewItem *)item;
//        if (actionItem.selectionHandler)
//            actionItem.selectionHandler(item);
//    }
//    
//    // Forward to UITableView delegate
//    //
//    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
//        [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
//    
//    [_tableView endUpdates];
//}

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableNode deselectRowAtIndexPath:indexPath animated:YES];
    MyBBTableViewSection *section = [self.mutableSections objectAtIndex:indexPath.section];
    id item = [section.items objectAtIndex:indexPath.row];
    if ([item respondsToSelector:@selector(setSelectionHandler:)]) {
        MyBBTableViewItem *actionItem = (MyBBTableViewItem *)item;
        if (actionItem.selectionHandler)
            actionItem.selectionHandler(item);
    }
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableNode:didSelectRowAtIndexPath:)]) {
        [self.delegate tableNode:tableNode didSelectRowAtIndexPath:indexPath];
    }
}

//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Forward to UITableView delegate
//    //
//    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)])
//        [self.delegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
//}

- (void)tableNode:(ASTableNode *)tableNode didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableNode:didDeselectRowAtIndexPath:)]) {
        [self.delegate tableNode:tableNode didDeselectRowAtIndexPath:indexPath];
    }
}

// Editing

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyBBTableViewSection *section = [self.mutableSections objectAtIndex:indexPath.section];
    MyBBTableViewItem *item = [section.items objectAtIndex:indexPath.row];
    
    if (![item isKindOfClass:[MyBBTableViewItem class]])
        return UITableViewCellEditingStyleNone;
    
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)])
        return [self.delegate tableView:tableView editingStyleForRowAtIndexPath:indexPath];
    
    return item.editingStyle;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:)])
        return [self.delegate tableView:tableView titleForDeleteConfirmationButtonForRowAtIndexPath:indexPath];
    
    return NSLocalizedString(@"Delete", @"Delete");
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:shouldIndentWhileEditingRowAtIndexPath:)])
        return [self.delegate tableView:tableView shouldIndentWhileEditingRowAtIndexPath:indexPath];
    
    return YES;
}

- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:willBeginEditingRowAtIndexPath:)])
        [self.delegate tableView:tableView willBeginEditingRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didEndEditingRowAtIndexPath:)])
        [self.delegate tableView:tableView didEndEditingRowAtIndexPath:indexPath];
}

// Moving/reordering

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    MyBBTableViewSection *sourceSection = [self.mutableSections objectAtIndex:sourceIndexPath.section];
    MyBBTableViewItem *item = [sourceSection.items objectAtIndex:sourceIndexPath.row];
    if (item.moveHandler) {
        BOOL allowed = item.moveHandler(item, sourceIndexPath, proposedDestinationIndexPath);
        if (!allowed)
            return sourceIndexPath;
    }
    
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:)])
        return [self.delegate tableView:tableView targetIndexPathForMoveFromRowAtIndexPath:sourceIndexPath toProposedIndexPath:proposedDestinationIndexPath];
    
    return proposedDestinationIndexPath;
}

// Indentation

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:indentationLevelForRowAtIndexPath:)])
        return [self.delegate tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    
    return 0;
}

// Copy/Paste.  All three methods must be implemented by the delegate.
//
//- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    MyBBTableViewSection *section = [self.mutableSections objectAtIndex:indexPath.section];
//    id anItem = [section.items objectAtIndex:indexPath.row];
//    if ([anItem respondsToSelector:@selector(setCopyHandler:)]) {
//        MyBBTableViewItem *item = anItem;
//        if (item.copyHandler || item.pasteHandler)
//            return YES;
//    }
//    
//    // Forward to UITableView delegate
//    //
//    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:shouldShowMenuForRowAtIndexPath:)])
//        return [self.delegate tableView:tableView shouldShowMenuForRowAtIndexPath:indexPath];
//    
//    return NO;
//}

- (BOOL)tableNode:(ASTableNode *)tableNode shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyBBTableViewSection *section = [self.mutableSections objectAtIndex:indexPath.section];
    id anItem = [section.items objectAtIndex:indexPath.row];
    if ([anItem respondsToSelector:@selector(setCopyHandler:)]) {
        MyBBTableViewItem *item = anItem;
        if (item.copyHandler || item.pasteHandler)
            return YES;
    }
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableNode:shouldShowMenuForRowAtIndexPath:)]) {
        return [self.delegate tableNode:tableNode shouldShowMenuForRowAtIndexPath:indexPath];
    }
    return NO;
}

//- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
//{
//    MyBBTableViewSection *section = [self.mutableSections objectAtIndex:indexPath.section];
//    id anItem = [section.items objectAtIndex:indexPath.row];
//    if ([anItem respondsToSelector:@selector(setCopyHandler:)]) {
//        MyBBTableViewItem *item = anItem;
//        if (item.copyHandler && action == @selector(copy:))
//            return YES;
//        
//        if (item.pasteHandler && action == @selector(paste:))
//            return YES;
//        
//        if (item.cutHandler && action == @selector(cut:))
//            return YES;
//    }
//    
//    // Forward to UITableViewDelegate
//    //
//    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:canPerformAction:forRowAtIndexPath:withSender:)])
//        return [self.delegate tableView:tableView canPerformAction:action forRowAtIndexPath:indexPath withSender:sender];
//    
//    return NO;
//}

- (BOOL)tableNode:(ASTableNode *)tableNode canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    MyBBTableViewSection *section = [self.mutableSections objectAtIndex:indexPath.section];
    id anItem = [section.items objectAtIndex:indexPath.row];
    if ([anItem respondsToSelector:@selector(setCopyHandler:)]) {
        MyBBTableViewItem *item = anItem;
        if (item.copyHandler && action == @selector(copy:))
            return YES;
        
        if (item.pasteHandler && action == @selector(paste:))
            return YES;
        
        if (item.cutHandler && action == @selector(cut:))
            return YES;
    }
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableNode:canPerformAction:forRowAtIndexPath:withSender:)]) {
        return [self.delegate tableNode:tableNode canPerformAction:action forRowAtIndexPath:indexPath withSender:sender];
    }
    return NO;
}

//- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
//{
//    MyBBTableViewSection *section = [self.mutableSections objectAtIndex:indexPath.section];
//    MyBBTableViewItem *item = [section.items objectAtIndex:indexPath.row];
//    
//    if (action == @selector(copy:)) {
//        if (item.copyHandler)
//            item.copyHandler(item);
//    }
//    
//    if (action == @selector(paste:)) {
//        if (item.pasteHandler)
//            item.pasteHandler(item);
//    }
//    
//    if (action == @selector(cut:)) {
//        if (item.cutHandler)
//            item.cutHandler(item);
//    }
//    
//    // Forward to UITableView delegate
//    //
//    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:performAction:forRowAtIndexPath:withSender:)])
//        [self.delegate tableView:tableView performAction:action forRowAtIndexPath:indexPath withSender:sender];
//}

- (void)tableNode:(ASTableNode *)tableNode performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    MyBBTableViewSection *section = [self.mutableSections objectAtIndex:indexPath.section];
    MyBBTableViewItem *item = [section.items objectAtIndex:indexPath.row];
    
    if (action == @selector(copy:)) {
        if (item.copyHandler)
            item.copyHandler(item);
    }
    
    if (action == @selector(paste:)) {
        if (item.pasteHandler)
            item.pasteHandler(item);
    }
    
    if (action == @selector(cut:)) {
        if (item.cutHandler)
            item.cutHandler(item);
    }
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableNode:performAction:forRowAtIndexPath:withSender:)]) {
        [self.delegate tableNode:tableNode performAction:action forRowAtIndexPath:indexPath withSender:sender];
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidScroll:)])
        [self.delegate scrollViewDidScroll:self.tableView.view];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidZoom:)])
        [self.delegate scrollViewDidZoom:self.tableView.view];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)])
        [self.delegate scrollViewWillBeginDragging:self.tableView.view];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)])
        [self.delegate scrollViewWillEndDragging:self.tableView.view withVelocity:velocity targetContentOffset:targetContentOffset];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)])
        [self.delegate scrollViewDidEndDragging:self.tableView.view willDecelerate:decelerate];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)])
        [self.delegate scrollViewWillBeginDecelerating:self.tableView.view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)])
        [self.delegate scrollViewDidEndDecelerating:self.tableView.view];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)])
        [self.delegate scrollViewDidEndScrollingAnimation:self.tableView.view];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(viewForZoomingInScrollView:)])
        return [self.delegate viewForZoomingInScrollView:self.tableView.view];
    
    return nil;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)])
        [self.delegate scrollViewWillBeginZooming:self.tableView.view withView:view];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)])
        [self.delegate scrollViewDidEndZooming:self.tableView.view withView:view atScale:scale];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)])
        return [self.delegate scrollViewShouldScrollToTop:self.tableView.view];
    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidScrollToTop:)])
        [self.delegate scrollViewDidScrollToTop:self.tableView.view];
}

#pragma mark -
#pragma mark Managing sections

- (void)addSection:(MyBBTableViewSection *)section
{
    ASDisplayNodeAssert(!self.dataSourceLocked, @"Could not update data source when it is locked !");
    section.tableViewManager = self;
    [self.mutableSections addObject:section];
}

- (void)addSectionsFromArray:(NSArray *)array
{
    for (MyBBTableViewSection *section in array)
        section.tableViewManager = self;
    [self.mutableSections addObjectsFromArray:array];
}

- (void)insertSection:(MyBBTableViewSection *)section atIndex:(NSUInteger)index
{
    section.tableViewManager = self;
    [self.mutableSections insertObject:section atIndex:index];
}

- (void)insertSections:(NSArray *)sections atIndexes:(NSIndexSet *)indexes
{
    for (MyBBTableViewSection *section in sections)
        section.tableViewManager = self;
    [self.mutableSections insertObjects:sections atIndexes:indexes];
}

- (void)removeSection:(MyBBTableViewSection *)section
{
    [self.mutableSections removeObject:section];
}

- (void)removeAllSections
{
    [self.mutableSections removeAllObjects];
}

- (void)removeSectionIdenticalTo:(MyBBTableViewSection *)section inRange:(NSRange)range
{
    [self.mutableSections removeObjectIdenticalTo:section inRange:range];
}

- (void)removeSectionIdenticalTo:(MyBBTableViewSection *)section
{
    [self.mutableSections removeObjectIdenticalTo:section];
}

- (void)removeSectionsInArray:(NSArray *)otherArray
{
    [self.mutableSections removeObjectsInArray:otherArray];
}

- (void)removeSectionsInRange:(NSRange)range
{
    [self.mutableSections removeObjectsInRange:range];
}

- (void)removeSection:(MyBBTableViewSection *)section inRange:(NSRange)range
{
    [self.mutableSections removeObject:section inRange:range];
}

- (void)removeLastSection
{
    [self.mutableSections removeLastObject];
}

- (void)removeSectionAtIndex:(NSUInteger)index
{
    [self.mutableSections removeObjectAtIndex:index];
}

- (void)removeSectionsAtIndexes:(NSIndexSet *)indexes
{
    [self.mutableSections removeObjectsAtIndexes:indexes];
}

- (void)replaceSectionAtIndex:(NSUInteger)index withSection:(MyBBTableViewSection *)section
{
    section.tableViewManager = self;
    [self.mutableSections replaceObjectAtIndex:index withObject:section];
}

- (void)replaceSectionsWithSectionsFromArray:(NSArray *)otherArray
{
    [self removeAllSections];
    [self addSectionsFromArray:otherArray];
}

- (void)replaceSectionsAtIndexes:(NSIndexSet *)indexes withSections:(NSArray *)sections
{
    for (MyBBTableViewSection *section in sections)
        section.tableViewManager = self;
    [self.mutableSections replaceObjectsAtIndexes:indexes withObjects:sections];
}

- (void)replaceSectionsInRange:(NSRange)range withSectionsFromArray:(NSArray *)otherArray range:(NSRange)otherRange
{
    for (MyBBTableViewSection *section in otherArray)
        section.tableViewManager = self;
    [self.mutableSections replaceObjectsInRange:range withObjectsFromArray:otherArray range:otherRange];
}

- (void)replaceSectionsInRange:(NSRange)range withSectionsFromArray:(NSArray *)otherArray
{
    [self.mutableSections replaceObjectsInRange:range withObjectsFromArray:otherArray];
}

- (void)exchangeSectionAtIndex:(NSUInteger)idx1 withSectionAtIndex:(NSUInteger)idx2
{
    [self.mutableSections exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
}

- (void)sortSectionsUsingFunction:(NSInteger (*)(id, id, void *))compare context:(void *)context
{
    [self.mutableSections sortUsingFunction:compare context:context];
}

- (void)sortSectionsUsingSelector:(SEL)comparator
{
    [self.mutableSections sortUsingSelector:comparator];
}


@end
