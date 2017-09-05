//
//  MyBBTableViewLoadingItemCell.h
//  MyBBTableView
//
//  Created by Gary on 4/22/16.
//  Copyright © 2016 Gary. All rights reserved.
//

#import "MyBBTableViewCell.h"
#import "MyBBTableViewLoadingItem.h"

@interface MyBBTableViewLoadingItemCell : MyBBTableViewCell

@property (strong, readwrite, nonatomic) MyBBTableViewLoadingItem *tableViewItem;

@end
