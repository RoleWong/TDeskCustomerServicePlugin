//
//  TUIChatBotStreamTextCell.h
//  TUICustomerServicePlugin
//
//  Created by lynx on 2023/10/30.
//

#import <TDeskChat/TUITextMessageCell.h>
#import "TUIBotStreamTextCellData.h"

NS_ASSUME_NONNULL_BEGIN

@interface TUIBotStreamTextCell : TUITextMessageCell
- (void)fillWithData:(TUIBotStreamTextCellData *)data;
@end

NS_ASSUME_NONNULL_END
