//
//  TUIBotBranchCell.m
//  TUICustomerServicePlugin
//
//  Created by lynx on 2023/10/30.
//

#import "TUIBotBranchCell.h"
#import "TUICustomerServicePluginDataProvider.h"
#import "TUICustomerServicePluginDataProvider+CalculateSize.h"
#import <TDeskCommon/TDesk_TIMDefine.h>
#import <TDeskCommon/TDesk_TIMRTLUtil.h>
#import <TDeskCore/TDesk_TUICore.h>

@implementation TUIBotBranchItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        _containerView = [[UIView alloc] init];
        _containerView.layer.borderColor = [UIColor colorWithRed:0.0/255.0 green:110.0/255.0 blue:255.0/255.0 alpha:0.3].CGColor;
        _containerView.layer.borderWidth = 0.5;
        _containerView.layer.cornerRadius = 20;
        _containerView.layer.masksToBounds = YES;
        _contentLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_containerView];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.textColor = [UIColor colorWithRed:0.0/255.0 green:110.0/255.0 blue:255.0/255.0 alpha:1.0];
        _contentLabel.numberOfLines = 1;
        [_containerView addSubview:_contentLabel];
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    
    [_containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(4);
        make.bottom.mas_equalTo(-4);
        make.height.mas_greaterThanOrEqualTo(40);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.9);
    }];
    
    [_contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_containerView);
        make.centerY.mas_equalTo(_containerView);
        make.leading.mas_greaterThanOrEqualTo(_containerView.mas_leading).offset(20);
        make.trailing.mas_greaterThanOrEqualTo(_containerView.mas_trailing).offset(-20);
//        make.top.mas_greaterThanOrEqualTo(_containerView.mas_top).offset(10);
        make.bottom.mas_greaterThanOrEqualTo(_containerView.mas_bottom).offset(-10);
    }];
}
@end


#define BranchItemCellMaxCountPerPage 4
@interface TUIBotBranchCell() <UITableViewDelegate, UITableViewDataSource>

@end

@implementation TUIBotBranchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _headerBkView = [[UIImageView alloc] init];
//        UIImage *headerBkImage = TUICustomerServicePluginBundleThemeImage(@"bot_branch_cell_head_bk_img", @"branch_cell_head_bk");
//        [_headerBkView setImage:[headerBkImage rtl_imageFlippedForRightToLeftLayoutDirection]];
        [self.container addSubview:_headerBkView];
        
//        _headerDotView = [[UIImageView alloc] init];
//        [_headerDotView setBackgroundColor:TUICustomerServicePluginDynamicColor(@"bot_branch_cell_header_dot_color", @"#000000")];
//        _headerDotView.layer.cornerRadius = kScale375(8) / 2;
//        _headerDotView.layer.masksToBounds = YES;
//        [self.container addSubview:_headerDotView];
        
        _headerLabel = [[UILabel alloc] init];
        _headerLabel.font = [UIFont systemFontOfSize:14];
        _headerLabel.numberOfLines = 0;
        _headerLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _headerLabel.textColor = TUICustomerServicePluginDynamicColor(@"bot_branch_cell_header_text_color_1", @"#000000");
        [self.container addSubview:_headerLabel];
        
        _headerRefreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _headerRefreshBtn.backgroundColor = [UIColor clearColor];
        [_headerRefreshBtn setTitle:TDeskIMCommonLocalizableString(TUIChatBotChangeQuestion) forState:UIControlStateNormal];
        [_headerRefreshBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_headerRefreshBtn setTitleColor:TUICustomerServicePluginDynamicColor(@"bot_branch_cell_refresh_btn_color", @"#006EFF") forState:UIControlStateNormal];
        [_headerRefreshBtn addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventTouchUpInside];
        [self.container addSubview:_headerRefreshBtn];
        
        _headerRefreshView = [[UIImageView alloc] init];
        [_headerRefreshView setImage:TUICustomerServicePluginBundleThemeImage(@"bot_branch_cell_refresh_img", @"branch_cell_refresh")];
        UITapGestureRecognizer *tag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onRefresh)];
        [_headerRefreshView addGestureRecognizer:tag];
        _headerRefreshView.userInteractionEnabled = YES;
        [self.container addSubview:_headerRefreshView];

        _itemsTableView = [[UITableView alloc] init];
        _itemsTableView.tableFooterView = [[UIView alloc] init];
//        _itemsTableView.backgroundColor = TUICoreDynamicColor(@"customer_service_brance_bg_color", @"#FFFFFF");
        _itemsTableView.backgroundColor = [UIColor clearColor];
        _itemsTableView.delegate = self;
        _itemsTableView.dataSource = self;
        _itemsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_itemsTableView registerClass:[TUIBotBranchItemCell class] forCellReuseIdentifier:@"item_cell"];
        [self.container addSubview:_itemsTableView];
    }
    return self;
}

- (void)onRefresh {
    if (!self.customData || 0 == self.customData.items.count) {
        return;
    }
    
    NSUInteger pageCount = self.customData.items.count / BranchItemCellMaxCountPerPage;
    if (self.customData.items.count % BranchItemCellMaxCountPerPage > 0) {
        pageCount++;
    }

    NSUInteger oldPageIndex = self.customData.pageIndex;
    if (self.customData.pageIndex < pageCount - 1) {
        self.customData.pageIndex++;
    } else {
        self.customData.pageIndex = 0;
    }

    if (self.customData.pageIndex != oldPageIndex) {
        NSUInteger location = self.customData.pageIndex * BranchItemCellMaxCountPerPage;
        NSUInteger length = MIN(self.customData.items.count - location, BranchItemCellMaxCountPerPage);
        self.customData.pageItems = [self.customData.items subarrayWithRange:NSMakeRange(location, length)];

        [self notifyCellSizeChanged];
    }
}

- (void)notifyCellSizeChanged {
    NSDictionary *param = @{TDeskCore_TUIPluginNotify_PluginViewSizeChangedSubKey_Message : self.customData.innerMessage};
    [TDeskCore notifyEvent:TDeskCore_TUIPluginNotify
                  subKey:TDeskCore_TUIPluginNotify_PluginViewSizeChangedSubKey
                  object:nil
                   param:param];
}

- (void)fillWithData:(TUIBotBranchCellData *)data {
    [super fillWithData:data];
    
    self.customData = data;
    self.headerLabel.text = data.header;
    if (BranchMsgSubType_Welcome == data.subType) {
//        self.headerDotView.hidden = NO;
        self.headerRefreshBtn.hidden = NO;
        self.headerRefreshView.hidden = NO;
        self.headerBkView.hidden = NO;
        self.headerLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        self.headerLabel.textColor = TUICustomerServicePluginDynamicColor(@"bot_branch_cell_header_text_color_1", @"#000000");
    } else {
//        self.headerDotView.hidden = YES;
        self.headerRefreshBtn.hidden = YES;
        self.headerRefreshView.hidden = YES;
        self.headerBkView.hidden = YES;
        self.headerLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        self.headerLabel.textColor = TUICustomerServicePluginDynamicColor(@"bot_branch_cell_header_text_color_2", @"#000000");
    }
    [self.itemsTableView reloadData];
    
    // tell constraints they need updating
    [self setNeedsUpdateConstraints];

    // update constraints now so we can animate the change
    [self updateConstraintsIfNeeded];

    [self layoutIfNeeded];
}

// Override, the size of bubble content.
+ (CGSize)getContentSize:(TDeskMessageCellData *)data {
    NSAssert([data isKindOfClass:TUIBotBranchCellData.class],
             @"data must be a kind of TUIBotBranchCellData");
    TUIBotBranchCellData *branchCellData = (TUIBotBranchCellData *)data;
    if (!branchCellData.pageItems) {
        if (BranchMsgSubType_Welcome == branchCellData.subType) {
            branchCellData.pageItems = [branchCellData.items subarrayWithRange:
                                        NSMakeRange(0, MIN(branchCellData.items.count, BranchItemCellMaxCountPerPage))];
        } else {
            branchCellData.pageItems = branchCellData.items;
        }
    }
    return [TUICustomerServicePluginDataProvider calcBranchCellSize:branchCellData.header items:branchCellData.pageItems];
}

- (void)updateConstraints {
    [super updateConstraints];

    CGFloat cellHeight = [TUICustomerServicePluginDataProvider calcBranchCellSize:self.customData.header
                                                                    items:self.customData.pageItems].height;
    CGSize tableViewSize = [TUICustomerServicePluginDataProvider calcBranchCellSizeOfTableView:self.customData.pageItems];
    CGSize headerLabelSize = [TUICustomerServicePluginDataProvider calcBranchCellSizeOfHeader:self.customData.header];
    CGSize headerSize = CGSizeMake(self.container.mm_w, headerLabelSize.height + TUIBotBranchCellMargin + TUIBotBranchCellInnerMargin);
    
    self.container
        .mm_width(TUIBotBranchCellWidth)
        .mm_height(cellHeight);
    
    if (BranchMsgSubType_Welcome == self.customData.subType) {
        [self.headerBkView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(headerSize.width);
            make.height.mas_equalTo(headerSize.height);
        }];
        
//        [self.headerDotView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.leading.mas_equalTo(TUIBotBranchCellMargin);
//            make.centerY.mas_equalTo(self.headerBkView);
//            make.width.mas_equalTo(TUIBotBranchCellInnerMargin);
//            make.height.mas_equalTo(TUIBotBranchCellInnerMargin);
//        }];
        
        [self.headerRefreshView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(self.container.mas_trailing).offset(-TUIBotBranchCellMargin);
            make.centerY.mas_equalTo(self.headerBkView);
            make.width.mas_equalTo(12);
            make.height.mas_equalTo(16);
        }];
        
        [self.headerRefreshBtn sizeToFit];
        [self.headerRefreshBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(self.headerRefreshView.mas_leading).offset(-TUIBotBranchCellMargin);
            make.centerY.mas_equalTo(self.headerBkView);
            make.size.mas_equalTo(self.headerRefreshBtn.frame.size);
        }];
        
        [self.headerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(TUIBotBranchCellMargin);
//            make.leading.mas_equalTo(self.headerDotView.mas_trailing).offset(TUIBotBranchCellMargin);
            make.trailing.mas_equalTo(self.headerRefreshBtn.mas_leading).offset(-TUIBotBranchCellMargin);
            make.centerY.mas_equalTo(self.headerBkView);
            make.height.mas_equalTo(headerLabelSize.height);
        }];
    } else {
        [self.headerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(TUIBotBranchCellMargin);
            make.top.mas_equalTo(TUIBotBranchCellMargin);
            make.width.mas_equalTo(headerLabelSize.width);
            make.height.mas_equalTo(headerLabelSize.height);
        }];
    }
    
    [self.itemsTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(0);
        make.top.mas_equalTo(headerSize.height);
        make.width.mas_equalTo(tableViewSize.width);
        make.height.mas_equalTo(tableViewSize.height);
    }];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [TUICustomerServicePluginDataProvider calcBranchCellHeightOfTableView:self.customData.pageItems row:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.customData.pageItems.count <= indexPath.row) {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    NSString *content = self.customData.pageItems[indexPath.row];
    [TUICustomerServicePluginDataProvider sendTextMessage:content];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.customData.pageItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.customData.pageItems.count <= indexPath.row) {
        return nil;
    }
    TUIBotBranchItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"item_cell" forIndexPath:indexPath];
    cell.subType = BranchMsgSubType_Clarify;
    cell.contentLabel.text = self.customData.pageItems[indexPath.row];
    
    // tell constraints they need updating
    [cell setNeedsUpdateConstraints];

    // update constraints now so we can animate the change
    [cell updateConstraintsIfNeeded];

    [cell layoutIfNeeded];
    return cell;
}

@end
