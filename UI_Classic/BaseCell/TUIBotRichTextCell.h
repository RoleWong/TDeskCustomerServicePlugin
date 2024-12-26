
//  Created by lynx on 2024/3/1.
//  Copyright © 2024 Tencent. All rights reserved.

#import <TDeskCommon/TDesk_TUIBubbleMessageCell.h>
#import "TUIBotRichTextCellData.h"

@interface TUIBotRichTextCell : TDeskBubbleMessageCell
@property TUIBotRichTextCellData *webViewData;

- (void)fillWithData:(TUIBotRichTextCellData *)data;
@end
