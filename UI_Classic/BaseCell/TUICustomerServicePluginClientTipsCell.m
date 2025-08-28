//
//  TUICustomerServicePluginClientTipsCell.m
//  Pods
//
//  Created by gavinwjwang on 2025/6/10.
//


#import "TUICustomerServicePluginClientTipsCell.h"
//#import <SVGKit/SVGKit.h>
#import <TDeskCore/TDesk_TUICore.h>

@implementation TUICustomerServicePluginClientTipsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _textView = [[UILabel alloc] init];
        _textView.font = [UIFont systemFontOfSize:12];
        _textView.numberOfLines = 0;
        _textView.textAlignment = NSTextAlignmentCenter;
        _textView.lineBreakMode = NSLineBreakByTruncatingTail;
        _textView.textColor = TUICustomerServicePluginDynamicColor(@"customer_service_evaluation_header_text_color", @"#1C1C1C");
        
        [self.contentView addSubview:_textView];
    }
    return self;
}


- (void)fillWithData:(TUICustomerServicePluginClientTipsCellData *)data {
    [super fillWithData:data];
    self.clientTipsData = data;
    _textView.text = data.content;
    [self setNeedsUpdateConstraints];
  
    [self updateConstraintsIfNeeded];
    
    [self layoutIfNeeded];
}

+ (CGFloat)getHeight:(TUICustomerServicePluginClientTipsCellData *)data withWidth:(CGFloat)width {
    CGFloat height = [super getHeight:data withWidth:width];
    return height - 30;
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(Screen_Width);
        make.height.mas_equalTo(20);
    }];
}

@end
