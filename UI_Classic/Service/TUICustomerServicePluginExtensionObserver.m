//
//  TUICustomerServicePluginExtensionObserver.m
//  TUICustomerServicePlugin
//
//  Created by xia on 2023/6/12.
//

#import "TUICustomerServicePluginExtensionObserver.h"
#import <TDeskCore/TDesk_TUICore.h>
#import <TDeskCore/TDesk_TUIDefine.h>
#import <TDeskCore/TDesk_TUIThemeManager.h>
#import "TUICustomerServicePluginDataProvider.h"
#import "TUICustomerServicePluginCardInputView.h"
#import "TUICustomerServicePluginConfig.h"
#import "TUICustomerServicePluginPrivateConfig.h"
#import "TUICustomerServicePluginAccountController.h"
#import "TUICustomerServicePluginMenuView.h"
#import "TUICustomerServicePluginPhraseView.h"
#import <TDeskChat/TDesk_TUIBaseChatViewController.h>
#import "TUICustomerServicePluginProductInfo.h"
#import "TUICustomerServicePluginUserController.h"

@interface TUICustomerServicePluginExtensionObserver () <TDeskExtensionProtocol>

@property (nonatomic, weak) TDeskBaseChatViewController *superVC;
@property (nonatomic, assign) CGFloat lastMenuHeight;

@end

@implementation TUICustomerServicePluginExtensionObserver

static id _instance = nil;
+ (void)load {
    [TDeskCore registerExtension:TDeskCore_TUIChatExtension_InputViewMoreItem_ClassicExtensionID object:TUICustomerServicePluginExtensionObserver.shareInstance];
    [TDeskCore registerExtension:TDeskCore_TUIContactExtension_ContactMenu_ClassicExtensionID object:TUICustomerServicePluginExtensionObserver.shareInstance];
    [TDeskCore registerExtension:TDeskCore_TUIChatExtension_ChatVCBottomContainer_ClassicExtensionID object:TUICustomerServicePluginExtensionObserver.shareInstance];
    [TDeskCore registerExtension:TDeskCore_TUIChatExtension_NavigationMoreItem_ClassicExtensionID object:TUICustomerServicePluginExtensionObserver.shareInstance];
    [TDeskCore registerExtension:TDeskCore_TUIChatExtension_ClickAvatar_ClassicExtensionID object:TUICustomerServicePluginExtensionObserver.shareInstance];
}

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

#pragma mark - TDeskExtensionProtocol
#pragma mark -- GetExtension
- (NSArray<TDeskExtensionInfo *> *)onGetExtension:(NSString *)extensionID param:(NSDictionary *)param {
    if (![extensionID isKindOfClass:NSString.class]) {
        return nil;
    }

    if ([extensionID isEqualToString:TDeskCore_TUIChatExtension_InputViewMoreItem_ClassicExtensionID]) {
        return [self getInputViewMoreItemExtensionForClassicChat:param];
    } else if ([extensionID isEqualToString:TDeskCore_TUIChatExtension_InputViewMoreItem_MinimalistExtensionID]) {
        return [self getInputViewMoreItemExtensionForMinimalistChat:param];
    } else if ([extensionID isEqualToString:TDeskCore_TUIContactExtension_ContactMenu_ClassicExtensionID]) {
        return [self getContactMenuExtensionForClassicChat:param];
    } else if ([extensionID isEqualToString:TDeskCore_TUIContactExtension_ContactMenu_MinimalistExtensionID]) {
        return [self getContactMenuExtensionForMinimalistChat:param];
    } else if ([extensionID isEqualToString:TDeskCore_TUIChatExtension_NavigationMoreItem_ClassicExtensionID]) {
        return [self getNavigationMoreItemExtensionForClassicChat:param];
    } else if ([extensionID isEqualToString:TDeskCore_TUIChatExtension_ClickAvatar_ClassicExtensionID]) {
        return [self getClickAvtarExtensionForClassicChat:param];
    } else {
        return nil;
    }
}

// InputViewMoreItem
- (NSArray<TDeskExtensionInfo *> *)getInputViewMoreItemExtensionForClassicChat:(NSDictionary *)param {
    if (![param isKindOfClass:NSDictionary.class]) {
        return nil;
    }
    NSString *userID = [param tdesk_objectForKey:TDeskCore_TUIChatExtension_InputViewMoreItem_UserID asClass:NSString.class];
    if (![TUICustomerServicePluginPrivateConfig.sharedInstance isCustomerServiceAccount:userID]) {
        return nil;
    }
    if (![TUICustomerServicePluginPrivateConfig sharedInstance].canEvaluate) {
        return nil;
    }
    
    TDeskExtensionInfo *evaluation = [[TDeskExtensionInfo alloc] init];
    evaluation.weight = 100;
    evaluation.text = TDeskIMCommonLocalizableString(TUIKitMoreEvaluation);
    evaluation.icon = TIMCommonBundleThemeImage(@"service_more_customer_service_evaluation_img", @"more_customer_service_evaluation");
    evaluation.onClicked = ^(NSDictionary *_Nonnull param) {
        NSData *data = [TDeskTool dictionary2JsonData:@{@"src": BussinessID_Src_CustomerService_EvaluationTrigger}];
        [TUICustomerServicePluginDataProvider sendCustomMessageWithoutUpdateUI:data];
    };
    return @[evaluation];
}

- (NSArray<TDeskExtensionInfo *> *)getInputViewMoreItemExtensionForMinimalistChat:(NSDictionary *)param {
    // TODO: ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ chat ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
    return nil;
}

// ContactMenu
- (NSArray<TDeskExtensionInfo *> *)getContactMenuExtensionForClassicChat:(NSDictionary *)param {
    if (![param isKindOfClass:NSDictionary.class]) {
        return nil;
    }
    [TUICustomerServicePluginPrivateConfig checkCommercialAbility];
    
    UINavigationController *nav = [param tdesk_objectForKey:TDeskCore_TUIContactExtension_ContactMenu_Nav asClass:UINavigationController.class];
    [TDeskTool addValueAddedUnsupportNeedContactNotificationInVC:nav debugOnly:YES];
    
    TDeskExtensionInfo *customerService = [[TDeskExtensionInfo alloc] init];
    customerService.weight = 50;
    customerService.text = TDeskIMCommonLocalizableString(TUICustomerServiceAccounts);
    customerService.icon = TUICustomerServicePluginBundleThemeImage(@"customer_service_contact_menu_icon_img", @"contact_customer_service");
    customerService.onClicked = ^(NSDictionary *_Nonnull param) {
        if (![TUICustomerServicePluginPrivateConfig isCustomerServiceSupported]) {
            [TDeskTool postValueAddedUnsupportNeedContactNotification:TDeskIMCommonLocalizableString(TUICustomerService)];
            NSLog(@"TUICustomerService ability is not supported");
            return;
        }
//        TUICustomerServicePluginAccountController *vc = [TUICustomerServicePluginAccountController new];
//        [nav pushViewController:vc animated:YES];
    };
    return @[customerService];
}

- (NSArray<TDeskExtensionInfo *> *)getContactMenuExtensionForMinimalistChat:(NSDictionary *)param {
    return nil;
}

// Navigation more item
- (NSArray<TDeskExtensionInfo *> *)getNavigationMoreItemExtensionForClassicChat:(NSDictionary *)param {
    if (![param isKindOfClass:NSDictionary.class]) {
        return nil;
    }
    NSString *userID = [param tdesk_objectForKey:TDeskCore_TUIChatExtension_NavigationMoreItem_UserID
                                       asClass:NSString.class];
    if (userID.length == 0 || ![TUICustomerServicePluginPrivateConfig.sharedInstance isCustomerServiceAccount:userID]) {
        return nil;
    }
    TDeskExtensionInfo *info = [[TDeskExtensionInfo alloc] init];
    info.icon = TUIContactBundleThemeImage(@"chat_nav_more_menu_img", @"chat_nav_more_menu");
    info.weight = 200;
    info.onClicked = ^(NSDictionary *_Nonnull param) {
        UINavigationController *nav = [param tdesk_objectForKey:TDeskCore_TUIChatExtension_NavigationMoreItem_PushVC
                                                      asClass:UINavigationController.class];
//        if (nav) {
//            [[V2TIMManager sharedInstance] getUsersInfo:@[userID]
//                                                   succ:^(NSArray<V2TIMUserFullInfo *> *infoList) {
//                TUICustomerServicePluginUserController *vc = [[TUICustomerServicePluginUserController alloc] initWithUserInfo:infoList.firstObject];
//                [nav pushViewController:vc animated:YES];
//            } fail:^(int code, NSString *desc) {
//                
//            }];
//        }
    };
    return @[info];
}

// Customizing action when clicking avatar
- (NSArray<TDeskExtensionInfo *> *)getClickAvtarExtensionForClassicChat:(NSDictionary *)param {
    if (![param isKindOfClass:NSDictionary.class]) {
        return nil;
    }
    NSString *userID = [param tdesk_objectForKey:TDeskCore_TUIChatExtension_ClickAvatar_UserID
                                       asClass:NSString.class];
    if (userID.length == 0 || ![TUICustomerServicePluginPrivateConfig.sharedInstance isCustomerServiceAccount:userID]) {
        return nil;
    }
    TDeskExtensionInfo *info = [[TDeskExtensionInfo alloc] init];
    info.onClicked = ^(NSDictionary *_Nonnull param) {
        UINavigationController *nav = [param tdesk_objectForKey:TDeskCore_TUIChatExtension_ClickAvatar_PushVC
                                                      asClass:UINavigationController.class];
//        if (nav) {
//            [[V2TIMManager sharedInstance] getUsersInfo:@[userID]
//                                                   succ:^(NSArray<V2TIMUserFullInfo *> *infoList) {
//                TUICustomerServicePluginUserController *vc = [[TUICustomerServicePluginUserController alloc] initWithUserInfo:infoList.firstObject];
//                [nav pushViewController:vc animated:YES];
//            } fail:^(int code, NSString *desc) {
//                
//            }];
//        }
    };
    return @[info];
}

#pragma mark -- RaiseExtension
- (BOOL)onRaiseExtension:(NSString *)extensionID parentView:(UIView *)parentView param:(nullable NSDictionary *)param {
    if ([extensionID isEqualToString:TDeskCore_TUIChatExtension_ChatVCBottomContainer_ClassicExtensionID]) {
        if (param == nil) {
            NSLog(@"TUIChat notify param is invalid");
            return NO;
        }
        NSString *userID = [param objectForKey:TDeskCore_TUIChatExtension_ChatVCBottomContainer_UserID];
        if (![parentView isKindOfClass:UIView.class]) {
            return NO;
        }
        self.superVC = [param objectForKey:TDeskCore_TUIChatExtension_ChatVCBottomContainer_VC];
        BOOL isExist = NO;
        for (UIView *subview in parentView.subviews) {
                    if ([subview isKindOfClass:[TUICustomerServicePluginMenuView class]]) {
                        [subview removeFromSuperview];
                        isExist = YES;
                        break;
                    }
                }
        NSArray *menuItems = TUICustomerServicePluginConfig.sharedInstance.menuItems;
        CGFloat height = (menuItems.count > 0) ? 46 : 0;
        
        // Only create and add view if there are menu items
        if (menuItems.count > 0) {
            TUICustomerServicePluginMenuView *view = [[TUICustomerServicePluginMenuView alloc] initWithDataSource:menuItems];
            [parentView addSubview:view];
            [view updateFrame];
        }
        
        // Always notify if height changed or if it's the first time
        if (!isExist || self.lastMenuHeight != height) {
            [self notifyHeightChanged:height];
            self.lastMenuHeight = height;
        }
        
        return YES;
    }
    return NO;
}

// Menu Event reponse
- (void)notifyHeightChanged:(CGFloat)height {
    NSDictionary *param = @{TDeskCore_TUIPluginNotify_PluginViewDidAddToSuperviewSubKey_PluginViewHeight: @(height)};
    [TDeskCore notifyEvent:TDeskCore_TUIPluginNotify
                  subKey:TDeskCore_TUIPluginNotify_PluginViewDidAddToSuperview
                  object:nil
                   param:param];
}

// Menu Event reponse
- (void)notifyHeightChangedSmaller {
    NSDictionary *param = @{TDeskCore_TUIPluginNotify_PluginViewDidAddToSuperviewSubKey_PluginViewHeight: @0};
    [TDeskCore notifyEvent:TDeskCore_TUIPluginNotify
                  subKey:TDeskCore_TUIPluginNotify_PluginViewDidAddToSuperview
                  object:nil
                   param:param];
}

- (void)onTextMessageClicked:(TUICustomerServicePluginMenuCellData *)menuCellData {
    NSString *text = menuCellData.title;
    [TUICustomerServicePluginDataProvider sendTextMessage:text];
}

- (void)onProductClicked {
    TUICustomerServicePluginProductInfo *info = TUICustomerServicePluginConfig.sharedInstance.productInfo;
    NSDictionary *dict = @{BussinessID_CustomerService: @0,
                           @"src": BussinessID_Src_CustomerService_Card,
                           @"content": @{@"header": info.title ?: @"",
                                         @"desc": info.desc ?: @"",
                                         @"pic": info.picURL ?: @"",
                                         @"url": info.linkURL ?: @""}
    };
    NSData *data = [TDeskTool dictionary2JsonData:dict];
    [TUICustomerServicePluginDataProvider sendCustomMessage:data];
}

- (void)onPhraseClicked {
    [self.superVC.inputController reset];
    TUICustomerServicePluginPhraseView *view = [[TUICustomerServicePluginPhraseView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    UIWindow *window = [TDeskTool applicationKeywindow];
    [window addSubview:view];
}

@end
