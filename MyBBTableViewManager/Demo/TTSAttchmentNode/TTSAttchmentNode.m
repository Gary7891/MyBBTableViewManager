//
//  TTSAttchmentNode.m
//  TTLoveCar
//
//  Created by Gary on 22/01/2018.
//  Copyright © 2018 王洋. All rights reserved.
//

#import "TTSAttchmentNode.h"
#import <SDWebImageManager.h>

@interface TTSAttchmentNode ()

@property (nonatomic, strong) NSMutableDictionary       *dictAttachments;

@property (nonatomic, strong) NSArray                   *arrPaths;

@property (nonatomic, strong) NSLock                    *mitLock;

@property (nonatomic, copy) NSString                    *mitText;

@property (nonatomic, strong) NSDictionary              *mitTextAttrDic;

@property (nonatomic, strong) UIFont                    *font;

@end

@implementation TTSAttchmentNode

- (void)setImages:(NSArray<NSString *> *)paths text:(NSString *)text textAttrDic:(NSDictionary *)attrDic {
    self.mitText = [text copy];
    self.mitTextAttrDic = attrDic;
    self.font = [attrDic objectForKey:NSFontAttributeName];
    if (!_font) {
        _font = [UIFont systemFontOfSize:14];
    }
    [self loadAttachmentsWithPaths:[paths copy]];
}

- (void)loadAttachmentsWithPaths:(NSArray*)paths {
    [self.lock lock];
    [self.dictAttachments removeAllObjects];
    [self.lock unlock];
    if (_arrPaths == paths) {
        return;
    }
    if (!paths.count) {
        self.arrPaths = nil;
        return;
    }
    self.arrPaths = paths;

    __weak __typeof(self) weakSelf = self;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        for (NSString *path in weakSelf.arrPaths) {
            NSURL *url = [NSURL URLWithString:[path tts_webImagePath]];
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager loadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                __strong typeof(weakSelf) sself = weakSelf;
                NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
                attachment.image = image;
                CGSize size = image.size;
                //计算文字padding-top ，使图片垂直居中
                CGFloat textPaddingTop = (sself.font.lineHeight - sself.font.pointSize) / 2;
                //图片与文字同高
                CGFloat imgH = sself.font.pointSize;
                if (size.width != 0 && size.height != 0) {
                    //计算图片大小，与文字同高，按比例设置宽度
                    CGFloat imgW = (size.width / size.height) * imgH;
                    attachment.bounds = CGRectMake(0, - textPaddingTop , imgW, imgH);
                }else {
                    attachment.bounds = CGRectMake(0, - textPaddingTop, 30, sself.font.pointSize);
                }
                
                NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
                [sself.lock lock];
                
                [sself.dictAttachments setValue:attachmentString forKey:[path copy]];
                [sself.lock unlock];
                if (sself.dictAttachments.count != 0 && sself.dictAttachments.count == sself.arrPaths.count) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
                        [sself refreshUI];
//                    });
                }
            }];
        }
        
    });
}

- (void)refreshUI {
    NSMutableAttributedString *myString = [[NSMutableAttributedString alloc] initWithString:@""];
    for (NSString *path in self.arrPaths) { //保证图片顺序
        NSAttributedString *atch = self.dictAttachments[path];
        if (atch && [atch isKindOfClass:[NSAttributedString class]]) {
            [myString appendAttributedString:atch];
        }
    }
    NSAttributedString *myText = nil;
    if (self.mitTextAttrDic) {
        myText = [[NSMutableAttributedString alloc] initWithString:self.mitText?:@""
                                                                            attributes:self.mitTextAttrDic];
    }else {
        myText = [[NSMutableAttributedString alloc] initWithString:self.mitText?:@""];
    }
    
    [myString appendAttributedString:myText];
    self.attributedText = myString;
}
#pragma mark - getter
- (NSLock *)lock {
    if (!_mitLock) {
        _mitLock = [[NSLock alloc] init];
    }
    return _mitLock;
}

- (NSMutableDictionary *)dictAttachments {
    if (!_dictAttachments) {
        _dictAttachments = [[NSMutableDictionary alloc] init];
    }
    return _dictAttachments;
}

@end
