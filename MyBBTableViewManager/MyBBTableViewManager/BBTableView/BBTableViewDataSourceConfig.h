//
//  BBTableViewDataSourceConfig.h
//  MyBBTableViewManager
//
//  Created by Gary on 2018/5/4.
//  Copyright © 2018 Gary. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BBTableViewLogDebug(frmt, ...)\
if ([BBTableViewDataSourceConfig isLogEnable]) {\
NSLog(@"[TTSCollectionViewDataSource Debug]: %@", [NSString stringWithFormat:(frmt), ##__VA_ARGS__]);\
}

static BOOL isEnableBB = YES;


static NSInteger kBBPageSize = 20;

extern NSString *const kBBTableViewDataSourceClassKey;
extern NSString *const kBBTableViewUrlKey;
extern NSString *const kBBTableViewDataManagerClassKey;

@interface BBTableViewDataSourceConfig : NSObject


+ (void)enableLog;

+ (void)disableLog;

+ (BOOL)isLogEnable;

+ (void)setPageSize:(NSInteger)size;

+ (NSInteger)pageSize;

+ (BBTableViewDataSourceConfig *)sharedInstance;

- (void)mapWithMappingInfo:(NSDictionary *)mapInfo;


- (Class)dataSourceByListType:(NSInteger)listType;

- (NSString*)urlByListType:(NSInteger)listType;

- (Class)dataManagerByListType:(NSInteger)listType;

@end
