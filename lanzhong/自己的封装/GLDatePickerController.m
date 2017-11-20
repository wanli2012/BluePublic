//
//  GLDatePickerController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/11/20.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLDatePickerController.h"

@interface GLDatePickerController ()

@property (nonatomic,copy)NSString *dateString;

@end

@implementation GLDatePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    
    //当前时间创建NSDate
    NSDate *pickerDate = [self.datePicker date];// 获取用户通过UIDatePicker设置的日期和时间
    NSDateFormatter *pickerFormatter = [[NSDateFormatter alloc] init];// 创建一个日期格式器
    [pickerFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateString = [pickerFormatter stringFromDate:pickerDate];

    self.dateString = dateString;
    
}

- (void)dateChange:(UIDatePicker *)sender {
    
//    UIDatePicker *control = (UIDatePicker*)sender;
//    NSDate* date = control.date;
//    //添加你自己响应代码
//    NSLog(@"dateChanged响应事件：%@",date);
    
    //NSDate格式转换为NSString格式
    NSDate *pickerDate = [self.datePicker date];// 获取用户通过UIDatePicker设置的日期和时间
    NSDateFormatter *pickerFormatter = [[NSDateFormatter alloc] init];// 创建一个日期格式器
    [pickerFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateString = [pickerFormatter stringFromDate:pickerDate];

    self.dateString = dateString;

}
- (IBAction)cancel:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoveConsumptionVC" object:nil];
}

- (IBAction)ensure:(id)sender {
    
    if (self.returnreslut) {
        self.returnreslut(self.dateString);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoveConsumptionVC" object:nil];
    
}

@end
