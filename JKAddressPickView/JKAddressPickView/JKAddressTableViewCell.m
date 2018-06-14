//
//  JKAddressTableViewCell.m
//  JKAddressPickView
//
//  Created by JackySong on 2018/6/14.
//  Copyright © 2018年 JackySong. All rights reserved.
//

#import "JKAddressTableViewCell.h"
#import "UIColor+Hex.h"

@interface JKAddressTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation JKAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setName:(NSString *)name{
    _name = name;
    self.nameLabel.text = name;
}

- (void)setCellSelected:(BOOL)cellSelected{
    _cellSelected = cellSelected;
    if (cellSelected) {
        self.iconImageView.hidden = NO;
        self.nameLabel.textColor = [UIColor colorWithHexString:@"#f56626"];
    }else{
        self.iconImageView.hidden = YES;
        self.nameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
}



@end
