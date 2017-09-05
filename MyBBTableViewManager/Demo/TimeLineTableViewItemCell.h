//
//  TimeLineTableViewItemCell.h
//  MYTableViewManager
//
//  Created by Melvin on 12/16/15.
//  Copyright © 2015 Melvin. All rights reserved.
//

#import "MyBBTableViewCell.h"
#import "TimeLineTableViewItem.h"

@interface TimeLineTableViewItemCell : MyBBTableViewCell

@property (strong, readwrite, nonatomic) TimeLineTableViewItem *tableViewItem;

@end
