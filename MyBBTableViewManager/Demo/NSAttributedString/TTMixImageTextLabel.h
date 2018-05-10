//
//  TTMixImageTextLabel.h
//  TTLoveCar
//
//  Created by 李正兵 on 2018/1/18.
//  Copyright © 2018年 王洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTMixImageTextLabel : UILabel

/**
 设置图文混排，图片来自网络,建议设置label的font之后再调用

 @param paths 图片路径
 @param text 后面跟随文字
 @param height 图片高度，自行调节，没有默认值
 @param atchTop 距离顶部距离
 */
- (void)setImages:(NSArray<NSString *> *)paths text:(NSString *)text;

@end
