//
//  TUICustomerServicePluginUtil.m
//  Pods
//
//  Created by Role Wong on 2025/8/28.
//

#import "TUICustomerServicePluginUtil.h"
#import "TUICustomerServicePluginService.h"
#import <TDeskCommon/TDesk_TIMDefine.h>
#import "TUICustomerServicePluginDataProvider.h"
#import "TUICustomerServicePluginPrivateConfig.h"
#import "TUICustomerServicePluginExtensionObserver.h"

@implementation TUICustomerServicePluginUtil

+ (NSArray<NSString *> *)aiNoteMessageTypeList {
    return @[@"fallback", @"aiReply", @"faq"];
}

+ (BOOL)canShowAINote:(V2TIMMessage *)message {
    if (message.cloudCustomData == nil || message.cloudCustomData.length == 0) {
        return NO;
    }
    
    NSDictionary *param = [TDeskTool jsonData2Dictionary:message.cloudCustomData];
    if (![param isKindOfClass:[NSDictionary class]]) {
        return NO;
    }

    NSString *messageType = param[@"messageType"];
    NSString *role = param[@"role"];
    
    BOOL typeMatch = [[self aiNoteMessageTypeList] containsObject:messageType ?: @""];
    BOOL roleMatch = [role isEqualToString:@"robot"];
    NSString *deviceLocale = [[NSLocale preferredLanguages] firstObject] ?: @"";
    BOOL localeMatch = ([deviceLocale containsString:@"zh-Hans"] || [deviceLocale containsString:@"en"]);
    
    return typeMatch && roleMatch && localeMatch;
}

@end
