//
//  ViewController.m
//  BBWebView
//
//  Created by 程肖斌 on 2019/1/23.
//  Copyright © 2019年 ICE. All rights reserved.
//

#import "ViewController.h"
#import "BBWebController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
}

- (IBAction)clickOn:(UIButton *)sender {
    BBBundleWebController *vc = [[BBBundleWebController alloc]init];
    vc.name = @"web";
    vc.type = @"html";
    vc.key_values[@"btnClick"] = ^(WKScriptMessage *message){
        NSLog(@"===%@",message.body);
    };
    [self.navigationController pushViewController:vc animated:YES];
}

@end
