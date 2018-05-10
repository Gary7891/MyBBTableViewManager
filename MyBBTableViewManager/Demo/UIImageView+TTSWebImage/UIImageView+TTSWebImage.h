//
//  UIImageView+TTSWebImage.h
//  iOS_Store_V2
//
//  Created by 李正兵 on 2017/5/11.
//  Copyright © 2017年 czy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (TTSWebImage)
- (NSString *)tts_webImagePath;

/**
 等比缩放，限定在矩形框内

 @param size 矩形框大小
 @return 图片url
 */
- (NSString *)tts_webImagePathWithSize:(CGSize )size;

/**
 单边缩略

 @param width  将图缩略成宽度为width，高度按比例处理。
 @return 图片url
 */
- (NSString *)tts_webImagePathWithWidth:(CGFloat )width;

/**
 单边缩略

 @param height 将图缩略成高度为height，宽度按比例处理
 @return 图片url
 */
- (NSString *)tts_webImagePathWithHeight:(CGFloat )height;
//
///**
// 图片格式设置为webp
//
// @return wep图片url
// */
//- (NSString *)tts_webpImagePath;
//
//@end
//
//@interface UIImageView (TTSWebImage)
//
//- (void)tts_setImageWithURL:(NSString *)url;
//
//- (void)tts_setImageWithURL:(NSString *)imageURL
//                placeholder:(NSString *)placeholder;
//
//- (void)tts_setImageWithURL:(NSString *)url
//                placeholder:(NSString *)placeholder
//                  completed:(SDExternalCompletionBlock)completedBlock;
//
//- (void)tts_setImageWithURL:(NSString *)url
//            placeholder:(NSString *)placeholder
//                    options:(SDWebImageOptions)options
//                  completed:(SDExternalCompletionBlock)completedBlock;
//
//- (void)tts_setImageWithURL:(NSString *)url
//                placeholder:(NSString *)placeholder
//                    options:(SDWebImageOptions)options
//                   progress:(SDWebImageDownloaderProgressBlock)progressBlock
//                  completed:(SDExternalCompletionBlock)completedBlock;
@end
