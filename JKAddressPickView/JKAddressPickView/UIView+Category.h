//
//  UIView+Category.h
//  JKAddressPickView
//
//  Created by JackySong on 2018/6/14.
//  Copyright © 2018年 JackySong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Category)
/**
 * 视图坐标
 * @returned    视图坐标
 */
- (CGPoint)origin;

/**
 * 视图相对于父view的最小x坐标
 * @returned    最小x坐标
 */
- (CGFloat)minX;

/**
 * 视图相对于父view的最大x坐标
 * @returned    最大x坐标
 */
- (CGFloat)maxX;

/**
 * 视图相对于父view的最小y坐标
 * @returned    最小y坐标
 */
- (CGFloat)minY;

/**
 * 视图相对于父view的最大y坐标
 * @returned    最大y坐标
 */
- (CGFloat)maxY;

/**
 * 视图高宽
 * @returned    视图高宽
 */
- (CGSize)size;

/**
 * 视图宽
 * @returned    视图宽
 */
- (CGFloat)width;

- (void)setWidth:(CGFloat)width;
/**
 * 视图高
 * @returned    视图高
 */
- (CGFloat)height;

- (void)setHeight:(CGFloat)height;
/**
 * 设置中心点X
 */
- (CGFloat)centerX;

- (void)setCenterX:(CGFloat)centerX;
/**
 * 设置中心点Y
 */
- (CGFloat)centerY;

- (void)setCenterY:(CGFloat)centerY;
/**
 * 设置y值
 */
- (CGFloat)y;

- (void)setY:(CGFloat)y;
/**
 * 设置x值
 */
- (CGFloat)x;

- (void)setX:(CGFloat)x;

@end
