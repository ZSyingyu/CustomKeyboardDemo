//
//  ViewController.m
//  CustomKeyboardDemo
//
//  Created by liguo.chen on 16/9/29.
//  Copyright © 2016年 Slience. All rights reserved.
//

#import "ViewController.h"
#import "Common.h"
#import "ZYYCustomKeyBoardViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"自定义输入金额键盘";
    self.navigationController.navigationBar.barTintColor = [UIColor purpleColor];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:[UIColor redColor]}];
    
    UIButton *numBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 100, SCREEN_WIDTH - 20, 50)];
    numBtn.backgroundColor = [UIColor purpleColor];
    [numBtn setTitle:@"自定义输入金额键盘" forState:UIControlStateNormal];
    [numBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [numBtn addTarget:self action:@selector(webAction1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:numBtn];
    
}

-(void)webAction1 {
    ZYYCustomKeyBoardViewController *keyboardVc = [[ZYYCustomKeyBoardViewController alloc] init];
    [self.navigationController pushViewController:keyboardVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
