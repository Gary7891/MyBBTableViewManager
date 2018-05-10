//
//  BBTableViewDataSource.m
//  MyBBTableViewManager
//
//  Created by Gary on 2018/5/4.
//  Copyright © 2018 Gary. All rights reserved.
//

#import "BBTableViewDataSource.h"
#import "BBTableViewDataManager.h"
#import "MyBBClassList.h"

#import "BBTableViewItem.h"
#import "BBTableViewItemCell.h"
#import "BBTableViewDataSourceConfig.h"


#import "BBTableViewRequest.h"


@interface BBTableViewDataSource()<BBTableViewManagerDelegate,MyBBTableViewManagerDelegate> {
    
}


/**
 *  向上滚动阈值
 */
@property (nonatomic ,assign) CGFloat                        upThresholdY;
/**
 *  向下阈值
 */
@property (nonatomic ,assign) CGFloat                        downThresholdY;
/**
 *  当前滚动方向
 */
@property (nonatomic ,assign) NSInteger                previousScrollDirection;
/**
 *  Y轴偏移
 */
@property (nonatomic ,assign) CGFloat                        previousOffsetY;
/**
 *  Y积累总量
 */
@property (nonatomic ,assign) CGFloat                        accumulatedY;

/**
 *  当前列表 NSIndexPath
 */
@property (nonatomic ,strong) NSIndexPath                    *currentIndexPath;

@property (nonatomic, strong) BBTableViewRequest            *tableViewRequest;
/**
 *  当前列表缓存key
 */
@property (nonatomic ,copy  ) NSString                       *cacheKey;
/**
 *  YES 使用 MYTableViewManager
 */
@property (nonatomic ,assign) BOOL managerFlag;

@property (nonatomic ,assign) BOOL buildingView;

@property (nonatomic ,assign) BOOL loadCacheData;


@end

//const static NSInteger kPageSize = 60;

@implementation BBTableViewDataSource

- (id)initWithTableView:(UITableView *)tableView
               listType:(NSInteger)listType
               delegate:(id /*<BBTableViewDataSourceDelegate>*/)delegate {
    self = [super init];
    if (!self)
        return nil;
    //列表管理器
    _delegate  = delegate;
    _listType  = listType;
    _tableView = tableView;
    _manager = [[BBTableViewManager alloc] initWithTableView:tableView delegate:self];
    //列表模式
    _manager.style.defaultCellSelectionStyle = UITableViewCellSelectionStyleNone;
    [self setupDataSource];
    return self;
}



- (id)initWithASTableView:(ASTableNode *)tableView
                 listType:(NSInteger)listType
                 delegate:(id /*<BBTableViewDataSourceDelegate>*/)delegate {
    self = [super init];
    if (!self)
        return nil;
    //列表管理器
    _managerFlag = YES;
    _delegate    = delegate;
    _listType    = listType;
    _tableNode   = tableView;
    _mManager = [[MyBBTableViewManager alloc] initWithTableView:tableView
                                                       delegate:self];
    //列表模式
    [self setupDataSource];
    return self;
}


/**
 *  初始化方法
 */
- (void)setupDataSource {
    //注册Cell
    [self registerClass];
    
    if (self.listType && [self.delegate showPullRefresh]) {
        [self addPullRefresh];
    }
    [self addLoadingMoreView];
    _downThresholdY = 200.0;
    _upThresholdY = 25.0;
    _tableViewRequest = [[BBTableViewRequest alloc]init];
    Class className = [[BBTableViewDataSourceConfig sharedInstance] dataManagerByListType:_listType];
    if (className) {
        _tableViewDataManager = [[className alloc] initWithDataSource:self listType:_listType];
        _tableViewDataManager.listType = _listType;
    }
    
}

- (void)addPullRefresh {

}

- (void)startPullRefresh {
    [self load:DataLoadPolicyReload params:_params];
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionWithPullRefresh)]) {
        [self.delegate actionWithPullRefresh];
    }
}

- (void)stopPullRefresh {

}


- (void)addLoadingMoreView {
    
}

- (void)stopLoadMore {
    
}

- (void)setFooterViewState {
    
}


- (void)reloadTableViewData:(BOOL)pullToRefresh {
    if (pullToRefresh) {
        pullToRefresh = [self.delegate showPullRefresh];
    }
    if (pullToRefresh) {
        [self startPullRefresh];
    }
    else {
        [self load:DataLoadPolicyReload params:_params];
    }
}

- (void)startLoading:(BOOL)pullToRefresh params:(NSDictionary *)params {
    if (pullToRefresh) {
        pullToRefresh = [self.delegate showPullRefresh];
    }
    if (pullToRefresh) {
        _params = [NSMutableDictionary dictionaryWithDictionary:params];
        [self startPullRefresh];
    }
    else {
        //        //第一次从缓存中加载
        //        [self load:DataLoadPolicyCache params:params];
        
        //第一次从缓存中加载
        if (_useCacheData) {
            [self load:DataLoadPolicyCache params:params];
            
        }//不缓存
        else{
            [self load:DataLoadPolicyNone params:params];
            
        }
    }
}

- (void)load:(DataLoadPolicy)loadPolicy params:(NSDictionary *)params {
    [self load:loadPolicy params:params context:nil];
}
/**
 *  加载列表数据
 *
 *  @param loadPolicy
 *  @param params
 */
- (void)load:(DataLoadPolicy)loadPolicy params:(NSDictionary *)params context:(ASBatchContext *)context {
    BBTableViewLogDebug(@"------------------------------load _loading = %@ dataLoadPolicy = %@",@(_loading),@(loadPolicy));
    if (_loading) {
        return;
    }
    if (loadPolicy == DataLoadPolicyMore) {
        if (_currentPage == _totalPage) {
            _finished = YES;
            return;
        }
        _currentPage++;
    }
    else {
        _currentPage = 1;
        _totalPage = 1;
        _finished = NO;
        [self setLastedId:@""];
    }
    //处理网络数据
    if (!_params) {
        _params = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    [_params setValue:[NSNumber numberWithInteger:_currentPage] forKey:@"pageNum"];
    if (self.pageSize > 0) {
        [_params setObject:@(self.pageSize) forKey:@"pageSize"];
    }
    else {
        [_params setObject:@([BBTableViewDataSourceConfig pageSize])
                    forKey:@"pageSize"];
        
    }
    
    if (params) {
        [_params addEntriesFromDictionary:params];
    }
    if ([self getLastedId]) {
        [_params setValue:[self getLastedId] forKey:@"lastedId"];
    }
    
    
    // 请求成功后的操作
    //    __weak __typeof(self) weakSelf = self;
    void (^successCompletionBlock)(BBBaseRequest *request) = ^(__kindof BBBaseRequest *request){
        BBTableViewLogDebug(@"get data from server %@ page:%@",request.requestUrl,@(self.currentPage));
        _loading = NO;
        [self handleCollectionViewData:request.responseObject dataLoadPolicy:loadPolicy error:nil context:context];
                if (loadPolicy == DataLoadPolicyMore) {
        
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopLoadMore];
                    });
                }
    };
    // 请求失败后的操作
    void (^failureCompletionBlock)(BBBaseRequest *request) = ^(__kindof BBBaseRequest *request){
        BBTableViewLogDebug(@"get data from %@ error :%@ userinfo:%@",request.requestUrl,request.error,request.userInfo);
        _loading = NO;
        if ([request cacheResponseObject]) {
            [self handleCollectionViewData:[request cacheResponseObject]
                            dataLoadPolicy:loadPolicy
                                     error:nil
                                   context:context];
        }
        else {
            [self handleCollectionViewData:nil
                            dataLoadPolicy:loadPolicy
                                     error:request.error
                                   context:context];
        }
    };
    
    NSString *url = [[BBTableViewDataSourceConfig sharedInstance] urlByListType:_listType];
    _tableViewRequest.requestURL = url;
    _tableViewRequest.requestArgument = _params;
    
    //加载第一页时候使用缓存数据
    if ([_tableViewRequest cacheResponseObject] && _useCacheData) {
        //使用缓存数据绘制UI
        BBTableViewLogDebug(@"use cache data for %@",_tableViewRequest.requestURL);
        [self handleCollectionViewData:[_tableViewRequest cacheResponseObject]
                        dataLoadPolicy:DataLoadPolicyCache
                                 error:nil
                               context:context];
        _loading = NO;
    }
    else if (loadPolicy == DataLoadPolicyMore) {
        [_tableViewRequest startWithOutCacheSuccess:successCompletionBlock
                                            failure:failureCompletionBlock];
        _loading = YES;
    }
    else {
        [_tableViewRequest startWithCompletionBlockWithSuccess:successCompletionBlock
                                                       failure:failureCompletionBlock];
        _loading = YES;
    }
    
    
}


- (void)handleCollectionViewData:(id) result
                  dataLoadPolicy:(DataLoadPolicy) dataLoadPolicy
                           error:(NSError *)hanldeError
                         context:(ASBatchContext *)context {
    BBTableViewLogDebug(@"----------------------------------handleTableViewData  loadPolicy = %@",@(dataLoadPolicy));
    //    typeof(self) strongSelf = weakSelf;
    self.buildingView = YES;
    if (dataLoadPolicy == DataLoadPolicyReload ||
        dataLoadPolicy == DataLoadPolicyNone) {
        //重新加载
        if (_managerFlag) {
            [self.mManager removeAllSections];
        }
        else {
            [self.manager removeAllSections];
        }
    }
    
    if (!result && dataLoadPolicy == DataLoadPolicyCache) {
        //缓存数据为空，触发下拉刷新操作
        [self startPullRefresh];
        return;
    }
    
    id listDic = [result objectForKey:@"result"] ;
    if ([listDic isKindOfClass:[NSDictionary class]]) {
        id sizeDic = [listDic objectForKey:@"size"];
        if (sizeDic) {
            [self setTotalPage:[sizeDic integerValue]];
        }
    }
    
    if (_totalPage == 0) {
        _totalPage = 1;
        _currentPage = 1;
    }

    
    
    //read data use network
    [self.tableViewDataManager reloadView:result
                                    block:^(BOOL finished, id object,NSError *error,NSInteger currentItemCount)
     {
         if (finished) {
             //加载列
             self.buildingView = NO;
             dispatch_async(dispatch_get_main_queue(), ^{

                 [self setFooterViewState];
                 //数据加载完成
                 if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishLoad:error:)]) {
                     [self.delegate didFinishLoad:dataLoadPolicy error:error?error:hanldeError];
                     [self stopPullRefresh];
                 }
                 if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishLoad:object:error:)]) {
                     [self.delegate didFinishLoad:dataLoadPolicy object:object error:error?error:hanldeError];
                     [self stopPullRefresh];
                 }
                 switch (dataLoadPolicy) {
                     case DataLoadPolicyNone:
                         break;
                     case DataLoadPolicyCache:
                         //开始下拉刷新
                         [self startPullRefresh];
                         break;
                     case DataLoadPolicyMore:{

                     }
                         break;
                     case DataLoadPolicyReload:
                         
                         break;
                     default:
                         break;
                 }
             });
         }
     }];
}


- (void)dealloc {
    _manager.delegate = nil;
    _tableView = nil;
    _manager = nil;
    
    _mManager.delegate = nil;
    _mManager = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)refreshCell:(NSInteger)actionType dataId:(NSString *)dataId {
    if (_tableViewDataManager) {
        [_tableViewDataManager refreshCell:actionType dataId:dataId];
    }
}

- (id)tableViewItemByIndexPath:(NSIndexPath *)indexPath {
    if (_managerFlag) {
        MyBBTableViewSection *section = [[self.mManager sections] objectAtIndex:indexPath.section];
        if (section && [[section items] count] > 0) {
            BBTableViewItem *item = (BBTableViewItem *)[[section items] objectAtIndex:indexPath.row];
            if (item) {
                return item;
            }        }
    }
    else {
        BBTableViewSection * section = [[self.manager sections] objectAtIndex:indexPath.section];
        if (section && [[section items] count] > 0) {
            BBTableViewItem *item = (BBTableViewItem *)[[section items] objectAtIndex:indexPath.row];
            if (item) {
                return item;
            }
        }
    }
    return nil;
}
#pragma mark - Private

/**
 *  注册列表Cell类型
 */
- (void)registerClass {
    NSArray *tableViewItemlist = [MyBBClassList subclassesOfClass:[BBTableViewItem class]];
    if (_managerFlag) {
        tableViewItemlist = [MyBBClassList subclassesOfClass:[MyBBTableViewItem class]];
    }
    for (Class itemClass in tableViewItemlist) {
        NSString *itemName = NSStringFromClass(itemClass);
        if (_managerFlag) {
            self.mManager[itemName] = [itemName stringByAppendingString:@"Cell"];
        }
        else {
            self.manager[itemName]   = [itemName stringByAppendingString:@"Cell"];
        }
    }
}

/**
 *  滚动方向判断
 *
 *  @param currentOffsetY
 *  @param previousOffsetY
 *
 *  @return ScrollDirection
 */
- (NSInteger)detectScrollDirection:(CGFloat)currentOffsetY previousOffsetY:(CGFloat)previousOffsetY {
    return currentOffsetY > previousOffsetY ? BBTableViewScrollDirectionUp :
    currentOffsetY < previousOffsetY ? BBTableViewScrollDirectionDown :
    BBTableViewScrollDirectionNone;
}

- (NSString *)getLastedId {
    NSString *lastedId = @"";
    lastedId = [[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"ListLastedId_%@",@(_listType)]];
    return lastedId;
}

- (void)setLastedId:(NSString *)lastedId {
    [[NSUserDefaults standardUserDefaults] setValue:lastedId
                                             forKey:[NSString stringWithFormat:@"ListLastedId_%@",@(_listType)]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadMore {
    if (_currentPage < _totalPage) {
        [self load:DataLoadPolicyMore params:_params];
    }else {
        [self stopLoadMore];
    }
}

#pragma mark - Delegate

#pragma mark - MYTableViewManagerDelegate
/**
 *  列表是否需要加载更多数据
 *
 *  @param tableView
 *
 *  @return
 */


- (BOOL)shouldBatchFetchForTableNode:(ASTableNode *)tableNode {
    return _currentPage < _totalPage;
}
/**
 *  列表开始加载更多数据
 *
 *  @param tableView
 *  @param context
 */

- (void)tableNode:(ASTableNode *)tableNode willBeginBatchFetchWithContext:(ASBatchContext *)context {
    if (!_asBtchCompletionBlock) {
        _asBtchCompletionBlock = ^(BOOL finished) {
            [context completeBatchFetching:YES];
        };
    }
    
    [self loadMore];
}

- (void)my_tableView:(UITableView *)tableView willLoadCell:(MyBBTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ([cell isKindOfClass:[MyBBTableViewLoadingItemCell class]]) {
//        //        [self performSelector:@selector(loadMore) withObject:nil afterDelay:0.3];
//    }
}
#pragma mark - UIScrollViewDelegate

- (void)stopLoading {
    if (_listType || [self.delegate showPullRefresh]) {
        [self stopPullRefresh];
    }
}

- (void)tableView:(UITableView *)tableView willLayoutCellSubviews:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath; {
    
}

- (void)tableView:(UITableView *)tableView willLoadCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath; {
    
}

- (void)tableView:(UITableView *)tableView didLoadCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath; {
    
}



- (BOOL)tableNode:(ASTableNode *)tableNode shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.delegate tableView:tableNode.view didSelectRowAtIndexPath:indexPath];
    }
    
}


- (NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return NSLocalizedString(@"删除", nil);
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:[NSArray
                                           arrayWithObjects:indexPath,nil]
                         withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
    }
}



- (void)tableNode:(ASTableNode *)tableNode didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}



//- (void)tableNode:(ASTableNode *)tableNode willDisplayRowWithNode:(ASCellNode *)node {
//    if ([node isKindOfClass:[TableViewLoadingItemCell class]]) {
//        [self performSelector:@selector(loadMore) withObject:nil afterDelay:0.3];
//    }
//    if ([self.delegate respondsToSelector:@selector(tableNode:willDisplayRowWithNode:)]) {
//        [self.delegate tableNode:tableNode willDisplayRowWithNode:node];
//    }
//}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ([cell isKindOfClass:[TableViewLoadingItemCell class]]) {
//        [self performSelector:@selector(loadMore) withObject:nil afterDelay:0.3];
//    }
    if ([self.delegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)]) {
        [self.delegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_delegate && [_delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [_delegate scrollViewDidScroll:_tableView];
    }
    
    
    CGFloat currentOffsetY = scrollView.contentOffset.y;
    NSInteger currentScrollDirection = [self detectScrollDirection:currentOffsetY previousOffsetY:_previousOffsetY];
    CGFloat topBoundary = -scrollView.contentInset.top;
    CGFloat bottomBoundary = scrollView.contentSize.height + scrollView.contentInset.bottom;
    
    BOOL isOverTopBoundary = currentOffsetY <= topBoundary;
    BOOL isOverBottomBoundary = currentOffsetY >= bottomBoundary;
    
    BOOL isBouncing = (isOverTopBoundary && currentScrollDirection != BBTableViewScrollDirectionDown) || (isOverBottomBoundary && currentScrollDirection != BBTableViewScrollDirectionUp);
    if (isBouncing || !scrollView.isDragging) {
        return;
    }
    
    CGFloat deltaY = _previousOffsetY - currentOffsetY;
    _accumulatedY += deltaY;
    
    if (currentScrollDirection == BBTableViewScrollDirectionUp) {
        BOOL isOverThreshold = _accumulatedY < -_upThresholdY;
        
        if (isOverThreshold || isOverBottomBoundary)  {
            if (_delegate && [_delegate respondsToSelector:@selector(scrollViewDidScrollUp:)]) {
                [_delegate scrollViewDidScrollUp:deltaY];
            }
        }
    }
    else if (currentScrollDirection == BBTableViewScrollDirectionDown) {
        BOOL isOverThreshold = _accumulatedY > _downThresholdY;
        
        if (isOverThreshold || isOverTopBoundary) {
            if (_delegate && [_delegate respondsToSelector:@selector(scrollViewDidScrollDown:)]) {
                [_delegate scrollViewDidScrollDown:deltaY];
            }
        }
    }
    else {
        
    }
    
    
    // reset acuumulated y when move opposite direction
    if (!isOverTopBoundary && !isOverBottomBoundary && _previousScrollDirection != currentScrollDirection) {
        _accumulatedY = 0;
    }
    
    _previousScrollDirection = currentScrollDirection;
    _previousOffsetY = currentOffsetY;
    
    
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    CGFloat currentOffsetY = scrollView.contentOffset.y;
    
    CGFloat topBoundary = -scrollView.contentInset.top;
    CGFloat bottomBoundary = scrollView.contentSize.height + scrollView.contentInset.bottom;
    
    if (_previousScrollDirection == BBTableViewScrollDirectionUp) {
        BOOL isOverThreshold = _accumulatedY < -_upThresholdY;
        BOOL isOverBottomBoundary = currentOffsetY >= bottomBoundary;
        
        if (isOverThreshold || isOverBottomBoundary) {
            if ([_delegate respondsToSelector:@selector(scrollFullScreenScrollViewDidEndDraggingScrollUp)]) {
                [_delegate scrollFullScreenScrollViewDidEndDraggingScrollUp];
            }
        }
    }
    else if (_previousScrollDirection == BBTableViewScrollDirectionDown) {
        BOOL isOverThreshold = _accumulatedY > _downThresholdY;
        BOOL isOverTopBoundary = currentOffsetY <= topBoundary;
        
        if (isOverThreshold || isOverTopBoundary) {
            if ([_delegate respondsToSelector:@selector(scrollFullScreenScrollViewDidEndDraggingScrollDown)]) {
                [self setLastedId:@""];
                [_delegate scrollFullScreenScrollViewDidEndDraggingScrollDown];
            }
        }
        
    }
    else {
        
    }
}


- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    BOOL ret = YES;
    if ([_delegate respondsToSelector:@selector(scrollFullScreenScrollViewDidEndDraggingScrollDown)]) {
        [_delegate scrollFullScreenScrollViewDidEndDraggingScrollDown];
    }
    return ret;
}

@end
