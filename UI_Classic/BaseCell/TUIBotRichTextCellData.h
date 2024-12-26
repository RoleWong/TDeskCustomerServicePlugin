
//  Created by lynx on 2024/3/1.
//  Copyright © 2024 Tencent. All rights reserved.

#import <TDeskCommon/TDesk_TUIBubbleMessageCellData.h>
NS_ASSUME_NONNULL_BEGIN

@interface TUIBotRichTextCellData : TDeskBubbleMessageCellData
@property(nonatomic, strong) NSString *content;
@property(nonatomic, assign) CGFloat cellHeight;
@property(nonatomic, assign) CGFloat lastUpdateTs;
@property(nonatomic, assign) BOOL delayUpdate;
@end

NS_ASSUME_NONNULL_END
