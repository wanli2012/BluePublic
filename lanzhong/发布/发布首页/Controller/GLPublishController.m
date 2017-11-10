//
//  GLPublishController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/25.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLPublishController.h"
#import "GLBusinessCircleModel.h"
#import "GLBusiness_CertificationController.h"//webview的VC

//照片选择
#import "HXPhotoViewController.h"
#import "HXPhotoView.h"

//单选picker 和动画
#import "GLSimpleSelectionPickerController.h"
#import "editorMaskPresentationController.h"

#import "HWCalendar.h"//日期选择
#import "GLMutipleChooseController.h"//省市选择
#import "GLPublish_CityModel.h"//城市模型


@interface GLPublishController ()<UITextViewDelegate,HXPhotoViewDelegate,UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning,HWCalendarDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    BOOL _ishidecotr;//判断是否隐藏弹出控制器
    BOOL _isAgreeProtocol;//是否同意协议
    BOOL _picIndex1;//pic1是否有图
    BOOL _picIndex2;//pic2是否有图
    BOOL _picIndex3;//pic3是否有图
    
}
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;//提交

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic)HWCalendar *Calendar;
@property (strong, nonatomic)UIView *CalendarView;

@property (nonatomic, strong)GLCircle_item_screenModel *categoryModel;
@property (nonatomic, strong)LoadWaitView *loadV;
@property (nonatomic, strong)NSMutableArray *dataSourceArr;//行业数据源

@property (weak, nonatomic) IBOutlet UILabel *industryLabel;//行业分类
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;//日期
@property (weak, nonatomic) IBOutlet UIImageView *isAgreeImageV;//是否同意协议

@property (weak, nonatomic) IBOutlet UITextField *moneyTF;//金额TF
@property (weak, nonatomic) IBOutlet UITextField *titleTF;//标题TF
@property (weak, nonatomic) IBOutlet UITextView *infoTV;//项目说明
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (nonatomic, copy)NSString *trade_id;//行业id
@property (nonatomic, copy)NSString *need_time;//截止日期

@property (nonatomic, assign)BOOL isHaveDian;
@property (nonatomic, strong)NSMutableArray *imageArr;//图片数组

@property (weak, nonatomic) IBOutlet UIImageView *pic1;
@property (weak, nonatomic) IBOutlet UIImageView *pic2;
@property (weak, nonatomic) IBOutlet UIImageView *pic3;

@property (nonatomic, assign)NSInteger picIndex;//pic下标
@property (nonatomic, copy)NSString *lastTextContent;//titleTF最后的字符串

@property (nonatomic, strong)NSMutableArray *cityModels;//城市数据源
@property (nonatomic, copy)NSString *provinceId;//省份id
@property (nonatomic, copy)NSString *cityId;//城市id

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
 
    self.isAgreeImageV.image = [UIImage imageNamed:@"publish_nochoice"];
    
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
    [self postRequest_City];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.titleTF];
    
}
#pragma mark - 获取分类
- (void)postRequest_Category {

    [NetworkManager requestPOSTWithURLStr:kCIRCLE_FITER_URL paramDic:@{} finish:^(id responseObject) {

        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            if([responseObject[@"data"] count] != 0){
                
                [self.dataSourceArr removeAllObjects];
                self.categoryModel = [GLCircle_item_screenModel mj_objectWithKeyValues:responseObject[@"data"]];
                
                for (GLCircle_itemScreen_manModel *manModel in self.categoryModel.trade) {
                    [self.dataSourceArr addObject:manModel.trade_name];
                }
            }
        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {

    }];
    
}
#pragma mark - 获取城市列表
- (void)postRequest_City {
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:kCITYLIST_URL paramDic:@{} finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            if([responseObject[@"data"] count] != 0){
                
                [self.cityModels removeAllObjects];
                for (NSDictionary *dic in responseObject[@"data"]) {
                    
                    GLPublish_CityModel *model = [GLPublish_CityModel mj_objectWithKeyValues:dic];
                    [self.cityModels addObject:model];
                }
            }
        }else{

            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}
#pragma mark -  行业选择
- (IBAction)industryChoose:(id)sender {

    GLSimpleSelectionPickerController *vc=[[GLSimpleSelectionPickerController alloc]init];
    
    if (self.dataSourceArr.count) {

        vc.dataSourceArr = self.dataSourceArr;

        vc.titlestr = @"请选择行业分类";
        __weak typeof(self)weakSelf = self;
        vc.returnreslut = ^(NSInteger index){
            
            weakSelf.industryLabel.text = weakSelf.categoryModel.trade[index].trade_name;
            weakSelf.trade_id = weakSelf.categoryModel.trade[index].trade_id;
            weakSelf.industryLabel.textColor = [UIColor darkGrayColor];
        };
        
        vc.transitioningDelegate = self;
        vc.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:vc animated:YES completion:nil];
    }else{
 
        [SVProgressHUD showErrorWithStatus:@"行业分类暂无数据"];
    }
}
#pragma mark - 截止日期选择
- (IBAction)endTimeChoose:(id)sender {

    self.CalendarView.hidden = NO;
    [_Calendar show];

}

#pragma mark - 省市选择
- (IBAction)cityChoose:(id)sender {
    GLMutipleChooseController *vc=[[GLMutipleChooseController alloc]init];
    vc.dataArr = self.cityModels;
    vc.transitioningDelegate=self;
    vc.modalPresentationStyle=UIModalPresentationCustom;
    
    [self presentViewController:vc animated:YES completion:nil];
    __weak typeof(self) weakself = self;
    vc.returnreslut = ^(NSString *str,NSString *strid,NSString *provinceid,NSString *cityd,NSString *areaid){
        weakself.addressLabel.textColor = [UIColor darkGrayColor];
        weakself.addressLabel.text = str;
        weakself.provinceId = provinceid;
        weakself.cityId = cityd;

    };
}
#pragma mark - 是否同意了协议
- (IBAction)isAgreeProtocol:(id)sender {

    _isAgreeProtocol = !_isAgreeProtocol;
    
    if (_isAgreeProtocol) {
        
        self.isAgreeImageV.image = [UIImage imageNamed:@"publish_choice"];
    }else{
        self.isAgreeImageV.image = [UIImage imageNamed:@"publish_nochoice"];
    }
    
}

#pragma mark - 发布协议
- (IBAction)toProtocol:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLBusiness_CertificationController *aboutVC = [[GLBusiness_CertificationController alloc] init];
    aboutVC.url = Publish_Protocol_URL;
    aboutVC.navTitle = @"发布协议";
    [self.navigationController pushViewController:aboutVC animated:YES];
}

- (IBAction)dismiss:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 图片选择
- (IBAction)getPicture:(UITapGestureRecognizer *)sender {
    
    switch (sender.view.tag) {
        case 11:
        {
            self.picIndex = 1;
        }
            break;
        case 22:
        {
            self.picIndex = 2;
        }
            break;
        case 33:
        {
            self.picIndex = 3;
        }
            break;
        default:
            break;
    }
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"项目图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *picture = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        //    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        //    // 设置选择后的图片可以被编辑
        //    picker.allowsEditing = YES;
        //    [self presentViewController:picker animated:YES completion:nil];
        //1.获取媒体支持格式
        NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        picker.mediaTypes = @[mediaTypes[0]];
        //5.其他配置
        //allowsEditing是否允许编辑，如果值为no，选择照片之后就不会进入编辑界面
        picker.allowsEditing = YES;
        //6.推送
        [self presentViewController:picker animated:YES completion:nil];
        
    }];
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            // 设置拍照后的图片可以被编辑
            picker.allowsEditing = YES;
            picker.sourceType = sourceType;
            [self presentViewController:picker animated:YES completion:nil];
        }else {
            
        }
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertVC addAction:picture];
    [alertVC addAction:camera];
    [alertVC addAction:cancel];
    [self presentViewController:alertVC animated:YES completion:nil];

}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        // 先把图片转成NSData
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil) {
            
            data = UIImageJPEGRepresentation(image, 0.2);
        }else {
            data = UIImageJPEGRepresentation(image, 0.2);
        }
        
        UIImage *picImage = [UIImage imageWithData:data];

        [picker dismissViewControllerAnimated:YES completion:nil];
        
        UIImage *placeImage = [UIImage imageNamed:@"addphotograph"];
        
        switch (self.picIndex) {
            case 1:
            {
                if (![UIImagePNGRepresentation(placeImage) isEqual:UIImagePNGRepresentation(picImage)]){
                    
                    self.pic1.image = picImage;
                    _picIndex1 = 1;
                }
            }
                break;
            case 2:
            {
                if (![UIImagePNGRepresentation(placeImage) isEqual:UIImagePNGRepresentation(picImage)]){
                    
                    self.pic2.image = picImage;
                    _picIndex2 = 1;
                }

            }
                break;
            case 3:
            {
                if (![UIImagePNGRepresentation(placeImage) isEqual:UIImagePNGRepresentation(picImage)]){
                    
                    self.pic3.image = picImage;
                    _picIndex3 = 1;
                }

            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - 提交
- (IBAction)submit:(id)sender {
    
    if (self.moneyTF.text.length == 0) {

        [SVProgressHUD showErrorWithStatus:@"请输入目标金额"];
        return;
    }else if([self.moneyTF.text floatValue] <= 0){

        [SVProgressHUD showErrorWithStatus:@"金额必须大于0"];
        return;
    }
    if (self.titleTF.text.length == 0) {

        [SVProgressHUD showErrorWithStatus:@"请输入标题"];
        return;
    }
    if ([self.industryLabel.text isEqualToString:@"请选择"]) {

        [SVProgressHUD showErrorWithStatus:@"请选择行业"];
        return;
    }
    if ([self.dateLabel.text isEqualToString:@"筹款截止日期"]) {
     
        [SVProgressHUD showErrorWithStatus:@"请选择截止日期"];
        return;
    }
    
    if ([self.infoTV.text isEqualToString:@"  请填写项目说明（限制150字以内）"]|| [self.infoTV.text isEqualToString:@""]) {
       
        [SVProgressHUD showErrorWithStatus:@"请输入项目说明"];
        return;
    }
    if ([self.addressLabel.text isEqualToString:@"请选择"]) {
    
        [SVProgressHUD showErrorWithStatus:@"请选择地址"];
        return;
    }
    
    if (!_isAgreeProtocol) {
        [SVProgressHUD showErrorWithStatus:@"请先同意发布协议"];
        return;
    }
    
    NSTimeInterval time = [self.need_time doubleValue];
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time];
    
    NSInteger kk = [self compareOneDay:detaildate withAnotherDay:[NSDate date]];
    if(kk != 1){
  
        [SVProgressHUD showErrorWithStatus:@"截止日期需大于当前日期"];
        return;
    }
    
    if (self.provinceId.length <= 0 || self.cityId.length == 0) {
    
        [SVProgressHUD showErrorWithStatus:@"未选择地区"];
        return;
    }
    
    [self.imageArr removeAllObjects];//每次判定的时候都清空数组,保证不会重复添加图片
    
    if(_picIndex1 == 1){
        [self.imageArr addObject:self.pic1.image];
    }
    if(_picIndex2 == 1){
        [self.imageArr addObject:self.pic2.image];
    }
    if(_picIndex3 == 1){
        [self.imageArr addObject:self.pic3.image];
    }

    if (self.imageArr.count <= 0) {
        [SVProgressHUD showErrorWithStatus:@"至少上传一张项目图片"];
        return;
    }
    
    
    self.submitBtn.userInteractionEnabled = NO;
    self.submitBtn.backgroundColor = [UIColor lightGrayColor];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"title"] = self.titleTF.text;
    dic[@"budget_money"] = self.moneyTF.text;
    dic[@"info"] = self.infoTV.text;
    dic[@"trade_id"] = self.trade_id;
    dic[@"need_time"] = self.need_time;
    
    dic[@"province"] = self.provinceId;
    dic[@"city"] = self.cityId;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    manager.requestSerializer.timeoutInterval = 20;
    // 加上这行代码，https ssl 验证。
    [manager setSecurityPolicy:[NetworkManager customSecurityPolicy]];
    [manager POST:[NSString stringWithFormat:@"%@%@",URL_Base,kPUBLISH_PROJECT_URL] parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //将图片以表单形式上传
        
        for (int i = 0; i < self.imageArr.count; i ++) {
            
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            formatter.dateFormat=@"yyyyMMddHHmmss";
            NSString *str=[formatter stringFromDate:[NSDate date]];
            NSString *fileName=[NSString stringWithFormat:@"%@%d.png",str,i];
            NSString *title = [NSString stringWithFormat:@"photo[%zd]",i];
      
            NSData *data = UIImagePNGRepresentation(self.imageArr[i]);
            
            [formData appendPartWithFileData:data name:title fileName:fileName mimeType:@"image/png"];
        }
        
    }progress:^(NSProgress *uploadProgress){

        [SVProgressHUD showProgress:uploadProgress.fractionCompleted status:[NSString stringWithFormat:@"上传中%.0f%%",(uploadProgress.fractionCompleted * 100)]];
        
        if (uploadProgress.fractionCompleted == 0.5) {
            [SVProgressHUD dismiss];
        
        }
        
    }success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
    
        
        if ([dic[@"code"] integerValue] == SUCCESS_CODE) {

            [SVProgressHUD showSuccessWithStatus:dic[@"message"]];
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:dic[@"message"]];

        }
        
        self.submitBtn.userInteractionEnabled = YES;
        self.submitBtn.backgroundColor = MAIN_COLOR;
        [_loadV removeloadview];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.submitBtn.userInteractionEnabled = YES;
        self.submitBtn.backgroundColor = MAIN_COLOR;

        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        
    }];

}

- (void)textFieldDidChange:(NSNotification *)note{
    //获取文本框内容的字节数
    int bytes = [self stringConvertToInt:self.titleTF.text];
    //设置不能超过32个字节，因为不能有半个汉字，所以以字符串长度为单位。
    if (bytes > 10){
        //超出字节数，还是原来的内容
        self.titleTF.text = self.lastTextContent;
        
    }else{
        
        self.lastTextContent = self.titleTF.text;
    }
}

#pragma mark - 得到字节数函数
-  (int)stringConvertToInt:(NSString*)strtemp
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++)
    {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength+1)/2;
}
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    

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
                [SVProgressHUD showErrorWithStatus:@"您的输入格式不正确"];
                return NO;
            }
            
            // 只能有一个小数点
            if (self.isHaveDian && single == '.') {
    
                [SVProgressHUD showErrorWithStatus:@"最多只能输入一个小数点"];
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
                        
                        [SVProgressHUD showErrorWithStatus:@"第二个字符需要是小数点"];
                        return NO;
                    }
                }else{
                    if (![string isEqualToString:@"."]) {
    
                        [SVProgressHUD showErrorWithStatus:@"第二个字符需要是小数点"];
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
                   
                        [SVProgressHUD showErrorWithStatus:@"小数点后最多有两位小数"];
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
    self.dateLabel.textColor = [UIColor darkGrayColor];
    
    NSDateFormatter  *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY年MM月dd日"];
    
    NSDate * now = [dateformatter dateFromString:date];
    //转成时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[now timeIntervalSince1970]];
    
    self.need_time = timeSp;
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
- (NSMutableArray *)cityModels{
    if (!_cityModels) {
        _cityModels = [NSMutableArray array];
    }
    return _cityModels;
}

@end
