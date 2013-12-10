//
//  HTAlertView.h
//  HTAlertView
//
//  Created by Mr.Yang on 13-12-4.
//  Copyright (c) 2013年 MoonLightCompany. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HTAlertViewWidth    280
#define HTAlertViewMinHeight    80

#define StretchImageAuto(imageName) [[UIImage imageNamed:imageName] autoStretchImage]
#define StretchImage(imageName, width, height) [[UIImage imageNamed:imageName] stretchImage:width andHeight:height]

@interface UIImage (StretchImage)
- (UIImage *)autoStretchImage;
- (UIImage *)stretchImage:(CGFloat)width andHeight:(CGFloat)height;
@end

typedef void(^ButtonBlock)(UIButton *, NSInteger);

@interface HTAlertView : UIView

@property (nonatomic, unsafe_unretained)   NSString  *title;
@property (nonatomic, strong)   UILabel *titleLabel;
@property (nonatomic, strong)   UIView *contentView;
@property (nonatomic, copy) ButtonBlock buttonClickBlock;

+ (HTAlertView *)alert:(NSString *)content;
+ (HTAlertView *)alertViewWithTitle:(NSString *)title Content:(NSString *)content submitButton:(NSString *)submitButton, ... NS_REQUIRES_NIL_TERMINATION;
+ (HTAlertView *)alertView:(NSString *)title submitButton:(NSString *)subButton ,...NS_REQUIRES_NIL_TERMINATION;
- (id)show;

@end

typedef NS_ENUM(NSInteger, HTButtonViewType) {
    HTButtonViewTypeAlert = 1,      //如果为两个按钮，则横向排列
    HTButtonViewTypeActionSheet = 2 //竖着排
};

@interface HTMoreButtons : UIView
@property (nonatomic, assign)   HTButtonViewType viewType;
@property (nonatomic, copy) ButtonBlock buttonClickBlock;

+ (HTMoreButtons *)alertViewButtons:(NSString *)title, ... NS_REQUIRES_NIL_TERMINATION;
+ (HTMoreButtons *)moreButtons:(NSString *)title, ... NS_REQUIRES_NIL_TERMINATION;
- (HTMoreButtons *)initWithButtonTitle:(NSString *)title list:(va_list)list viewType:(HTButtonViewType)type;
@end