//
//  MyBBTableViewLoadingItem.m
//  MyBBTableView
//
//  Created by Gary on 4/22/16.
//  Copyright © 2016 Gary. All rights reserved.
//

#import "MyBBTableViewLoadingItem.h"

@implementation MyBBTableViewLoadingItem

+ (MyBBTableViewLoadingItem*)itemWithTitle:(NSString *)title {
    MyBBTableViewLoadingItem *item = [[MyBBTableViewLoadingItem alloc] init];
    item.title = title;
    item.selectionStyle = UITableViewCellSelectionStyleNone;
    return item;
}


@end
