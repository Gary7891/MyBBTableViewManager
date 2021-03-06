//
//  CommentsNode.m
//  MYTableViewManager
//
//  Created by Melvin on 12/16/15.
//  Copyright © 2015 Melvin. All rights reserved.
//

#import "CommentsNode.h"
#import "TextStyles.h"

@implementation CommentsNode
- (instancetype)initWithCommentsCount:(NSInteger)comentsCount {
    
    self = [super init];
    
    if(self) {
        
        _comentsCount = comentsCount;
        
        _iconNode = [[ASImageNode alloc] init];
        _iconNode.image = [UIImage imageNamed:@"TimeLineComment.png"];
        [self addSubnode:_iconNode];
        
        _countNode = [[ASTextNode alloc] init];
        if(_comentsCount > 0) {
            
            _countNode.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", (long)_comentsCount] attributes:[TextStyles cellControlStyle]];
            
        }
        
        [self addSubnode:_countNode];
        
        // make it tappable easily
        self.hitTestSlop = UIEdgeInsetsMake(-10, -10, -10, -10);
        
    }
    
    return self;
    
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    ASStackLayoutSpec *mainStack =  [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:6.0 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter children:@[_iconNode, _countNode]];
    
    // set sizeRange to make width fixed to 60
//    mainStack.sizeRange = ASRelativeSizeRangeMake(ASRelativeSizeMake(
//                                                                     ASRelativeDimensionMakeWithPoints(60.0),
//                                                                     ASRelativeDimensionMakeWithPoints(0.0)
//                                                                     ), ASRelativeSizeMake(
//                                                                                           ASRelativeDimensionMakeWithPoints(60.0),
//                                                                                           ASRelativeDimensionMakeWithPoints(40.0)
//                                                                                           ));
    mainStack.style.width = ASDimensionMake(0.6);
    mainStack.style.height = ASDimensionMake(0.4);
    return mainStack;
//    return [ASStaticLayoutSpec staticLayoutSpecWithChildren:@[mainStack]];
    
}
@end
