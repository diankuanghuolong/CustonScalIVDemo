//
//  ViewController.m
//  CustonScalIVDemo
//
//  Created by Ios_Developer on 2018/4/20.
//  Copyright © 2018年 com.Hai. All rights reserved.
//

#import "ViewController.h"
#import "CustonScallImageVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 120, 40)];
    [btn setBackgroundColor:[UIColor greenColor]];
    btn.layer.cornerRadius = 10;
    btn.layer.masksToBounds = YES;
    [btn setTitle:@"点击进入列表" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(didClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
}
#pragma mark =====  action  =====
-(void)didClick:(id)sender
{
    CustonScallImageVC *custonScallImageVC = [CustonScallImageVC new];
    custonScallImageVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:custonScallImageVC animated:YES];
}



@end
