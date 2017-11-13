//
//  GLBusiness_AddFundTrendController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/27.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLBusiness_AddFundTrendController.h"
#import "HWCalendar.h"//日期选择

@interface GLBusiness_AddFundTrendController ()<UITextViewDelegate,HWCalendarDelegate>
{
    NSInteger _isStartTime;//是否是开始时间
}
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UITextView *textV;

@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@property (strong, nonatomic)HWCalendar *Calendar;
@property (strong, nonatomic)UIView *CalendarView;

@property (nonatomic, copy)NSString * startTimeStamp;//开始时间  时间戳
@property (nonatomic, copy)NSString * endTimeStamp;//结束时间  时间戳
@property (nonatomic, strong)LoadWaitView *loadV;

@end

@implementation GLBusiness_AddFundTrendController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.submitBtn.layer.cornerRadius = 5.f;
    
    self.textV.text = @"请填写资金动向内容(限制150字以内)";
    
    [self.view addSubview:self.CalendarView];
    
    self.CalendarView.hidden = YES;
    
    [self.CalendarView addSubview:self.Calendar];
     __weak typeof(self) weakself = self;
    _Calendar.returnCancel = ^(){
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakself.CalendarView.hidden = YES;
        });
    };
    

}
- (IBAction)startTimeChoose:(id)sender {
    _isStartTime = YES;
    self.CalendarView.hidden = NO;
    [_Calendar show];

}
- (IBAction)endTimeChoose:(id)sender {
    _isStartTime = NO;
    self.CalendarView.hidden = NO;
    [_Calendar show];

}

//提交
- (IBAction)sumbit:(id)sender {
    
    NSTimeInterval startTime = [self.startTimeStamp doubleValue];
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:startTime];
    
    NSTimeInterval endTime = [self.endTimeStamp doubleValue];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endTime];
    
    NSInteger kk = [self compareOneDay:startDate withAnotherDay:endDate];
    
    if(kk != -1){

        [SVProgressHUD showErrorWithStatus:@"截止日期需大于开始日期"];
        return;
    }
    
    if(self.textV.text.length == 0 || [self.textV.text isEqualToString:@"请填写资金动向内容(限制150字以内)"]){
      
        [SVProgressHUD showErrorWithStatus:@"请输入动向内容"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"item_id"] = self.item_id;
    dic[@"starttime"] = self.startTimeStamp;
    dic[@"endtime"] = self.endTimeStamp;
    dic[@"content"] = self.textV.text;
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kADD_FUNDTREND_URL paramDic:dic finish:^(id responseObject) {
        
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
           
            [SVProgressHUD showSuccessWithStatus:responseObject[@"message"]];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AddFundTrendNotification" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];

    }];


}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    self.textV.textColor = [UIColor darkTextColor];
    self.textV.text = @"";
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    if([[textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length] == 0) {
        
        self.textV.textColor = [UIColor lightGrayColor];
        self.textV.text = @"请填写资金动向内容(限制150字以内)";
    }
    
    return YES;
}

#pragma mark - HWCalendarDelegate
- (void)calendar:(HWCalendar *)calendar didClickSureButtonWithDate:(NSString *)date
{
    __weak typeof(self) weakself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakself.CalendarView.hidden = YES;
    });
    
    
    NSDateFormatter  *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY年MM月dd日"];
    
    NSDate * now = [dateformatter dateFromString:date];
    //转成时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[now timeIntervalSince1970]];
    
    if (_isStartTime) {
        self.startTimeLabel.text = date;
        self.startTimeStamp = timeSp;
    }else{
        self.endTimeLabel.text = date;
        self.endTimeStamp = timeSp;
    }

}

#pragma mark - 时间比较大小
- (NSInteger )compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedDescending) {
        //oneDay > anotherDay
        return 1;
    }
    else if (result == NSOrderedAscending){
        //oneDay < anotherDay
        return -1;
    }
    //oneDay = anotherDay
    return 0;
}

#pragma mark - 懒加载
-(HWCalendar*)Calendar{
    
    if (!_Calendar) {
        _Calendar = [[HWCalendar alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH , (kSCREEN_WIDTH * 0.8)/7 * 9.5)];
        _Calendar.delegate = self;
        _Calendar.showTimePicker = YES;
    }
    return _Calendar;
}

-(UIView*)CalendarView{
    
    if (!_CalendarView) {
        _CalendarView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _CalendarView.backgroundColor = YYSRGBColor(0, 0, 0, 0.2);
    }
    return _CalendarView;
}
@end
