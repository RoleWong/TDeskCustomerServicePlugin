//
//  TUICustomerServicePluginDataProvider.m
//  Masonry
//
//  Created by xia on 2023/6/12.
//

#import "TUICustomerServicePluginDataProvider.h"
#import <TDeskCore/TDesk_TUICore.h>
#import <TDeskCore/TDesk_TUIDefine.h>
#import <ImSDK_Plus/ImSDK_Plus.h>

@implementation TUICustomerServicePluginDataProvider

+ (void)sendTextMessage:(NSString *)text {
    V2TIMMessage *message = [[V2TIMManager sharedInstance] createTextMessage:text];
    if (message == nil) {
        return;
    }
    NSDictionary *param = @{TDeskCore_TUIChatService_SendMessageMethod_MsgKey: message};
    [TDeskCore callService:TDeskCore_TUIChatService
                  method:TDeskCore_TUIChatService_SendMessageMethod
                   param:param];
}

+ (void)sendCustomMessage:(NSData *)data {
    V2TIMMessage *message = [[V2TIMManager sharedInstance] createCustomMessage:[self supplyCustomerServiceID:data]];
    if (message == nil) {
        return;
    }
    NSDictionary *param = @{TDeskCore_TUIChatService_SendMessageMethod_MsgKey: message};
    [TDeskCore callService:TDeskCore_TUIChatService
                  method:TDeskCore_TUIChatService_SendMessageMethod
                   param:param];
}

+ (void)sendCustomMessageWithoutUpdateUI:(NSData *)data {
    V2TIMMessage *message = [[V2TIMManager sharedInstance] createCustomMessage:[self supplyCustomerServiceID:data]];
    if (message == nil) {
        return;
    }
    NSDictionary *param = @{TDeskCore_TUIChatService_SendMessageMethodWithoutUpdateUI_MsgKey: message};
    [TDeskCore callService:TDeskCore_TUIChatService
                  method:TDeskCore_TUIChatService_SendMessageMethodWithoutUpdateUI
                   param:param];
}

+ (NSData *)supplyCustomerServiceID:(NSData *)data {
    NSDictionary *dic = [TDeskTool jsonData2Dictionary:data];
    if (!dic || 0 == dic.allKeys.count || [dic objectForKey:BussinessID_CustomerService]) {
        return data;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:dic];
    [param setObject:@(0) forKey:BussinessID_CustomerService];
    return [TDeskTool dictionary2JsonData:param];
}

@end
