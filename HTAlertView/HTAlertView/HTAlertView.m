//
//  HTAlertView.m
//  HTAlertView
//
//  Created by Mr.Yang on 13-12-4.
//  Copyright (c) 2013年 MoonLightCompany. All rights reserved.
//

#import "HTAlertView.h"
#import "HTShadowView.h"
#import "UIView+Animation.h"
#import <QuartzCore/QuartzCore.h>

 
@implementation UIImage (StretchImage)

- (UIImage *)autoStretchImage
{
    CGSize size = self.size;
    return [self stretchableImageWithLeftCapWidth:size.width / 2.0f topCapHeight:size.height / 2.0f];
}

- (UIImage *)stretchImage:(CGFloat)width andHeight:(CGFloat)height
{
    return [self stretchableImageWithLeftCapWidth:width topCapHeight:height];
}

@end

#define HTAlertViewMaxContentViewHeight  150

@interface HTAlertView ()
{
    __unsafe_unretained HTShadowView *_shadowView;
    __unsafe_unretained UIView *_inputView;//监测可输入的视图
    CGPoint _originLocation;
}
@property (nonatomic, strong)   HTMoreButtons *buttonsView;
@property (nonatomic, strong)   UIImageView *backImageView;


@end
@implementation HTAlertView

+ (HTAlertView *)alert:(NSString *)content
{
    UIView *contentView = [HTAlertView contentViewWithContent:content];
    return [[[HTAlertView alloc] initWithTitle:@"提示" contentView:contentView andSubButton:@"知道了" andValist:nil] show];
}

+ (HTAlertView *)alertView:(NSString *)title submitButton:(NSString *)subButton, ...
{
    va_list list;
    va_start(list, subButton);
    HTAlertView *view = [[HTAlertView alloc] initWithTitle:title contentView:nil andSubButton:subButton andValist:list];
    va_end(list);
    return view;
}

+ (HTAlertView *)alertViewWithTitle:(NSString *)title Content:(NSString *)content submitButton:(NSString *)submitButton, ...
{
    va_list list;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
    va_start(list, submitButton);
    UIView *contentView = [HTAlertView contentViewWithContent:content];
    HTAlertView *view = [[[HTAlertView alloc] initWithTitle:title contentView:contentView andSubButton:submitButton andValist:list] show];
    va_end(list);
    return view;
}

- (HTAlertView *)initWithTitle:(NSString *)title contentView:(UIView *)contentView andSubButton:subButton andValist:(va_list)list
{
    self = [super init];
    if (self){
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.backImageView];
        
        self.title = title;
        self.contentView = contentView;
        HTMoreButtons *buttonView = [[HTMoreButtons alloc] initWithButtonTitle:subButton list:list viewType:HTButtonViewTypeAlert];
        self.buttonsView = buttonView;
        
        __unsafe_unretained HTAlertView *selfWeak = self;
        [self.buttonsView setButtonClickBlock:^(UIButton *button, NSInteger i){
            
            if (selfWeak.buttonClickBlock) {
                selfWeak.buttonClickBlock(button, i);
            }
            
            [selfWeak dismiss];
        }];
        
    }
    return self;
}

+ (UIView *)contentViewWithContent:(NSString *)content
{
    UIFont *font = [UIFont systemFontOfSize:17.0f];
    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(HTAlertViewWidth - 20, NSIntegerMax)];
    size.height = MAX(40, size.height);
    CGRect rect = CGRectMake(0, 0, HTAlertViewWidth, size.height);
    rect = CGRectInset(rect, 10, 0);
    UIView *tmpView;
    if (size.height < HTAlertViewMaxContentViewHeight) {
        UILabel *label = [[UILabel alloc] initWithFrame:rect];
        label.numberOfLines = 0;
        tmpView = label;
    }else {
        rect.size.height =  HTAlertViewMaxContentViewHeight;
        UITextView *textView = [[UITextView alloc] initWithFrame:rect];
        textView.editable = NO;
        tmpView = textView;
    }
    ((UILabel *)tmpView).font = font;
    ((UILabel *)tmpView).text = content;
    tmpView.backgroundColor = [UIColor clearColor];
    return tmpView;
}

- (id)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    HTShadowView *view = [[HTShadowView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [window addSubview:view];
    _shadowView = view;
    if ([self.contentView isKindOfClass:[UITextView class]]) {
        [((UITextView *) self.contentView) flashScrollIndicators];
    }
    
    if ([self hasInputView:_contentView]) {
        [self regesitKeyboardNotifation];
    }
    
    [window popupSubView:self atPosition:PopAnchorCenterY | PopAnchorCenterX];
    
    return self;
}

- (void)regesitKeyboardNotifation
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(handleKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)handleKeyboardWillShow:(NSNotification *)center
{
    CGRect rect = self.frame;
    CGRect frame = [[center.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [[center.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    if (CGRectGetMaxY(rect) > CGRectGetMinY(frame)) {
        rect.origin.y += CGRectGetMinY(frame) - CGRectGetMaxY(rect);
    }
    [UIView animateWithDuration:duration animations:^{
        self.frame = rect;
    }];
}

- (void)handleKeyboardWillHide:(NSNotification *)center
{
     CGRect rect = self.frame;
    CGFloat duration = [[center.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    rect.origin = _originLocation;
    [UIView animateWithDuration:duration animations:^{
        self.frame = rect;
    }];

}

//递归遍历所有的子视图
- (BOOL)hasInputView:(UIView *)view
{
    NSEnumerator *enumerator = [view.subviews reverseObjectEnumerator];
    UIView *subView;
    while (subView = [enumerator nextObject]) {
        if ([subView conformsToProtocol:@protocol(UITextInput)]) {
            _inputView = subView;
            return YES;
        }
        //递归遍历子视图
        if ([self hasInputView:subView]) {
            return YES;
        }
    }
    return NO;
}

- (void)dismiss
{
    [UIView animateWithDuration:.25 animations:^{
        self.alpha = 0;
        _shadowView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
    }];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self removeFromSuperview];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        CGRect rect = CGRectMake(0, 3, HTAlertViewWidth, 26);
        rect = CGRectInset(rect, 10, 0);
        _titleLabel.frame = rect;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIImageView *)backImageView
{
    if (!_backImageView) {
        UIImage *backImage = StretchImage(@"custom_alert_view_background", 20, 50);
        _backImageView = [[UIImageView alloc] initWithImage:backImage];
        _backImageView.frame = CGRectMake(0, 0, HTAlertViewWidth, 0);
        [self addSubview:_backImageView];
    }
    return _backImageView;
}

- (void)setButtonClickBlock:(void (^)(UIButton *, NSInteger))buttonBlock
{
    if (_buttonClickBlock != buttonBlock) {
        _buttonClickBlock = buttonBlock;
    }
}

- (void)setTitle:(NSString *)title
{
    if(![_title isEqualToString:title]){
        _title = title;
        self.titleLabel.text = _title;
    }
}

- (void)setButtonsView:(HTMoreButtons *)buttonsView
{
    if (_buttonsView != buttonsView) {
        [_buttonsView removeFromSuperview];
        _buttonsView = buttonsView;
        if (buttonsView) {
            [self addSubview:_buttonsView];
            [self setNeedsLayout];
        }
    }
}

- (void)setContentView:(UIView *)contentView
{
    if (_contentView != contentView) {
        [_contentView removeFromSuperview];
        _contentView = contentView;
        if (_contentView) {
            if ([self hasInputView:_contentView]) {
                [self regesitKeyboardNotifation];
            }
            
            [self addSubview:_contentView];
            [self setNeedsLayout];
        }
    }
}
#define HTAlertViewMargin   10
#define HTAlertViewTitleHeight    30

- (void)layoutSubviews
{
    CGFloat locationY = HTAlertViewTitleHeight + HTAlertViewMargin;
    CGRect rect = self.contentView.frame;
    rect.origin.y = locationY;
    rect.size.width = MIN(HTAlertViewWidth, CGRectGetWidth(rect));
    rect.size.height = MIN(HTAlertViewMaxContentViewHeight, CGRectGetHeight(rect));
    self.contentView.frame = rect;
    locationY = CGRectGetMaxY(_contentView.frame);
    
    rect = self.buttonsView.frame;
    rect.origin.x = 0;
    rect.origin.y = locationY;
    self.buttonsView.frame = rect;
    
    locationY = CGRectGetMaxY(_buttonsView.frame) + HTAlertViewMargin;
    rect.origin.y = 0;
    rect.size.width = HTAlertViewWidth;
    rect.size.height = locationY;
    self.backImageView.frame = rect;
    
    rect = self.frame;
    rect.size.width = HTAlertViewWidth;
    rect.size.height = locationY;
    self.frame = rect;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.center = window.center;
    if (_inputView) {
        [_inputView becomeFirstResponder];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_shadowView removeFromSuperview];
}

@end

#define ButtonMargin  10    //按钮之间的间隔
#define BUttonHeight  40    //按钮的高度
#define ButtonLimit   3     //最大按钮数量，超出后可以上下滑动翻页

@interface HTMoreButtons ()
{
    
}
@property (nonatomic, strong)   NSMutableArray *buttons;
@end

@implementation HTMoreButtons
+ (HTMoreButtons *)alertViewButtons:(NSString *)title, ...
{
    va_list list;
    va_start(list, title);
    HTMoreButtons *view = [[HTMoreButtons alloc] initWithButtonTitle:title list:list viewType:HTButtonViewTypeAlert];
    va_end(list);
    return view;
}

+ (HTMoreButtons *)moreButtons:(NSString *)title, ...
{
    va_list list;
    va_start(list, title);
    HTMoreButtons *view = [[HTMoreButtons alloc] initWithButtonTitle:title list:list viewType:HTButtonViewTypeActionSheet];
    va_end(list);
    return view;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (HTMoreButtons *)initWithButtonTitle:(NSString *)title list:(va_list)list viewType:(HTButtonViewType)type
{
    self = [self init];
    if (self) {
        static BOOL first;
        first = YES;
        NSInteger i = 0;
        while (title) {
            UIButton *button;
            
            if (first) {
                first = NO;
                button = [self cancelButton];
            }else {
                button = [self submitButton];
            }
            
            button.tag = i++;
            [button setTitle:title forState:UIControlStateNormal];
            [self.buttons addObject:button];
            [self addSubview:button];
            if (list) {
                 title = va_arg(list, id);
            }else {
                title = nil;
            }
           
        }
        
        self.viewType = type == 0 ? HTButtonViewTypeActionSheet : HTButtonViewTypeAlert;
        [self layoutSubviews];
    }

    return self;
}

- (void)setViewType:(HTButtonViewType)viewType
{
    if (_viewType != viewType) {
        _viewType = viewType;
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews
{
    if (_buttons.count > 2 || _buttons.count == 1) {
        _viewType = HTButtonViewTypeActionSheet;
    }
    
    CGFloat buttonWidth = HTAlertViewWidth - 2 * ButtonMargin;
    if (_viewType == HTButtonViewTypeAlert) {
        buttonWidth = (HTAlertViewWidth- 3 * ButtonMargin) / 2 ;
    }
    CGFloat locationX = ButtonMargin;
    CGFloat locationY = ButtonMargin;
    UIScrollView *buttonScrollView;
    if (_viewType == HTButtonViewTypeAlert) {
        for (UIButton *button in _buttons) {
            button.frame = CGRectMake(locationX, ButtonMargin, buttonWidth, BUttonHeight);
            locationX += buttonWidth + ButtonMargin;
            locationY = CGRectGetMaxY(button.frame) + ButtonMargin;
        }
       
    }else {
        if (_buttons.count > ButtonLimit) {
            CGFloat viewHeight = BUttonHeight * ButtonLimit + ButtonMargin * (ButtonLimit + 1);
            buttonScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, HTAlertViewWidth, viewHeight)];
            [self addSubview:buttonScrollView];
        }
        for (UIButton *button in _buttons) {
            button.frame = CGRectMake( ButtonMargin, locationY, buttonWidth, BUttonHeight);
            locationY = CGRectGetMaxY(button.frame) +  ButtonMargin;
            if (buttonScrollView) {
                [buttonScrollView addSubview:button]; 
            }
        }
    }
    if (buttonScrollView) {
        buttonScrollView.contentSize = CGSizeMake(HTAlertViewWidth, locationY);
        locationY = CGRectGetMaxY(buttonScrollView.frame) + ButtonMargin;
    }
    CGRect rect = self.frame;
    rect.size.width = HTAlertViewWidth;
    rect.size.height = locationY - ButtonMargin;
    self.frame = rect;
}

- (void)buttonClicked:(UIButton *)button
{
    if (_buttonClickBlock) {
        _buttonClickBlock(button, button.tag);
    }
}

- (UIButton *)cancelButton
{
    return [self createButtonWithImageName:@"custom_alert_view_submit_button"];
}

- (UIButton *)submitButton
{
    return [self createButtonWithImageName:@"custom_alert_view_cancel_button"];
}

- (UIButton *)createButtonWithImageName:(NSString *)imageName
{
    UIImage *image = StretchImageAuto(imageName);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (NSMutableArray *)buttons
{
    if (!_buttons) {
        _buttons = [[NSMutableArray alloc] init];
    }
    return _buttons;
}

@end
