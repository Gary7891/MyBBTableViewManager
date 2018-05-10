//
//  HomeProductListModel.h
//  TTLoveCar
//
//  Created by Gary on 13/05/2017.
//  Copyright © 2017 王洋. All rights reserved.
//


#import <JSONModel/JSONModel.h>

@interface HomeProductListModel : JSONModel

@property (nonatomic, strong) NSString                 *id;


/**
 IM号	string
 */
@property (nonatomic, strong) NSString                 *im;

/**
 库存
 */
@property (nonatomic, strong) NSString                 *inventory;

/**
 是否活动
 */
@property (nonatomic, assign) BOOL                     isAct;

/**
 是否登录
 */
@property (nonatomic, assign) BOOL                     isLogin;

/**
 是否vip
 */
@property (nonatomic, assign) BOOL                     isVip;

@property (nonatomic, strong) NSString                 *memo;

/**
 产品名称
 */
@property (nonatomic, strong) NSString                 *name;

/**
 	产品名称拼音简写
 */
@property (nonatomic, strong) NSString                 *namespell;

/**
 主图地址
 */
@property (nonatomic, strong) NSString                 *path;

/**
 价格（活动价）
 */
@property (nonatomic, strong) NSString                 *price;

/**
 登录价
 */
@property (nonatomic, strong) NSString                 *priceM;

/**
 详见接口相关说明-商品列表价格显示逻辑
 */
@property (nonatomic, strong) NSString                 *priceShowType;

@property (nonatomic, strong) NSString                 *priceShowTypeNew;

/**
 会员价
 */
@property (nonatomic, strong) NSString                 *priceV;

/**
 分享url
 */
@property (nonatomic, strong) NSString                 *shareUrl;

/**
 	店铺id
 */
@property (nonatomic, strong) NSString                 *storeId;

/**
 店铺名称
 */
@property (nonatomic, strong) NSString                 *storeName;


/**
 暂未用到
 */
@property (nonatomic, strong) NSString                 *priceType;

/**
 浏览量
 */
@property (nonatomic, strong) NSString                 *viewCount;

@property (nonatomic, strong) NSString                 *goodsName;

@property (nonatomic, strong) NSString                 *goodsId;

/**
 是否新品
 */
@property (nonatomic, assign) BOOL                            isGoodsNew;

/**
 是否代运营，1.代运营  0.普通
 */
@property (nonatomic, assign) NSInteger                       storeType;

/**
 1.批发价 2.活动价 3.vip1 4.vip2  5.vip3 6.未登录  7.未审核
 */
@property (nonatomic, assign) NSInteger                       pType;

/**
 价格
 */
@property (nonatomic, strong) NSString                        *pValue;

/**
 遮罩层的图片Url
 */
@property (nonatomic, strong) NSString                        *coverPic;


/**
 底部标签
 */
@property (nonatomic, strong) NSArray                         *goodsTagsBottom;

/**
 顶部标签
 */
@property (nonatomic, strong) NSArray                         *goodsTagsTop;



@end
