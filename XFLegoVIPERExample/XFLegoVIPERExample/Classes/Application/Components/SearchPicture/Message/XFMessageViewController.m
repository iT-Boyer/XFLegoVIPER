//
//  XFMessageViewController.m
//  XFLegoVIPERExample
//
//  Created by Yizzuide on 2017/1/16.
//  Copyright © 2017年 Yizzuide. All rights reserved.
//

#import "XFMessageViewController.h"
#import "XFLegoMarco.h"

@interface XFMessageViewController ()

@end

@implementation XFMessageViewController

// 导出为组件
XF_EXPORT_COMPONENT

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"我的消息";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:217/255.0 green:108/255.0 blue:0/255.0 alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
//    NSLog(@"%@",self.URLParams);
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
    // 这个属性不是自动注入的，只是接口声明，需要在头文件自己添加了属性框架才能反向传值！！
    self.intentData = @"我是返回数据";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc
{
    XF_Debug_M();
}

@end
