//
//  TTMixImageTextLabel.m
//  TTLoveCar
//
//  Created by 李正兵 on 2018/1/18.
//  Copyright © 2018年 王洋. All rights reserved.
//

#import "TTMixImageTextLabel.h"
#import <SDWebImageManager.h>

@interface TTMixImageTextLabel()

@property (nonatomic, strong)NSMutableDictionary *dictAttachments;

@property (nonatomic, strong)NSArray * arrPaths;

@property (nonatomic, strong)NSLock *mit_lock;

@property (nonatomic, copy)NSString *mit_text;

@property (nonatomic, copy)NSString * atcIdentifier;
@end

@implementation TTMixImageTextLabel

- (void)setImages:(NSArray<NSString *> *)paths text:(NSString *)text {
    self.text = text;
    self.mit_text = [text copy];
    [self loadAttachmentsWithPaths:[paths copy]];
    
}
- (void)loadAttachmentsWithPaths:(NSArray *)paths {
//    identifier
    if (_arrPaths == paths) {
        if (self.dictAttachments.count == _arrPaths.count) {
            [self refreshUI];
        }
        return;
    }
    [self.mit_lock lock];
    [self.dictAttachments removeAllObjects];
    [self.mit_lock unlock];
    if (!paths.count) {
        self.arrPaths = nil;
        return;
    }
    [self.mit_lock lock];
    self.arrPaths = paths;
    [self.mit_lock unlock];
    __weak __typeof(self) weakSelf = self;
    CGFloat pointSize = self.font.pointSize;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        for (NSString *path in weakSelf.arrPaths) {
            NSURL *url = [NSURL URLWithString:[path tts_webImagePathWithHeight:pointSize * 2]];
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager loadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                __strong typeof(weakSelf) sself = weakSelf;
                NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
                attachment.image = image;
                CGSize size = image.size;
                //计算文字padding-top ，使图片垂直居中
                CGFloat textPaddingTop = (sself.font.lineHeight - pointSize) / 2;
                //图片与文字同高
                CGFloat imgH = pointSize;
                if (size.width != 0 && size.height != 0) {
                    //计算图片大小，与文字同高，按比例设置宽度
                    CGFloat imgW = (size.width / size.height) * imgH;
                    attachment.bounds = CGRectMake(0, - textPaddingTop , imgW, imgH);
                }else {
                    attachment.bounds = CGRectMake(0, - textPaddingTop, 30, pointSize);
                }
                
                NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
                [sself.lock lock];
                [sself.dictAttachments setValue:attachmentString forKey:path];
                [sself.lock unlock];
                if (sself.dictAttachments.count != 0 && sself.dictAttachments.count == sself.arrPaths.count) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [sself refreshUI];
                    });
                }
            }];
        }
        
    });
}
- (void)refreshUI {
    NSMutableAttributedString *myString = [[NSMutableAttributedString alloc] initWithString:@""];
    for (NSString *path in self.arrPaths) {
        NSAttributedString *attach = self.dictAttachments[path];
        if (attach && [attach isKindOfClass:[NSAttributedString class]]) {
            [myString appendAttributedString:attach];
        }
    }
    NSAttributedString *myText = [[NSMutableAttributedString alloc] initWithString:self.mit_text?:@""];
    [myString appendAttributedString:myText];
    self.attributedText = myString;
}
#pragma mark - getter
- (NSLock *)lock {
    if (!_mit_lock) {
        _mit_lock = [[NSLock alloc] init];
    }
    return _mit_lock;
}

- (NSMutableDictionary *)dictAttachments {
    if (!_dictAttachments) {
        _dictAttachments = [[NSMutableDictionary alloc] init];
    }
    return _dictAttachments;
}
@end
