//
//  UIColor+Hex.h
//  Yjyx
//
//  Created by liushaochang on 16/8/15.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)


/**
 * 十六进制字符串转为UIColor输出
 * 支持@“#123456”、 @“0X123456”、 @“123456”三种格式
 *
 **/


// 透明度默认
+ (UIColor *)colorWithHexString:(NSString *)color;

// 透明度可设置
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;



@end
