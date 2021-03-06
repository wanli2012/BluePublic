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
#import "HXPhotoView.h"

//单选picker 和动画
#import "GLSimpleSelectionPickerController.h"
#import "editorMaskPresentationController.h"

#import "HWCalendar.h"//日期选择
#import "GLMutipleChooseController.h"//省市选择
#import "GLPublish_CityModel.h"//城市模型
//#import "GLPublish_WebsiteController.h"//上传文件
#import "GLPublishCategoryModel.h"//分类模型

#import "GLPublish_UploadController.h"//上传文件页

static const CGFloat kPhotoViewMargin = 12.0;

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

//@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@property (weak, nonatomic) IBOutlet UILabel *industryLabel;//行业分类
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;//日期
@property (weak, nonatomic) IBOutlet UIImageView *isAgreeImageV;//是否同意协议

@property (weak, nonatomic) IBOutlet UITextField *moneyTF;//金额TF
@property (weak, nonatomic) IBOutlet UITextField *titleTF;//标题TF
@property (weak, nonatomic) IBOutlet UITextView *infoTV;//项目说明
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (strong, nonatomic)HWCalendar *Calendar;
@property (strong, nonatomic)UIView *CalendarView;

//@property (nonatomic, strong)GLCircle_item_screenModel *categoryModel;
@property (nonatomic, strong)LoadWaitView *loadV;
//@property (nonatomic, strong)NSMutableArray *dataSourceArr;//行业数据源
@property (nonatomic, strong) GLPublishCategoryModel *categoryModel;//行业模型
@property (nonatomic, copy) NSString *trade_id_first;//行业一级id
@property (nonatomic, copy)NSString *trade_id;//行业id(二级)
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

@property (strong, nonatomic) HXPhotoManager *manager;
@property (strong, nonatomic) HXPhotoView *photoView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeight;

@property (weak, nonatomic) IBOutlet UIImageView *noInsureImageV;
@property (weak, nonatomic) IBOutlet UIImageView *selfInsureImageV;
@property (weak, nonatomic) IBOutlet UIImageView *projectInsreImageV;
@property (weak, nonatomic) IBOutlet UIView *uploadView;

@property (nonatomic, assign)NSInteger ensure_type;//投保类型

@end

@implementation GLPublishController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"项目发布";
    [self addleftItem];
    self.contentViewWidth.constant = kSCREEN_WIDTH;
    self.contentViewHeight.constant = 1000;

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

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.titleTF];
    
    self.photoView.manager = self.manager;
    [self.scrollView addSubview:self.photoView];
    
    self.scrollViewHeight.constant = (kSCREEN_WIDTH - 30)/3;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenTheUploadView) name:@"UploadFileNotification" object:nil];
    
    self.ensure_type = 1;
    
}

-(void)addleftItem{
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake( 0, 0, 60, 44)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//左对齐
    [button setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0 ,10, 0, 0)];
    // 让返回按钮内容继续向左边偏移10
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -17, 0, 0);
    
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *ba=[[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItem = ba;
}
-(void)popself{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 获取分类
- (void)postRequest_Category {

    [NetworkManager requestPOSTWithURLStr:kItem_type_data paramDic:@{} finish:^(id responseObject) {

        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            if([responseObject[@"data"] count] != 0){
                
                self.categoryModel = nil;
                self.categoryModel = [GLPublishCategoryModel mj_objectWithKeyValues:responseObject[@"data"]];

            }
        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        
    }];
    
}
//设置字体颜色
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

//！！！重点在viewWillAppear方法里调用下面两个方法
-(void)viewWillAppear:(BOOL)animated{
    
    [self preferredStatusBarStyle];
    
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
    
    self.navigationController.navigationBar.hidden = NO;
}

/**
 显示出文件,隐藏上传View
 */
- (void)hiddenTheUploadView {
    
    self.uploadView.hidden = YES;
    
}
#pragma mark -  行业选择
- (IBAction)industryChoose:(id)sender {
    [self.view endEditing:YES];
    GLSimpleSelectionPickerController *vc=[[GLSimpleSelectionPickerController alloc]init];
    
    if (self.categoryModel) {

        NSMutableArray *arrM = [NSMutableArray array];
        for (GLPublishCategoryModel *model in self.categoryModel.son) {
            [arrM addObject:model.type_name];
        }
        vc.dataSourceArr = arrM;
        vc.titlestr = @"请选择行业分类";
        __weak typeof(self)weakSelf = self;
        vc.returnreslut = ^(NSInteger index){
            
            weakSelf.industryLabel.text = weakSelf.categoryModel.son[index].type_name;
            weakSelf.trade_id = weakSelf.categoryModel.son[index].type_id;
            weakSelf.industryLabel.textColor = [UIColor darkGrayColor];
            weakSelf.trade_id_first = weakSelf.categoryModel.type_id;
//            if(self.trade_id.length == 0){
//                [SVProgressHUD showErrorWithStatus:@"不限不能提交,请重新选择"];
//                weakSelf.industryLabel.text = @"";
//            }
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
    
    if(self.cityModels.count != 0){
        [self popCityChoose];
        return;
    }
    
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
                [self popCityChoose];
            }
        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
    }];

}

- (void)popCityChoose{
    [self.view endEditing:YES];
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
        [weakself.view endEditing:YES];
        
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

#pragma mark - 照片选择器 代理
- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {

    [self.imageArr removeAllObjects];
    
    __weak typeof(self) weakself = self;
    
    for (HXPhotoModel *photo in photos) {
        if (photo.type == HXPhotoModelMediaTypeCameraPhoto) {
 
            [weakself.imageArr insertObject:photo.previewPhoto atIndex:0];
        }else{

            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
            
            [[PHImageManager defaultManager] requestImageForAsset:photo.asset targetSize:[UIScreen mainScreen].bounds.size contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage *result, NSDictionary *info) {
                //设置图片
                [weakself.imageArr insertObject:result atIndex:0];
                
            }];
        }
    }
}

- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {

    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(frame) + kPhotoViewMargin);
    
}


#pragma mark - 上传文件
/**
 上传文件
 */
- (IBAction)uploadFile:(id)sender {
    
//    GLPublish_WebsiteController *websiteVC= [[GLPublish_WebsiteController alloc] init];
//    [self presentViewController:websiteVC  animated:YES completion:nil];
    
}

#pragma mark - 保险选择
/**
 保险选择
 @param tap 手势
 */
- (IBAction)insureChoose:(UITapGestureRecognizer *)tap {
    self.noInsureImageV.image = [UIImage imageNamed:@"nochoice_grey"];
    self.selfInsureImageV.image = [UIImage imageNamed:@"nochoice_grey"];
    self.projectInsreImageV.image = [UIImage imageNamed:@"nochoice_grey"];
    
    switch (tap.view.tag) {
        case 11:
        {
            self.noInsureImageV.image = [UIImage imageNamed:@"mine_choice"];
        
            
        }
            break;
        case 12:
        {
            self.selfInsureImageV.image = [UIImage imageNamed:@"mine_choice"];
        }
            break;
        case 13:
        {
            self.projectInsreImageV.image = [UIImage imageNamed:@"mine_choice"];
        }
            break;
            
        default:
            break;
    }
    
    self.ensure_type = tap.view.tag - 10;
    
}

//自行资金投保 说明
- (IBAction)insureSelfDetail:(id)sender {

    self.hidesBottomBarWhenPushed = YES;
    GLBusiness_CertificationController *aboutVC = [[GLBusiness_CertificationController alloc] init];
    aboutVC.url = Other_ensure_URL;
    aboutVC.navTitle = @"自行资金投保";
    [self.navigationController pushViewController:aboutVC animated:YES];
}

//项目资金投保 说明
- (IBAction)insureProjectDetail:(id)sender {

    self.hidesBottomBarWhenPushed = YES;
    GLBusiness_CertificationController *aboutVC = [[GLBusiness_CertificationController alloc] init];
    aboutVC.url = Other_lose_URL;
    aboutVC.navTitle = @"项目资金投保";
    [self.navigationController pushViewController:aboutVC animated:YES];
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
    
    if ( self.trade_id.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"不限不能提交,请重新选择行业"];
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
    dic[@"ensure_type"] = @(self.ensure_type);
    
    dic[@"one_type"] = self.trade_id;
    dic[@"two_type"] = self.trade_id_first;

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    manager.requestSerializer.timeoutInterval = 20;
    // 加上这行代码，https ssl 验证。
//    [manager setSecurityPolicy:[NetworkManager customSecurityPolicy]];
    [manager POST:[NSString stringWithFormat:@"%@%@",URL_Base,kPUBLISH_PROJECT_URL] parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //将图片以表单形式上传

        for (int i = 0; i < self.imageArr.count; i ++) {

            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            formatter.dateFormat=@"yyyyMMddHHmmss";
            NSString *str=[formatter stringFromDate:[NSDate date]];
            NSString *fileName=[NSString stringWithFormat:@"%@%d.png",str,i];
            NSString *title = [NSString stringWithFormat:@"photo[%zd]",i];

            NSData *data;
            if (UIImagePNGRepresentation(self.imageArr[i]) == nil) {

                data = UIImageJPEGRepresentation(self.imageArr[i], 0.2);
            }else {
                data = UIImageJPEGRepresentation(self.imageArr[i], 0.2);
            }

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

//            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:dic[@"message"]];
            self.hidesBottomBarWhenPushed = YES;
            GLPublish_UploadController *uploadVC = [[GLPublish_UploadController alloc] init];
            uploadVC.item_id = dic[@"data"][@"item_id"];
            [self.navigationController pushViewController:uploadVC animated:YES];

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
    
    if(textField == self.titleTF){
        NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
        if (![string isEqualToString:tem]) {
            [SVProgressHUD showErrorWithStatus:@"标题中不能包含空格"];
            return NO;
            
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
    
    if([[textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length] == 0 || [self.textView.text isEqualToString:@"  请填写项目说明（限制150字以内）"]) {
    self.textView.text = @"";
        
    }
    
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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if (range.length == 1 && text.length == 0) {
        
        return YES;
        
    }else if (textView.text.length > 149) {
        
        textView.text = [textView.text substringToIndex:150];
        [SVProgressHUD showErrorWithStatus:@"请限制在150字以内"];
        return NO;
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
    [self.view endEditing:YES];
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

//- (NSMutableArray *)dataSourceArr{
//
//    if (!_dataSourceArr) {
//        _dataSourceArr = [NSMutableArray array];
//    }
//
//    return _dataSourceArr;
//}
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

- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
        _manager.configuration.openCamera = YES;
        _manager.configuration.photoMaxNum = 3;
        _manager.configuration.videoMaxNum = 0;
        _manager.configuration.maxNum = 3;
        _manager.configuration.videoMaxDuration = 0;
        _manager.configuration.saveSystemAblum = YES;
    }
    return _manager;
}

- (HXPhotoView *)photoView{
    if (!_photoView) {
        _photoView = [HXPhotoView photoManager:self.manager];;
        _photoView.frame = CGRectMake(kPhotoViewMargin, 0, kSCREEN_WIDTH - kPhotoViewMargin * 2, 0);
        _photoView.delegate = self;
        _photoView.backgroundColor = [UIColor whiteColor];
    }
    return _photoView;
}

@end
