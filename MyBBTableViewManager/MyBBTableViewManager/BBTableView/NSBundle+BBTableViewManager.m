//
//  NSBundle+BBTableViewManager.m
//  MyBBTableViewManager
//
//  Created by Gary on 2018/5/3.
//  Copyright © 2018 Gary. All rights reserved.
//

#import "NSBundle+BBTableViewManager.h"
#import "BBTableViewManager.h"

@implementation NSBundle (BBTableViewManager)

+ (instancetype)BBTableViewManagerBundle {
    static NSBundle *bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSBundle *containingBundle = [NSBundle bundleForClass:[BBTableViewManager class]];
        NSURL *bundleURL = [containingBundle URLForResource:@"BBTableViewManager" withExtension:@"bundle"];
        if (bundleURL) {
            bundle = [NSBundle bundleWithURL:bundleURL];
        }
    });
    
    return bundle;
}

@end
