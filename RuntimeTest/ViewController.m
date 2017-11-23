//
//  ViewController.m
//  RuntimeTest
//
//  Created by Hongfei Zhai on 2017/11/22.
//  Copyright © 2017年 Hongfei Zhai. All rights reserved.
//

#import "ViewController.h"

#import "ABCell.h"

#import <objc/runtime.h>

#import "UIButton+block.h"

#define kScreenWidth self.view.frame.size.width

#define kScreenHeight self.view.frame.size.height

//1.导入runtime头文件。 2.声明key
static const void *callBtnKey = &callBtnKey;

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate> {
    UITableView *tableView;
    NSMutableArray *dataArray;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //dataArray
    dataArray = [NSMutableArray arrayWithArray:@[@"18292079201",@"18292079202",@"18292079203",@"18292079204",@"18292079205"]];
    //初始化tableview
    //[self initTableView];
    
    //test button runtime block
    //类似blockskit中的uitouch+block的实现
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = CGRectMake(0, 0, 100, 50);
    button.center = self.view.center;
    button.backgroundColor = [UIColor redColor];
    button.tag = 10001;
    [button touchWithEvents:(UIControlEventTouchUpInside) withBlock:^(UIButton *sender) {
        NSLog(@"sender.tag === %ld",(long)sender.tag);
    }];
    [self.view addSubview:button];
}

//初始化方法
- (void)initTableView {
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:(UITableViewStylePlain)];
    tableView.delegate = self;
    tableView.dataSource = self;
    //注册cell
    [tableView registerNib:[UINib nibWithNibName:@"ABCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CELL"];
    [self.view addSubview:tableView];
    tableView.tableFooterView = [UIView new];
}
//delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"CELL";
    ABCell *tabCell = [tableView dequeueReusableCellWithIdentifier:identifer forIndexPath:indexPath];
    tabCell.cellLabel.text = dataArray[indexPath.row];
    tabCell.callBlock = ^(UIButton *sender){
        NSLog(@"电话号码 === %@",dataArray[indexPath.row]);
        //[self showAlterController:dataArray[indexPath.row]];
        //block可以获取到电话号码，绑定测试使用alterview的代理方法，由于是代理方法无法直接获取到numberString，所以使用动态绑定来传值和取值
        [self showAlterView:dataArray[indexPath.row]];
    };
    return tabCell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}



//MARK:-alterViewShow
- (void)showAlterView:(NSString *)numString {
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"call number" message:numString delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alterView show];
    
    //3.通过key绑定alterview和对应的cell数据源
    objc_setAssociatedObject(alterView, callBtnKey, numString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//alterViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex) {
        //取值
        NSString *numString = objc_getAssociatedObject(alertView, callBtnKey);
        
        NSLog(@" ==== %@",numString);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",numString]] options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES} completionHandler:^(BOOL success) {
            if (success) {
                NSLog(@"拨打电话成功");
            }else {
                NSLog(@"拨打电话失败");
            }
        }];
    }else {
        NSLog(@"false");
    }
}

//MARK:-alterController
//alterController   block可以获取到电话号码，绑定测试使用alterview的代理方法，由于是代理方法无法直接获取到numberString，所以使用动态绑定来传值和取值
- (void)showAlterController:(NSString *)numberString {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Call This Number" message:numberString preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //执行拨打电话的事件
        NSLog(@"拨打电话 - %@",numberString);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",numberString]] options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES} completionHandler:^(BOOL success) {
            if (success) {
                NSLog(@"拨打电话成功");
            }else {
                NSLog(@"拨打电话失败");
            }
        }];
        NSLog(@"%@",numberString);
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
