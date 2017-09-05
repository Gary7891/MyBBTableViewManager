//
//  MyBBTableViewCell.m
//  MyBBTableView
//
//  Created by Gary on 4/22/16.
//  Copyright © 2016 Gary. All rights reserved.
//

#import "MyBBTableViewCell.h"

#import "MyBBTableViewItem.h"

@interface MyBBTableViewCell()

@property (nonatomic ,strong) ASDisplayNode *dividerNode;

@end

@implementation MyBBTableViewCell


- (instancetype)initWithTableViewItem:(MyBBTableViewItem *)tableViewItem {
    self = [super init];
    if(self) {
        self.tableViewItem = tableViewItem;
        
        // hairline cell separator
        if (self.tableViewItem.separatorStyle != UITableViewCellSeparatorStyleNone) {
            _dividerNode = [[ASDisplayNode alloc] init];
            _dividerNode.backgroundColor = self.tableViewItem.dividerColor;
            [self addSubnode:_dividerNode];
        }
        [self initCell];
    }
    return self;
}

- (void)initCell {
    
}

- (void)didLoad {
    // enable highlighting now that self.layer has loaded -- see ASHighlightOverlayLayer.h
    self.layer.as_allowsHighlightDrawing = YES;
    [super didLoad];
}

//- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
//    return nil;
//}

- (void)layout {
    [super layout];
    CGFloat pixelHeight = 1.0f / [[UIScreen mainScreen] scale];
    _dividerNode.frame = CGRectMake(0.0f, 0.0f, self.calculatedSize.width, pixelHeight);
}

@end
