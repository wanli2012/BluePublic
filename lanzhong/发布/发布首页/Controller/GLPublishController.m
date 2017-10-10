//
//  GLPublishController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/25.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLPublishController.h"
#import "GLBusinessCircleModel.h"

//照片选择
#import "HXPhotoViewController.h"
#import "HXPhotoView.h"

//单选picker 和动画
#import "GLSimpleSelectionPickerController.h"
#import "editorMaskPresentationController.h"

#import "HWCalendar.h"//日期选择
#import <SVProgressHUD/SVProgressHUD.h>

static const CGFloat kPhotoViewMargin = 25;

@interface GLPublishController ()<UITextViewDelegate,HXPhotoViewDelegate,UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning,HWCalendarDelegate,UITextFieldDelegate>
{
    BOOL _ishidecotr;//判断是否隐藏弹出控制器
    BOOL _isAgreeProtocol;//是否同意协议
}
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;//提交

@property (weak, nonatomic) IBOutlet UIView *bgPhotoView;//照片View
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgPhotoViewHeight;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeight;

@property (strong, nonatomic) HXPhotoManager *manager;
@property (strong, nonatomic) HXPhotoView *photoView;

@property (strong, nonatomic)HWCalendar *Calendar;
@property (strong, nonatomic)UIView *CalendarView;

@property (nonatomic, strong)GLCircle_item_screenModel *categoryModel;
@property (nonatomic, strong)LoadWaitView *loadV;
@property (nonatomic, strong)NSMutableArray *dataSourceArr;

@property (weak, nonatomic) IBOutlet UILabel *industryLabel;//行业分类
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;//日期
@property (weak, nonatomic) IBOutlet UIImageView *isAgreeImageV;//是否同意协议

@property (weak, nonatomic) IBOutlet UITextField *moneyTF;//金额TF
@property (weak, nonatomic) IBOutlet UITextField *titleTF;//标题TF
@property (weak, nonatomic) IBOutlet UITextView *infoTV;//项目说明

@property (nonatomic, copy)NSString *trade_id;//行业id
@property (nonatomic, copy)NSString *need_time;//截止日期

@property (nonatomic, assign)BOOL isHaveDian;
@property (nonatomic, strong)NSMutableArray *imageArr;//图片数组

@end

@implementation GLPublishController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.contentViewWidth.constant = kSCREEN_WIDTH;
    self.contentViewHeight.constant = 820;

    self.bgView.layer.cornerRadius = 5.f;
    self.bgView.layer.shadowOpacity = 0.2f;
    self.bgView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.bgView.layer.shadowRadius = 2.f;
    
    self.textView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.textView.layer.borderWidth = 1.f;
    
    self.submitBtn.layer.cornerRadius = 5.f;
    
    self.scrollView.alwaysBounceVertical = YES;
    
    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
    photoView.frame = CGRectMake(kPhotoViewMargin, 0, kSCREEN_WIDTH - kPhotoViewMargin * 2, 0);
    photoView.delegate = self;
    photoView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:photoView];
    self.photoView = photoView;
    
    [self.view addSubview:self.CalendarView];
    
    self.CalendarView.hidden = YES;
    
    [self.CalendarView addSubview:self.Calendar];
    __weak typeof(self) weakself = self;

    _Calendar.returnCancel = ^(){
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakself.CalendarView.hidden = YES;
        });
    };
    _isAgreeProtocol = NO;
    [self postRequest_Category];
    
}

- (void)postRequest_Category {
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];

    [NetworkManager requestPOSTWithURLStr:kCIRCLE_FITER_URL paramDic:@{} finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            if([responseObject[@"data"] count] != 0){
                
                [self.dataSourceArr removeAllObjects];
                self.categoryModel = [GLCircle_item_screenModel mj_objectWithKeyValues:responseObject[@"data"]];
                
                for (GLCircle_itemScreen_manModel *manModel in self.categoryModel.trade) {
                    [self.dataSourceArr addObject:manModel.trade_name];
                }
            }
            
        }else{
            
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
    }];
    
}
- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
        _manager.openCamera = YES;
        _manager.cacheAlbum = YES;
        _manager.lookLivePhoto = YES;
        _manager.open3DTouchPreview = YES;
        _manager.cameraType = HXPhotoManagerCameraTypeSystem;
        _manager.photoMaxNum = 9;
        _manager.videoMaxNum = 9;
        _manager.maxNum = 18;
        _manager.saveSystemAblum = NO;
        
    }
    return _manager;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (IBAction)industryChoose:(id)sender {

    GLSimpleSelectionPickerController *vc=[[GLSimpleSelectionPickerController alloc]init];
    
    if (self.dataSourceArr.count) {

        vc.dataSourceArr = self.dataSourceArr;

        vc.titlestr = @"请选择行业分类";
        __weak typeof(self)weakSelf = self;
        vc.returnreslut = ^(NSInteger index){
            
            weakSelf.industryLabel.text = weakSelf.categoryModel.trade[index].trade_name;
            weakSelf.trade_id = weakSelf.categoryModel.trade[index].trade_id;
        };
        
        vc.transitioningDelegate = self;
        vc.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        [MBProgressHUD showError:@"行业分类暂无数据"];
    }
}

- (IBAction)endTimeChoose:(id)sender {

    self.CalendarView.hidden = NO;
    [_Calendar show];

}

- (IBAction)isAgreeProtocol:(id)sender {

    _isAgreeProtocol = !_isAgreeProtocol;
    
    if (_isAgreeProtocol) {
        
        self.isAgreeImageV.image = [UIImage imageNamed:@"choice"];
    }else{
        self.isAgreeImageV.image = [UIImage imageNamed:@"nochoice"];
    }
    
}

- (IBAction)toProtocol:(id)sender {
    NSLog(@"跳转协议");
}

- (IBAction)dismiss:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//提交
- (IBAction)submit:(id)sender {
    
    if (self.moneyTF.text.length == 0) {
        [MBProgressHUD showError:@"请输入目标金额"];
        return;
    }
    if (self.titleTF.text.length == 0) {
        [MBProgressHUD showError:@"请输入标题"];
        return;
    }
    if ([self.industryLabel.text isEqualToString:@"请选择"]) {
        [MBProgressHUD showError:@"请选择行业"];
        return;
    }
    if ([self.dateLabel.text isEqualToString:@"请选择"]) {
        [MBProgressHUD showError:@"请选择截止日期"];
        return;
    }
    if ([self.infoTV.text isEqualToString:@"  请填写项目说明（限制150字以内）"]|| [self.infoTV.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入项目说明"];
        return;
    }
  
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"title"] = self.titleTF.text;
    dic[@"budget_money"] = self.moneyTF.text;
    dic[@"info"] = self.infoTV.text;
    dic[@"trade_id"] = self.trade_id;
    dic[@"need_time"] = self.need_time;

    dic[@"photo"] = self.imageArr;
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kPUBLISH_PROJECT_URL paramDic:dic finish:^(id responseObject) {
        
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
           
        }else{
            
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        
    }];
    
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
//    manager.requestSerializer.timeoutInterval = 20;
//    // 加上这行代码，https ssl 验证。
//    [manager setSecurityPolicy:[NetworkManager customSecurityPolicy]];
//    [manager POST:[NSString stringWithFormat:@"%@User/openOne",URL_Base] parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        //将图片以表单形式上传
//        
//        for (int i = 0; i < self.imageArr.count; i ++) {
//            
//            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
//            formatter.dateFormat=@"yyyyMMddHHmmss";
//            NSString *str=[formatter stringFromDate:[NSDate date]];
//            NSString *fileName=[NSString stringWithFormat:@"%@%d.png",str,i];
//            [formData appendPartWithFileData:imageViewArr[i] name:titleArr[i] fileName:fileName mimeType:@"image/png"];
//        }
//        
//    }progress:^(NSProgress *uploadProgress){
//
//        [SVProgressHUD showProgress:uploadProgress.fractionCompleted status:[NSString stringWithFormat:@"上传中%.0f%%",(uploadProgress.fractionCompleted * 100)]];
//        
//        if (uploadProgress.fractionCompleted == 1.0) {
//            [SVProgressHUD dismiss];
//            
//            //            self.submit.userInteractionEnabled = YES;
//        }
//        
//    }success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"%@",dic);
//        if ([dic[@"code"]integerValue]==1) {
//            
//            [MBProgressHUD showError:dic[@"message"]];
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        }else{
//            [MBProgressHUD showError:dic[@"message"]];
//            self.submit.userInteractionEnabled = YES;
//            self.submit.backgroundColor = TABBARTITLE_COLOR;
//        }
//        
//        [_loadV removeloadview];
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        self.submit.userInteractionEnabled = YES;
//        self.submit.backgroundColor = TABBARTITLE_COLOR;
//        [MBProgressHUD showError:error.localizedDescription];
//        
//    }];

}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.titleTF) {
        if (textField.text.length > 9) {
            if(![string isEqualToString:@""]){
                
                [MBProgressHUD showError:@"标题请设置在10字以内"];
                return NO;
            }
        }
    }
    
    if (textField == self.moneyTF) {
        /*
         * 不能输入.0-9以外的字符。
         * 设置输入框输入的内容格式
         * 只能有一个小数点
         * 小数点后最多能输入两位
         * 如果第一位是.则前面加上0.
         * 如果第一位是0则后面必须输入点，否则不能输入。
         */
        
        // 判断是否有小数点
        if ([textField.text containsString:@"."]) {
            self.isHaveDian = YES;
        }else{
            self.isHaveDian = NO;
        }
        
        if (string.length > 0) {
            
            //当前输入的字符
            unichar single = [string characterAtIndex:0];
            
            // 不能输入.0-9以外的字符
            if (!((single >= '0' && single <= '9') || single == '.' || single == '\n'))
            {
                [MBProgressHUD showError:@"您的输入格式不正确"];
                return NO;
            }
            
            // 只能有一个小数点
            if (self.isHaveDian && single == '.') {
                [MBProgressHUD showError:@"最多只能输入一个小数点"];
                return NO;
            }
            
            // 如果第一位是.则前面加上0.
            if ((textField.text.length == 0) && (single == '.')) {
                textField.text = @"0";
            }
            
            // 如果第一位是0则后面必须输入点，否则不能输入。
            if ([textField.text hasPrefix:@"0"]) {
                if (textField.text.length > 1) {
                    NSString *secondStr = [textField.text substringWithRange:NSMakeRange(1, 1)];
                    if (![secondStr isEqualToString:@"."]) {
                        [MBProgressHUD showError:@"第二个字符需要是小数点"];
                        return NO;
                    }
                }else{
                    if (![string isEqualToString:@"."]) {
                        [MBProgressHUD showError:@"第二个字符需要是小数点"];
                        return NO;
                    }
                }
            }
            
            // 小数点后最多能输入两位
            if (self.isHaveDian) {
                NSRange ran = [textField.text rangeOfString:@"."];
                // 由于range.location是NSUInteger类型的，所以这里不能通过(range.location - ran.location)>2来判断
                if (range.location > ran.location) {
                    if ([textField.text pathExtension].length > 1) {
                        [MBProgressHUD showError:@"小数点后最多有两位小数"];
                        return NO;
                    }
                }
            }
        }
    }

    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.moneyTF) {
        [self.titleTF becomeFirstResponder];
        
    }else{
        [self.titleTF resignFirstResponder];
    }
    return YES;
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    self.textView.textAlignment = NSTextAlignmentLeft;
    self.textView.textColor = [UIColor darkTextColor];
    self.textView.text = @"";
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    if([[textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]==0) {
        
        self.textView.textAlignment = NSTextAlignmentCenter;
        self.textView.textColor = [UIColor lightGrayColor];
        self.textView.text = @"  请填写项目说明（限制150字以内）";
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
    
    self.dateLabel.text = date;
    
    //    NSDate * senddate = [NSDate date];
    NSDateFormatter  *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY年MM月dd日"];
    //    NSString * locationString=[dateformatter stringFromDate:senddate];
    
    NSDate * now = [dateformatter dateFromString:date];
    //转成时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[now timeIntervalSince1970]];
    
    self.need_time = timeSp;
    
}

#pragma mark-
#pragma mark HXPhotoViewDelegate
- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {
    
    //    NSSLog(@"所有:%ld - 照片:%ld - 视频:%ld",allList.count,photos.count,videos.count);
    
    [self.imageArr removeAllObjects];
    
    for (HXPhotoModel *model in photos) {
        NSString *aPath3=[NSString stringWithFormat:@"%@/Documents/%@.jpg",NSHomeDirectory(),[NSString stringWithFormat:@"%@",model.fullSizeImageURL]];

        UIImage *img = [[UIImage alloc] initWithContentsOfFile:aPath3];
//        [self.imageArr addObject:UIImagePNGRepresentation(img)];
    }
}

- (void)photoView:(HXPhotoView *)photoView deleteNetworkPhoto:(NSString *)networkPhotoUrl {
    //    NSSLog(@"%@",networkPhotoUrl);
}

- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
    //    NSSLog(@"%@",NSStringFromCGRect(frame));
//    self.bgPhotoViewHeight.constant = CGRectGetMaxY(frame) + kPhotoViewMargin;
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(frame) + kPhotoViewMargin);
    
    self.scrollViewHeight.constant = CGRectGetMaxY(frame) + kPhotoViewMargin;
    self.contentViewHeight.constant = 720 + frame.size.height;
    
}

#pragma mark - 动画的代理
//动画
- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source{
    
    return [[editorMaskPresentationController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
    
}
//控制器创建执行的动画（返回一个实现UIViewControllerAnimatedTransitioning协议的类）
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    _ishidecotr=YES;
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    _ishidecotr=NO;
    return self;
}
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    return 0.5;
    
}
-(void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
  
    [self chooseindustry:transitionContext];
    
    
}
-(void)chooseindustry:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    if (_ishidecotr==YES) {
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        toView.frame=CGRectMake(-kSCREEN_WIDTH, (kSCREEN_HEIGHT - 300)/2, kSCREEN_WIDTH - 40, 280);
        toView.layer.cornerRadius = 6;
        toView.clipsToBounds = YES;
        [transitionContext.containerView addSubview:toView];
        [UIView animateWithDuration:0.3 animations:^{
            
            toView.frame=CGRectMake(20, (kSCREEN_HEIGHT - 300)/2, kSCREEN_WIDTH - 40, 280);
            
        } completion:^(BOOL finished) {
            
            [transitionContext completeTransition:YES]; //这个必须写,否则程序 认为动画还在执行中,会导致展示完界面后,无法处理用户的点击事件
        }];
    }else{
        
        UIView *toView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            toView.frame=CGRectMake(20 + kSCREEN_WIDTH, (kSCREEN_HEIGHT - 300)/2, kSCREEN_WIDTH - 40, 280);
            
        } completion:^(BOOL finished) {
            if (finished) {
                [toView removeFromSuperview];
                [transitionContext completeTransition:YES]; //这个必须写,否则程序 认为动画还在执行中,会导致展示完界面后,无法处理用户的点击事件
            }
        }];
    }
}

#pragma mark - 懒加载
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
        _CalendarView.backgroundColor=YYSRGBColor(0, 0, 0, 0.2);
    }
    return _CalendarView;
}

- (NSMutableArray *)dataSourceArr{
    
    if (!_dataSourceArr) {
        _dataSourceArr = [NSMutableArray array];
    }
    
    return _dataSourceArr;
}
- (NSMutableArray *)imageArr{
    if (!_imageArr) {
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
}

@end
