//
//  AddressPickView.h
//  YjyxTeacher
//
//  Created by JackySong on 2018/6/11.
//  Copyright © 2018年 YJYX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKAddressPickView : UIView

- (instancetype)initWithContentHeight:(CGFloat)height completion:(void(^)(NSString *addressString))completion;

- (void)show;

@end
