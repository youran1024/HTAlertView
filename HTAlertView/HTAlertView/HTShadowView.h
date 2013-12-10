//
//  HTShadowView.h
//  HTAlertView
//
//  Created by Mr.Yang on 13-12-4.
//  Copyright (c) 2013年 MoonLightCompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTShadowView : UIView

@property (nonatomic, assign)   BOOL showGradient;
@property (nonatomic, copy) void(^shdowViewTouchedBlock)(HTShadowView *view);
@end
