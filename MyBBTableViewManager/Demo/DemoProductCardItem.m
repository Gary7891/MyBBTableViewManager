//
//  DemoProductCardItem.m
//  MyBBTableViewManager
//
//  Created by Gary on 2018/5/9.
//  Copyright © 2018 Gary. All rights reserved.
//

#import "DemoProductCardItem.h"

@implementation DemoProductCardItem

+(DemoProductCardItem*)itemWithModel:(HomeProductListModel*)model
                        clickHandler:(void(^)(DemoProductCardItem *item,NSInteger actionType))clickHandler
                    selectionHandler:(void(^)(DemoProductCardItem *item))selectionHandler {
    DemoProductCardItem *item = [[DemoProductCardItem alloc]init];
    item.model = model;
    item.onViewClickHandler = clickHandler;
    item.selectionHandler = selectionHandler;
    
    return item;
}

@end
