//
//  AddressPickView.h
//  YjyxTeacher
//
//  Created by JackySong on 2018/6/11.
//  Copyright © 2018年 YJYX. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JKAddressPickViewDelegate <NSObject>

-(void)addressPickViewClicked:(NSString *)placeString;


@end


@interface Place:NSObject

@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *name;

@end


@interface JKAddressPickView : UIView

@property(nonatomic,weak)id<JKAddressPickViewDelegate>delegate;

- (instancetype)initAddressPickViewWithContentHeight:(CGFloat)height;

- (void)show;

@end
