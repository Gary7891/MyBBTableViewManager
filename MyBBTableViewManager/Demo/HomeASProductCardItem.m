//
//  HomeASProductCardItem.m
//  TTLoveCar
//
//  Created by Gary on 21/12/2017.
//  Copyright © 2017 王洋. All rights reserved.
//

#import "HomeASProductCardItem.h"




@implementation HomeASProductCardItem

+(HomeASProductCardItem *)itemWithModel:(HomeProductListModel *)model
                           clickHandler:(void(^)(HomeASProductCardItem *item,NSInteger actionType))clickHandler
                       selectionHandler:(void(^)(HomeASProductCardItem *item))selectionHandler {
    HomeASProductCardItem *item = [[HomeASProductCardItem alloc]init];
    item.model = model;
    item.onViewClickHandler = clickHandler;
    item.selectionHandler = selectionHandler;
    
    item.preferredSize = CGSizeMake(ScreenWidth, kCardProductCellHeight);
    return item;
}



@end
