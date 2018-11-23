//
//  AddressPickView.h
//  YjyxTeacher
//
//  Created by JackySong on 2018/6/11.
//  Copyright © 2018年 YJYX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Place:NSObject

@property(nonatomic,copy)NSString *code;
@property(nonatomic,copy)NSString *name;

@end


@interface JKAddressPickView : UIView

- (instancetype)initAddressPickViewWithCompletion:(void(^)(Place *province,Place *city,Place *district))completion;

- (void)show;

@end
