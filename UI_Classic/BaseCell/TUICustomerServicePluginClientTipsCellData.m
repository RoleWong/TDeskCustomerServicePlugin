//
//  TUICustomerServicePluginClientTipsCellData.m
//  Pods
//
//  Created by gavinwjwang on 2025/6/10.
//

#import "TUICustomerServicePluginClientTipsCellData.h"
#import "TUICustomerServicePluginPrivateConfig.h"
#import "TUICustomerServicePluginConfig.h"

@implementation TUICustomerServicePluginClientTipsCellData

+ (TDeskMessageCellData *)getCellData:(V2TIMMessage *)message {
    NSDictionary *param = [NSJSONSerialization JSONObjectWithData:message.customElem.data
                                                          options:NSJSONReadingAllowFragments error:nil];
    if (param == nil) {
        return nil;
    }
    TUICustomerServicePluginClientTipsCellData *cellData = [[TUICustomerServicePluginClientTipsCellData alloc] initWithDirection:message.isSelf ? MsgDirectionOutgoing : MsgDirectionIncoming];
    cellData.innerMessage = message;
    cellData.content = param[@"content"];
    return cellData;
}

- (BOOL)shouldHide {
    return false;
}

@end
