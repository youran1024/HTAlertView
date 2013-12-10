//
//  HTShadowView.m
//  HTAlertView
//
//  Created by Mr.Yang on 13-12-4.
//  Copyright (c) 2013年 MoonLightCompany. All rights reserved.
//

#import "HTShadowView.h"

#define HTShowDefaultFrame   [UIScreen mainScreen].bounds

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef  endColor) {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = [NSArray arrayWithObjects:(__bridge id)startColor, (__bridge id)endColor, nil];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
}

@implementation HTShadowView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)init
{
    return [self initWithFrame:HTShowDefaultFrame];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touche = [touches anyObject];
    CGPoint location = [touche locationInView:self];
    for (UIView *view in self.subviews) {
        if (CGRectContainsPoint(self.frame, location)) {
            return;
        }
    }
    
    if (_shdowViewTouchedBlock) {
        _shdowViewTouchedBlock(self);
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (_showGradient) {
        CGRect currentBounds = self.bounds;
        CGGradientRef backgroundGradient;
        size_t num_locations = 2;
        CGFloat locations[2] = {0.0, 1.0};
        CGFloat components[8] = {
            0.0, 0.0, 0.0, 0.0,
            0.0, 0.0, 0.0, 0.6
        };
        CGColorSpaceRef rgbColorspace = CGColorSpaceCreateDeviceRGB();
        
        backgroundGradient = CGGradientCreateWithColorComponents (rgbColorspace, components, locations, num_locations);
        CGPoint centerPoint = CGPointMake(CGRectGetMidX(currentBounds), CGRectGetMidY(currentBounds));
        CGContextDrawRadialGradient (context, backgroundGradient, centerPoint, 0.0, centerPoint, currentBounds.size.width , kCGGradientDrawsAfterEndLocation);
        CGGradientRelease(backgroundGradient);
        CGColorSpaceRelease(rgbColorspace);
    }else {
        CGContextSetFillColorWithColor(context, [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:.5].CGColor);
        CGContextFillRect(context, rect);
    }
}



@end
