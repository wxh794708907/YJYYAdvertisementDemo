//
//  ViewController.m
//  YJYYAdvertisementDemo
//
//  Created by 遇见远洋 on 16/8/9.
//  Copyright © 2016年 遇见远洋. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人界面";
    
    self.view.backgroundColor = [UIColor cyanColor];
    
    UILabel * welComeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    
    welComeLabel.text = @"恭喜你，进入到主界面了";
    
    [self.view addSubview:welComeLabel];
    
    welComeLabel.center = self.view.center;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
