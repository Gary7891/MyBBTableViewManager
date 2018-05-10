//
//  BBTableViewRequest.h
//  MyBBTableViewManager
//
//  Created by Gary on 2018/5/7.
//  Copyright © 2018 Gary. All rights reserved.
//

#import <BBNetwork/BBNetwork.h>

@interface BBTableViewRequest : BBRequest

@property (nonatomic ,copy) NSString *requestURL;
@property (nonatomic ,strong) NSDictionary *requestArgument;
@property (nonatomic ,assign) NSInteger cacheTimeInSeconds;
@property (strong, nonatomic) id sensitiveData;
- (instancetype)initWithRequestURL:(NSString *)url params:(NSDictionary *)params;


- (void)startWithOutCacheSuccess:(BBRequestCompletionBlock)success failure:(BBRequestCompletionBlock)failure;

@end
