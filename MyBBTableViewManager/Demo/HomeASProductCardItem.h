//
//  HomeASProductCardItem.h
//  TTLoveCar
//
//  Created by Gary on 21/12/2017.
//  Copyright © 2017 王洋. All rights reserved.
//

#import "HomeProductListModel.h"
#import "MyBBTableViewItem.h"

#define kCardProductCellHeight             127

@interface HomeASProductCardItem : MyBBTableViewItem


@property (nonatomic, strong) HomeProductListModel                   *model;

@property (copy, readwrite, nonatomic) void (^onViewClickHandler)(id item,NSInteger actionType);

+(HomeASProductCardItem *)itemWithModel:(HomeProductListModel *)model
                           clickHandler:(void(^)(HomeASProductCardItem *item,NSInteger actionType))clickHandler
                       selectionHandler:(void(^)(HomeASProductCardItem *item))selectionHandler;



@end
