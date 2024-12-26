//
//  TUICustomerServicePluginTaskInformationCollectorCellData.h
//  TDeskCustomerServicePlugin
//
//  Created by Role Wong on 11/14/24.
//


#import <TDeskChat/TDesk_TUITextMessageCell.h>
#import "TUIBotStreamTextCellData.h"

#ifndef TUICustomerServicePluginTaskInformationCollectorCellData_h
#define TUICustomerServicePluginTaskInformationCollectorCellData_h

NS_ASSUME_NONNULL_BEGIN

@interface TUICustomerServicePluginTaskInformationCollectorCellData : TDeskBubbleMessageCellData

@property (nonatomic, copy) NSString *tip;
@property (nonatomic, assign) NSInteger nodeStatus;
@property (nonatomic, strong) NSMutableArray *inputVariables;

@end

NS_ASSUME_NONNULL_END

#endif /* TUICustomerServicePluginTaskInformationCollectorCellData_h */
