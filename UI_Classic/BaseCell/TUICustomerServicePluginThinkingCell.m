//
//  TUICustomerServicePluginThinkingCell.m
//  Pods
//
//  Created by gavinwjwang on 2025/4/24.
//

#import "TUICustomerServicePluginThinkingCell.h"
//#import <SVGKit/SVGKit.h>
#import <TDeskCore/TDesk_TUICore.h>

@implementation TUICustomerServicePluginThinkingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _circleView = [[UIView alloc] init];
        _circleView.frame = CGRectMake(0, 0, 80, 46);
        _circleView.backgroundColor = TUICustomerServicePluginDynamicColor(@"customer_service_card_backview_bg_color", @"#FFFFFF");//  [UIColor redColor];
        
        _circleView.layer.cornerRadius = 8;
        _circleView.clipsToBounds = YES;
        
        _circleView.translatesAutoresizingMaskIntoConstraints = NO;

        NSString *bundlePath = TDeskBundlePath(TUICustomerServicePluginBundle,TUICustomerServicePluginBundle_Key_Class);
        NSBundle *customBundle = [NSBundle bundleWithPath:bundlePath];
        
        NSString *imageName = @"loading_message";
        
        UIImage *image = [UIImage imageNamed:imageName inBundle:customBundle compatibleWithTraitCollection:nil];
        if (image) {
            self.circle1 = [[UIImageView alloc] initWithImage:image];
            self.circle1.frame = CGRectMake(10, 13, 20, 20);
            self.circle1.contentMode = UIViewContentModeScaleAspectFit;
            [self.circleView addSubview:self.circle1];
            
            self.circle2 = [[UIImageView alloc] initWithImage:image];
            self.circle2.frame = CGRectMake(30, 13, 20, 20);
            self.circle2.contentMode = UIViewContentModeScaleAspectFit;
            [self.circleView addSubview:self.circle2];
            
            self.circle3 = [[UIImageView alloc] initWithImage:image];
            self.circle3.frame = CGRectMake(50, 13, 20, 20);
            self.circle3.contentMode = UIViewContentModeScaleAspectFit;
            [self.circleView addSubview:self.circle3];
            
            [self.bubbleView addSubview:_circleView];
            [self startAnimation];
        }
    }
    return self;
}

- (void)startAnimation {
    NSTimeInterval animationDuration = 1.0; // 动画时长，单位秒
    NSTimeInterval delay = 0.2; // 延迟时间，单位秒
    
    // 第一个圆圈的动画
    CAAnimationGroup *animatorSet1 = [self createAnimatorSet:self.circle1 duration:animationDuration];
    [self.circle1.layer addAnimation:animatorSet1 forKey:@"animation1"];
    
    // 第二个圆圈的动画，添加延迟
    CAAnimationGroup *animatorSet2 = [self createAnimatorSet:self.circle2 duration:animationDuration];
    animatorSet2.beginTime = CACurrentMediaTime() + delay;
    [self.circle2.layer addAnimation:animatorSet2 forKey:@"animation2"];
    
    // 第三个圆圈的动画，添加两倍延迟
    CAAnimationGroup *animatorSet3 = [self createAnimatorSet:self.circle3 duration:animationDuration];
    animatorSet3.beginTime = CACurrentMediaTime() + 2 * delay;
    [self.circle3.layer addAnimation:animatorSet3 forKey:@"animation3"];
}

- (CAAnimationGroup *)createAnimatorSet:(UIImageView *)imageView duration:(NSTimeInterval)duration {
    // 透明度动画
    CABasicAnimation *alphaAnimator = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimator.fromValue = @(1.0);
    alphaAnimator.toValue = @(0.2);
    alphaAnimator.duration = duration;
    alphaAnimator.repeatCount = HUGE_VALF;
    alphaAnimator.autoreverses = YES;
    
    // 缩放动画 - X 轴
    CABasicAnimation *scaleXAnimator = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    scaleXAnimator.fromValue = @(1.0);
    scaleXAnimator.toValue = @(0.6);
    scaleXAnimator.duration = duration;
    scaleXAnimator.repeatCount = HUGE_VALF;
    scaleXAnimator.autoreverses = YES;
    
    // 缩放动画 - Y 轴
    CABasicAnimation *scaleYAnimator = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    scaleYAnimator.fromValue = @(1.0);
    scaleYAnimator.toValue = @(0.6);
    scaleYAnimator.duration = duration;
    scaleYAnimator.repeatCount = HUGE_VALF;
    scaleYAnimator.autoreverses = YES;
    
    CAAnimationGroup *animatorSet = [CAAnimationGroup animation];
    animatorSet.animations = @[alphaAnimator, scaleXAnimator, scaleYAnimator];
    animatorSet.duration = duration;
    animatorSet.repeatCount = HUGE_VALF;
    return animatorSet;
}


- (void)fillWithData:(TUICustomerServicePluginThinkingCellData *)data {
    [super fillWithData:data];
    self.thinkingData = data;
    if ([data thinkingStatus] == 0) {
        _circleView.frame = CGRectMake(0, 0, 80, 46);
        self.circle3.hidden = false;
        self.contentView.frame = CGRectMake(0, 0, 80, 46);
        self.frame = CGRectMake(0, 0, 80, 46);
        self.hidden = false;

        self.circle1.hidden = false;
        self.circle2.hidden = false;
        self.circle3.hidden = false;
        [self startAnimation];
        [self hideViewAfterDelay:60];
    } else {
         [self hideThinkingView];
    }
    // tell constraints they need updating
    [self setNeedsUpdateConstraints];
    
    // update constraints now so we can animate the change
    [self updateConstraintsIfNeeded];
    
    [self layoutIfNeeded];
}

- (void)hideViewAfterDelay:(NSTimeInterval)delay {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideThinkingView];
        [self notifyCellSizeChanged];
    });
}

- (void)hideThinkingView {
    _circleView.frame = CGRectMake(0, 0, 0, 0);
//    self.circleView.hidden = YES;
//    self.circle3.hidden = YES;
}

+ (CGFloat)getHeight:(TUICustomerServicePluginThinkingCellData *)data withWidth:(CGFloat)width {
    CGFloat height = [super getHeight:data withWidth:width];
    if (data == nil)
        return 0;
    if ([data thinkingStatus] == 0) {
        return height;
    }
    return 0;
}

- (void)updateConstraints {
    [super updateConstraints];
}

- (void)notifyCellSizeChanged {
    if (self.thinkingData == nil)
        return;
    NSDictionary *param = @{TDeskCore_TUIPluginNotify_PluginViewSizeChangedSubKey_Message : self.thinkingData.innerMessage};
    [TDeskCore notifyEvent:TDeskCore_TUIPluginNotify
                  subKey:TDeskCore_TUIPluginNotify_PluginViewSizeChangedSubKey
                  object:nil
                  param:param];
}


@end
