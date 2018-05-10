//
//  MyBBClassList.h
//  MyBBTableViewManager
//
//  Created by Gary on 2018/5/4.
//  Copyright © 2018 Gary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyBBClassList : NSObject

+ (NSArray*)subclassesOfClass:(Class)parentClass;

@end
