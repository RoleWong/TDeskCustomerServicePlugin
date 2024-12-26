//
//  TUICustomerServicePluginTaskInformationCollectorCell.m
//  TDeskCustomerServicePlugin
//
//  Created by Role Wong on 11/14/24.
//

#import <Foundation/Foundation.h>
#import "TUICustomerServicePluginTaskInformationCollectorCell.h"
#import "TUICustomerServicePluginDataProvider.h"
#import "TUICustomerServicePluginDataProvider+CalculateSize.h"
#import <TDeskCore/TDesk_TUICore.h>

@implementation TaskInformationColloctorModalView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)tip inputVariables:(NSArray *)inputVariables inPreviewMode:(BOOL)inPreviewMode {
    self = [super initWithFrame:frame];
    if (self) {
        self.inPreviewMode = inPreviewMode;
        [self setupBackground];
        [self setupTopViewWithTip:tip];
        [self setupFormWithInputVariables:inputVariables];
        if(!inPreviewMode){
            [self setupSubmitButton];
        }
        self.keyboardShow = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}

- (void)dismissKeyboard {
    [self endEditing:YES];
    if (self.keyboardShow) {
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectMake(self.frame.origin.x,
                                    [UIScreen mainScreen].bounds.size.height - self.frame.size.height,
                                    self.frame.size.width,
                                    self.frame.size.height);
        }];
        self.keyboardShow = NO;
    }
}

- (void)keyboardWillShow:(NSNotification *)notification {
    if (self.keyboardShow) {
        return;
    }
    self.keyboardShow = YES;
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = keyboardFrame.size.height;

    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(self.frame.origin.x,
                                self.frame.origin.y - keyboardHeight / 4 * 3,
                                self.frame.size.width,
                                self.frame.size.height);
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if (!self.keyboardShow) {
        return;
    }
    [self dismissKeyboard];
}

- (void)setupBackground {
    self.layer.cornerRadius = 16;
    self.layer.masksToBounds = YES;
    
    self.backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    UIImage *backgroundImage = TUIChatBundleThemeImage(@"chat_customer_bg_img", @"more_file");
    if (backgroundImage) {
        self.layer.contents = (id)backgroundImage.CGImage;
        self.layer.contentsGravity = kCAGravityResizeAspectFill;
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
}


- (void)setupTopViewWithTip:(NSString *)tip {
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 50)];
    [self addSubview:topView];
    
    // Tip Label
    self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, self.bounds.size.width - 60, 30)];
    self.tipLabel.text = tip;
    self.tipLabel.font = [UIFont boldSystemFontOfSize:18];
    self.tipLabel.textColor = [UIColor blackColor];
    [topView addSubview:self.tipLabel];
    
    // Close Button
    self.closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.closeButton.frame = CGRectMake(self.bounds.size.width - 40, 10, 30, 30);
    [self.closeButton setTitle:@"✕" forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(closeModal) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:self.closeButton];
}

- (void)setupFormWithInputVariables:(NSArray *)inputVariables {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(15, 60, self.bounds.size.width - 30, self.bounds.size.height - 140)];
    self.scrollView.showsVerticalScrollIndicator = YES;
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
    [self addSubview:self.scrollView];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapGesture.cancelsTouchesInView = NO;
    [self.scrollView addGestureRecognizer:tapGesture];

    self.formStackView = [[UIStackView alloc] init];
    self.formStackView.axis = UILayoutConstraintAxisVertical;
    self.formStackView.spacing = 0;
    self.formStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.formStackView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.formStackView.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor],
        [self.formStackView.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor],
        [self.formStackView.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor],
        [self.formStackView.bottomAnchor constraintEqualToAnchor:self.scrollView.bottomAnchor],
        [self.formStackView.widthAnchor constraintEqualToAnchor:self.scrollView.widthAnchor]
    ]];
    
    for (NSDictionary *variable in inputVariables) {
        NSString *type = variable[@"formType"];
        NSString *name = variable[@"name"];
        NSString *placeholder = variable[@"placeholder"];
        NSString *value = variable[@"variableValue"] ?: @"";
        BOOL isRequired = [variable[@"isRequired"] boolValue];
        
        if ([type integerValue] == 0) {
            // 输入框类型
            UIView *inputItemView = [self createInputItemWithName:name placeholder:placeholder value:value isRequired:isRequired];
            [self.formStackView addArrangedSubview:inputItemView];
        } else if ([type integerValue] == 1) {
            // 单选按钮类型
            UIView *selectionItemView = [self createSelectionItemWithName:name options:variable[@"chooseItemList"] value:value isRequired:isRequired];
            [self.formStackView addArrangedSubview:selectionItemView];
        }
    }
}


#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.scrollView scrollRectToVisible:textField.frame animated:YES];
}

- (UIView *)createInputItemWithName:(NSString *)name
                         placeholder:(NSString *)placeholder
                        value:(NSString *)value
                          isRequired:(BOOL)isRequired {
    UIView *inputItemView = [[UIView alloc] init];
    inputItemView.translatesAutoresizingMaskIntoConstraints = NO;

    UIView *nameContainerView = [[UIView alloc] init];
    nameContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [inputItemView addSubview:nameContainerView];

    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = name;
    nameLabel.accessibilityIdentifier = @"fieldName";
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [nameContainerView addSubview:nameLabel];

    UILabel *requiredLabel = [[UILabel alloc] init];
    requiredLabel.text = isRequired ? @"*" : @"";
    requiredLabel.accessibilityIdentifier = @"isRequired";
    requiredLabel.font = [UIFont systemFontOfSize:16];
    requiredLabel.textColor = [UIColor redColor];
    requiredLabel.translatesAutoresizingMaskIntoConstraints = NO;
    requiredLabel.hidden = !isRequired;
    [nameContainerView addSubview:requiredLabel];

    UITextField *inputField = [[UITextField alloc] init];
    inputField.font = [UIFont systemFontOfSize:16];
    inputField.textColor = [UIColor blackColor];
    inputField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    inputField.borderStyle = UITextBorderStyleNone;
    inputField.translatesAutoresizingMaskIntoConstraints = NO;
    inputField.delegate = self;
    if(self.inPreviewMode){
        inputField.text = value;
        inputField.enabled = NO;
    }
    [inputItemView addSubview:inputField];

    UILabel *errorLabel = [[UILabel alloc] init];
    errorLabel.text = TIMCommonLocalizableString(TUICustomerTaskFieldRequired);
    errorLabel.font = [UIFont systemFontOfSize:12];
    errorLabel.accessibilityIdentifier = @"errorLabel";
    errorLabel.textColor = [UIColor redColor];
    errorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    errorLabel.hidden = YES;
    [inputItemView addSubview:errorLabel];

    UIView *separatorLine = [[UIView alloc] init];
    separatorLine.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
    separatorLine.translatesAutoresizingMaskIntoConstraints = NO;
    [inputItemView addSubview:separatorLine];

    [NSLayoutConstraint activateConstraints:@[
        [nameContainerView.leadingAnchor constraintEqualToAnchor:inputItemView.leadingAnchor],
        [nameContainerView.centerYAnchor constraintEqualToAnchor:inputItemView.centerYAnchor],
        [nameContainerView.widthAnchor constraintEqualToConstant:85],

        [nameLabel.leadingAnchor constraintEqualToAnchor:nameContainerView.leadingAnchor],
        [nameLabel.centerYAnchor constraintEqualToAnchor:nameContainerView.centerYAnchor],

        [requiredLabel.leadingAnchor constraintEqualToAnchor:nameLabel.trailingAnchor constant:2],
        [requiredLabel.centerYAnchor constraintEqualToAnchor:nameLabel.centerYAnchor],
        [requiredLabel.trailingAnchor constraintLessThanOrEqualToAnchor:nameContainerView.trailingAnchor],

        [inputField.leadingAnchor constraintEqualToAnchor:nameContainerView.trailingAnchor constant:10],
        [inputField.trailingAnchor constraintEqualToAnchor:inputItemView.trailingAnchor],
        [inputField.centerYAnchor constraintEqualToAnchor:inputItemView.centerYAnchor],
        [inputField.heightAnchor constraintEqualToConstant:36],

        [errorLabel.topAnchor constraintEqualToAnchor:inputField.bottomAnchor constant:4],
        [errorLabel.leadingAnchor constraintEqualToAnchor:inputField.leadingAnchor],
        [errorLabel.trailingAnchor constraintEqualToAnchor:inputField.trailingAnchor],

        [separatorLine.leadingAnchor constraintEqualToAnchor:inputItemView.leadingAnchor],
        [separatorLine.trailingAnchor constraintEqualToAnchor:inputItemView.trailingAnchor],
        [separatorLine.topAnchor constraintEqualToAnchor:errorLabel.bottomAnchor constant:2],
        [separatorLine.heightAnchor constraintEqualToConstant:1],

        [inputItemView.heightAnchor constraintEqualToAnchor:inputField.heightAnchor constant:32] // 额外空间给错误提示和分割线
    ]];

    return inputItemView;
}

- (UIView *)createSelectionItemWithName:(NSString *)name
                                options:(NSArray<NSString *> *)options
                                  value:(NSString *)value
                             isRequired:(BOOL)isRequired {
    UIView *selectionItemView = [[UIView alloc] init];
    selectionItemView.translatesAutoresizingMaskIntoConstraints = NO;

    UIView *nameContainerView = [[UIView alloc] init];
    nameContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [selectionItemView addSubview:nameContainerView];

    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.accessibilityIdentifier = @"fieldName";
    nameLabel.text = name;
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [nameContainerView addSubview:nameLabel];

    UILabel *requiredLabel = [[UILabel alloc] init];
    requiredLabel.text = isRequired ? @"*" : @"";
    requiredLabel.accessibilityIdentifier = @"isRequired";
    requiredLabel.font = [UIFont systemFontOfSize:16];
    requiredLabel.textColor = [UIColor redColor];
    requiredLabel.translatesAutoresizingMaskIntoConstraints = NO;
    requiredLabel.hidden = !isRequired;
    [nameContainerView addSubview:requiredLabel];

    UIStackView *optionsStackView = [[UIStackView alloc] init];
    optionsStackView.axis = UILayoutConstraintAxisVertical;
    optionsStackView.spacing = 0;
    optionsStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [selectionItemView addSubview:optionsStackView];

    UILabel *errorLabel = [[UILabel alloc] init];
    errorLabel.text = TIMCommonLocalizableString(TUICustomerTaskSelectionFieldRequired);
    errorLabel.accessibilityIdentifier = @"errorLabel";
    errorLabel.font = [UIFont systemFontOfSize:12];
    errorLabel.textColor = [UIColor redColor];
    errorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    errorLabel.hidden = YES;
    [selectionItemView addSubview:errorLabel];

    for (NSString *option in options) {
        UIView *optionView = [[UIView alloc] init];
        optionView.translatesAutoresizingMaskIntoConstraints = NO;

        UIButton *radioButton = [UIButton buttonWithType:UIButtonTypeCustom];
        radioButton.translatesAutoresizingMaskIntoConstraints = NO;
        radioButton.layer.cornerRadius = 10;
        radioButton.layer.borderWidth = 1.0;
        radioButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        radioButton.backgroundColor = [UIColor clearColor];
        [radioButton setImage:nil forState:UIControlStateNormal];
        [radioButton setImage:[UIImage systemImageNamed:@"checkmark"] forState:UIControlStateSelected];
        [radioButton setTintColor:[UIColor whiteColor]];
        if(self.inPreviewMode && option == value){
            radioButton.selected = YES;
            radioButton.backgroundColor = [UIColor systemBlueColor];
            radioButton.layer.borderColor = [UIColor clearColor].CGColor;
        }
        [optionView addSubview:radioButton];

        UILabel *optionLabel = [[UILabel alloc] init];
        optionLabel.text = option;
        optionLabel.font = [UIFont systemFontOfSize:16];
        optionLabel.textColor = [UIColor blackColor];
        optionLabel.translatesAutoresizingMaskIntoConstraints = NO;
        optionLabel.numberOfLines = 1;
        optionLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [optionView addSubview:optionLabel];

        UIView *separatorLine = [[UIView alloc] init];
        separatorLine.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
        separatorLine.translatesAutoresizingMaskIntoConstraints = NO;
        [optionView addSubview:separatorLine];

        [radioButton addTarget:self action:@selector(handleOptionSelection:) forControlEvents:UIControlEventTouchUpInside];
        radioButton.tag = optionsStackView.arrangedSubviews.count;

        [NSLayoutConstraint activateConstraints:@[
            [radioButton.leadingAnchor constraintEqualToAnchor:optionView.leadingAnchor constant:10],
            [radioButton.centerYAnchor constraintEqualToAnchor:optionView.centerYAnchor],
            [radioButton.widthAnchor constraintEqualToConstant:20],
            [radioButton.heightAnchor constraintEqualToConstant:20],

            [optionLabel.leadingAnchor constraintEqualToAnchor:radioButton.trailingAnchor constant:10],
            [optionLabel.trailingAnchor constraintEqualToAnchor:optionView.trailingAnchor constant:-10],
            [optionLabel.centerYAnchor constraintEqualToAnchor:optionView.centerYAnchor],

            [separatorLine.leadingAnchor constraintEqualToAnchor:optionView.leadingAnchor],
            [separatorLine.trailingAnchor constraintEqualToAnchor:optionView.trailingAnchor],
            [separatorLine.bottomAnchor constraintEqualToAnchor:optionView.bottomAnchor],
            [separatorLine.heightAnchor constraintEqualToConstant:1],

            [optionView.heightAnchor constraintEqualToConstant:56]
        ]];

        [optionsStackView addArrangedSubview:optionView];
    }

    [NSLayoutConstraint activateConstraints:@[
        [nameContainerView.leadingAnchor constraintEqualToAnchor:selectionItemView.leadingAnchor],
        [nameContainerView.topAnchor constraintEqualToAnchor:selectionItemView.topAnchor constant:27],
        [nameContainerView.widthAnchor constraintEqualToConstant:85],

        [nameLabel.leadingAnchor constraintEqualToAnchor:nameContainerView.leadingAnchor],
        [nameLabel.centerYAnchor constraintEqualToAnchor:nameContainerView.centerYAnchor],

        [requiredLabel.leadingAnchor constraintEqualToAnchor:nameLabel.trailingAnchor constant:2],
        [requiredLabel.centerYAnchor constraintEqualToAnchor:nameLabel.centerYAnchor],
        [requiredLabel.trailingAnchor constraintLessThanOrEqualToAnchor:nameContainerView.trailingAnchor],

        [optionsStackView.leadingAnchor constraintEqualToAnchor:nameContainerView.trailingAnchor constant:10],
        [optionsStackView.trailingAnchor constraintEqualToAnchor:selectionItemView.trailingAnchor],
        [optionsStackView.topAnchor constraintEqualToAnchor:selectionItemView.topAnchor],
        [optionsStackView.bottomAnchor constraintEqualToAnchor:errorLabel.topAnchor constant:-4],

        [errorLabel.leadingAnchor constraintEqualToAnchor:optionsStackView.leadingAnchor],
        [errorLabel.trailingAnchor constraintEqualToAnchor:optionsStackView.trailingAnchor],
        [errorLabel.bottomAnchor constraintEqualToAnchor:selectionItemView.bottomAnchor],
    ]];

    return selectionItemView;
}

#pragma mark - 单选逻辑
- (void)handleOptionSelection:(UIButton *)sender {
    if(self.inPreviewMode){
        return;
    }
    UIView *parentView = sender.superview.superview;
    for (UIView *outerSubviews in parentView.subviews) {
        for (UIView *subview in outerSubviews.subviews) {
            if ([subview isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)subview;
                button.selected = NO;
                button.backgroundColor = [UIColor clearColor];
                button.layer.borderColor = [UIColor lightGrayColor].CGColor;
            }
        }
    }

    sender.selected = YES;
    sender.backgroundColor = [UIColor systemBlueColor];
    sender.layer.borderColor = [UIColor clearColor].CGColor;
}

- (void)selectOption:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (void)setupSubmitButton {
    self.submitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.submitButton.frame = CGRectMake((self.bounds.size.width - 100) / 2, self.bounds.size.height - 70, 100, 40);
    [self.submitButton setTitle:TIMCommonLocalizableString(TUICustomerSubmit) forState:UIControlStateNormal];
    self.submitButton.backgroundColor = [UIColor systemBlueColor];
    [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.submitButton.layer.cornerRadius = 8;
    [self.submitButton addTarget:self action:@selector(submitForm) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.submitButton];
}

- (void)closeModal {
    [self removeFromSuperview];
    [self.backgroundView removeFromSuperview];
}

- (void)submitForm {
    NSMutableArray *formFields = [NSMutableArray array];
    BOOL canSend = YES;

    for (UIView *itemView in self.formStackView.arrangedSubviews) {
        NSMutableDictionary *fieldData = [NSMutableDictionary dictionary];
        UILabel *nameLabel = nil;
        UITextField *inputField = nil;
        UILabel *requiredLabel = nil;
        UILabel *errorLabel = nil;
        UIStackView *optionsStackView = nil;
        BOOL isRequired = NO;

        for (UIView *subview in itemView.subviews) {
            if ([subview isKindOfClass:[UILabel class]]) {
                UILabel *label = (UILabel *)subview;
                if ([label.accessibilityIdentifier isEqualToString:@"errorLabel"]) {
                    errorLabel = label;
                }
            } else if ([subview isKindOfClass:[UITextField class]]) {
                inputField = (UITextField *)subview;
            } else if ([subview isKindOfClass:[UIStackView class]]) {
                optionsStackView = (UIStackView *)subview;
            } else if ([subview isKindOfClass:[UIView class]]) {
                for (UIView *innerView in subview.subviews) {
                    if ([innerView isKindOfClass:[UILabel class]]) {
                        UILabel *label = (UILabel *)innerView;
                        if ([label.accessibilityIdentifier isEqualToString:@"fieldName"]) {
                            nameLabel = label;
                        } else if ([label.accessibilityIdentifier isEqualToString:@"isRequired"]) {
                            requiredLabel = label;
                            isRequired = [requiredLabel.text containsString:@"*"];
                        }
                    }
                }
            }
        }

        if (inputField) {
            NSString *name = nameLabel.text;
            NSString *value = inputField.text ?: @"";
            fieldData[@"name"] = name;
            fieldData[@"value"] = value;
            fieldData[@"isRequired"] = @(isRequired);

            if (isRequired && value.length == 0) {
                canSend = NO;
                errorLabel.hidden = NO;
                NSLog(@"字段 %@ 是必填项，但未填写", name);
            } else {
                errorLabel.hidden = YES;
            }
        }

        if (optionsStackView) {
            NSString *name = nameLabel.text;
            NSString *selectedValue = nil;

            for (UIView *optionView in optionsStackView.arrangedSubviews) {
                for (UIView *optionSubview in optionView.subviews) {
                    if ([optionSubview isKindOfClass:[UIButton class]]) {
                        UIButton *radioButton = (UIButton *)optionSubview;
                        if (radioButton.isSelected) {
                            UILabel *optionLabel = nil;
                            for (UIView *optionSubviewInner in optionView.subviews) {
                                if ([optionSubviewInner isKindOfClass:[UILabel class]]) {
                                    optionLabel = (UILabel *)optionSubviewInner;
                                    break;
                                }
                            }
                            selectedValue = optionLabel.text;
                            break;
                        }
                    }
                }
                if (selectedValue) break;
            }

            fieldData[@"name"] = name;
            fieldData[@"value"] = selectedValue ?: @"";
            fieldData[@"isRequired"] = @(isRequired);

            if (isRequired && !selectedValue) {
                canSend = NO;
                errorLabel.hidden = NO;
                NSLog(@"字段 %@ 是必选项，但未选择", name);
            } else {
                errorLabel.hidden = YES;
            }
        }

        if (fieldData.count > 0) {
            [formFields addObject:fieldData];
        }
    }

    if (canSend) {
        NSError *error = nil;
        NSMutableArray *inputVariables = [NSMutableArray array];

        for (NSDictionary *field in formFields) {
            NSString *name = field[@"name"];
            NSString *value = field[@"value"];
            BOOL isRequired = [field[@"isRequired"] boolValue];

            NSDictionary *inputVariable = @{
                @"name": name,
                @"isRequired": @(isRequired ? 1 : 0),
                @"variableValue": value
            };
            [inputVariables addObject:inputVariable];
        }

        NSDictionary *finalJSON = @{
            @"customerServicePlugin": @0,
            @"src": @"33",
            @"content": @{
                @"inputVariables": inputVariables
            }
        };
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:finalJSON options:NSJSONWritingPrettyPrinted error:&error];
        if (!error) {
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"表单提交数据: %@", jsonString);
            [TUICustomerServicePluginDataProvider sendCustomMessageWithoutUpdateUI:jsonData];
            [self closeModal];
        } else {
            NSLog(@"表单提交数据解析失败: %@", error.localizedDescription);
        }
    }
}


- (void)showInView:(UIView *)parentView {
    [parentView addSubview:self.backgroundView];
    [parentView addSubview:self];
    
    [parentView bringSubviewToFront:self];
}

@end


@interface TUICustomerServicePluginTaskInformationCollectorCell() <TUINotificationProtocol>

@end

@implementation TUICustomerServicePluginTaskInformationCollectorCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.iconImageView = [[UIImageView alloc] init];
        self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.iconImageView.image = TUICustomerServicePluginBundleThemeImage(@"information_collection", @"information_collection"); // Replace with actual image name
        [self.container addSubview:self.iconImageView];

        self.confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.confirmButton.layer.cornerRadius = 14;
        self.confirmButton.layer.masksToBounds = YES;
        self.confirmButton.backgroundColor = [UIColor colorWithRed:0.0 green:0.48 blue:1.0 alpha:1.0];
        [self.confirmButton setTitle:TIMCommonLocalizableString(TUICustomerFillin) forState:UIControlStateNormal];
        [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.confirmButton.contentEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 4);
        [self.confirmButton addTarget:self action:@selector(confirmButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self.container addSubview:self.confirmButton];

        [TDeskCore registerEvent:TUICore_TUIChatNotify
                        subKey:TUICore_TUIChatNotify_KeyboardWillHideSubKey
                        object:self];
    }
    return self;
}



- (void)fillWithData:(TUICustomerServicePluginTaskInformationCollectorCellData *)data {
    [super fillWithData:data];
    self.customData = data;

    if (data.nodeStatus == 0) {
        self.canClick = YES;
        self.iconImageView.image = TUICustomerServicePluginBundleThemeImage(@"information_collection", @"information_collection");
        [self.confirmButton setTitle:TIMCommonLocalizableString(TUICustomerFillinNow) forState:UIControlStateNormal];
    } else if (data.nodeStatus == 1) {
        self.canClick = NO;
        self.iconImageView.image = TUICustomerServicePluginBundleThemeImage(@"information_collection", @"information_collection");
        [self.confirmButton setTitle:TIMCommonLocalizableString(TUICustomerNotEditable) forState:UIControlStateNormal];
    } else if (data.nodeStatus == 2) {
        self.canClick = YES;
        self.iconImageView.image = TUICustomerServicePluginBundleThemeImage(@"information_collection_done", @"information_collection_done");
        [self.confirmButton setTitle:TIMCommonLocalizableString(TUICustomerView) forState:UIControlStateNormal];
    }
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
}

+ (CGSize)getContentSize:(TUICustomerServicePluginTaskInformationCollectorCellData *)data {
    return CGSizeMake(110, 138);
}

- (void)updateConstraints {
    [super updateConstraints];

    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(60);
        make.centerX.mas_equalTo(self.container);
        make.top.mas_equalTo(10);
    }];

    [self.confirmButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(30);
        make.centerX.mas_equalTo(self.container);
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(20);
    }];
}


- (void)confirmButtonTapped {
    if(self.canClick){
        UIView *parentView = [UIApplication sharedApplication].keyWindow;
        [parentView endEditing:YES];
        double height = self.customData.nodeStatus == [@(2) integerValue] ? 0.6 : 0.7;
        TaskInformationColloctorModalView *modalView = [[TaskInformationColloctorModalView alloc] initWithFrame:CGRectMake(0, parentView.bounds.size.height * (1 - height), parentView.bounds.size.width, parentView.bounds.size.height * height)
                                                                       title:self.customData.tip
                                                             inputVariables:self.customData.inputVariables
                                      inPreviewMode:self.customData.nodeStatus == [@(2) integerValue]
        ];
        [modalView showInView:parentView];
    }
}

#pragma mark - TUINotificationProtocol
- (void)onNotifyEvent:(NSString *)key subKey:(NSString *)subKey object:(nullable id)anObject param:(nullable NSDictionary *)param {
    if ([key isEqualToString:TUICore_TUIChatNotify] &&
        [subKey isEqualToString:TUICore_TUIChatNotify_KeyboardWillHideSubKey]) {
    }
}

@end
