//
//  Utility.m
//  MyBBTableViewManager
//
//  Created by Gary on 2018/5/9.
//  Copyright © 2018 Gary. All rights reserved.
//

#import "Utility.h"
#import <AdSupport/AdSupport.h>

@implementation Utility

+ (instancetype)sharedUtility
{
    static Utility* utility = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (!utility) {
            utility = [[self alloc] init];
        }
    });
    return utility;
}

- (NSString*)imageResize:(NSString*)preurl
                imageUrl:(NSString*)endUrl
                   width:(CGFloat)width
                  height:(CGFloat)height {
    NSInteger width_int = round(width * [UIScreen mainScreen].scale );
    NSInteger height_int = round(height * [UIScreen mainScreen].scale);
    return [NSString stringWithFormat:@"%@%@?x-oss-process=image/resize,w_%@,h_%@",preurl,endUrl,@(width_int),@(height_int)];
}

+ (NSString*)getUniqueDeviceID {
    NSString *deviceID = nil;
    
    //IDFA 广告唯一标识符
    NSString *IDFA_NEW = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
    IDFA_NEW = [IDFA_NEW stringByReplacingOccurrencesOfString:@"-" withString:@""];
    IDFA_NEW = [IDFA_NEW lowercaseString];
    
    
    if (IDFA_NEW && ![IDFA_NEW isEqualToString:@""]) {
        deviceID = [IDFA_NEW copy];
    }else{
        deviceID = @"NULL";
    }
    
    NSRange range = {[deviceID length]-12, 12};
    NSString *udid = [deviceID substringWithRange:range];
    udid = [NSString stringWithFormat:@"%@I",udid];
    deviceID = udid;
    
    return deviceID;
}

@end
