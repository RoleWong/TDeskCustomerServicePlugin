//
//  TUIChatBotStreamTextCell.h
//  TUICustomerServicePlugin
//
//  Created by lynx on 2023/10/30.
//

#import <TDeskChat/TDesk_TUITextMessageCell.h>
#import "TUIBotStreamTextCellData.h"

NS_ASSUME_NONNULL_BEGIN

@interface TUIBotStreamTextCell : TDeskTextMessageCell
- (void)fillWithData:(TUIBotStreamTextCellData *)data;
@end

NS_ASSUME_NONNULL_END
