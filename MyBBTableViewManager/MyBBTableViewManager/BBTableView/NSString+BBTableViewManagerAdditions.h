//
//  NSString+BBTableViewManagerAdditions.h
//  MyBBTableViewManager
//
//  Created by Gary on 2018/5/3.
//  Copyright © 2018 Gary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (BBTableViewManagerAdditions)

- (CGSize)re_sizeWithFont:(UIFont *)font;
- (CGSize)re_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

@end
