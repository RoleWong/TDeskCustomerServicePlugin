//
//  TUICustomerServicePluginBranchCellData.h
//  TUICustomerServicePlugin
//
//  Created by xia on 2023/5/30.
//

#import <TDeskCommon/TDesk_TUIMessageCell.h>
#import <TDeskCommon/TDesk_TUIBubbleMessageCellData.h>

NS_ASSUME_NONNULL_BEGIN

@interface TUICustomerServicePluginBranchCellData : TDeskBubbleMessageCellData

@property (nonatomic, copy) NSString *header;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, copy) NSString *selectedContent;
@property (nonatomic, assign) BOOL selected;

@end

NS_ASSUME_NONNULL_END
