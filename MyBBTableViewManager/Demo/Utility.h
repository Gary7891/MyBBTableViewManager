//
//  Utility.h
//  MyBBTableViewManager
//
//  Created by Gary on 2018/5/9.
//  Copyright © 2018 Gary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

+ (instancetype)sharedUtility;

/**
 图片压缩
 
 @param preurl
 @param endUrl
 @param width
 @param height
 @return
 */
- (NSString*)imageResize:(NSString*)preurl
                imageUrl:(NSString*)endUrl
                   width:(CGFloat)width
                  height:(CGFloat)height;



/**
 获取deviceId,广告Id
 
 @return
 */
+ (NSString*)getUniqueDeviceID;

@end
