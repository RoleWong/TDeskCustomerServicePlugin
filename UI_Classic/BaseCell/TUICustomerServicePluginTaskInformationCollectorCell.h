//
//  TUICustomerServicePluginTaskInformationCollectorCell.h
//  TDeskCustomerServicePlugin
//
//  Created by Role Wong on 11/14/24.
//

#import "TUICustomerServicePluginTaskInformationCollectorCellData.h"

#ifndef TUICustomerServicePluginTaskInformationCollectorCell_h
#define TUICustomerServicePluginTaskInformationCollectorCell_h

@interface TaskInformationColloctorModalView : UIView

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UIStackView *formStackView;
@property (nonatomic) BOOL inPreviewMode;
@property (nonatomic) BOOL keyboardShow;

@end

@interface TUICustomerServicePluginTaskInformationCollectorCell : TUIBubbleMessageCell

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic) BOOL canClick;

- (void)fillWithData:(TUICustomerServicePluginTaskInformationCollectorCellData *)data;

@property (nonatomic, strong) TUICustomerServicePluginTaskInformationCollectorCellData *customData;

@end

#endif /* TUICustomerServicePluginTaskInformationCollectorCell_h */
