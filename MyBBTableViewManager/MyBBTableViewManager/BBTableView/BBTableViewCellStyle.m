//
//  BBTableViewCellStyle.m
//  MyBBTableViewManager
//
//  Created by Gary on 2018/5/3.
//  Copyright © 2018 Gary. All rights reserved.
//

#import "BBTableViewCellStyle.h"
#import "BBTableViewManager.h"

@implementation BBTableViewCellStyle

- (id)init
{
    self = [super init];
    if (!self)
        return nil;
    
    self.backgroundImages = [[NSMutableDictionary alloc] init];
    self.selectedBackgroundImages = [[NSMutableDictionary alloc] init];
    self.cellHeight = 44.0;
    self.defaultCellSelectionStyle = UITableViewCellSelectionStyleBlue;
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    BBTableViewCellStyle *style = [[self class] allocWithZone:zone];
    if (style) {
        style.backgroundImages = [NSMutableDictionary dictionaryWithDictionary:[self.backgroundImages copyWithZone:zone]];
        style.selectedBackgroundImages = [NSMutableDictionary dictionaryWithDictionary:[self.selectedBackgroundImages copyWithZone:zone]];
        style.cellHeight = self.cellHeight;
        style.defaultCellSelectionStyle = self.defaultCellSelectionStyle;
        style.backgroundImageMargin = self.backgroundImageMargin;
        style.contentViewMargin = self.contentViewMargin;
    }
    return style;
}

- (BOOL)hasCustomBackgroundImage
{
    return [self backgroundImageForCellType:BBTableViewCellTypeAny] || [self backgroundImageForCellType:BBTableViewCellTypeFirst] || [self backgroundImageForCellType:BBTableViewCellTypeMiddle] || [self backgroundImageForCellType:BBTableViewCellTypeLast] || [self backgroundImageForCellType:BBTableViewCellTypeSingle];
}

- (UIImage *)backgroundImageForCellType:(BBTableViewCellType)cellType
{
    UIImage *image = self.backgroundImages[@(cellType)];
    if (!image && cellType != BBTableViewCellTypeAny)
        image = self.backgroundImages[@(BBTableViewCellTypeAny)];
    return image;
}

- (void)setBackgroundImage:(UIImage *)image forCellType:(BBTableViewCellType)cellType
{
    if (image)
        [self.backgroundImages setObject:image forKey:@(cellType)];
}

- (BOOL)hasCustomSelectedBackgroundImage
{
    return [self selectedBackgroundImageForCellType:BBTableViewCellTypeAny] ||[self selectedBackgroundImageForCellType:BBTableViewCellTypeFirst] || [self selectedBackgroundImageForCellType:BBTableViewCellTypeMiddle] || [self selectedBackgroundImageForCellType:BBTableViewCellTypeLast] || [self selectedBackgroundImageForCellType:BBTableViewCellTypeSingle];
}

- (UIImage *)selectedBackgroundImageForCellType:(BBTableViewCellType)cellType
{
    UIImage *image = self.selectedBackgroundImages[@(cellType)];
    if (!image && cellType != BBTableViewCellTypeAny)
        image = self.selectedBackgroundImages[@(BBTableViewCellTypeAny)];
    return image;
}

- (void)setSelectedBackgroundImage:(UIImage *)image forCellType:(BBTableViewCellType)cellType
{
    if (image)
        [self.selectedBackgroundImages setObject:image forKey:@(cellType)];
}

@end
