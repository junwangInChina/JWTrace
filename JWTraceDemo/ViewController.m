//
//  ViewController.m
//  JWTraceDemo
//
//  Created by wangjun on 15/12/7.
//  Copyright © 2015年 wangjun. All rights reserved.
//

#import "ViewController.h"

#import "JWTrace.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    JW_OUTPUT_LOG(OutputLevelDebug, @"打印日子控件，可以修改AppDelegate里面设置的级别，来控制App中是否打印");
    
    UIButton *tempButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 40)];
    tempButton.backgroundColor = [UIColor greenColor];
    [tempButton setTitle:@"点我" forState:UIControlStateNormal];
    [tempButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    tempButton.titleLabel.font = [UIFont fontWithName:@"Arial" size:14];
    [tempButton addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tempButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchAction:(id)sender
{
    for (NSInteger i = 0; i < 499; i++)
    {
        JW_OUTPUT_LOG(OutputLevelDebug, @"点我点我");
    }
}

@end
