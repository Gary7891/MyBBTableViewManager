//
//  UIImageView+TTSWebImage.m
//  iOS_Store_V2
//
//  Created by 李正兵 on 2017/5/11.
//  Copyright © 2017年 czy. All rights reserved.
//

#import "UIImageView+TTSWebImage.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation NSString (TTSWebImage)
- (NSString *)tts_webImagePath {
    NSString *imgStr;
    if ([self hasPrefix:@"http"]) {
        imgStr = self;
    }else {
        imgStr = [NSString stringWithFormat:@"%@%@",TT_Global_Photo_Domain,self];
    }
    return imgStr;
}
- (NSString *)tts_webImagePathWithSize:(CGSize)size {
    NSString *url = [self tts_webImagePath];
    if (url && !CGSizeEqualToSize(size, CGSizeZero)) {
        url = [NSString stringWithFormat:@"%@?x-oss-process=image/resize,m_lfit,h_%@,w_%@",url,@(ceil(size.width * [UIScreen mainScreen].scale)),@(ceil(size.height * [UIScreen mainScreen].scale))];
    }
    return url;
}

- (NSString *)tts_webImagePathWithWidth:(CGFloat )width {
    NSString *url = [self tts_webImagePath];
    if (url) {
        url = [NSString stringWithFormat:@"%@?x-oss-process=image/resize,w_%@",url,@(ceil(width * [UIScreen mainScreen].scale))];
    }
    return url;
}

- (NSString *)tts_webImagePathWithHeight:(CGFloat )height {
    NSString *url = [self tts_webImagePath];
    if (url) {
        url = [NSString stringWithFormat:@"%@?x-oss-process=image/resize,h_%@",url,@(ceil(height * [UIScreen mainScreen].scale))];
    }
    return url;
}

- (NSString *)tts_webpImagePath {
    NSString *url = [self tts_webImagePath];
    if (url) {
         url = [NSString stringWithFormat:@"%@?x-oss-process=image/format,webp",url];
    }
    return url;
}
@end

@implementation UIImageView (TTSWebImage)
- (void)tts_setImageWithURL:(NSString *)url {
    [self tts_setImageWithURL:url placeholder:nil options:0 progress:nil completed:nil];
    
}

- (void)tts_setImageWithURL:(NSString *)url
                placeholder:(NSString *)placeholder{
    [self tts_setImageWithURL:url placeholder:placeholder options:0 progress:nil completed:nil];
}

//- (void)tts_setImageWithURL:(NSString *)url
//                placeholder:(NSString *)placeholder
//                  completed:(SDExternalCompletionBlock)completedBlock{
//    [self tts_setImageWithURL:url placeholder:nil options:0 progress:nil completed:completedBlock];
//}
//
//- (void)tts_setImageWithURL:(NSString *)url
//                placeholder:(NSString *)placeholder
//                    options:(SDWebImageOptions)options
//                  completed:(SDExternalCompletionBlock)completedBlock{
//    [self tts_setImageWithURL:url placeholder:placeholder options:options progress:nil completed:completedBlock];
//}
//
- (void)tts_setImageWithURL:(NSString *)url
                placeholder:(NSString *)placeholder
                    options:(SDWebImageOptions)options
                   progress:(SDWebImageDownloaderProgressBlock)progressBlock
                  completed:(SDExternalCompletionBlock)completedBlock{
    NSString *imgStr;
    if ([url hasPrefix:@"http"]) {
        imgStr = url;
    }else {
        imgStr = [NSString stringWithFormat:@"%@%@",TT_Global_Photo_Domain,url];
    }

    NSURL *imgUrl = [NSURL URLWithString:imgStr];
    UIImage *placeImg;
    if (placeholder.length) {
        placeImg = [UIImage imageNamed:placeholder];
    }else {
        placeImg = nil;
    }

    [self sd_setImageWithURL:imgUrl
            placeholderImage:placeImg
                     options:options
                    progress:progressBlock
                   completed:completedBlock];
}
@end
