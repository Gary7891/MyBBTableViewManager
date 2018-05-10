//
//  ViewController.h
//  MyBBTableViewManager
//
//  Created by Gary on 5/5/16.
//  Copyright © 2016 Gary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBTableViewDataSource.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface ViewController : UIViewController <BBTableViewDataSourceDelegate>


@property (nonatomic, strong ,readwrite) NSMutableDictionary           *requestParams;

@property (nonatomic ,strong ,readonly) UITableView           *tableView;
@property (nonatomic ,strong ,readonly) ASTableNode           *asTableView;
@property (nonatomic ,assign          ) UITableViewStyle      tableViewStyle;
@property (nonatomic ,strong ,readonly) BBTableViewDataSource *dataSource;
@property (nonatomic ,assign          ) NSInteger             listType;
@property (nonatomic ,assign          ) BOOL                  loaded;
@property (nonatomic ,assign          ) BOOL                  usePullReload;
@property (nonatomic ,assign          ) BOOL                  useASKit;



@end

