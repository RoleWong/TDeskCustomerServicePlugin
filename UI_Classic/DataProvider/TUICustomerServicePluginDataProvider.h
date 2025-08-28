//
//  TUICustomerServicePluginDataProvider.h
//  Masonry
//
//  Created by xia on 2023/6/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TUICustomerServicePluginDataProvider : NSObject

+ (void)sendTextMessage:(NSString *)text;
+ (void)sendTextMessageWithCloudData:(NSString *)text cloudCustomData:(NSData *)cloudCustomData;
+ (void)sendCustomMessage:(NSData *)data;
+ (void)sendCustomMessageWithoutUpdateUI:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
