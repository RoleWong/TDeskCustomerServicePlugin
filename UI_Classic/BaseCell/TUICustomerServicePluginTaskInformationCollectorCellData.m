//
//  TUICustomerServicePluginTaskInformationCollectorCellData.m
//  TDeskCustomerServicePlugin
//
//  Created by Role Wong on 11/14/24.
//

#import <Foundation/Foundation.h>

#import "TUICustomerServicePluginTaskInformationCollectorCellData.h"
#import "TUICustomerServicePluginDataProvider+CalculateSize.h"

@implementation TUICustomerServicePluginTaskInformationCollectorCellData

+ (TDeskMessageCellData *)getCellData:(V2TIMMessage *)message {
    NSDictionary *param = [NSJSONSerialization JSONObjectWithData:message.customElem.data
                                                          options:NSJSONReadingAllowFragments error:nil];
    if (param == nil) {
        return nil;
    }
    TUICustomerServicePluginTaskInformationCollectorCellData *cellData = [[TUICustomerServicePluginTaskInformationCollectorCellData alloc] initWithDirection:message.isSelf ? MsgDirectionOutgoing : MsgDirectionIncoming];
    cellData.innerMessage = message;
    cellData.nodeStatus = [param[@"nodeStatus"] integerValue];
    NSDictionary *content = param[@"content"];
    cellData.tip = content[@"tip"];
    NSArray *inputVariables = content[@"inputVariables"];
    for (NSDictionary *item in inputVariables) {
        [cellData.inputVariables addObject:item];
    }
    return cellData;
}

+ (NSString *)getDisplayString:(V2TIMMessage *)message {
    return TIMCommonLocalizableString(TUICustomerServiceCollectInfomation);
}

// Override
- (BOOL)canForward {
    return NO;
}

- (NSMutableArray *)inputVariables {
    if (!_inputVariables) {
        _inputVariables = [[NSMutableArray alloc] init];
    }
    return _inputVariables;
}

@end
