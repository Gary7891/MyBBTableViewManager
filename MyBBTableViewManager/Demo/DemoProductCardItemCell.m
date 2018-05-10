//
//  DemoProductCardItemCell.m
//  MyBBTableViewManager
//
//  Created by Gary on 2018/5/9.
//  Copyright © 2018 Gary. All rights reserved.
//

#import "DemoProductCardItemCell.h"
#import "TTMixImageTextLabel.h"
#import <Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSAttributedString+TSText.h"

#define kIconWidth             40
#define kIconHeight            40

@interface DemoProductCardItemCell ()

@property (nonatomic, strong) UIView *proSellOutView;

@property (nonatomic, strong) UIImageView *proMainImageView;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIImageView *proSelloutImageView;
@property (nonatomic, strong) UIImageView *iconImageView;


@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *unAuditedButton;

@property (nonatomic, strong) TTMixImageTextLabel *proDescLabel;
@property (nonatomic, strong) UILabel *proPriceLabel;
@property (nonatomic, strong) UILabel *proStoreNameLabel;
@property (nonatomic, strong) UILabel *proStatusAndBrowserLabel;
@property (nonatomic, strong)   TTMixImageTextLabel *bottomTag;//底部标签

@property (nonatomic, strong) UIView  *bottomLine;


@end

@implementation DemoProductCardItemCell
@dynamic item;

+(CGFloat)heightWithItem:(BBTableViewItem *)item tableViewManager:(BBTableViewManager *)tableViewManager {
    return 127;
//    return UITableViewAutomaticDimension;
}

- (void)cellDidLoad {
    [super cellDidLoad];
    
    self.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.proMainImageView];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.coverImageView];
    [self.contentView addSubview:self.proSellOutView];
    
    [self.proSellOutView addSubview:self.proSelloutImageView];
    
    [self.contentView addSubview:self.proDescLabel];
    [self.contentView addSubview:self.proPriceLabel];
    [self.contentView addSubview:self.proStoreNameLabel];
    [self.contentView addSubview:self.proStatusAndBrowserLabel];
    
    [self.contentView addSubview:self.loginButton];
    [self.contentView addSubview:self.unAuditedButton];
    [self.contentView addSubview:self.bottomLine];
    [self.contentView addSubview:self.bottomTag];
    
    
    [self initView];
}

- (void)cellWillAppear {
    [super cellWillAppear];
    
    self.loginButton.hidden = YES;
    self.unAuditedButton.hidden = YES;
    
    [self initSellOutView];
    self.iconImageView.hidden = !self.item.model.isGoodsNew;
    if(self.item.model.coverPic.length) {
        _coverImageView.hidden = NO;
        NSString *url = [NSString stringWithFormat:@"%@%@",TT_Global_Photo_Domain,self.item.model.coverPic];
        [_coverImageView sd_setImageWithURL:[NSURL URLWithString:url]
                           placeholderImage:nil];
    }else {
        _coverImageView.hidden = YES;
    }
    
    //1.批发价 2.活动价 3.vip1 4.vip2  5.vip3 6.未登录  7.未审核
    NSString *vipStr = @"";
    if (self.item.model.pType == 3) {
        vipStr = @"gd_vip_1";
    }else if (self.item.model.pType == 4) {
        vipStr = @"gd_vip_2";
    }else if (self.item.model.pType == 5) {
        vipStr = @"gd_vip_3";
    }
    
    switch (self.item.model.pType) {
        case 1:
            [self loadNormalPrice];
            break;
        case 2:
            [self loadActPrice];
            break;
        case 3:
        case 4:
        case 5:
            [self loadVipPrice:vipStr];
            break;
        case 6:
            [self loadLoginStatus];
            break;
        case 7:
            [self loadUnauditedStatus];
            break;
            
        default:
            break;
    }
    
    [self.proDescLabel setImages:self.item.model.goodsTagsTop text:self.item.model.name];
    [self.bottomTag setImages:self.item.model.goodsTagsBottom text:@""];
    
    self.proStoreNameLabel.text = self.item.model.storeName;
    
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    NSString *url = [NSString stringWithFormat:@"%@%@",TT_Global_Photo_Domain,self.item.model.path];
    [self.proMainImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"tupianjiazaibuchu"]];
}

- (void)cellDidDisappear {
    [super cellDidDisappear];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark 卖完的view
-(void)initSellOutView {
    if (!self.item.model.inventory.integerValue) {
        self.proSellOutView.hidden =NO;
        self.proSelloutImageView.hidden = NO;
    } else {
        self.proSellOutView.hidden =YES;
        self.proSelloutImageView.hidden = YES;
    }
}


-(void)loadNormalPrice {
    
    
    NSString *priceStr = [NSString stringWithFormat:@"¥ %@",self.item.model.pValue];
    NSMutableAttributedString *attr_string = [[NSMutableAttributedString alloc]initWithString:priceStr];
    [attr_string addAttributes:@{
                                 NSFontAttributeName : [UIFont systemFontOfSize:17],
                                 NSForegroundColorAttributeName : HEX_COLOR(0xff434e)
                                 }range:NSMakeRange(0, priceStr.length - 2)];
    [attr_string addAttributes:@{
                                 NSFontAttributeName : [UIFont systemFontOfSize:14],
                                 NSForegroundColorAttributeName :HEX_COLOR(0xff434e)
                                 }range:NSMakeRange(priceStr.length - 2, 2)];
    self.proPriceLabel.attributedText = attr_string;
    
    if (self.item.model.viewCount.length) {
        self.proStatusAndBrowserLabel.text =  [NSString stringWithFormat:@" %@次浏览量",self.item.model.viewCount];
    }else {
        self.proStatusAndBrowserLabel.text = nil;
    }
    
    self.proStatusAndBrowserLabel.textColor = HEX_COLOR(0x666666);
    self.proStatusAndBrowserLabel.font =  [UIFont systemFontOfSize:12];
    
    self.proPriceLabel.hidden = NO;
    self.proStatusAndBrowserLabel.hidden = NO;
}

-(void)loadActPrice {
    
    NSMutableAttributedString *priceMutableAttr = [[NSMutableAttributedString alloc]init];
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    attch.image = [UIImage imageNamed:@"activityPeiceTag.png"];
    attch.bounds = CGRectMake(0, -2, 33, 13);
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [priceMutableAttr appendAttributedString:string];
    [priceMutableAttr appendString:@" "];
    NSString *priceStr = [NSString stringWithFormat:@"¥ %@",self.item.model.pValue];
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
    self.proPriceLabel.attributedText = priceMutableAttr;
    
    NSString *browser = self.item.model.viewCount;
    NSString *StatusAndBrowser = [NSString stringWithFormat:@"%@次浏览量",browser];
    NSMutableAttributedString *StatusAndBrowserAttr = [[NSMutableAttributedString alloc]initWithString:StatusAndBrowser];
    
    
    [StatusAndBrowserAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, StatusAndBrowser.length)];
    if (browser.length) {
        [StatusAndBrowserAttr addAttribute:NSForegroundColorAttributeName value:HEX_COLOR(0x666666) range:NSMakeRange(0, StatusAndBrowser.length)];
    }else {
        [StatusAndBrowserAttr addAttribute:NSForegroundColorAttributeName value:[UIColor clearColor] range:NSMakeRange(0, StatusAndBrowser.length)];
    }
    
    self.proStatusAndBrowserLabel.attributedText = StatusAndBrowserAttr;
    
    self.proPriceLabel.hidden = NO;
    self.proStatusAndBrowserLabel.hidden = NO;
}


-(void)loadVipPrice:(NSString*)vipStepStr {
    
    NSMutableAttributedString *priceMutableAttr = [[NSMutableAttributedString alloc]init];
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    attch.image = [UIImage imageNamed:vipStepStr];
    attch.bounds = CGRectMake(0, -2, 19, 14);
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [priceMutableAttr appendAttributedString:string];
    NSAttributedString *attrSpace = [[NSAttributedString alloc] initWithString:@" "
                                                                    attributes:@{
                                                                                 NSForegroundColorAttributeName :[UIColor whiteColor],
                                                                                 NSFontAttributeName : [UIFont systemFontOfSize:12],
                                                                                 }];
    [priceMutableAttr appendAttributedString:attrSpace];
    NSString *priceStr = [NSString stringWithFormat:@"¥ %@",self.item.model.pValue];
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
    self.proPriceLabel.attributedText = priceMutableAttr;
    
    
    
    NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc]init];
    
    
    if (self.item.model.viewCount.length) {
        NSAttributedString *viewConteAttr = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@次浏览量",self.item.model.viewCount]
                                                                           attributes:@{
                                                                                        NSFontAttributeName : [UIFont systemFontOfSize:12],
                                                                                        NSForegroundColorAttributeName : HEX_COLOR(0x666666)
                                                                                        }];
        [mutableAttr appendAttributedString:viewConteAttr];
    }
    self.proStatusAndBrowserLabel.attributedText = mutableAttr;
    
    self.proPriceLabel.hidden = NO;
    self.proStatusAndBrowserLabel.hidden = NO;
    
    
}

-(void)loadLoginStatus {
    
    self.loginButton.hidden = NO;
    self.unAuditedButton.hidden = YES;
    
    self.proPriceLabel.hidden = YES;
    self.proStatusAndBrowserLabel.hidden = NO;
    
    NSString *browser = self.item.model.viewCount;
    NSString *StatusAndBrowser = [NSString stringWithFormat:@"%@次浏览量",browser];
    
    if ([self.item.model.viewCount integerValue]) {
        self.proStatusAndBrowserLabel.textColor = HEX_COLOR(0x666666);
    } else {
        self.proStatusAndBrowserLabel.textColor = [UIColor clearColor];
    }
    self.proStatusAndBrowserLabel.font = [UIFont systemFontOfSize:12];
    self.proStatusAndBrowserLabel.text = StatusAndBrowser;
    
}

-(void)loadUnauditedStatus {
    
    self.loginButton.hidden = YES;
    self.unAuditedButton.hidden = NO;
    
    self.proPriceLabel.hidden = YES;
    self.proStatusAndBrowserLabel.hidden = NO;
    
    
    NSString *browser = self.item.model.viewCount;
    NSString *StatusAndBrowser = [NSString stringWithFormat:@"%@次浏览量",browser];
    
    if ([self.item.model.viewCount integerValue]) {
        self.proStatusAndBrowserLabel.textColor = HEX_COLOR(0x666666);
    } else {
        self.proStatusAndBrowserLabel.textColor = [UIColor clearColor];
    }
    
    self.proStatusAndBrowserLabel.font = [UIFont systemFontOfSize:12];
    self.proStatusAndBrowserLabel.text = StatusAndBrowser;
}

-(void)initView {
    
    
    [self.proMainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(90);
        make.top.mas_equalTo(10);
        make.height.equalTo(self.proMainImageView.mas_width);
    }];
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(90);
        make.top.mas_equalTo(10);
        make.height.equalTo(self.coverImageView.mas_width);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kIconWidth);
        make.height.mas_equalTo(kIconHeight);
        make.right.equalTo(self.proMainImageView);
        make.top.equalTo(self.proMainImageView);
    }];
    
    [self.proSellOutView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.proMainImageView);
        make.right.mas_equalTo(self.proMainImageView);
        make.top.mas_equalTo(self.proMainImageView);
        make.height.mas_equalTo(self.proMainImageView);
    }];
    
    [self.proSelloutImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self.proSellOutView);
        make.centerY.mas_equalTo(self.proSellOutView);
        make.width.equalTo(@80);
        make.height.equalTo(@80);
    }];
    
    [self.proDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.proMainImageView.mas_right).offset(10);
        make.right.mas_equalTo(self).offset(-10);
        make.top.mas_equalTo(self.proMainImageView.mas_top).offset(5);
        make.height.mas_equalTo(34);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.proDescLabel);
        make.right.mas_equalTo(self.contentView).offset(-10);
        make.top.mas_equalTo(self.proDescLabel.mas_bottom);
        make.height.mas_equalTo(30);
    }];
    
    [self.unAuditedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.proDescLabel);
        make.right.mas_equalTo(self.contentView).offset(-10);
        make.top.mas_equalTo(self.proStoreNameLabel.mas_bottom);
        make.height.mas_equalTo(30);
    }];
    
    [self.proPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.proDescLabel);
        make.right.mas_equalTo(self.proDescLabel);
        make.top.mas_equalTo(self.proDescLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(@15);
    }];
    
    [self.proStoreNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.proMainImageView);
        make.right.mas_equalTo(self.proMainImageView);
        make.top.mas_equalTo(self.proMainImageView.mas_bottom);
        make.height.mas_equalTo(@20);
    }];
    
    [self.proStatusAndBrowserLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.proDescLabel);
        make.bottom.mas_equalTo(self.proStoreNameLabel.mas_bottom).offset(-5);
        make.height.mas_equalTo(@12);
    }];
    
    [self.bottomTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.proDescLabel);
        make.centerY.mas_equalTo(self.proStatusAndBrowserLabel);
        make.height.mas_equalTo(@12);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(0.5f);
        make.left.mas_equalTo(0);
        make.bottom.equalTo(self.mas_bottom);
        
    }];
    
}

-(void)login {
    
//    if (self.loginBlock!=nil) {
//        self.loginBlock();
//    }
}

-(UIView *)proSellOutView {
    
    if (!_proSellOutView) {
        _proSellOutView = [[UIView alloc]init];
        _proSellOutView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    }
    
    return  _proSellOutView;
}

-(UIImageView *)proMainImageView {
    
    if (!_proMainImageView) {
        _proMainImageView = [[UIImageView alloc]init];
        _proMainImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    return _proMainImageView;
}

- (UIImageView*)coverImageView {
    if(!_coverImageView) {
        _coverImageView = [[UIImageView alloc]init];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
        _coverImageView.backgroundColor = [UIColor clearColor];
    }
    return _coverImageView;
}


-(UIImageView *)proSelloutImageView {
    
    if (!_proSelloutImageView) {
        _proSelloutImageView = [[UIImageView alloc]init];
        [_proSelloutImageView setImage:[UIImage imageNamed:@"classify_icon_SoldOut1"]];
    }
    
    return _proSelloutImageView;
}

-(UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.backgroundColor = [UIColor clearColor];
        [_loginButton setTitle:@"登录后查看价格" forState:UIControlStateNormal];
        [_loginButton setTitleColor:HEX_COLOR(0xff434e) forState:UIControlStateNormal];
        
        
        _loginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:13];
        //        _loginButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return  _loginButton;
}

-(UIButton *)unAuditedButton {
    
    if (!_unAuditedButton) {
        _unAuditedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_unAuditedButton setTitle:@"通过审核后查看价格" forState:UIControlStateNormal];
        [_unAuditedButton setTitleColor:HEX_COLOR(0xff434e) forState:UIControlStateNormal];
        _unAuditedButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _unAuditedButton.titleLabel.font = [UIFont systemFontOfSize:13];
        //        _unAuditedButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        _unAuditedButton.backgroundColor = [UIColor clearColor];
    }
    
    
    return _unAuditedButton;
}
-(UILabel *)proPriceLabel {
    
    if (!_proPriceLabel) {
        _proPriceLabel = [[UILabel alloc]init];
    }
    
    
    return _proPriceLabel;
}

-(TTMixImageTextLabel *)proDescLabel {
    
    if (!_proDescLabel) {
        _proDescLabel = [[TTMixImageTextLabel alloc]init];
        _proDescLabel.font = [UIFont systemFontOfSize:14];
        _proDescLabel.textColor = HEX_COLOR(0x666666);
        _proDescLabel.numberOfLines = 2;
    }
    
    return _proDescLabel;
}

-(UILabel *)proStoreNameLabel {
    
    if (!_proStoreNameLabel) {
        
        _proStoreNameLabel = [[UILabel alloc]init];
        _proStoreNameLabel.backgroundColor = HEX_COLOR(0xaaaaaa);
        _proStoreNameLabel.textColor = [UIColor whiteColor];
        _proStoreNameLabel.font = [UIFont systemFontOfSize:10];
        
    }
    
    return _proStoreNameLabel;
}

-(UILabel *)proStatusAndBrowserLabel {
    
    if (!_proStatusAndBrowserLabel) {
        _proStatusAndBrowserLabel = [[UILabel alloc]init];
        _proStatusAndBrowserLabel.textAlignment = NSTextAlignmentRight;
        [_bottomTag setContentCompressionResistancePriority:751 forAxis:UILayoutConstraintAxisHorizontal];
    }
    return  _proStatusAndBrowserLabel;
}

- (UIImageView*)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
//        _iconImageView.width = kIconWidth;
//        _iconImageView.height = kIconHeight;
        _iconImageView.image = [UIImage imageNamed:@"GoodLabel_new.png"];
    }
    return _iconImageView;
}

- (UIView*)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc]init];
        _bottomLine.backgroundColor = HEX_COLOR(0xededed);
        
    }
    return _bottomLine;
}

- (TTMixImageTextLabel *)bottomTag {
    if (!_bottomTag) {
        _bottomTag = [[TTMixImageTextLabel alloc] init];
        _bottomTag.font = [UIFont systemFontOfSize:12];
        _bottomTag.textAlignment = NSTextAlignmentLeft;
    }
    return _bottomTag;
}



//- (void)awakeFromNib {
//    [super awakeFromNib];
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end
