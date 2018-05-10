//
//  BBTableViewDataManager.m
//  MyBBTableViewManager
//
//  Created by Gary on 2018/5/4.
//  Copyright © 2018 Gary. All rights reserved.
//

#import "BBTableViewDataManager.h"

@interface BBTableViewDataManager() {
    
}


@end

@implementation BBTableViewDataManager

- (instancetype)initWithDataSource:(BBTableViewDataSource *)tableViewDataSource
                          listType:(NSInteger)listType {
    self = [super init];
    if (!self) {
        return nil;
    }
    _tableViewDataSource = tableViewDataSource;
    __weak __typeof(self)weakSelf = self;
    _cellViewClickHandler = ^ (id item ,NSInteger actionType) {
        if ([item isKindOfClass:[BBTableViewItem class]]) {
            weakSelf.currentIndexPath = ((BBTableViewItem*)item).indexPath;
            [((BBTableViewItem*)item) deselectRowAnimated:YES];
        }
        if ([item isKindOfClass:[MyBBTableViewItem class]]) {
            weakSelf.currentIndexPath = ((MyBBTableViewItem*)item).indexPath;
            [((MyBBTableViewItem*)item) deselectRowAnimated:YES];
        }
        
        
        if ([weakSelf.tableViewDataSource.delegate respondsToSelector:@selector(actionOnView:actionType:)]) {
            [weakSelf.tableViewDataSource.delegate actionOnView:item actionType:actionType];
        }
        [weakSelf cellViewClickHandler:item actionType:actionType];
    };
    _selectionHandler = ^(id item) {
        if ([item isKindOfClass:[BBTableViewItem class]]) {
            weakSelf.currentIndexPath = ((BBTableViewItem*)item).indexPath;
            [((BBTableViewItem*)item) deselectRowAnimated:YES];
        }
        if ([item isKindOfClass:[MyBBTableViewItem class]]) {
            weakSelf.currentIndexPath = ((MyBBTableViewItem*)item).indexPath;
            [((MyBBTableViewItem*)item) deselectRowAnimated:YES];
        }
        
        if ([weakSelf.tableViewDataSource.delegate respondsToSelector:@selector(actionItemClick:)]) {
            [weakSelf.tableViewDataSource.delegate actionItemClick:item];
            
        }
        [weakSelf selectionHandler:item];
    };
    
    _deleteHanlder = ^(BBTableViewItem *item ,Completion completion) {
        [weakSelf deleteHanlder:item completion:completion];
    };
    
    return self;
}

- (void)reloadView:(NSDictionary *)result block:(TableViewReloadCompletionBlock)completionBlock {
    
}

- (void)refreshCell:(NSInteger)actionType dataId:(NSString *)dataId {
    
}

- (void)cellViewClickHandler:(id)item actionType:(NSInteger)actionType {
    
}
- (void)selectionHandler:(id)item {
    
}
- (void)deleteHanlder:(id)item completion:(void (^)(void))completion {
    
}

- (void)updateTableViewData:(id)section {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger sectionCount = 0;
        if (self.tableViewDataSource.manager) {
            sectionCount = [self.tableViewDataSource.manager.sections count];
            [self.tableViewDataSource.manager addSection:section];
        }
        else {
            sectionCount = [self.tableViewDataSource.mManager.sections count];
            [self.tableViewDataSource.mManager addSection:section];
        }
        if (sectionCount > 0) {
            if (self.tableViewDataSource.manager) {
                [self.tableViewDataSource.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionCount]
                                                  withRowAnimation:UITableViewRowAnimationBottom];
            }else {
                [self.tableViewDataSource.tableNode performBatchAnimated:YES updates:^{
                    [self.tableViewDataSource.tableNode insertSections:[NSIndexSet indexSetWithIndex:sectionCount] withRowAnimation:UITableViewRowAnimationBottom];
                } completion:self.tableViewDataSource.asBtchCompletionBlock];
                
            }
            
        }
        else {
            if (self.tableViewDataSource.manager) {
                [self.tableViewDataSource.tableView reloadData];
            }else {
                [self.tableViewDataSource.tableNode reloadData];
            }
            
        }
    });
}

@end
