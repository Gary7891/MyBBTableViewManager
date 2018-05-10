//
//  BBTableViewCellStyle.h
//  MyBBTableViewManager
//
//  Created by Gary on 2018/5/3.
//  Copyright © 2018 Gary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBTableViewItemCell.h"

@interface BBTableViewCellStyle : NSObject <NSCopying>

@property (assign, readwrite, nonatomic) CGFloat cellHeight;
@property (assign, readwrite, nonatomic) UITableViewCellSelectionStyle defaultCellSelectionStyle;
@property (assign, readwrite, nonatomic) CGFloat backgroundImageMargin;
@property (assign, readwrite, nonatomic) CGFloat contentViewMargin;
@property (strong, readwrite, nonatomic) NSMutableDictionary *backgroundImages;
@property (strong, readwrite, nonatomic) NSMutableDictionary *selectedBackgroundImages;

- (BOOL)hasCustomBackgroundImage;
- (UIImage *)backgroundImageForCellType:(BBTableViewCellType)cellType;
- (void)setBackgroundImage:(UIImage *)image forCellType:(BBTableViewCellType)cellType;

- (BOOL)hasCustomSelectedBackgroundImage;
- (UIImage *)selectedBackgroundImageForCellType:(BBTableViewCellType)cellType;
- (void)setSelectedBackgroundImage:(UIImage *)image forCellType:(BBTableViewCellType)cellType;

@end
