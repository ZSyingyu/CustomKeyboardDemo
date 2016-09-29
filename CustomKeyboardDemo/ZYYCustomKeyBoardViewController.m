//
//  ZYYCustomKeyBoardViewController.m
//  CustomKeyboardDemo
//
//  Created by liguo.chen on 16/9/29.
//  Copyright © 2016年 Slience. All rights reserved.
//

#import "ZYYCustomKeyBoardViewController.h"
#import "Common.h"

#define BTN_WIDTH HFixWidthBaseOn320(80)
#define BTN_HEIGHT HFixHeightBaseOn568(76)
#define MAX_COUNT_LENGTH 10 //此处是控制键盘可以输入金额的最大位数

@interface ZYYCustomKeyBoardViewController ()<UIAlertViewDelegate>
@property(nonatomic, strong)UILabel *labNumber;
@property(nonatomic, strong)NSArray *btnTitles;
@property(nonatomic, strong)NSString *showStr;
@property(nonatomic, assign)NSInteger numerical;
@property(nonatomic, strong)NSNumberFormatter *formatter;
@property(nonatomic, assign)BOOL isFloat;

@property(nonatomic, assign)NSInteger floatTen;//用于fix .00 bug
@property(nonatomic, assign)NSInteger floatDigits;

@end

@implementation ZYYCustomKeyBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"自定义输入金额键盘";
    [self setBackBarButtonItemWithTitle:@"返回"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.floatTen = -1;
    self.floatDigits = -1;
    
    self.formatter = [[NSNumberFormatter alloc] init];
    self.formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    
    self.numerical = 0;
    self.isFloat = NO;
    
    CGFloat height = IPHONE4__4S? 80 : 124;
    
    self.labNumber = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, height)];
    self.labNumber.font = [UIFont systemFontOfSize:35];
    [self.labNumber setTextAlignment:NSTextAlignmentRight];
    self.labNumber.text = self.showStr;
    [self.view addSubview:self.labNumber];
    
    self.btnTitles = @[@"7",@"8",@"9",@"4",@"5",@"6",@"1",@"2",@"3",@"0",@"10",@"11",@"C",@"清除"];
    
    for (int i = 0; i < self.btnTitles.count - 2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *number = [self.btnTitles objectAtIndex:i];
        
        [btn setTag:number.integerValue];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn setContentMode:UIViewContentModeBottom];
        [btn setFrame:CGRectMake((i%3) * BTN_WIDTH, (i/3) * BTN_HEIGHT + height, BTN_WIDTH, BTN_HEIGHT)];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",number]];
        UIView *view = [[UIView alloc] init];
        [view setUserInteractionEnabled:NO];
        view.layer.contents = (id)image.CGImage;
        [view setBounds:CGRectMake(0, 0, image.size.width, image.size.height)];
        view.center = CGPointMake(BTN_WIDTH/2.f, BTN_HEIGHT /2.f);
        [btn addSubview:view];
        
    }
    
    for (int i = 0; i < self.btnTitles.count - 12; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTag:i + 12];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn setContentMode:UIViewContentModeBottom];
        [btn setFrame:CGRectMake(3 * BTN_WIDTH, i * 2 * BTN_HEIGHT + height, BTN_WIDTH, 2 * BTN_HEIGHT)];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
        UIImage *image = [UIImage imageNamed:[self.btnTitles objectAtIndex:i + 12]];
        UIView *view = [[UIView alloc] init];
        [view setUserInteractionEnabled:NO];
        view.layer.contents = (id)image.CGImage;
        [view setBounds:CGRectMake(0, 0, image.size.width, image.size.height)];
        view.center = CGPointMake(BTN_WIDTH/2.f, BTN_HEIGHT);
        [btn addSubview:view];
    }
    
    for (int i = 0; i < 2; i++) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(BTN_WIDTH * i, height, LINE_HEIGTH, BTN_HEIGHT * 4)];
        [line setBackgroundColor:[UIColor lightGrayColor]];
        [self.view addSubview:line];
    }
    
    for (int i = 0; i < 5; i++) {
        CGFloat w;
        if ((i+1) % 2 == 0) {
            w = SCREEN_WIDTH  - BTN_WIDTH;
        }else {
            w = SCREEN_WIDTH;
        }
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, height + i*BTN_HEIGHT, w, LINE_HEIGTH)];
        [line setBackgroundColor:[UIColor lightGrayColor]];
        [self.view addSubview:line];
    }
    
    
    for (int i = 1; i < 4; i++) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(BTN_WIDTH * i, height, LINE_HEIGTH, BTN_HEIGHT * 4)];
        [line setBackgroundColor:[UIColor lightGrayColor]];
        [self.view addSubview:line];
    }
    
    UIButton *btnConfirm = [UIButton buttonWithType:UIButtonTypeCustom];
    btnConfirm.frame = CGRectMake(10, SCREEN_HEIGHT - 130, SCREEN_WIDTH - 20, 40);
    [btnConfirm setBackgroundColor:[UIColor cyanColor]];
    [btnConfirm.titleLabel setTextColor:[UIColor whiteColor]];
    [btnConfirm setContentMode:UIViewContentModeBottom];
    [btnConfirm setTitle:@"确认" forState:UIControlStateNormal];
    [btnConfirm.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [btnConfirm addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnConfirm];
    
}

- (NSString *)showStr
{
    NSInteger intPart = self.numerical / 100;
    NSInteger folatPart = self.numerical % 100;
    
    NSNumber *number = [NSNumber numberWithInteger:intPart];
    
    self.formatter = [[NSNumberFormatter alloc] init];
    self.formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    _showStr = [self.formatter stringFromNumber:number];
    
    if(folatPart >= 10){//两位数
        _showStr = [_showStr stringByAppendingString:[NSString stringWithFormat:@".%zd",folatPart]];
    }else if(folatPart >= 1){//一位数
        _showStr = [_showStr stringByAppendingString:[NSString stringWithFormat:@".0%zd",folatPart]];
    }else if(folatPart == 0){//0
        _showStr = [_showStr stringByAppendingString:@".00"];
    }
    
    return _showStr;
}

- (NSInteger)getIntPartLength
{
    NSInteger intPart = self.numerical /100;
    NSString *intStr = [NSString stringWithFormat:@"%zd",intPart];
    return [intStr length];
}

- (void)btnAction:(UIButton *)btn
{
    switch (btn.tag) {
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:{
            if(self.isFloat){
                if(self.numerical % 100 == 0  && self.floatTen == -1 && self.floatDigits == -1){//刚点击完小数点
                    self.numerical = self.numerical + btn.tag*10;
                    self.floatTen = btn.tag;
                }else if(self.numerical % 10 == 0  && self.floatDigits == -1){//小数点后一位
                    self.numerical = self.numerical + btn.tag*1;
                    self.floatDigits = btn.tag;
                }else { //小数点后两位
                    //已经达到小数点后两位不能输入
                }
            }else {
                if([self getIntPartLength] < MAX_COUNT_LENGTH)//小于最大值
                    self.numerical = self.numerical*10 + btn.tag*100;
            }
        }
            break;
        case 10:{//点
            self.isFloat = YES;
        }
            break;
        case 11://00
            if(!self.isFloat){
                if([self getIntPartLength] < MAX_COUNT_LENGTH - 1){
                    self.numerical *= 100;
                }else if([self getIntPartLength] < MAX_COUNT_LENGTH){
                    self.numerical *= 10;
                }
            }
            
            break;
        case 12://C
            self.numerical = 0;
            self.isFloat = NO;
            self.floatTen = -1;
            self.floatDigits = -1;
            
            break;
        case 13://清除
            if(!self.isFloat){
                if(self.numerical >= 1000){
                    NSInteger floatPart = self.numerical % 100;
                    self.numerical /= 1000;
                    self.numerical =self.numerical*100 + floatPart ;
                }else if(self.numerical >=100){
                    self.numerical %= 100;
                }
            }else {
                if(self.numerical % 100 == 0 && self.floatTen == -1 && self.floatDigits == -1){//刚点击完小数点
                    self.isFloat = NO;
                    self.numerical /= 1000;
                    self.numerical *= 100;
                    self.floatTen = -1;
                    self.floatDigits = -1;
                }else if(self.numerical % 10 == 0 && self.floatDigits == -1){//小数点后一位
                    self.numerical /= 100;
                    self.numerical *= 100;
                    self.floatTen = -1;
                }else { //小数点后两位
                    self.numerical /= 10;
                    self.numerical *= 10;
                    self.floatDigits = -1;
                }
            }
            break;
        default:
            break;
    }
    
    [self.labNumber setText:self.showStr];
}

- (void)confirmAction {
    NSLog(@"输入的金额为:%@",self.labNumber.text);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您输入的金额是" message:self.labNumber.text delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

/**
 *  设置返回按钮标题
 */
- (void)setBackBarButtonItemWithTitle:(NSString *)title
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"NavBackSorrow"] forState:UIControlStateNormal];
    [btn setContentMode:UIViewContentModeScaleAspectFill];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -7, 0, 50)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 10)];
    [btn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

/**
 *  返回按钮点击事件
 */
- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
