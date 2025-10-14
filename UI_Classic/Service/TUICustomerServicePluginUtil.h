//
//  TUICustomerServicePluginUtil.h
//  Pods
//
//  Created by Role Wong on 2025/8/28.
//

#import <Foundation/Foundation.h>
#import <ImSDK_Plus/ImSDK_Plus.h>

@interface TUICustomerServicePluginUtil : NSObject

+ (BOOL)canShowAINote:(V2TIMMessage *)message;

+ (NSArray<NSString *> *)aiNoteMessageTypeList;

@end
