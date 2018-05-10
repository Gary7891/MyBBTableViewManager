//
//  HomeASProductCardItemCell.m
//  TTLoveCar
//
//  Created by Gary on 21/12/2017.
//  Copyright © 2017 王洋. All rights reserved.
//

#import "HomeASProductCardItemCell.h"
#import "TTSAttchmentNode.h"
#import "Utility.h"
#import "NSAttributedString+TSText.h"

#define kImageWidth                90
#define kImageHeight               90

#define kIconWidth                      40
#define kIconHeight                     40


@interface HomeASProductCardItemCell ()

@property (nonatomic, strong) ASNetworkImageNode                    *imageNode;

@property (nonatomic, strong) ASNetworkImageNode                    *coverImageNode;

@property (nonatomic, strong) ASImageNode                           *iconNode;

@property (nonatomic, strong) ASTextNode                            *storeNameNode;

@property (nonatomic, strong) ASTextNode                            *priceNode;

@property (nonatomic, strong) TTSAttchmentNode                      *productNameNode;

@property (nonatomic, strong) TTSAttchmentNode                      *bottomTags; //底部标签

@property (nonatomic, strong) ASTextNode                            *stateAndViewCountNode;

@property (nonatomic, strong) ASTextNode                            *toLoginNode;

@property (nonatomic, strong) ASTextNode                            *unAuditedNode;

@property (nonatomic, strong) ASDisplayNode                         *sellOutNode;

@property (nonatomic, strong) ASImageNode                           *sellOutImageNode;

@property (nonatomic, strong) ASDisplayNode                         *cellBgNode;


@end

@implementation HomeASProductCardItemCell
@dynamic tableViewItem;

- (void)initCell {
    [super initCell];
    
//    self.dividerNode.backgroundColor = HEX_COLOR(0xededed);
    
//    _cellBgNode = [[ASDisplayNode alloc]init];
//    _cellBgNode.backgroundColor = [UIColor whiteColor];
//    _cellBgNode.style.preferredSize = self.item.preferredSize;
//    [self addSubnode:_cellBgNode];

    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubnode:self.imageNode];
    _imageNode.defaultImage = [UIImage imageNamed:@"tupianjiazaibuchu"];
    NSString *imageUrl = [[Utility sharedUtility]imageResize:TT_Global_Photo_Domain
                                                    imageUrl:self.tableViewItem.model.path
                                                       width:kImageWidth
                                                      height:kImageHeight];
    [_imageNode setURL:[NSURL URLWithString:imageUrl]];
    
    if(self.tableViewItem.model.coverPic.length) {
        [self addSubnode:self.coverImageNode];
        _coverImageNode.defaultImage = nil;
        _coverImageNode.backgroundColor = [UIColor clearColor];
        NSString *coverUrl = [[Utility sharedUtility]imageResize:TT_Global_Photo_Domain
                                                        imageUrl:self.tableViewItem.model.coverPic
                                                           width:kImageWidth
                                                          height:kImageHeight];
        [_coverImageNode setURL:[NSURL URLWithString:coverUrl]];
    }
    
    _iconNode = [[ASImageNode alloc] init];
    _iconNode.image = [UIImage imageNamed:@"GoodLabel_new.png"];
    _iconNode.style.preferredSize = CGSizeMake(kIconWidth, kIconHeight);
    [self addSubnode:_iconNode];
    
    
    
    if (self.tableViewItem.model.isGoodsNew) {
        _iconNode.hidden = NO;
    }else {
        _iconNode.hidden = YES;
    }
    
    _storeNameNode = [self getTextNode];
    _storeNameNode.backgroundColor = HEX_COLOR(0xaaaaaa);
    _storeNameNode.textContainerInset = UIEdgeInsetsMake((20 - [UIFont systemFontOfSize:12].lineHeight) / 2, 0, 0, 0);
    if (self.tableViewItem.model.storeName.length) {
        NSAttributedString *storeNameAttr = [[NSAttributedString alloc]initWithString:self.tableViewItem.model.storeName
                                                                           attributes:@{
                                                                                        NSForegroundColorAttributeName :[UIColor whiteColor],
                                                                                        NSFontAttributeName : [UIFont systemFontOfSize:12]
                                                                                        }];
        _storeNameNode.attributedText = storeNameAttr;
    }
    
    [self addSubnode:_storeNameNode];
    
    _productNameNode = [[TTSAttchmentNode alloc]init];
    _productNameNode.maximumNumberOfLines = 2;
    NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc]init];
//    if (self.item.model.storeType) {
//        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
//        attch.image = [UIImage imageNamed:@"gd_daiyunying_tag"];
//        attch.bounds = CGRectMake(0, -2, 34, 13);
//        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
//        [mutableAttr appendAttributedString:string];
//        NSAttributedString *attrSpace = [[NSAttributedString alloc] initWithString:@" "
//                                                                        attributes:@{
//                                                                                     NSForegroundColorAttributeName :[UIColor whiteColor],
//                                                                                     NSFontAttributeName : BBSTYLEVAR(font12),
//                                                                                     }];
//        [mutableAttr appendAttributedString:attrSpace];
//    }
    if (self.tableViewItem.model.name.length) {
        NSAttributedString *productNameAttr = [[NSAttributedString alloc]initWithString:self.tableViewItem.model.name
                                                                             attributes:@{
                                                                                          NSForegroundColorAttributeName :HEX_COLOR(0x666666),
                                                                                          NSFontAttributeName:[UIFont systemFontOfSize:14]
                                                                                          }];
        [mutableAttr appendAttributedString:productNameAttr];
    }
    _productNameNode.attributedText = mutableAttr;
    
    NSMutableArray *topTagArrays = [[NSMutableArray alloc]init];
    for (NSString * string in self.tableViewItem.model.goodsTagsTop) {
        NSString *imageString = [NSString stringWithFormat:@"%@%@",TT_Global_Photo_Domain,string];
        imageString = [imageString tts_webImagePathWithHeight:14];
        [topTagArrays addObject:imageString];
    }
    if (topTagArrays.count) {
        [_productNameNode setImages:topTagArrays text:self.tableViewItem.model.name textAttrDic:@{
                                                                                         NSForegroundColorAttributeName :HEX_COLOR(0x666666),
                                                                                         NSFontAttributeName:[UIFont systemFontOfSize:14]
                                                                                         }];
    }
    
    [self addSubnode:_productNameNode];
    
    _bottomTags = [[TTSAttchmentNode alloc]init];
    NSMutableArray *bottomTagArrays = [[NSMutableArray alloc]init];
    for (NSString * string in self.tableViewItem.model.goodsTagsBottom) {
        NSString *imageString = [NSString stringWithFormat:@"%@%@",TT_Global_Photo_Domain,string];
        imageString = [imageString tts_webImagePathWithHeight:12];
        [bottomTagArrays addObject:imageString];
    }
    if (bottomTagArrays.count) {
        [_bottomTags setImages:bottomTagArrays text:@" " textAttrDic:@{
                                                                       NSForegroundColorAttributeName :HEX_COLOR(0x666666),
                                                                       NSFontAttributeName:[UIFont systemFontOfSize:12]
                                                                       }];
    }
    
    [self addSubnode:_bottomTags];
    
    [self loadPriceAndStateWithNewType];
    
    if (!self.tableViewItem.model.inventory.integerValue) {
        _sellOutNode = [[ASDisplayNode alloc]init];
        _sellOutNode.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        _sellOutNode.style.preferredSize = CGSizeMake(kImageWidth, kImageHeight);
        [self addSubnode:_sellOutNode];
        
        [self addSubnode:self.sellOutImageNode];
        
    }
    
    
}

- (void)didLoad {
    [super didLoad];
}

- (ASLayoutSpec*)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    NSMutableArray *mutableArray = [[NSMutableArray alloc]init];
    [mutableArray addObject:_iconNode];
    if(_coverImageNode) {
        ASBackgroundLayoutSpec *coverBackSpec = [ASBackgroundLayoutSpec backgroundLayoutSpecWithChild:_coverImageNode background:_imageNode];
        [mutableArray addObject:coverBackSpec];
    }else {
        [mutableArray addObject:_imageNode];
    }
    [mutableArray addObject:_storeNameNode];
    ASStackLayoutSpec  *stackSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                            spacing:0
                                                                     justifyContent:ASStackLayoutJustifyContentStart
                                                                         alignItems:ASStackLayoutAlignItemsStart
                                                                           children:mutableArray];
    
    ASStackLayoutSpec *rightStack = nil;
    ASStackLayoutSpec *bottomTagSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                               spacing:10
                                                                        justifyContent:ASStackLayoutJustifyContentStart
                                                                            alignItems:ASStackLayoutAlignItemsStart
                                                                              children:@[_bottomTags,_stateAndViewCountNode]];
    if (self.tableViewItem.model.pType == 6) {
        rightStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                              spacing:10
                                                       justifyContent:ASStackLayoutJustifyContentStart
                                                           alignItems:ASStackLayoutAlignItemsStart
                                                             children:@[_toLoginNode,bottomTagSpec]];
    }else if (self.tableViewItem.model.pType == 7) {
        rightStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                              spacing:10
                                                       justifyContent:ASStackLayoutJustifyContentStart
                                                           alignItems:ASStackLayoutAlignItemsStart
                                                             children:@[_unAuditedNode,bottomTagSpec]];
    }else {
        rightStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                              spacing:10
                                                       justifyContent:ASStackLayoutJustifyContentStart
                                                           alignItems:ASStackLayoutAlignItemsStart
                                                             children:@[_priceNode,bottomTagSpec]];
    }
    
    ASStackLayoutSpec *wholeSpcer = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                            spacing:10
                                                                     justifyContent:ASStackLayoutJustifyContentStart
                                                                         alignItems:ASStackLayoutAlignItemsStart
                                                                           children:@[stackSpec,rightStack]];
//    ASBackgroundLayoutSpec *wholeBackSpecer = [ASBackgroundLayoutSpec backgroundLayoutSpecWithChild:_cellBgNode background:wholeSpcer];
    
    
    return wholeSpcer;
}

- (void)layout {
    [super layout];
    
    _imageNode.frame = CGRectMake(10, 10, kImageWidth, kImageHeight);
    _iconNode.frame = CGRectMake(10 + kImageWidth - kIconWidth, 10, kIconWidth, kIconHeight);
    if (_coverImageNode) {
        _coverImageNode.frame = CGRectMake(10, 10, kImageWidth, kImageHeight);
    }
    _storeNameNode.frame = CGRectMake(10, 10 + kImageHeight, kImageWidth, 20);
    
    _productNameNode.frame = CGRectMake(10 + kImageWidth + 10, 20, self.tableViewItem.preferredSize.width - 10 * 2 - kImageWidth - 10, 34);
    if (self.tableViewItem.model.pType == 6) {
        _toLoginNode.frame = CGRectMake(10 + kImageWidth + 10, _productNameNode.frame.origin.y + _productNameNode.frame.size.height + 15, self.tableViewItem.preferredSize.width - 10 * 3 - kImageWidth, 30);
        _stateAndViewCountNode.frame = CGRectMake(self.tableViewItem.preferredSize.width - 10 - _stateAndViewCountNode.calculatedSize.width, _imageNode.frame.origin.y + _imageNode.frame.size.height + 20 - 7 - _stateAndViewCountNode.calculatedSize.height, _stateAndViewCountNode.calculatedSize.width, _stateAndViewCountNode.calculatedSize.height);
        _bottomTags.frame = CGRectMake(10 * 2 + kImageWidth, _imageNode.frame.origin.y + _imageNode.frame.size.height + 20 - 7 - _stateAndViewCountNode.calculatedSize.height, _bottomTags.calculatedSize.width, _bottomTags.calculatedSize.height);
    }else if (self.tableViewItem.model.pType == 7) {
        _unAuditedNode.frame = CGRectMake(10 + kImageWidth + 10, _productNameNode.frame.origin.y + _productNameNode.frame.size.height + 15, self.tableViewItem.preferredSize.width - 10 * 3 - kImageWidth, 30);
        _stateAndViewCountNode.frame = CGRectMake(self.tableViewItem.preferredSize.width - 10  - _stateAndViewCountNode.calculatedSize.width, _imageNode.frame.origin.y + _imageNode.frame.size.height + 20 - 7 - _stateAndViewCountNode.calculatedSize.height, _stateAndViewCountNode.calculatedSize.width, _stateAndViewCountNode.calculatedSize.height);
        _bottomTags.frame = CGRectMake(10 * 2 + kImageWidth, _imageNode.frame.origin.y + _imageNode.frame.size.height + 20 - 7 - _stateAndViewCountNode.calculatedSize.height, _bottomTags.calculatedSize.width, _bottomTags.calculatedSize.height);
    }else {
        _priceNode.frame = CGRectMake(10 + kImageWidth + 10, _productNameNode.frame.origin.y + _productNameNode.frame.size.height + 15, self.tableViewItem.preferredSize.width - 10 * 3 - kImageWidth, 30);
        _stateAndViewCountNode.frame = CGRectMake(self.tableViewItem.preferredSize.width - 10  - _stateAndViewCountNode.calculatedSize.width, _imageNode.frame.origin.y + _imageNode.frame.size.height + 20 - 7 - _stateAndViewCountNode.calculatedSize.height, _stateAndViewCountNode.calculatedSize.width, _stateAndViewCountNode.calculatedSize.height);
        _bottomTags.frame = CGRectMake(10 * 2 + kImageWidth, _imageNode.frame.origin.y + _imageNode.frame.size.height + 20 - 7 - _stateAndViewCountNode.calculatedSize.height, _bottomTags.calculatedSize.width, _bottomTags.calculatedSize.height);
    }
    
    if (!self.tableViewItem.model.inventory.integerValue) {
        _sellOutNode.frame = CGRectMake(10, 10, kImageWidth, kImageHeight);
        _sellOutImageNode.frame = CGRectMake(10, 10, _sellOutImageNode.style.preferredSize.width, _sellOutImageNode.style.preferredSize.height);
    }
    
//    self.dividerNode.frame = CGRectMake(0, self.item.preferredSize.height - 0.5f, ScreenWidth, 0.5f);
    
    
    
}

#pragma mark - Pricate Action

- (void)loadPriceAndStateWithNewType {
    //1.批发价 2.活动价 3.vip1 4.vip2  5.vip3 6.未登录  7.未审核
    NSString *vipStr = @"";
    if (self.tableViewItem.model.pType == 3) {
        vipStr = @"gd_vip_1";
    }else if (self.tableViewItem.model.pType == 4) {
        vipStr = @"gd_vip_2";
    }else if (self.tableViewItem.model.pType == 5) {
        vipStr = @"gd_vip_3";
    }
    switch (self.tableViewItem.model.pType) {
        case 1:{
            _priceNode = [self getTextNode];
            _stateAndViewCountNode = [self getTextNode];
            [self addSubnode:_priceNode];
            [self addSubnode:_stateAndViewCountNode];
            
            NSString *priceStr = [NSString stringWithFormat:@"¥ %@",self.tableViewItem.model.pValue];
            NSMutableAttributedString *attr_string = [[NSMutableAttributedString alloc]initWithString:priceStr];
            [attr_string addAttributes:@{
                                         NSFontAttributeName : [UIFont systemFontOfSize:17],
                                         NSForegroundColorAttributeName : HEX_COLOR(0xff434e)
                                         }range:NSMakeRange(0, priceStr.length - 2)];
            [attr_string addAttributes:@{
                                         NSFontAttributeName : [UIFont systemFontOfSize:14],
                                         NSForegroundColorAttributeName : HEX_COLOR(0xff434e)
                                         }range:NSMakeRange(priceStr.length - 2, 2)];
            _priceNode.attributedText = attr_string;
            
            
            if (self.tableViewItem.model.viewCount.length) {
                NSString *viewCount = [NSString stringWithFormat:@"%@次浏览量",self.tableViewItem.model.viewCount];
                
                NSAttributedString *viewCountAttr = [[NSAttributedString alloc]initWithString:viewCount
                                                                                   attributes:@{
                                                                                                NSForegroundColorAttributeName : HEX_COLOR(0x666666),
                                                                                                NSFontAttributeName :[UIFont systemFontOfSize:12]
                                                                                                }];
                _stateAndViewCountNode.attributedText = viewCountAttr;
            }
            
            break;
        }
        case 2:{
            _priceNode = [self getTextNode];
            _stateAndViewCountNode = [self getTextNode];
            [self addSubnode:_priceNode];
            [self addSubnode:_stateAndViewCountNode];
            
            
            NSMutableAttributedString *priceMutableAttr = [[NSMutableAttributedString alloc]init];
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            attch.image = [UIImage imageNamed:@"activityPeiceTag.png"];
            attch.bounds = CGRectMake(0, -2, 33, 13);
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
            [priceMutableAttr appendAttributedString:string];
            [priceMutableAttr appendString:@" "];
            NSString *priceStr = [NSString stringWithFormat:@"¥ %@",self.tableViewItem.model.pValue];
            NSMutableAttributedString *attr_string = [[NSMutableAttributedString alloc]initWithString:priceStr];
            [attr_string addAttributes:@{
                                         NSFontAttributeName : [UIFont systemFontOfSize:17],
                                         NSForegroundColorAttributeName : HEX_COLOR(0xff434e)
                                         }range:NSMakeRange(0, priceStr.length - 2)];
            [attr_string addAttributes:@{
                                         NSFontAttributeName : [UIFont systemFontOfSize:14],
                                         NSForegroundColorAttributeName : HEX_COLOR(0xff434e)
                                         }range:NSMakeRange(priceStr.length - 2, 2)];
            [priceMutableAttr appendAttributedString:attr_string];
            _priceNode.attributedText = priceMutableAttr;
            
            
            
            NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc]init];
            if (self.tableViewItem.model.viewCount.length) {
                NSAttributedString *viewConteAttr = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@次浏览量",self.tableViewItem.model.viewCount]
                                                                                   attributes:@{
                                                                                                NSFontAttributeName : [UIFont systemFontOfSize:12],
                                                                                                NSForegroundColorAttributeName : HEX_COLOR(0x666666)
                                                                                                }];
                [mutableAttr appendAttributedString:viewConteAttr];
            }
            _stateAndViewCountNode.attributedText = mutableAttr;
            
            break;
        }
        case 3:
        case 4:
        case 5: {
            _priceNode = [self getTextNode];
            _stateAndViewCountNode = [self getTextNode];
            [self addSubnode:_priceNode];
            [self addSubnode:_stateAndViewCountNode];
            NSMutableAttributedString *priceMutableAttr = [[NSMutableAttributedString alloc]init];
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            attch.image = [UIImage imageNamed:vipStr];
            attch.bounds = CGRectMake(0, -2, 19, 14);
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
            [priceMutableAttr appendAttributedString:string];
            NSAttributedString *attrSpace = [[NSAttributedString alloc] initWithString:@" "
                                                                            attributes:@{
                                                                                         NSForegroundColorAttributeName :[UIColor whiteColor],
                                                                                         NSFontAttributeName : [UIFont systemFontOfSize:12]
                                                                                         }];
            [priceMutableAttr appendAttributedString:attrSpace];
            NSString *priceStr = [NSString stringWithFormat:@"¥%@",self.tableViewItem.model.pValue];
            NSMutableAttributedString *attr_string = [[NSMutableAttributedString alloc]initWithString:priceStr];
            [attr_string addAttributes:@{
                                         NSFontAttributeName : [UIFont systemFontOfSize:17],
                                         NSForegroundColorAttributeName : HEX_COLOR(0xff434e)
                                         }range:NSMakeRange(0, priceStr.length - 2)];
            [attr_string addAttributes:@{
                                         NSFontAttributeName : [UIFont systemFontOfSize:14],
                                         NSForegroundColorAttributeName : HEX_COLOR(0xff434e)
                                         }range:NSMakeRange(priceStr.length - 2, 2)];
            [priceMutableAttr appendAttributedString:attr_string];
            _priceNode.attributedText = priceMutableAttr;
            
            
            
            NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc]init];
            if (self.tableViewItem.model.viewCount.length) {
                NSAttributedString *viewConteAttr = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@" %@次浏览量",self.tableViewItem.model.viewCount]
                                                                                   attributes:@{
                                                                                                NSFontAttributeName : [UIFont systemFontOfSize:12],
                                                                                                NSForegroundColorAttributeName : HEX_COLOR(0x666666)
                                                                                                }];
                [mutableAttr appendAttributedString:viewConteAttr];
            }
            _stateAndViewCountNode.attributedText = mutableAttr;
            
            
            break;
        }
        case 6: {
            
            _toLoginNode = [self getTextNode];
            _toLoginNode.textContainerInset = UIEdgeInsetsMake((30 - [UIFont systemFontOfSize:13].lineHeight) / 2, 0, 0, 0);
            [self addSubnode:_toLoginNode];
            _stateAndViewCountNode = [self getTextNode];
            [self addSubnode:_stateAndViewCountNode];
            
            NSAttributedString *toLoginAttr = [[NSAttributedString alloc]initWithString:@"登录后查看价格"
                                                                             attributes:@{
                                                                                          NSForegroundColorAttributeName : HEX_COLOR(0xff434e),
                                                                                          NSFontAttributeName : [UIFont systemFontOfSize:13]
                                                                                          }];
            _toLoginNode.attributedText = toLoginAttr;
            [_toLoginNode addTarget:self action:@selector(onViewClick:) forControlEvents:ASControlNodeEventTouchUpInside];
            
            
            if (self.tableViewItem.model.viewCount.length) {
                NSString *viewCount = [NSString stringWithFormat:@"%@次浏览量",self.tableViewItem.model.viewCount];
                
                NSAttributedString *viewCountAttr = [[NSAttributedString alloc]initWithString:viewCount
                                                                                   attributes:@{
                                                                                                NSForegroundColorAttributeName : HEX_COLOR(0x666666),
                                                                                                NSFontAttributeName :[UIFont systemFontOfSize:12]
                                                                                                }];
                _stateAndViewCountNode.attributedText = viewCountAttr;
            }
            break;
        }
        case 7:{
            
            _unAuditedNode = [self getTextNode];
            [self addSubnode:_unAuditedNode];
            _stateAndViewCountNode = [self getTextNode];
            [self addSubnode:_stateAndViewCountNode];
            
            NSAttributedString *auditeAttr = [[NSAttributedString alloc]initWithString:@"通过审核后查看价格"
                                                                            attributes:@{
                                                                                         NSForegroundColorAttributeName : HEX_COLOR(0xff434e),
                                                                                         NSFontAttributeName : [UIFont systemFontOfSize:13]
                                                                                         }];
            _unAuditedNode.attributedText = auditeAttr;
            
            if (self.tableViewItem.model.viewCount.length) {
                NSString *viewCount = [NSString stringWithFormat:@"%@次浏览量",self.tableViewItem.model.viewCount];
                
                NSAttributedString *viewCountAttr = [[NSAttributedString alloc]initWithString:viewCount
                                                                                   attributes:@{
                                                                                                NSForegroundColorAttributeName : HEX_COLOR(0x666666),
                                                                                                NSFontAttributeName :[UIFont systemFontOfSize:12]
                                                                                                }];
                _stateAndViewCountNode.attributedText = viewCountAttr;
            }
            break;
        }
            
            
        default: {
            _priceNode = [self getTextNode];
            _stateAndViewCountNode = [self getTextNode];
            [self addSubnode:_priceNode];
            [self addSubnode:_stateAndViewCountNode];
            break;
        }
            
    }
}



#pragma mark - Private Action

- (void)onViewClick:(id)sender {
    if (self.tableViewItem.onViewClickHandler) {
        self.tableViewItem.onViewClickHandler(self.tableViewItem, 4);
    }
}



#pragma mark - Create View

- (ASNetworkImageNode*)imageNode {
    if (!_imageNode) {
        _imageNode = [[ASNetworkImageNode alloc]init];
        _imageNode.contentMode = UIViewContentModeScaleAspectFit;
        _imageNode.clipsToBounds = YES;
        _imageNode.style.preferredSize = CGSizeMake(kImageWidth, kImageHeight);
    }
    return _imageNode;
}

- (ASNetworkImageNode*)coverImageNode {
    if(!_coverImageNode) {
        _coverImageNode = [[ASNetworkImageNode alloc]init];
        _coverImageNode.contentMode = UIViewContentModeScaleAspectFit;
        _coverImageNode.clipsToBounds = YES;
        _coverImageNode.style.preferredSize = CGSizeMake(kImageWidth, kImageHeight);
    }
    return _coverImageNode;
}

- (ASTextNode*)getTextNode {
    ASTextNode *textNode = [[ASTextNode alloc]init];
    textNode.maximumNumberOfLines = 1;
    return textNode;
}

- (ASImageNode*)sellOutImageNode {
    if (!_sellOutImageNode) {
        _sellOutImageNode = [[ASImageNode alloc]init];
        _sellOutImageNode.image = [UIImage imageNamed:@"classify_icon_SoldOut1.png"];
        _sellOutImageNode.style.preferredSize = CGSizeMake(kImageWidth, kImageHeight);
    }
    return _sellOutImageNode;
}

@end
