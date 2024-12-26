//
//  TUICustomerServicePluginCollectionCellData.h
//  TUICustomerServicePlugin
//
//  Created by xia on 2023/5/30.
//

#import <TDeskCommon/TDesk_TUIMessageCell.h>
#import <TDeskCommon/TDesk_TUIBubbleMessageCellData.h>

NS_ASSUME_NONNULL_BEGIN

@interface TUICustomerServicePluginCollectionCellData : TDeskBubbleMessageCellData

@property (nonatomic, copy) NSString *header;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, copy) NSString *selectedContent;
@property (nonatomic, assign) NSInteger type;

@end

NS_ASSUME_NONNULL_END
