//
//  TUICustomerServicePluginInvisibleCellData.m
//  TUICustomerServicePlugin
//
//  Created by xia on 2023/5/30.
//

#import "TUICustomerServicePluginInvisibleCellData.h"
#import "TUICustomerServicePluginPrivateConfig.h"
#import "TUICustomerServicePluginConfig.h"

@implementation TUICustomerServicePluginInvisibleCellData

+ (TDeskMessageCellData *)getCellData:(V2TIMMessage *)message {
    NSDictionary *param = [NSJSONSerialization JSONObjectWithData:message.customElem.data
                                                          options:NSJSONReadingAllowFragments error:nil];
    if (param == nil) {
        return nil;
    }
    TUICustomerServicePluginInvisibleCellData *cellData = [[TUICustomerServicePluginInvisibleCellData alloc] initWithDirection:message.isSelf ? MsgDirectionOutgoing : MsgDirectionIncoming];
    cellData.innerMessage = message;
    
    if ([param[@"src"] isEqualToString: BussinessID_Src_CustomerService_EvaluationRule]) {
        NSDictionary *content = param[@"content"];
        NSInteger menuSendRuleFlag = [content[@"menuSendRuleFlag"] integerValue];
        [TUICustomerServicePluginPrivateConfig sharedInstance].canEvaluate = menuSendRuleFlag >> 2;
    }
    
    if ([param[@"src"] isEqualToString: BussinessID_Src_CustomerService_Agent_Status]) {
        NSDictionary *content = param[@"content"];
        NSString *updateSeatStatus = [content[@"content"] description];

        if ([updateSeatStatus isEqualToString:@"inSeat"]) {
            if ([TUICustomerServicePluginPrivateConfig sharedInstance].enableShowHumanService) {
                [TUICustomerServicePluginConfig sharedInstance].showHumanServiceMenuItem = NO;
            }
            if ([TUICustomerServicePluginPrivateConfig sharedInstance].enableShowServiceRating) {
                [TUICustomerServicePluginConfig sharedInstance].showServiceRatingMenuItem = YES;
            }
            if ([TUICustomerServicePluginPrivateConfig sharedInstance].enableShowEndHumanService) {
                [TUICustomerServicePluginConfig sharedInstance].showEndHumanServiceMenuItem = YES;
            }
        } else if ([updateSeatStatus isEqualToString:@"outSeat"]) {
            if ([TUICustomerServicePluginPrivateConfig sharedInstance].enableShowHumanService) {
                [TUICustomerServicePluginConfig sharedInstance].showHumanServiceMenuItem = YES;
            }
            if ([TUICustomerServicePluginPrivateConfig sharedInstance].enableShowServiceRating) {
                [TUICustomerServicePluginConfig sharedInstance].showServiceRatingMenuItem = NO;
            }
            if ([TUICustomerServicePluginPrivateConfig sharedInstance].enableShowEndHumanService) {
                [TUICustomerServicePluginConfig sharedInstance].showEndHumanServiceMenuItem = NO;
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TUICustomerServiceMenuItemUpdatedNotification" object:nil];
    }
    
    return cellData;
}

+ (NSString *)getDisplayString:(V2TIMMessage *)message {
    NSDictionary *param = [NSJSONSerialization JSONObjectWithData:message.customElem.data
                                                          options:NSJSONReadingAllowFragments error:nil];
    if (param == nil) {
        return nil;
    }
    
    if ([param[@"src"] isEqualToString: BussinessID_Src_CustomerService_Timeout]) {
        return TDeskIMCommonLocalizableString(TUICustomerServiceTimeout);
    } else if ([param[@"src"] isEqualToString: BussinessID_Src_CustomerService_End]) {
        return TDeskIMCommonLocalizableString(TUICustomerServiceEnd);
    }
    
    return nil;
}

// Override
- (BOOL)shouldHide {
    return YES;
}

@end
