//
//  TUICustomerServicePluginClientTipsCell.h
//  Pods
//
//  Created by gavinwjwang on 2025/6/10.
//

#import <TDeskCommon/TDesk_TUIBubbleMessageCell.h>
#import "TUICustomerServicePluginClientTipsCellData.h"
#import <TDeskCommon/TDesk_TUITextView.h>
//#import <SVGKit/SVGKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface TUICustomerServicePluginClientTipsCell : TDeskBubbleMessageCell

@property(nonatomic, strong) UILabel *textView;

@property (nonatomic, strong) TUICustomerServicePluginClientTipsCellData *clientTipsData;

- (void)fillWithData:(TUICustomerServicePluginClientTipsCellData *)data;

@end

NS_ASSUME_NONNULL_END
