//
//  TUICustomerServicePluginCardCellData.h
//  TUICustomerServicePlugin
//
//  Created by xia on 2023/5/30.
//

#import <TDeskCommon/TDesk_TUIMessageCell.h>
#import <TDeskCommon/TDesk_TUIBubbleMessageCellData.h>

NS_ASSUME_NONNULL_BEGIN

@interface TUICustomerServicePluginCardCellData : TDeskBubbleMessageCellData

@property (nonatomic, copy) NSString *header;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *picURL;
@property (nonatomic, copy) NSString *jumpURL;

@end

NS_ASSUME_NONNULL_END
