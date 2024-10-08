//
//  TUICustomerServicePluginMenuView.m
//  TUICustomerServicePlugin
//
//  Created by xia on 2023/6/29.
//

#import "TUICustomerServicePluginMenuView.h"
#import <TDeskCore/TUICore.h>
#import <TDeskCore/TUIDefine.h>
#import <TDeskCommon/TIMDefine.h>
#import "TUICustomerServicePluginDataProvider+CalculateSize.h"

@interface TUICustomerServicePluginMenuCellData()

@end

@implementation TUICustomerServicePluginMenuCellData

- (CGSize)calcSize {
    return [TUICustomerServicePluginDataProvider calcMenuCellSize:self.title];
}

@end


@interface TUICustomerServicePluginMenuCell()

@end

@implementation TUICustomerServicePluginMenuCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.button = [UIButton new];
        
        self.button.backgroundColor = TUICustomerServicePluginDynamicColor(@"customer_service_menu_button_bg_color", @"#FFFFFF");
        
        self.button.layer.borderWidth = 0.0;
        
        self.button.layer.cornerRadius = 16;
        
        self.button.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.button setTitleColor:TUICustomerServicePluginDynamicColor(@"customer_service_menu_button_text_color", @"#000000") forState:UIControlStateNormal];
        
        self.button.layer.shadowColor = TUICustomerServicePluginDynamicColor(@"customer_service_menu_button_shadow_color", @"#D3D3D3").CGColor;
        self.button.layer.shadowOpacity = 0.5;
        self.button.layer.shadowOffset = CGSizeMake(0, 1);
        self.button.layer.shadowRadius = 2;
        
        [self addSubview:self.button];
    }
    return self;
}

- (void)fillWithData:(TUICustomerServicePluginMenuCellData *)cellData {
    self.cellData = cellData;
    [self.button setTitle:cellData.title forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // tell constraints they need updating
    [self setNeedsUpdateConstraints];

    // update constraints now so we can animate the change
    [self updateConstraintsIfNeeded];

    [self layoutIfNeeded];
}

- (void)buttonClicked:(UIButton *)sender {
    if (self.cellData.onClick) {
        self.cellData.onClick();
    }
}

- (void)updateConstraints {
    [super updateConstraints];
    
    CGSize size = [TUICustomerServicePluginDataProvider calcMenuCellButtonSize:self.cellData.title];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(12);
        make.top.mas_equalTo(8);
        make.width.mas_equalTo(size.width);
        make.height.mas_equalTo(size.height);
    }];
}

@end

@interface TUICustomerServicePluginMenuView() <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *backView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation TUICustomerServicePluginMenuView

- (instancetype)initWithDataSource:(NSArray *)source {
    self = [super init];
    if (self) {
        self.dataSource = [source mutableCopy];
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.backView];
}

#pragma mark - Public
- (void)updateFrame {
    self.mm_left(0).mm_top(0).mm_width(Screen_Width).mm_height(46);
    self.backView.mm_fill();
}

#pragma mark - Getter
- (UICollectionView *)backView {
    if (!_backView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _backView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _backView.delegate = self;
        _backView.dataSource = self;
        _backView.scrollEnabled = YES;
        _backView.backgroundColor = [UIColor clearColor];
        _backView.showsHorizontalScrollIndicator = NO;
        [_backView registerClass:[TUICustomerServicePluginMenuCell class] forCellWithReuseIdentifier:@"menuCell"];
    }
    return _backView;
}

#pragma mark - UICollectionViewDataSource & Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TUICustomerServicePluginMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"menuCell" forIndexPath:indexPath];
    TUICustomerServicePluginMenuCellData *cellData = self.dataSource[indexPath.row];
    [cell fillWithData:cellData];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    TUICustomerServicePluginMenuCellData *cellData = self.dataSource[indexPath.row];
    return [cellData calcSize];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


@end
