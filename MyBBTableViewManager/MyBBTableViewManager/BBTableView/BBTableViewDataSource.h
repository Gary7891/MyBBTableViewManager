//
//  BBTableViewDataSource.h
//  MyBBTableViewManager
//
//  Created by Gary on 2018/5/4.
//  Copyright © 2018 Gary. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BBTableViewManager.h"
#import "MyBBTableViewManager.h"

@class BBTableViewDataManager;

typedef void (^btchTableCompletion) (BOOL finishded);

typedef NS_ENUM(NSInteger, DataLoadPolicy) {
    /**
     *  第一次加载
     */
    DataLoadPolicyFirstLoad = -1,
    /**
     *  正常加载
     */
    DataLoadPolicyNone      = 0,
    /**
     *  加载下一页
     */
    DataLoadPolicyMore      = 1,
    /**
     *  重新加载
     */
    DataLoadPolicyReload    = 2,
    /**
     *  从缓存加载
     */
    DataLoadPolicyCache     = 3,
};

typedef NS_ENUM(NSInteger, BBTableViewScrollDirection) {
    BBTableViewScrollDirectionNone  = 0,
    BBTableViewScrollDirectionUp    = 1,
    BBTableViewScrollDirectionDown  = 2,
    BBTableViewScrollDirectionLeft  = 3,
    BBTableViewScrollDirectionRight = 4,
};

@protocol BBTableViewDataSourceDelegate <NSObject>

@required

- (void)actionOnView:(id)item actionType:(NSInteger)actionType;

- (void)actionItemClick:(id)item;

- (void)didStartLoad;

- (void)didFinishLoad:(DataLoadPolicy)loadPolicy error:(NSError *)error;

- (void)didFinishLoad:(DataLoadPolicy)loadPolicy object:(id)object error:(NSError *)error;

@optional
- (BOOL)showPullRefresh;

- (void)stopPullRefresh;

- (void)actionWithPullRefresh;

- (void)tableViewExpandData:(id)expandData success:(BOOL)success;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

- (void)scrollViewDidScrollUp:(CGFloat)deltaY;

- (void)scrollViewDidScrollDown:(CGFloat)deltaY;

- (void)scrollFullScreenScrollViewDidEndDraggingScrollUp;

- (void)scrollFullScreenScrollViewDidEndDraggingScrollDown;

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface BBTableViewDataSource : NSObject
/**
 *  列表代理
 */
@property (nonatomic ,weak  ) id<BBTableViewDataSourceDelegate> delegate;
/**
 *  tableview
 */
@property (nonatomic ,weak  ) UITableView                   *tableView;

@property (nonatomic, weak) ASTableNode                     *tableNode;
/**
 *  tableview 管理器
 */
@property (nonatomic ,strong) BBTableViewManager            *manager;
@property (nonatomic ,strong) MyBBTableViewManager            *mManager;
/**
 *  数据管理器
 */
@property (nonatomic ,strong) BBTableViewDataManager         *tableViewDataManager;

@property (nonatomic ,copy  ) NSString                      *lastedId;

/**
 *  参数字典
 */
@property (nonatomic ,strong) NSMutableDictionary           *params;
/**
 *  item的数量
 */
@property (nonatomic ,assign) NSInteger                     itemCount;
/**
 *  列表类型
 */
@property (nonatomic ,assign) NSInteger                     listType;
@property (nonatomic ,assign) BOOL                          useCacheData;
/**
 *  正在加载
 */
@property (nonatomic ,assign) BOOL                           loading;
/**
 *  网络数据加载完成
 */
@property (nonatomic ,assign) BOOL                           finished;
/**
 *  总页数
 */
@property (nonatomic ,assign) NSUInteger                     totalPage;
/**
 *  当前页码
 */
@property (nonatomic ,assign) NSUInteger                     currentPage;

/**
 *  @brief 当前pageSize
 */
@property (nonatomic, assign) NSInteger                      pageSize;

@property (nonatomic, strong) btchTableCompletion            asBtchCompletionBlock;

- (id)initWithTableView:(UITableView *)tableView
               listType:(NSInteger)listType
               delegate:(id /*<BBTableViewDataSourceDelegate>*/)delegate;

- (id)initWithASTableView:(ASTableNode *)tableView
                 listType:(NSInteger)listType
                 delegate:(id /*<BBTableViewDataSourceDelegate>*/)delegate;
/**
 *  刷新列表数据
 *
 *  @param pullToRefresh 是否使用下拉刷新模式
 */
- (void)reloadTableViewData:(BOOL)pullToRefresh;
/**
 *  开始加载数据
 *
 *  @param pullToRefresh
 *  @param params
 */
- (void)startLoading:(BOOL)pullToRefresh params:(NSDictionary *)params;

/**
 加载更多
 */
- (void)loadMore;

/**
 *  停止加载
 */
- (void)stopLoading;

/**
 *  刷新指定Cell
 *
 *  @param actionType
 *  @param dataId
 */
- (void)refreshCell:(NSInteger)actionType dataId:(NSString *)dataId;

//返回item
- (id)tableViewItemByIndexPath:(NSIndexPath *)indexPath;


/**
 *  添加下拉刷新组件，子类或者category可重写
 */
- (void)addPullRefresh;

/**
 开始下拉刷新
 */
- (void)startPullRefresh;
/**
 *  停止下拉刷新，子类或者category可重写
 */
- (void)stopPullRefresh;

/**
 添加上啦加载更多的View
 */
- (void)addLoadingMoreView;

/**
 停止上拉加载更多
 */
- (void)stopLoadMore;

- (void)setFooterViewState;

@end
