//
//  CALayer+BorderColor.m
//  HCPushSettingViewController
//
//  Created by haocaihaocai on 2020/3/16.
//  Copyright © 2020年 haocaihaocai. All rights reserved.
//

#import "CALayer+BorderColor.h"

@implementation CALayer (BorderColor)
- (void)setBorderColorFromUIColor:(UIColor *)color {
    self.borderColor = color.CGColor;
}
@end
