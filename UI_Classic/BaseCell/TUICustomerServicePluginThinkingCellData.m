//
//  TUICustomerServicePluginThinkingCellData.m
//  Pods
//
//  Created by gavinwjwang on 2025/4/24.
//


#import "TUICustomerServicePluginThinkingCellData.h"
#import "TUICustomerServicePluginPrivateConfig.h"
#import "TUICustomerServicePluginConfig.h"

@implementation TUICustomerServicePluginThinkingCellData

+ (TDeskMessageCellData *)getCellData:(V2TIMMessage *)message {
    NSDictionary *param = [NSJSONSerialization JSONObjectWithData:message.customElem.data
                                                          options:NSJSONReadingAllowFragments error:nil];
    if (param == nil) {
        return nil;
    }
    TUICustomerServicePluginThinkingCellData *cellData = [[TUICustomerServicePluginThinkingCellData alloc] initWithDirection:message.isSelf ? MsgDirectionOutgoing : MsgDirectionIncoming];
    cellData.innerMessage = message;
    
    cellData.thinkingStatus = [param[@"thinkingStatus"] integerValue];
    return cellData;
}

- (BOOL)shouldHide {
// 这里先不过滤掉
//    if (self.thinkingStatus != 0)
//        return YES;
    return false;
}

@end
