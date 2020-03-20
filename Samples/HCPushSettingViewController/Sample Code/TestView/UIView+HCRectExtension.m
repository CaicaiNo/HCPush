//
//  UIView+GSRectExtension.m
//  RtSDKDemo
//
//  Created by Sheng on 2018/7/24.
//  Copyright © 2018年 gensee. All rights reserved.
//

#import "UIView+HCRectExtension.h"

@implementation UIView (HCRectExtension)

- (void)setHc_x:(CGFloat)gs_x {
    CGRect frame = self.frame;
    frame.origin.x = gs_x;
    self.frame = frame;
}

- (CGFloat)hc_x {
    return self.frame.origin.x;
}

- (void)setHc_y:(CGFloat)gs_y {
    CGRect frame = self.frame;
    frame.origin.y = gs_y;
    self.frame = frame;
}

- (CGFloat)hc_y {
    return self.frame.origin.y;
}

- (void)setHc_centerX:(CGFloat)gs_centerX {
    CGPoint center = self.center;
    center.x = gs_centerX;
    self.center = center;
}

- (CGFloat)hc_centerX {
    return self.center.x;
}

- (void)setHc_centerY:(CGFloat)gs_centerY {
    CGPoint center = self.center;
    center.y = gs_centerY;
    self.center = center;
}

- (CGFloat)hc_centerY {
    return self.center.y;
}

- (void)setHc_width:(CGFloat)gs_width {
    CGRect frame = self.frame;
    frame.size.width = gs_width;
    self.frame = frame;
}

- (CGFloat)hc_width {
    return self.frame.size.width;
}

- (void)setHc_height:(CGFloat)gs_height {
    CGRect frame = self.frame;
    frame.size.height = gs_height;
    self.frame = frame;
}

- (CGFloat)hc_height {
    return  self.frame.size.height;
}

- (void)setHc_size:(CGSize)gs_size {
    CGRect frame = self.frame;
    frame.size = gs_size;
    self.frame = frame;
}

- (CGSize)hc_size {
    return self.frame.size;
}

- (void)setHc_origin:(CGPoint)gs_origin {
    CGRect frame = self.frame;
    frame.origin = gs_origin;
    self.frame = frame;
}

- (CGPoint)hc_origin {
    return self.frame.origin;
}

@end
