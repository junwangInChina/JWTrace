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
    
    UIButton *temp1Button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 40)];
    temp1Button.backgroundColor = [UIColor greenColor];
    [temp1Button setTitle:@"点我" forState:UIControlStateNormal];
    [temp1Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    temp1Button.titleLabel.font = [UIFont fontWithName:@"Arial" size:14];
    [temp1Button addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:temp1Button];
    
    UIButton *temp2Button = [[UIButton alloc] initWithFrame:CGRectMake(200, 100, 100, 40)];
    temp2Button.backgroundColor = [UIColor greenColor];
    [temp2Button setTitle:@"崩溃" forState:UIControlStateNormal];
    [temp2Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    temp2Button.titleLabel.font = [UIFont fontWithName:@"Arial" size:14];
    [temp2Button addTarget:self action:@selector(crashAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:temp2Button];
    
    UITextView *tempTextView = [[UITextView alloc] initWithFrame:CGRectMake(100, 150, 200, 100)];
    tempTextView.backgroundColor = [UIColor greenColor];
    tempTextView.text = @"测试测试tempTextViewtempTextViewtempTextViewtempTextViewtempTextView";
    tempTextView.editable = NO;
    [self.view addSubview:tempTextView];
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

- (void)crashAction:(id)sender
{    
    NSArray *arr=[NSArray arrayWithObjects:@"4",@"5", nil];
    NSLog(@"%@",[arr objectAtIndex:3]);
}

@end
