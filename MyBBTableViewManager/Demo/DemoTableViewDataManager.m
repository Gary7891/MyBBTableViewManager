//
//  DemoTableViewDataManager.m
//  MyBBTableViewManager
//
//  Created by Gary on 2018/5/9.
//  Copyright © 2018 Gary. All rights reserved.
//

#import "DemoTableViewDataManager.h"
#import "DemoProductCardItem.h"

@implementation DemoTableViewDataManager

- (void)reloadView:(NSDictionary *)result block:(TableViewReloadCompletionBlock)completionBlock {
    __weak __typeof (self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            NSLog(@"result = %@",result);
            
            NSError *error = nil;
            NSDictionary *resultDic = [result objectForKey:@"result"];
            //            if (![resultDic isKindOfClass:[NSArray class]]) {
            //                return ;
            //            }
            id listData = [resultDic objectForKey:@"goodses"];
            if ([listData isKindOfClass:[NSString class]]) {
                listData = [NSArray array];
                //                return ;
            }
            NSInteger currentCount = 0;
            //            MyBBTableViewSection *section = self.section;
            //            [self.addIndexPathArray removeAllObjects];
            BBTableViewSection *section = [BBTableViewSection section];
            for (NSDictionary *entry in listData) {
                HomeProductListModel *model = [[HomeProductListModel alloc]initWithDictionary:entry error:&error];
                if (!error) {
                    
                    
                    DemoProductCardItem  *item = [DemoProductCardItem itemWithModel:model
                                                                           clickHandler:weakSelf.cellViewClickHandler
                                                                       selectionHandler:weakSelf.selectionHandler];
                    
                    
                    [section addItem:item];
                    //                    [_dataItemArray addObject:item];
                    NSInteger itemIndex = [section.items indexOfObject:item];
                    NSLog(@"itemindex = %@",@(itemIndex));
                    //                    [self.addIndexPathArray addObject:[NSIndexPath indexPathForItem:itemIndex inSection:0]];
                    currentCount ++;
                }
            }
            [weakSelf updateTableViewData:section];
            
            
            weakSelf.tableViewDataSource.itemCount += currentCount;
            NSError *resultError = nil;
            if (!weakSelf.tableViewDataSource.itemCount) {
                resultError = [NSError errorWithDomain:@"test" code:100 userInfo:nil];
            }
            completionBlock(YES,result,resultError,currentCount);
        }
    });
}

-(void)refreshCell:(NSInteger)actionType dataId:(NSString *)dataId {
    if (!self.currentIndexPath) {
        return;
    }
    BBTableViewSection *section =[[self.tableViewDataSource.manager sections] objectAtIndex:self.currentIndexPath.section];
    if (section && [[section items] count] > 0) {
        
    }
    //刷新
    [self.tableViewDataSource.tableView reloadRowsAtIndexPaths:@[self.currentIndexPath]
                                              withRowAnimation:UITableViewRowAnimationNone];
}

-(void)cellViewClickHandler:(BBTableViewItem *)item actionType:(NSInteger)actionType{
    self.currentIndexPath = item.indexPath;
    NSLog(@"cellViewClickHandler");
}

-(void)selectionHandler:(BBTableViewItem *)item{
    self.currentIndexPath = item.indexPath;
    NSLog(@"selectionHandler");
}

-(void)deleteHanlder:(BBTableViewItem *)item{
    NSLog(@"deleteHanlder");
}

@end
