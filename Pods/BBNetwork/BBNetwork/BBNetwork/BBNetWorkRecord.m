//
//  BBNetWorkRecord.m
//  BBNetwork
//
//  Created by Gary on 31/07/2017.
//  Copyright © 2017 Gary. All rights reserved.
//

#import "BBNetWorkRecord.h"

typedef void (^BBNetRun)(void);

@interface NSDictionary (BB)

- (BOOL)containsObjectForKey:(id)key;

@end

@implementation NSDictionary (BB)

- (BOOL)containsObjectForKey:(id)key {
    if (!key) return NO;
    return self[key] != nil;
}

@end

@interface BBNetWorkRecord ()

@property (nonatomic, assign) BOOL           record;

@end

@implementation BBNetWorkRecord

+(instancetype)sharedReord {
    static BBNetWorkRecord* helper = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (!helper) {
            helper = [[self alloc] init];
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
            helper.interfaceDic = dictionary;
        }
    });
    return helper;
}

- (void)redirectNSlogToDocumentFolder:(BBNetRun)run
{
    if (!_record) {
        return;
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"record.csv"];// 注意不是NSData!
    NSString *logFilePath = [documentDirectory stringByAppendingPathComponent:fileName];
    NSString *otherFilePath = [documentDirectory stringByAppendingPathComponent:@"other.csv"];
    // 先删除已经存在的文件
    //    NSFileManager *defaultManager = [NSFileManager defaultManager];
    //    [defaultManager removeItemAtPath:logFilePath error:nil];
    
    // 将log输入到文件
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    run();
    freopen([otherFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    
    //    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
}

- (void)printRequestStart:(NSString*)url header:(NSDictionary*)header params:(NSDictionary*)params mark:(NSString*)mark {
    __weak __typeof(self) weakSelf = self;
    [self redirectNSlogToDocumentFolder:^{
        NSMutableString *headerStr = [[NSMutableString alloc]init];
        for (NSString *key in header) {
            [headerStr appendString:key];
            [headerStr appendString:@":"];
            if ([header objectForKey:key]) {
                [headerStr appendString:[NSString stringWithFormat:@"%@",[header objectForKey:key]]];
            }else {
                [headerStr appendString:@"null"];
            }
            
            [headerStr appendString:@" "];
        }
        NSMutableString *paramsStr = [[NSMutableString alloc]init];
        for (NSString *key in params) {
            [paramsStr appendString:key];
            [paramsStr appendString:@":"];
            if ([params objectForKey:key]) {
                [paramsStr appendString:[NSString stringWithFormat:@"%@",[params objectForKey:key]]];
            }else {
                [paramsStr appendString:@"null"];
            }
            [paramsStr appendString:@" "];
        }
        NSString *string = [NSString stringWithFormat:@"%@,%@,%@,%lf",url,headerStr,paramsStr,[[NSDate date] timeIntervalSince1970]];
        if (![weakSelf.interfaceDic containsObjectForKey:url]) {
            [weakSelf.interfaceDic setObject:string forKey:url];
        }
        
    }];
    
}
- (void)printRequestEnd:(id)response url:(NSString*)url mark:(NSString*)mark{
    __weak __typeof(self) weakSelf = self;
    [self redirectNSlogToDocumentFolder:^{
        
        if ([self.interfaceDic containsObjectForKey:url]) {
            
            NSData *jsonData = nil;
            if ([response isKindOfClass:[NSString class]]){
                jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
            }else if ([response isKindOfClass:[NSData class]]){
                jsonData = response;
            }else if([response isKindOfClass:[NSDictionary class]]){
                jsonData = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:nil];
            }
            
            //            NSString *key = [self.interfaceDic objectForKey:url];
            printf("%s,%ld,%lf,%s,end\n",[[self.interfaceDic objectForKey:url] UTF8String],(long)(jsonData.length),[[NSDate date] timeIntervalSince1970],[mark UTF8String]);
            [weakSelf.interfaceDic removeObjectForKey:url];
            
        }
        
        
    }];
    
}

- (void)printfRequestFaild:(NSString*)url mark:(NSString*)mark {
    __weak __typeof(self) weakSelf = self;
    [self redirectNSlogToDocumentFolder:^{
        if ([self.interfaceDic containsObjectForKey:url]) {
            printf("%s,%lf,%s,faild\n",[[self.interfaceDic objectForKey:url] UTF8String],[[NSDate date] timeIntervalSince1970],[mark UTF8String]);
            [weakSelf.interfaceDic removeObjectForKey:url];
        }
        
        
    }];
    
}

- (void)setRecordFlag:(BOOL)flag {
    _record = flag;
}

@end
