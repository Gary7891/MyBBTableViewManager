//
//  TimeLineTableViewItem.h
//  MYTableViewManager
//
//  Created by Melvin on 12/16/15.
//  Copyright © 2015 Melvin. All rights reserved.
//

#import "MyBBTableViewItem.h"

@interface TimeLineTableViewItem : MyBBTableViewItem

@property (nonatomic, strong) NSDictionary  *data;

@property (nonatomic, assign) NSInteger     index;

@property (nonatomic, assign) CGFloat       contentHeight;

@property (nonatomic, assign) CGFloat       contentImageHeight;

+ (TimeLineTableViewItem*)itemWithModel:(NSDictionary*)data;


@end
