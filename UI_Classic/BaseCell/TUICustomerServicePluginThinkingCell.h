//
//  TUICustomerServicePluginThinkingCell.h
//  Pods
//
//  Created by gavinwjwang on 2025/4/24.
//

#import <TDeskCommon/TDesk_TUIBubbleMessageCell.h>
#import "TUICustomerServicePluginThinkingCellData.h"
#import <TDeskCommon/TDesk_TUITextView.h>
#import <SVGKit/SVGKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface TUICustomerServicePluginThinkingCell : TDeskBubbleMessageCell

@property (nonatomic, strong) SVGKFastImageView *circle1;
@property (nonatomic, strong) SVGKFastImageView *circle2;
@property (nonatomic, strong) SVGKFastImageView *circle3;
@property (nonatomic, strong) UIView *circleView;

@property (nonatomic, strong) TUICustomerServicePluginThinkingCellData *thinkingData;

- (void)fillWithData:(TUICustomerServicePluginThinkingCellData *)data;

@end

NS_ASSUME_NONNULL_END
