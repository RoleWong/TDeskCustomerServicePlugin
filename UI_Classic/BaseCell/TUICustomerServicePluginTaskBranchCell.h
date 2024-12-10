//
//  TUICustomerServicePluginTaskBranchCell.h
//  TDeskCustomerServicePlugin
//
//  Created by Role Wong on 11/8/24.
//


#import "TUICustomerServicePluginTaskBranchCellData.h"

#ifndef TUICustomerServicePluginTaskBranchCell_h
#define TUICustomerServicePluginTaskBranchCell_h

NS_ASSUME_NONNULL_BEGIN

@interface TUICustomerServicePluginTaskBranchItemCell : UITableViewCell

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *containerView;

@end

@interface TUICustomerServicePluginTaskBranchCell : TUIBubbleMessageCell

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *headerViewLabel;
@property (nonatomic, strong) UITableView *itemsTableView;
@property (nonatomic, strong) UIButton *confirmButton;

- (void)fillWithData:(TUICustomerServicePluginTaskBranchCellData *)data;

@property (nonatomic, strong) TUICustomerServicePluginTaskBranchCellData *customData;

@end

NS_ASSUME_NONNULL_END


#endif /* TUICustomerServicePluginTaskBranchCell_h */
