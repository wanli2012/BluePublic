//
//  GLMine_AddFundTrendController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/17.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_AddFundTrendController.h"
#import "HWCalendar.h"

@interface GLMine_AddFundTrendController ()<HWCalendarDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textV;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (weak, nonatomic) IBOutlet UIButton *startDateBtn;//起始日期
@property (weak, nonatomic) IBOutlet UIButton *endDateBtn;//截止日期

@property (assign, nonatomic)NSInteger timeBtIndex;//判断选择的按钮时哪一个
@property (strong, nonatomic)HWCalendar *Calendar;
@property (strong, nonatomic)UIView *CalendarView;

@property (nonatomic, strong)LoadWaitView *loadV;

@end

@implementation GLMine_AddFundTrendController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"发布动向";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.textV.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.textV.layer.borderWidth = 0.5f;
    
    self.submitBtn.layer.cornerRadius = 5.f;
    
    [self.view addSubview:self.CalendarView];
    
    self.CalendarView.hidden = YES;
    
    [self.CalendarView addSubview:self.Calendar];
}

- (IBAction)dateChoose:(UIButton *)sender {
    if (sender == self.startDateBtn) {
        _timeBtIndex = 1;
    }else{
        _timeBtIndex = 2;
    }
    self.CalendarView.hidden = NO;
    [self.Calendar show];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (IBAction)submit:(id)sender {
    
    NSLog(@"提交");
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY年MM月dd日"];
    NSDate* date = [formatter dateFromString:self.startDateBtn.titleLabel.text];
    NSDate* date2 = [formatter dateFromString:self.endDateBtn.titleLabel.text];
    
    //时间转时间戳的方法:
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    NSInteger timeSp2 = [[NSNumber numberWithDouble:[date2 timeIntervalSince1970]] integerValue];

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"item_id"] = self.item_id;
    dic[@"starttime"] = [NSString stringWithFormat:@"%zd",timeSp];
    dic[@"endtime"] = [NSString stringWithFormat:@"%zd",timeSp2];
    dic[@"content"] = self.textV.text;
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kADD_TREND_URL paramDic:dic finish:^(id responseObject) {
        
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }

    } enError:^(NSError *error) {
        [_loadV removeloadview];

    }];
}

#pragma mark - UITextViewDelegate textViewShouldBeginEditing
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    if([textView.text isEqualToString:@"请填写资金动向内容(限制150字以内)"]){
        self.textV.text = @"";
        self.textV.textAlignment = NSTextAlignmentLeft;
        self.textV.textColor = [UIColor darkGrayColor];
        
    }
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    if (self.textV.text.length == 0) {
        self.textV.text = @"请填写资金动向内容(限制150字以内)";
        self.textV.textAlignment = NSTextAlignmentCenter;
        self.textV.textColor = [UIColor lightGrayColor];
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
    
    if (_timeBtIndex == 1) {
        
        [self.startDateBtn setTitle:date forState:UIControlStateNormal];
        
    }else if (_timeBtIndex == 2){
        
        [self.endDateBtn setTitle:date forState:UIControlStateNormal];
    }
}


#pragma mark - 时间比较大小
- (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
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

-(HWCalendar*)Calendar{
    
    if (!_Calendar) {
        _Calendar=[[HWCalendar alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH , (kSCREEN_WIDTH * 0.8)/7 * 9.5)];
        _Calendar.delegate = self;
        _Calendar.showTimePicker = YES;
    }
    return _Calendar;
}

-(UIView*)CalendarView{
    
    if (!_CalendarView) {
        _CalendarView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _CalendarView.backgroundColor = YYSRGBColor(0, 0, 0, 0.2);
    }
    return _CalendarView;
}

@end
