//
//  DemoTableViewDataSource.m
//  MyBBTableViewManager
//
//  Created by Gary on 2018/5/9.
//  Copyright © 2018 Gary. All rights reserved.
//

#import "DemoTableViewDataSource.h"
#import <MJRefresh/MJRefresh.h>

@implementation DemoTableViewDataSource

- (void)addPullRefresh {
    __weak __typeof(self) weakSelf = self;
    NSMutableArray *progress =[NSMutableArray array];
    for (int i=1;i<=12;i++)
    {
        NSString *fname = [NSString stringWithFormat:@"LoadingImage%02d",i];
        [progress addObject:[UIImage imageNamed:fname]];
    }
    if (self.tableView) {
        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            
            NSLog(@"addd  refresh");
            
//            [weakSelf reloadCollectionViewData:YES];
            [weakSelf reloadTableViewData:YES];
            
        }];
        [header setImages:progress forState:MJRefreshStateIdle];
        [header setImages:progress forState:MJRefreshStatePulling];
        [header setImages:progress forState:MJRefreshStateRefreshing];
        // Hide the time
        header.lastUpdatedTimeLabel.hidden = YES;
        // Hide the status
        header.stateLabel.hidden = YES;
        self.tableView.mj_header = header;
    }else if (self.tableNode) {
        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            
            NSLog(@"addd  refresh");
            
//            [weakSelf reloadCollectionViewData:YES];
            [weakSelf reloadTableViewData:YES];
            
        }];
        [header setImages:progress forState:MJRefreshStateIdle];
        [header setImages:progress forState:MJRefreshStatePulling];
        [header setImages:progress forState:MJRefreshStateRefreshing];
        // Hide the time
        header.lastUpdatedTimeLabel.hidden = YES;
        // Hide the status
        header.stateLabel.hidden = YES;
        self.tableNode.view.mj_header = header;
    }
}

- (void)startPullRefresh {
    [super startPullRefresh];
}

- (void)stopPullRefresh {
    NSLog(@"start stopPullRefresh");
    if (self.tableView) {
        [self.tableView.mj_header endRefreshing];
    }else if (self.tableNode) {
        [self.tableNode.view.mj_header endRefreshing];
    }
}

- (void)addLoadingMoreView {
    __weak __typeof(self) weakSelf = self;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMore];
        
    }];
    self.tableView.mj_footer.hidden = YES;
    
}

- (void)setFooterViewState {
    if (self.currentPage < self.totalPage) {
        self.tableView.mj_footer.hidden = NO;
    }else {
        self.tableView.mj_footer.hidden = YES;
    }
}

- (void)stopLoadMore {
    [self.tableView.mj_footer endRefreshing];
}

@end
