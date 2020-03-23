//
//  CALayer+BorderColor.h
//  HCPushSettingViewController
//
//  Created by haocaihaocai on 2020/3/16.
//  Copyright © 2020年 haocaihaocai. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

//use for xib ,to reset layer.borderColor by runtime,because xib not support CGColor type

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (BorderColor)

- (void)setBorderColorFromUIColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
