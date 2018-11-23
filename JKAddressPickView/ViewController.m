//
//  ViewController.m
//  JKAddressPickView
//
//  Created by JackySong on 2018/6/14.
//  Copyright © 2018年 JackySong. All rights reserved.
//

#import "ViewController.h"
#import "JKAddressPickView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)addressPickAction:(id)sender {
    __weak typeof(self)weakSelf = self;
    JKAddressPickView *addressPickView = [[JKAddressPickView alloc] initAddressPickViewWithCompletion:^(Place *province,Place *city,Place *district) {
        weakSelf.textField.text = [NSString stringWithFormat:@"%@%@%@",province.name,city.name,district.name];
    }];
    [addressPickView show];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
