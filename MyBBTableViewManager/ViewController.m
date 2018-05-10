//
//  ViewController.m
//  MyBBTableViewManager
//
//  Created by Gary on 5/5/16.
//  Copyright © 2016 Gary. All rights reserved.
//

#import "ViewController.h"
#import "MyBBTableViewManager.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import <AsyncDisplayKit/ASAssert.h>
#import "TimeLineTableViewItem.h"
#import "YYFPSLabel.h"
#import "BBTableViewDataSourceConfig.h"

@interface ViewController () {
//    ASTableNode         *_tableView;
//    MyBBTableViewManager  *_tableViewManager;
    YYFPSLabel          *_fpsLabel;
}

@end

@implementation ViewController

//- (instancetype)init
//{
//    if (!(self = [super init]))
//        return nil;
//
//
//
//
//    return self;
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
////    [[ASTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain asyncDataFetching:YES];
////    _tableView = [[ASTableNode alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//    _tableView = [[ASTableNode alloc]initWithStyle:UITableViewStylePlain];
//
//    _tableView.view.separatorStyle = UITableViewCellSeparatorStyleNone; // SocialAppNode has its own separator
//    [self.view addSubnode:_tableView];
//    // Do any additional setup after loading the view, typically from a nib.
//
//    _tableViewManager = [[MyBBTableViewManager alloc] initWithTableView:_tableView delegate:self];
//    [_tableViewManager registerClass:@"TimeLineTableViewItem"
//          forCellWithReuseIdentifier:@"TimeLineTableViewItemCell"];
//
//    [self loadData];
//
//
//    _fpsLabel = [YYFPSLabel new];
//    [_fpsLabel sizeToFit];
//    CGRect frmae = _fpsLabel.frame;
//    frmae.origin.x = 12;
//    frmae.origin.y = 12;
//    _fpsLabel.frame = frmae;
//    [self.view addSubview:_fpsLabel];
//}
//
//- (void)viewWillLayoutSubviews
//{
//    _tableView.frame = self.view.bounds;
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//
//- (BOOL)prefersStatusBarHidden
//{
//    return YES;
//}
//
//- (void)loadData {
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
//        @autoreleasepool {
//            NSArray *temp = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"data"
//                                                                                             ofType:@"plist"]];
//            MyBBTableViewSection *section = [MyBBTableViewSection section];
//            for (NSDictionary *entry in temp) {
//                [section addItem:[TimeLineTableViewItem itemWithModel:entry]];
//            }
//            [_tableViewManager addSection:section];
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [_tableView reloadData];
//        });
//    });
//}

#pragma mark - CPTableViewManagerDelegate

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tableViewStyle = UITableViewStylePlain;
//        self.usePullReload = YES;
//        self.listType = 1;
//        _useASKit = YES;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    if (_useASKit) {
        _asTableView = [[ASTableNode alloc] initWithStyle:UITableViewStylePlain];
        _asTableView.backgroundColor = [UIColor whiteColor];
        _asTableView.view.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubnode:_asTableView];
    }
    else {
        if (!_tableView) {
            _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:_tableViewStyle];
            _tableView.backgroundColor = [UIColor whiteColor];
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            [self.view addSubview:_tableView];
        }
    }
}
- (void)viewWillLayoutSubviews {
    _asTableView.frame = self.view.bounds;
}
- (void)createDataSource {

    Class class = [[BBTableViewDataSourceConfig sharedInstance] dataSourceByListType:self.listType];
    if (_useASKit) {

        _dataSource = [[class alloc] initWithASTableView:self.asTableView
                                                    listType:self.listType
                                                    delegate:self];
    }else {
        _dataSource = [[class alloc]initWithTableView:self.tableView
                                                 listType:self.listType
                                                 delegate:self];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self createDataSource];
//    [JDStatusBarNotification addStyleNamed:@"scrollNotice"
//                                   prepare:^JDStatusBarStyle*(JDStatusBarStyle *style)
//     {
//         style.barColor = [UIColor darkTextColor];
//         style.textColor = [UIColor whiteColor];
//         style.animationType = JDStatusBarAnimationTypeMove;
//         return style;
//     }];
    _requestParams = [[NSMutableDictionary alloc]init];
}


- (void)dealloc {
    [self.dataSource stopLoading];
    if (self.asTableView) {
        self.asTableView.delegate = nil;
        self.asTableView.dataSource = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (animated) {
        //        [self.tableView flashScrollIndicators];
    }
    if (self.listType) {
        [self startLoadData];
    }
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kBBReloadCellNotification object:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(autoReload:)
//                                                 name:kBBAutoLoadNotification
//                                               object:nil];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kBBAutoLoadNotification
//                                                  object:nil];
//    
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(reloadCell:)
//                                                 name:kBBReloadCellNotification
//                                               object:nil];
    
    
}

- (void)autoReload:(NSNotification *)notification {
    _loaded = NO;
    [self startLoadData];
}

- (void)scrollTableViewToSearchBarAnimated:(BOOL)animated {
    NSAssert(YES, @"This method should be handled by a subclass!");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startLoadData {
    if (!_loaded) {
        [self.dataSource startLoading:NO params:self.requestParams];
        _loaded = YES;
    }
}


- (void)reloadData {
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.dataSource reloadTableViewData:YES];
}

- (void)reloadCell:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    if (userInfo) {
        NSInteger actionType = [[userInfo objectForKey:@"type"] integerValue];
        NSString *timeId = [userInfo objectForKey:@"timeId"];
        [self.dataSource refreshCell:actionType dataId:timeId];
    }
}
#pragma mark - Privare
- (void)onLeftNavClick:(id)sender {
    
}
- (void)onRightNavClick:(id)sender {
    
}

#pragma mark - TableViewDataSourceDelegate

- (void)actionOnView:(id)item actionType:(NSInteger)actionType {
    
}

- (void)actionItemClick:(id)item {
    
}

- (BOOL)showPullRefresh {
    return _usePullReload;
}


- (void)didStartLoad {
    NSLog(@"%s",__func__);
//    [self showStateView:kBBViewStateLoading];
}


- (CGPoint)offseBBorStateView:(UIView *)view {
    return CGPointMake(0, 0);
}

- (void)didFinishLoad:(DataLoadPolicy)loadPolicy error:(NSError *)error {
//    BBLog(@"%s",__func__);
//    if (!error) {
//        [self removeStateView];
//        self.tableView.tableFooterView = [[UIView alloc] init];
//    }
//    else {
//        BBLog(@"%s",__func__);
//        if ([error.domain isEqualToString:BB_APP_ERROR_DOMAIN]) {
//            NSInteger state = kBBViewStateNone;
//            if (error.code == kBBErrorCodeAPI ||
//                error.code == kBBErrorCodeHTTP ||
//                error.code == kBBErrorCodeUnknown) {
//                state = kBBViewStateDataError;
//            }
//            if (error.code == kBBErrorCodeNetwork) {
//                state = kBBViewStateNetError;
//            }
//            if (error.code == kBBErrorCodeEmpty) {
//                state = kBBViewStateNoData;
//            }
//            if (error.code == kBBErrorCodeLocationError) {
//                state = kBBViewStateLocationError;
//            }
//            if (error.code == kBBErrorCodePhotosError) {
//                state = kBBViewStatePhotosError;
//            }
//            if (error.code == kBBErrorCodeMicrophoneError) {
//                state = kBBViewStateMicrophoneError;
//            }
//            if (error.code == kBBErrorCodeCameraError) {
//                state = kBBViewStateCameraError;
//            }
//            if (error.code == kBBErrorCodeContactsError) {
//                state = kBBViewStateContactsError;
//            }
//            [self showStateView:state];
//        }
//        else {
//            [self showStateView:kBBViewStateDataError];
//        }
//    }
}

- (void)didFinishLoad:(DataLoadPolicy)loadPolicy object:(id)object error:(NSError *)error {
    [self didFinishLoad:loadPolicy error:error];
}


- (void)scrollViewDidScroll:(UITableView *)tableView {
    
//    CGFloat currentPostion = tableView.contentOffset.y;
//    if (currentPostion - lastPosition > 30) {
//        lastPosition = currentPostion;
//        //向上滚动
//        if (currentPostion > 3000) {
//            BOOL noticed = [[BBCoreUtility sharedUtility] getBoolByKey:@"STORE_KEY_SCROLLNOTICE"];
//            if (!noticed) {
//                [JDStatusBarNotification showWithStatus:@"点击这里返回顶部"
//                                           dismissAfter:1.5
//                                              styleName:@"scrollNotice"];
//                [[BBCoreUtility sharedUtility] setBoolByKey:@"STORE_KEY_SCROLLNOTICE" value:YES];
//            }
//        }
//    }
//    else if (lastPosition - currentPostion > 30) {
//        lastPosition = currentPostion;
//    }
}
//- (void)scrollViewDidScrollUp:(CGFloat)deltaY
//{
//    [self moveToolbar:-deltaY animated:YES];
//}
//
//- (void)scrollViewDidScrollDown:(CGFloat)deltaY
//{
//    [self moveToolbar:-deltaY animated:YES];
//}
//
//- (void)scrollFullScreenScrollViewDidEndDraggingScrollUp
//{
//    [self hideToolbar:YES];
//}
//
//- (void)scrollFullScreenScrollViewDidEndDraggingScrollDown
//{
//    [self showToolbar:YES];
//}

#pragma mark - Search Delegate

//- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
//    
//}
//
//- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
//    
//}
//
//- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
//{
//    return NO;
//}

@end
