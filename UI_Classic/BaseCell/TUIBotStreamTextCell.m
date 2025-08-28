//
//  TUIChatBotStreamTextCell.m
//  TUICustomerServicePlugin
//
//  Created by lynx on 2023/10/30.
//

#import "TUIBotStreamTextCell.h"
#import <TDeskCommon/TDesk_TIMDefine.h>
#import <TDeskCore/TDesk_TUICore.h>

@implementation TUIBotStreamTextCell
- (void)fillWithData:(TUIBotStreamTextCellData *)data {
    [super fillWithData:data];
    // 在线 Push 的文本需要流式展示
    if (Msg_Source_OnlinePush == data.source) {
        data.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        NSTimeInterval period = 0.05;
        dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, period * NSEC_PER_SEC);
        dispatch_source_set_timer(data.timer, start, period * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(data.timer, ^{
            if (data.displayedContentLength == data.contentString.length) {
                [self stopTimer:data.timer];
                return;
            }
            data.displayedContentLength++;

            if (self.textView.attributedText.length > 1 &&
                [self getAttributeStringRect:self.textView.attributedText].size.height >
                [self getAttributeStringRect:[self.textView.attributedText attributedSubstringFromRange:
                                              NSMakeRange(0, self.textView.attributedText.length - 1)]].size.height) {
                [self stopTimer:data.timer];
                [self notifyCellSizeChanged];
            } else {
                UIColor *textColor = self.class.incommingTextColor;
                UIFont *textFont = self.class.incommingTextFont;
                if (data.direction == MsgDirectionIncoming) {
                    textColor = self.class.incommingTextColor;
                    textFont = self.class.incommingTextFont;
                } else {
                    textColor = self.class.outgoingTextColor;
                    textFont = self.class.outgoingTextFont;
                }
                self.textView.attributedText = [data getContentAttributedString:textFont];
                self.textView.textColor = textColor;
                [self updateCellConstraints];
            }
        });
        dispatch_resume(data.timer);
    }
    
    UILabel *aiDisclaimerLabel = [[UILabel alloc] init];
    aiDisclaimerLabel.text = TDeskIMCommonLocalizableString(TUIAILabel);
    aiDisclaimerLabel.textColor = [UIColor colorWithRed:0.58 green:0.60 blue:0.62 alpha:1.0];
    aiDisclaimerLabel.font = [UIFont systemFontOfSize:12.0];
    aiDisclaimerLabel.textAlignment = NSTextAlignmentLeft;

    [self.bottomContainer addSubview:aiDisclaimerLabel];

    aiDisclaimerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [aiDisclaimerLabel.leadingAnchor constraintEqualToAnchor:self.bottomContainer.leadingAnchor],
        [aiDisclaimerLabel.topAnchor constraintEqualToAnchor:self.bottomContainer.topAnchor],
        [aiDisclaimerLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.bottomContainer.trailingAnchor]
    ]];
}

- (CGRect)getAttributeStringRect:(NSAttributedString *)attributeString {
    return [attributeString boundingRectWithSize:CGSizeMake(TTextMessageCell_Text_Width_Max, MAXFLOAT)
            options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
}

- (void)stopTimer:(dispatch_source_t)timer {
    if (timer) {
        dispatch_source_cancel(timer);
        timer = nil;
    }
}

- (void)notifyCellSizeChanged {
    NSDictionary *param = @{TDeskCore_TUIPluginNotify_PluginViewSizeChangedSubKey_Message : self.textData.innerMessage};
    [TDeskCore notifyEvent:TDeskCore_TUIPluginNotify
                  subKey:TDeskCore_TUIPluginNotify_PluginViewSizeChangedSubKey
                  object:nil
                   param:param];
}

- (void)updateCellConstraints {
    // tell constraints they need updating
    [self setNeedsUpdateConstraints];
    // update constraints now so we can animate the change
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
}

@end
