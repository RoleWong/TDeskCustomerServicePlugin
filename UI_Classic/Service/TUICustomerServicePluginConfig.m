//
//  TUICustomerServicePluginConfig.m
//  TUICustomerServicePlugin
//
//  Created by xia on 2023/6/16.
//

#import "TUICustomerServicePluginConfig.h"
#import <TDeskCore/TDesk_TUICore.h>
#import <TDeskCore/TDesk_TUIDefine.h>
#import "TUICustomerServicePluginMenuView.h"
#import "TUICustomerServicePluginDataProvider.h"
#import "TUICustomerServicePluginExtensionObserver.h"
#import "TUICustomerServicePluginPrivateConfig.h"
#import "TUICustomerServicePluginProductInfo.h"

#pragma clang diagnostic ignored "-Wundeclared-selector"

@implementation TUICustomerServicePluginConfig

+ (TUICustomerServicePluginConfig *)sharedInstance {
    static dispatch_once_t onceToken;
    static TUICustomerServicePluginConfig * g_sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        g_sharedInstance = [[TUICustomerServicePluginConfig alloc] init];
        
    });
    return g_sharedInstance;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        // 显示人工服务（仅在转人工成功前显示）
        _showHumanServiceMenuItem = YES;
        // 显示服务评价（仅在转人工成功后显示）
        _showServiceRatingMenuItem = NO;
        // 显示结束对话（仅在转人工成功后显示）
        _showEndHumanServiceMenuItem = NO;
    }
    return self;
}

#pragma mark - Public
- (void)setCustomerServiceAccounts:(NSArray *)customerServiceAccounts {
    [TUICustomerServicePluginPrivateConfig sharedInstance].customerServiceAccounts = customerServiceAccounts;
}

- (NSArray *)menuItems {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pluginConfig:shouldUpdateOldMenuItems:)]) {
        return [self.delegate pluginConfig:self shouldUpdateOldMenuItems:[self defaultMenuItems]];
    }
    return [self defaultMenuItems];
}

- (NSArray *)commonPhrases {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pluginConfig:shouldUpdateCommonPhrases:)]) {
        return [self.delegate pluginConfig:self shouldUpdateCommonPhrases:[self defaultCommonPhrases]];
    }
    return [self defaultCommonPhrases];
}

- (TUICustomerServicePluginProductInfo *)productInfo {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pluginConfigShouldUpdateProductInfo:)]) {
        return [self.delegate pluginConfigShouldUpdateProductInfo:self];
    }
    return [self defaultProductInfo];
}

#pragma mark - Private
- (NSArray *)defaultMenuItems {
    NSMutableArray *dataSource = [NSMutableArray new];
    
    TUICustomerServicePluginPrivateConfig *privateConfig = [TUICustomerServicePluginPrivateConfig sharedInstance];

    if (privateConfig.enableShowHumanService && self.showHumanServiceMenuItem) {
        TUICustomerServicePluginMenuCellData *toHuman = [TUICustomerServicePluginMenuCellData new];
        NSString *toHumanMsg = TDeskIMCommonLocalizableString(TUICustomerHumanService);
        toHuman.title = toHumanMsg;
        toHuman.icon = TUICustomerServicePluginBundleThemeImage(@"to_human_img", @"to_human");
        toHuman.onClick = ^{
            [TUICustomerServicePluginDataProvider sendTextMessage:toHumanMsg];
        };
        [dataSource addObject:toHuman];
    }
    
    if (privateConfig.enableShowServiceRating && self.showServiceRatingMenuItem) {
        TUICustomerServicePluginMenuCellData *serviceRatingBtn = [TUICustomerServicePluginMenuCellData new];
        NSString *serviceRatingMsg = TDeskIMCommonLocalizableString(TUICustomerServiceRating);
        serviceRatingBtn.title = serviceRatingMsg;
        serviceRatingBtn.icon = TUICustomerServicePluginBundleThemeImage(@"service_rating_img", @"service_rating");
        serviceRatingBtn.onClick = ^{
            NSString *language = [TDeskGlobalization getPreferredLanguage];
            NSData *data = [TDeskTool dictionary2JsonData:@{@"src": BussinessID_Src_CustomerService_EvaluationTrigger,
                                                            @"customerServicePlugin": @0,
                                                            @"triggeredContent": @{@"language": language}
                                                          }];
            [TUICustomerServicePluginDataProvider sendCustomMessageWithoutUpdateUI:data];
        };
        [dataSource addObject:serviceRatingBtn];
    }
    
    if (privateConfig.enableShowEndHumanService && self.showEndHumanServiceMenuItem) {
        TUICustomerServicePluginMenuCellData *endServiceBtn = [TUICustomerServicePluginMenuCellData new];
        NSString *endHumanServiceMsg = TDeskIMCommonLocalizableString(TUICustomerEndService);
        endServiceBtn.title = endHumanServiceMsg;
        endServiceBtn.icon = TUICustomerServicePluginBundleThemeImage(@"end_human_service_img", @"end_human_service");
        endServiceBtn.onClick = ^{
            
            NSString *language = [TDeskGlobalization getPreferredLanguage];
            NSData *data = [TDeskTool dictionary2JsonData:@{@"src": BussinessID_Src_CustomerService_End_Session,
                                                            @"customerServicePlugin": @0,
                                                            @"triggeredContent": @{@"language": language}
                                                          }];
            [TUICustomerServicePluginDataProvider sendCustomMessageWithoutUpdateUI:data];
        };
        [dataSource addObject:endServiceBtn];
    }
    
    return [dataSource copy];
}

- (NSArray *)defaultCommonPhrases {
    return @[
        TDeskIMCommonLocalizableString(TUICustomerServiceCommonPhraseStock),
        TDeskIMCommonLocalizableString(TUICustomerServiceCommonPhraseCheaper),
        TDeskIMCommonLocalizableString(TUICustomerServiceCommonPhraseGift),
        TDeskIMCommonLocalizableString(TUICustomerServiceCommonPhraseShipping),
        TDeskIMCommonLocalizableString(TUICustomerServiceCommonPhraseDelivery),
        TDeskIMCommonLocalizableString(TUICustomerServiceCommonPhraseArrive),
    ];
}

- (TUICustomerServicePluginProductInfo *)defaultProductInfo {
    TUICustomerServicePluginProductInfo *info = [TUICustomerServicePluginProductInfo new];
    info.title = @"手工编织皮革提包2023新品女士迷你简约大方高端有档次";
    info.desc = @"¥788";
    info.picURL = @"https://qcloudimg.tencent-cloud.cn/raw/a811f634eab5023f973c9b224bc07a51.png";
    info.linkURL = @"https://cloud.tencent.com/document/product/269";
    return info;
}

@end
