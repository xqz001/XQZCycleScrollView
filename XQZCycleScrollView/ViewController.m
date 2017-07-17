//
//  ViewController.m
//  XQZCycleScrollView
//
//  Created by liwei on 2016/7/15.
//  Copyright © 2016年 PioneerLee. All rights reserved.
//

#import "ViewController.h"

#import "XQZCycleScrollView.h"

@interface ViewController ()

@property (nonatomic, assign) NSInteger index; /**< 索引 */

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGRect cycleViewFrame = CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 200);
    XQZCycleScrollView *cycleView = [XQZCycleScrollView xqz_cycleScrollViewWithFrame:cycleViewFrame];
//    cycleView.isAutoCycle = NO;
    
    [self.view addSubview:cycleView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
