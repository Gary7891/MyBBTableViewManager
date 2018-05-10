//
//  BBTableViewDataSourceConfig.m
//  MyBBTableViewManager
//
//  Created by Gary on 2018/5/4.
//  Copyright © 2018 Gary. All rights reserved.
//

#import "BBTableViewDataSourceConfig.h"

NSString *const kBBTableViewDataSourceClassKey = @"kBBTableViewDataSourceClassKey";
NSString *const kBBTableViewDataManagerClassKey = @"kBBTableViewDataManagerClassKey";
NSString *const kBBTableViewUrlKey = @"kBBTableViewUrlKey";

@interface BBTableViewDataSourceConfig ()

@property (nonatomic ,strong) NSMutableDictionary *mappingInfo;

@end

@implementation BBTableViewDataSourceConfig

+ (void)enableLog {
    isEnableBB = YES;
}

+ (void)disableLog {
    isEnableBB = NO;
}

+ (BOOL)isLogEnable {
    return isEnableBB;
}


+ (void)setPageSize:(NSInteger)size {
    kBBPageSize = size;
}

+ (NSInteger)pageSize {
    return kBBPageSize;
}

+ (BBTableViewDataSourceConfig *)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _mappingInfo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)mapWithMappingInfo:(NSDictionary *)mapInfo {
    [_mappingInfo setValuesForKeysWithDictionary:mapInfo];
}


- (Class)dataManagerByListType:(NSInteger)listType {
    NSDictionary *entry = [_mappingInfo objectForKey:[NSNumber numberWithInteger:listType]];
    if (!entry) {
        entry = [_mappingInfo objectForKey:[NSNumber numberWithInteger:0]];
    }
    NSString *dataMnagerClassName = [entry objectForKey:kBBTableViewDataManagerClassKey];
    if (!dataMnagerClassName) {
        dataMnagerClassName = @"BBTableViewDataManager";
    }
    return NSClassFromString(dataMnagerClassName) ;
}


- (NSString*)urlByListType:(NSInteger)listType {
    NSDictionary *entry = [_mappingInfo objectForKey:[NSNumber numberWithInteger:listType]];
    if (!entry) {
        entry = [_mappingInfo objectForKey:[NSNumber numberWithInteger:0]];
    }
    NSString *url = [entry objectForKey:kBBTableViewUrlKey];
    if (!url) {
        url = @"/defaulturl";
    }
    return url;
}

- (Class)dataSourceByListType:(NSInteger)listType {
    NSDictionary *entry = [_mappingInfo objectForKey:[NSNumber numberWithInteger:listType]];
    if (!entry) {
        entry = [_mappingInfo objectForKey:[NSNumber numberWithInteger:0]];
    }
    NSString *dataSourceClassName =[entry objectForKey:kBBTableViewDataSourceClassKey];
    if (!dataSourceClassName) {
        dataSourceClassName = @"BBTableViewDataSource";
    }
    return NSClassFromString(dataSourceClassName);
}


@end
