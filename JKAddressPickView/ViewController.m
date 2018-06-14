//
//  ViewController.m
//  JKAddressPickView
//
//  Created by JackySong on 2018/6/14.
//  Copyright © 2018年 JackySong. All rights reserved.
//

#import "ViewController.h"
#import "JKAddressPickView.h"

@interface ViewController ()<JKAddressPickViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)addressPickAction:(id)sender {
    JKAddressPickView *addressPickView = [[JKAddressPickView alloc] initAddressPickViewWithContentHeight:468.0];
    addressPickView.delegate = self;
    [addressPickView show];
    
}

#pragma mark - AddressPickViewDelegate
- (void)addressPickViewClicked:(NSString *)placeString{
    self.textField.text = placeString;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
