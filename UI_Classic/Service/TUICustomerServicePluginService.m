//
//  TUICustomerServicePluginService.m
//  TUICustomerServicePlugin
//
//  Created by xia on 2023/5/30.
//

#import "TUICustomerServicePluginService.h"
#import <TDeskChat/TDesk_TUIChatConfig.h>
#import <TDeskChat/TDesk_TUIChatConversationModel.h>
#import <TDeskCommon/TDesk_TIMDefine.h>
#import <TDeskCore/TDesk_TUIThemeManager.h>
#import <TDeskCore/TDesk_TUICore.h>
#import <TDeskCore/TDesk_TUILogin.h>
#import "TUICustomerServicePluginDataProvider.h"
#import "TUICustomerServicePluginPrivateConfig.h"
#import "TUICustomerServicePluginExtensionObserver.h"

@interface TUICustomerServicePluginService() <TDeskNotificationProtocol, TDeskExtensionProtocol>

@end

@implementation TUICustomerServicePluginService

+ (void)load {
    NSLog(@"TUICustomerServicePluginService load");
    [TUICustomerServicePluginService sharedInstance];
    TDeskRegisterThemeResourcePath(TUICustomerServicePluginThemePath, TUIThemeModuleCustomerService);
}

+ (TUICustomerServicePluginService *)sharedInstance {
    static dispatch_once_t onceToken;
    static TUICustomerServicePluginService * g_sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        g_sharedInstance = [[TUICustomerServicePluginService alloc] init];
    });
    return g_sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        [self registerEvent];
        [self registerExtension];
        [self registerCustomMessageCell];
    }
    return self;
}

- (void)registerEvent {
    [TDeskCore registerEvent:TUICore_TDeskNotify
                    subKey:TUICore_TDeskNotify_ChatVC_ViewDidLoadSubKey
                    object:self];
}

- (void)registerExtension {
    [TDeskCore registerExtension:TUICore_TUIChatExtension_GetChatConversationModelParams object:self];
}

- (void)registerCustomMessageCell {
    [TDeskCore callService:TUICore_TUIChatService
                  method:TUICore_TUIChatService_AppendCustomMessageMethod
                   param:@{BussinessID : GetCustomerServiceBussinessID(BussinessID_Src_CustomerService_Evaluation),
                           TMessageCell_Name : @"TUICustomerServicePluginEvaluationCell",
                           TMessageCell_Data_Name : @"TUICustomerServicePluginEvaluationCellData"
                         }
    ];
    [TDeskCore callService:TUICore_TUIChatService
                  method:TUICore_TUIChatService_AppendCustomMessageMethod
                   param:@{BussinessID : GetCustomerServiceBussinessID(BussinessID_Src_CustomerService_EvaluationSelected),
                           TMessageCell_Name : @"TUICustomerServicePluginInvisibleCell",
                           TMessageCell_Data_Name : @"TUICustomerServicePluginInvisibleCellData"
                         }
    ];
    [TDeskCore callService:TUICore_TUIChatService
                  method:TUICore_TUIChatService_AppendCustomMessageMethod
                   param:@{BussinessID : GetCustomerServiceBussinessID(BussinessID_Src_CustomerService_Typing),
                           TMessageCell_Name : @"TDeskMessageCell",
                           TMessageCell_Data_Name : @"TUICustomerServicePluginTypingCellData"
                         }
    ];
    [TDeskCore callService:TUICore_TUIChatService
                  method:TUICore_TUIChatService_AppendCustomMessageMethod
                   param:@{BussinessID : GetCustomerServiceBussinessID(BussinessID_Src_CustomerService_Branch),
                           TMessageCell_Name : @"TUICustomerServicePluginBranchCell",
                           TMessageCell_Data_Name : @"TUICustomerServicePluginBranchCellData"
                         }
    ];
    [TDeskCore callService:TUICore_TUIChatService
                  method:TUICore_TUIChatService_AppendCustomMessageMethod
                   param:@{BussinessID : GetCustomerServiceBussinessID(BussinessID_Src_CustomerService_End),
                           TMessageCell_Name : @"TDeskMessageCell",
                           TMessageCell_Data_Name : @"TUICustomerServicePluginInvisibleCellData"
                         }
    ];
    [TDeskCore callService:TUICore_TUIChatService
                  method:TUICore_TUIChatService_AppendCustomMessageMethod
                   param:@{BussinessID : GetCustomerServiceBussinessID(BussinessID_Src_CustomerService_Timeout),
                           TMessageCell_Name : @"TUICustomerServicePluginInvisibleCell",
                           TMessageCell_Data_Name : @"TUICustomerServicePluginInvisibleCellData"
                         }
    ];
    [TDeskCore callService:TUICore_TUIChatService
                  method:TUICore_TUIChatService_AppendCustomMessageMethod
                   param:@{BussinessID : GetCustomerServiceBussinessID(BussinessID_Src_CustomerService_EvaluationRule),
                           TMessageCell_Name : @"TUICustomerServicePluginInvisibleCell",
                           TMessageCell_Data_Name : @"TUICustomerServicePluginInvisibleCellData"
                         }
    ];
    [TDeskCore callService:TUICore_TUIChatService
                  method:TUICore_TUIChatService_AppendCustomMessageMethod
                   param:@{BussinessID : GetCustomerServiceBussinessID(BussinessID_Src_CustomerService_EvaluationTrigger),
                           TMessageCell_Name : @"TUICustomerServicePluginInvisibleCell",
                           TMessageCell_Data_Name : @"TUICustomerServicePluginInvisibleCellData"
                         }
    ];
    [TDeskCore callService:TUICore_TUIChatService
                  method:TUICore_TUIChatService_AppendCustomMessageMethod
                   param:@{BussinessID : GetCustomerServiceBussinessID(BussinessID_Src_CustomerService_Collection),
                           TMessageCell_Name : @"TUICustomerServicePluginCollectionCell",
                           TMessageCell_Data_Name : @"TUICustomerServicePluginCollectionCellData"
                         }
    ];
    [TDeskCore callService:TUICore_TUIChatService
                  method:TUICore_TUIChatService_AppendCustomMessageMethod
                   param:@{BussinessID : GetCustomerServiceBussinessID(BussinessID_Src_CustomerService_TASK_BRANCH),
                           TMessageCell_Name : @"TUICustomerServicePluginTaskBranchCell",
                           TMessageCell_Data_Name : @"TUICustomerServicePluginTaskBranchCellData"
                         }
    ];
    [TDeskCore callService:TUICore_TUIChatService
                  method:TUICore_TUIChatService_AppendCustomMessageMethod
                   param:@{BussinessID : GetCustomerServiceBussinessID(BussinessID_Src_CustomerService_TASK_INFORMATION_COLLECTOR),
                           TMessageCell_Name : @"TUICustomerServicePluginTaskInformationCollectorCell",
                           TMessageCell_Data_Name : @"TUICustomerServicePluginTaskInformationCollectorCellData"
                         }
    ];
    [TDeskCore callService:TUICore_TUIChatService
                  method:TUICore_TUIChatService_AppendCustomMessageMethod
                   param:@{BussinessID : GetCustomerServiceBussinessID(BussinessID_Src_CustomerService_Card),
                           TMessageCell_Name : @"TUICustomerServicePluginCardCell",
                           TMessageCell_Data_Name : @"TUICustomerServicePluginCardCellData"
                         }
    ];
    [TDeskCore callService:TUICore_TUIChatService
                      method:TUICore_TUIChatService_AppendCustomMessageMethod
                       param:@{BussinessID : GetCustomerServiceBussinessID(BussinessID_Src_CustomerService_Bot_Welcome_Clarify),
                               TMessageCell_Name : @"TUIBotBranchCell",
                               TMessageCell_Data_Name : @"TUIBotBranchCellData"
                             }
        ];
    [TDeskCore callService:TUICore_TUIChatService
                  method:TUICore_TUIChatService_AppendCustomMessageMethod
                   param:@{BussinessID : GetCustomerServiceBussinessID(BussinessID_Src_CustomerService_Bot_Rich_Text),
                           TMessageCell_Name : @"TUIBotRichTextCell",
                           TMessageCell_Data_Name : @"TUIBotRichTextCellData"
                         }
    ];
    [TDeskCore callService:TUICore_TUIChatService
                  method:TUICore_TUIChatService_AppendCustomMessageMethod
                   param:@{BussinessID : GetCustomerServiceBussinessID(BussinessID_Src_CustomerService_Bot_Stream_Text),
                           TMessageCell_Name : @"TUIBotStreamTextCell",
                           TMessageCell_Data_Name : @"TUIBotStreamTextCellData"
                         }
    ];
}

#pragma mark - TDeskNotificationProtocol
- (void)onNotifyEvent:(NSString *)key subKey:(NSString *)subKey object:(nullable id)anObject param:(nullable NSDictionary *)param {
    if ([key isEqualToString:TUICore_TDeskNotify] &&
        [subKey isEqualToString:TUICore_TDeskNotify_ChatVC_ViewDidLoadSubKey]) {
        if (param == nil) {
            NSLog(@"TUIChat notify param is invalid");
            return;
        }
        NSString *userID = [param objectForKey:TUICore_TUIChatNotify_ChatVC_ViewDidLoadSubKey_UserID];
        if (![TUICustomerServicePluginPrivateConfig.sharedInstance isCustomerServiceAccount:userID]) {
            return;
        }
        NSString *language = [self getPreferredLanguage];
        NSData *data = [TDeskTool dictionary2JsonData:@{@"src": BussinessID_Src_CustomerService_Request,
                                                        @"customerServicePlugin": @0,
                                                        @"triggeredContent": @{@"language": language}
                                                      }];
        [TUICustomerServicePluginDataProvider sendCustomMessageWithoutUpdateUI:data];
    }
}

- (NSString *)getPreferredLanguage {
    NSString *appLanguage = [NSLocale preferredLanguages].firstObject;
    
    NSDictionary *languageMap = @{
        @"zh-Hans": @"zh",
        @"zh-Hant": @"zh-TW",
        @"zh-TW": @"zh-TW",
        @"en": @"en",
        @"id": @"id",
        @"vi": @"vi",
        @"ja": @"ja",
        @"fil": @"fil"
    };
    
    for (NSString *key in languageMap.allKeys) {
        if ([appLanguage hasPrefix:key]) {
            return languageMap[key];
        }
    }
    
    return @"en";
}

#pragma mark - TDeskExtensionProtocol
- (nullable NSArray<TDeskExtensionInfo *> *)onGetExtension:(NSString *)extensionID param:(nullable NSDictionary *)param {
    if ([extensionID isEqualToString:TUICore_TUIChatExtension_GetChatConversationModelParams]) {
        if (extensionID == nil) {
            NSLog(@"extensionID is invalid");
            return nil;
        }
        NSString *userID = [param objectForKey:TUICore_TUIChatExtension_GetChatConversationModelParams_UserID];
        if (!userID || ![TUICustomerServicePluginPrivateConfig.sharedInstance isCustomerServiceAccount:userID]) {
            return nil;
        }
        TDeskExtensionInfo *extensionInfo = [[TDeskExtensionInfo alloc] init];
        extensionInfo.data = @{TUICore_TUIChatExtension_GetChatConversationModelParams_MsgNeedReadReceipt : @(YES),
                               TUICore_TUIChatExtension_GetChatConversationModelParams_EnableVideoCall : @(NO),
                               TUICore_TUIChatExtension_GetChatConversationModelParams_EnableAudioCall : @(NO),
                               TUICore_TUIChatExtension_GetChatConversationModelParams_EnableWelcomeCustomMessage : @(NO)};
        return @[extensionInfo];
    }
    return nil;
}

@end
