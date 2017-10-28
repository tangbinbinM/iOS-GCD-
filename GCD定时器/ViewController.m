//
//  ViewController.m
//  GCD定时器
//
//  Created by YiGuo on 2017/10/28.
//  Copyright © 2017年 tbb. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
/** 定时器(这里不用带*，因为dispatch_source_t就是个类，内部已经包含了*) */
@property (nonatomic, strong) dispatch_source_t timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}
static int totalTime = 60;
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"------开始------");
    // 获得队列
    //    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_queue_t queue = dispatch_get_main_queue();
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    /**
     设置定时器的各种属性（几时开始任务，每隔多长时间执行一次）
     GCD的时间参数，一般是纳秒（1秒 == 10的9次方纳秒）
     何时开始执行第一个任务
     dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC) 比当前时间晚1秒
     */
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
    uint64_t interval = (uint64_t)(1.0 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    // 设置回调
    dispatch_source_set_event_handler(self.timer, ^{
        totalTime --;
        if (totalTime >=0) {
            NSLog(@"------------%@----还有%d秒", [NSThread currentThread],totalTime);
        }
    });
    // 启动定时器
    dispatch_resume(self.timer);
}

-(void)timer1{
    //一秒后执行且执行一次
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)1.0*NSEC_PER_SEC);
    //回调
    dispatch_after(when, dispatch_get_main_queue(), ^{
        NSLog(@"----%@---",[NSThread currentThread]);
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
