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
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSDate *maxDate;
    NSDate *minDate;
    if(self.type == 1){
        [comps setYear:10];//设置最大时间为：当前时间推后十年
        maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
        [comps setYear:-100];//设置最小时间为：当前时间前推十年
        minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    }else{
        [comps setYear:0];//设置最大时间为：当前时间推后十年
        maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
        [comps setYear:-150];//设置最小时间为：当前时间前推十年
        minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
        
    }
    [self.datePicker setMaximumDate:maxDate];
    [self.datePicker setMinimumDate:minDate];

}

- (void)dateChange:(UIDatePicker *)sender {
    
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
