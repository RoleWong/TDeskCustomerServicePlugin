//
//  TUICustomerServicePluginTaskBranchCell.m
//  TDeskCustomerServicePlugin
//
//  Created by Role Wong on 11/8/24.
//

#import <Foundation/Foundation.h>
#import "TUICustomerServicePluginTaskBranchCell.h"
#import "TUICustomerServicePluginDataProvider.h"
#import "TUICustomerServicePluginDataProvider+CalculateSize.h"
#import <TDeskCore/TDesk_TUICore.h>

@implementation TUICustomerServicePluginTaskBranchItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = TUICustomerServicePluginDynamicColor(@"customer_service_card_backview_bg_color", @"#FFFFFF");
        _containerView.layer.borderColor = [UIColor colorWithRed:0.0/255.0 green:110.0/255.0 blue:255.0/255.0 alpha:0.3].CGColor;
        _containerView.layer.borderWidth = 0.75;
        _containerView.layer.cornerRadius = 20;
        _containerView.layer.masksToBounds = YES;
        [self.contentView addSubview:_containerView];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.textColor = [UIColor colorWithRed:28.0/255.0 green:102.0/255.0 blue:230.0/255.0 alpha:1.0];
        _contentLabel.numberOfLines = 1;
        [_containerView addSubview:_contentLabel];
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    
    [_containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(4);
        make.bottom.mas_equalTo(-4);
        make.height.mas_greaterThanOrEqualTo(36);
    }];
    
    [_contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_containerView);
        make.centerY.mas_equalTo(_containerView);
        make.leading.mas_greaterThanOrEqualTo(_containerView.mas_leading).offset(20);
        make.trailing.mas_greaterThanOrEqualTo(_containerView.mas_trailing).offset(-20);
    }];
}

@end


@interface TUICustomerServicePluginTaskBranchCell() <UITableViewDelegate, UITableViewDataSource, TUINotificationProtocol>

@end

@implementation TUICustomerServicePluginTaskBranchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupHeaderLabel];
        [self setupListCollectionViews];
        
        [TDeskCore registerEvent:TUICore_TUIChatNotify
                        subKey:TUICore_TUIChatNotify_KeyboardWillHideSubKey
                        object:self];
    }
    return self;
}

- (void)setupHeaderLabel {
    _headerView = [[UIView alloc] init];
    _headerView.backgroundColor = TUICustomerServicePluginDynamicColor(@"customer_service_card_backview_bg_color", @"#FFFFFF");
    _headerView.layer.cornerRadius = 8.0;
    _headerView.clipsToBounds = YES;
    
    _headerViewLabel = [[UILabel alloc] init];
    _headerViewLabel.font = [UIFont systemFontOfSize:16];
    _headerViewLabel.numberOfLines = 0;
    _headerViewLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _headerViewLabel.textColor = TUICustomerServicePluginDynamicColor(@"customer_service_collection_header_text_color", @"#000000");

    [self.headerView addSubview:_headerViewLabel];
    _headerView.translatesAutoresizingMaskIntoConstraints = NO;
    _headerViewLabel.translatesAutoresizingMaskIntoConstraints = NO;

    [self.container addSubview:_headerView];
}

- (void)setupListCollectionViews {
    _itemsTableView = [[UITableView alloc] init];
    _itemsTableView.tableFooterView = [[UIView alloc] init];
    _itemsTableView.backgroundColor = [UIColor clearColor];
    _itemsTableView.delegate = self;
    _itemsTableView.dataSource = self;
    _itemsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_itemsTableView registerClass:[TUICustomerServicePluginTaskBranchItemCell class] forCellReuseIdentifier:@"item_cell"];
    [self.container addSubview:_itemsTableView];
}

- (void)fillWithData:(TUICustomerServicePluginTaskBranchCellData *)data {
    [super fillWithData:data];
    
    self.customData = data;
    self.headerViewLabel.text = data.header;
    
    [self.itemsTableView reloadData];
    
    // tell constraints they need updating
    [self setNeedsUpdateConstraints];

    // update constraints now so we can animate the change
    [self updateConstraintsIfNeeded];

    [self layoutIfNeeded];
}

// Override, the size of bubble content
+ (CGSize)getContentSize:(TUICustomerServicePluginTaskBranchCellData *)data {
    return [TUICustomerServicePluginDataProvider calcCollectionCellSize:data.header items:data.items];
}

- (void)updateConstraints {
    [super updateConstraints];

    CGFloat cellHeight = [TUICustomerServicePluginDataProvider calcBranchCellSize:self.customData.header
                                                              items:self.customData.items].height;
    CGSize tableViewSize = [TUICustomerServicePluginDataProvider calcCollectionCellSizeOfTableView:self.customData.items];
    CGSize headerSize= [TUICustomerServicePluginDataProvider calcCollectionCellSizeOfHeader:self.customData.header];
    
    self.bubbleView.image = nil;
    
    self.container
        .mm_width(TUICustomerServicePluginBranchCellWidth)
        .mm_height(cellHeight);
    
    [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(TUICustomerServicePluginBranchCellMargin);
        make.height.mas_equalTo(headerSize.height + 20);
    }];
    
     [NSLayoutConstraint activateConstraints:@[
         [self.headerViewLabel.leadingAnchor constraintEqualToAnchor:_headerView.leadingAnchor constant:12],
         [self.headerViewLabel.trailingAnchor constraintEqualToAnchor:_headerView.trailingAnchor constant:-12],
         [self.headerViewLabel.topAnchor constraintEqualToAnchor:_headerView.topAnchor constant:10],
         [self.headerViewLabel.bottomAnchor constraintEqualToAnchor:_headerView.bottomAnchor constant:-10]
     ]];
    
    [self.itemsTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(0);
        make.top.mas_equalTo(self.headerView.mas_bottom).offset(TUICustomerServicePluginBranchCellInnerMargin);
        make.width.mas_equalTo(tableViewSize.width);
        make.height.mas_equalTo(tableViewSize.height);
    }];
}

- (void)notifyCellSizeChanged {
    NSDictionary *param = @{TUICore_TUIPluginNotify_PluginViewSizeChangedSubKey_Message : self.customData.innerMessage};
    [TDeskCore notifyEvent:TUICore_TUIPluginNotify
                  subKey:TUICore_TUIPluginNotify_PluginViewSizeChangedSubKey
                  object:nil
                   param:param];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [TUICustomerServicePluginDataProvider calcCollectionCellHeightOfTableView:self.customData.items row:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.customData.items.count <= indexPath.row) {
        return;
    }
    NSString *content = self.customData.items[indexPath.row];
    [self.customData.items removeAllObjects];
    [self notifyCellSizeChanged];
        
    [TUICustomerServicePluginDataProvider sendTextMessage:content];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.customData.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.customData.items.count <= indexPath.row) {
        return nil;
    }
    NSString *content = self.customData.items[indexPath.row];
    TUICustomerServicePluginTaskBranchItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"item_cell" forIndexPath:indexPath];
    cell.contentLabel.text = content;
    // tell constraints they need updating
    [cell setNeedsUpdateConstraints];

    // update constraints now so we can animate the change
    [cell updateConstraintsIfNeeded];

    [cell layoutIfNeeded];
    return cell;
}

#pragma mark - TUINotificationProtocol
- (void)onNotifyEvent:(NSString *)key subKey:(NSString *)subKey object:(nullable id)anObject param:(nullable NSDictionary *)param {
    if ([key isEqualToString:TUICore_TUIChatNotify] &&
        [subKey isEqualToString:TUICore_TUIChatNotify_KeyboardWillHideSubKey]) {
    }
}

@end
