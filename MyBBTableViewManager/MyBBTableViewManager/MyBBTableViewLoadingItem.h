//
//  MyBBTableViewLoadingItem.h
//  MyBBTableView
//
//  Created by Gary on 4/22/16.
//  Copyright © 2016 Gary. All rights reserved.
//

#import "MyBBTableViewItem.h"

@interface MyBBTableViewLoadingItem : MyBBTableViewItem

@property (nonatomic ,copy) NSString *title;

+ (MyBBTableViewLoadingItem*)itemWithTitle:(NSString *)title;

@end
