//
//  TUICustomerServicePluginTaskBranchCellData.m
//  TDeskCustomerServicePlugin
//
//  Created by Role Wong on 11/7/24.
//

#import <Foundation/Foundation.h>
#import "TUICustomerServicePluginTaskBranchCellData.h"
#import "TUICustomerServicePluginDataProvider+CalculateSize.h"

@implementation TUICustomerServicePluginTaskBranchCellData

+ (TDeskMessageCellData *)getCellData:(V2TIMMessage *)message {
    NSDictionary *param = [NSJSONSerialization JSONObjectWithData:message.customElem.data
                                                          options:NSJSONReadingAllowFragments error:nil];
    if (param == nil) {
        return nil;
    }
    TUICustomerServicePluginTaskBranchCellData *cellData = [[TUICustomerServicePluginTaskBranchCellData alloc] initWithDirection:message.isSelf ? MsgDirectionOutgoing : MsgDirectionIncoming];
    cellData.innerMessage = message;
    NSDictionary *content = param[@"content"];
    cellData.taskStatus = [param[@"status"] integerValue];
    cellData.header = content[@"header"];
    cellData.optionType = [param[@"optionType"] integerValue];
    if (cellData.optionType == 1) {
        NSDictionary *taskInfo = param[@"taskInfo"];
        [cellData.taskInfo setValue:taskInfo[@"nodeID"] forKey:@"nodeID"];
        [cellData.taskInfo setValue:taskInfo[@"taskID"] forKey:@"taskID"];
        [cellData.taskInfo setValue:taskInfo[@"env"] forKey:@"env"];
    }
    if(cellData.optionType == 0 && cellData.taskStatus != 0) {
        cellData.items = [NSMutableArray array];
    } else {
        NSArray *items = content[@"items"];
        for (NSDictionary *item in items) {
            [cellData.items addObject:item[@"content"]];
        }
    }
    
    NSDictionary *selected = content[@"selected"];
    cellData.selectedContent = selected[@"content"];
    return cellData;
}

+ (NSString *)getDisplayString:(V2TIMMessage *)message {
    return TDeskIMCommonLocalizableString(TUICustomerServiceCollectInfomation);
}

// Override
- (BOOL)canForward {
    return NO;
}

- (NSMutableArray *)items {
    if (!_items) {
        _items = [[NSMutableArray alloc] init];
    }
    return _items;
}

- (NSMutableDictionary *)taskInfo {
    if (!_taskInfo) {
        _taskInfo = [[NSMutableDictionary alloc] init];
    }
    return _taskInfo;
}

@end
