//
//  DemoProductCardItem.h
//  MyBBTableViewManager
//
//  Created by Gary on 2018/5/9.
//  Copyright © 2018 Gary. All rights reserved.
//

#import "BBTableViewItem.h"
#import "HomeProductListModel.h"

@interface DemoProductCardItem : BBTableViewItem

@property (nonatomic, strong) HomeProductListModel                *model;


@property (copy, readwrite, nonatomic) void (^onViewClickHandler)(id item,NSInteger actionType);

+(DemoProductCardItem*)itemWithModel:(HomeProductListModel*)model
                        clickHandler:(void(^)(DemoProductCardItem *item,NSInteger actionType))clickHandler
                    selectionHandler:(void(^)(DemoProductCardItem *item))selectionHandler;

@end
