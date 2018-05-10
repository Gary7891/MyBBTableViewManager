//
//  BBNetWorkRecord.h
//  BBNetwork
//
//  Created by Gary on 31/07/2017.
//  Copyright © 2017 Gary. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface BBNetWorkRecord : NSObject

+(instancetype)sharedReord;


/**
 请求开始的时候使用这个方法打印一些信息

 @param url 请求的url
 @param header 请求头的字典
 @param params 请求参数字典
 @param mark 备注信息
 */
- (void)printRequestStart:(NSString*)url header:(NSDictionary*)header params:(NSDictionary*)params mark:(NSString*)mark;

/**
 请求正常返回时使用这个方法打印

 @param response 返回的数据
 @param url 请求url
 @param mark 备注信息，这里可以传GET或者POST等信息
 */
- (void)printRequestEnd:(id)response url:(NSString*)url mark:(NSString*)mark;

/**
 请求返回失败时使用这个方法

 @param url 请求url
 @param mark 备注信息
 */
- (void)printfRequestFaild:(NSString*)url mark:(NSString*)mark;

- (void)setRecordFlag:(BOOL)flag;

@property (nonatomic, strong) NSMutableDictionary                    *interfaceDic;

@end
