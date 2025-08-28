//
//  TUICustomerServicePluginThinkingCellData.h
//  Pods
//
//  Created by gavinwjwang on 2025/4/24.
//

#import <TDeskCommon/TDesk_TUIMessageCell.h>
#import <TDeskCommon/TDesk_TUIBubbleMessageCellData.h>

NS_ASSUME_NONNULL_BEGIN

@interface TUICustomerServicePluginThinkingCellData : TDeskBubbleMessageCellData

// 0 思考中,1 思考结束
@property (nonatomic, assign) NSInteger thinkingStatus;

@end

NS_ASSUME_NONNULL_END
