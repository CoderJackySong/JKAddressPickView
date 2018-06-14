//
//  UIView+Category.m
//  JKAddressPickView
//
//  Created by JackySong on 2018/6/14.
//  Copyright © 2018年 JackySong. All rights reserved.
//

#import "UIView+Category.h"

@implementation UIView (Category)

#pragma mark 视图坐标大小
- (CGPoint)origin{
    return self.frame.origin;
}

- (CGFloat)minX{
    return self.frame.origin.x;
}

- (CGFloat)maxX{
    return self.frame.origin.x + self.frame.size.width;
}
- (CGFloat)minY{
    return self.frame.origin.y;
}

- (CGFloat)maxY{
    return self.frame.origin.y + self.frame.size.height;
}

- (CGSize)size{
    return self.frame.size;
}

- (CGFloat)width{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width{
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}

- (void)setHeight:(CGFloat)height{
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

- (CGFloat)height{
    return self.frame.size.height;
}

- (CGFloat)centerX{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerY{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)y{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y{
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
}

- (CGFloat)x{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x{
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
}

@end
