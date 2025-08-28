//
//  TUICustomerServicePluginTaskBranchCellData.h
//  TDeskCustomerServicePlugin
//
//  Created by Role Wong on 11/7/24.
//

#import <TDeskChat/TDesk_TUITextMessageCell.h>
#import "TUIBotStreamTextCellData.h"

#ifndef TUICustomerServicePluginTaskBranchCellData_h
#define TUICustomerServicePluginTaskBranchCellData_h

NS_ASSUME_NONNULL_BEGIN

@interface TUICustomerServicePluginTaskBranchCellData : TDeskBubbleMessageCellData

@property (nonatomic, copy) NSString *header;
@property (nonatomic, assign) NSInteger taskStatus;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, copy) NSString *selectedContent;
@property (nonatomic, assign) NSInteger optionType;
@property (nonatomic, strong) NSMutableDictionary *taskInfo;
@end

NS_ASSUME_NONNULL_END


#endif /* TUICustomerServicePluginTaskBranchCellData_h */
