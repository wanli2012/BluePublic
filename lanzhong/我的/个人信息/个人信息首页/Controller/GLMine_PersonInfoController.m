//
//  GLMine_PersonInfoController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/28.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_PersonInfoController.h"
#import "GLMine_PersonInfo_AddressChooseController.h"//地址选择
#import <SDWebImage/UIImageView+WebCache.h>

@interface GLMine_PersonInfoController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;


@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;//IDNum
@property (weak, nonatomic) IBOutlet UITextField *trueNameTF;//真实姓名
@property (weak, nonatomic) IBOutlet UITextField *IDCardNumTF;//身份证号
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;//昵称

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;//手机号
@property (weak, nonatomic) IBOutlet UITextField *recommendTF;//推荐人TF
@property (nonatomic, strong)LoadWaitView *loadV;

@end

@implementation GLMine_PersonInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"个人信息";
    
    self.picImageV.layer.cornerRadius = self.picImageV.height/2;
    
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:[UserModel defaultUser].user_pic] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    
    self.contentViewWidth.constant = kSCREEN_WIDTH;
    self.contentViewHeight.constant = 530;
    self.ensureBtn.layer.cornerRadius = 5.f;
    
    self.phoneTF.text = [UserModel defaultUser].phone;
    self.recommendTF.text = [UserModel defaultUser].g_name;
    self.userNameLabel.text = [UserModel defaultUser].uname;
    
    self.trueNameTF.text = [UserModel defaultUser].truename;
    self.IDCardNumTF.text = [UserModel defaultUser].idcard;
    
    self.nickNameLabel.text = [UserModel defaultUser].nickname;
    
    if ([[UserModel defaultUser].real_state integerValue] == 0 || [[UserModel defaultUser].real_state integerValue] == 2) {
        self.trueNameTF.enabled = YES;
        self.IDCardNumTF.enabled = YES;
    }else{
        self.trueNameTF.enabled = NO;
        self.IDCardNumTF.enabled = NO;
    }
    
    switch ([[UserModel defaultUser].real_state integerValue]) {//实名认证状态 0未认证  1成功   2失败   3审核中
        case 0:
        {
            self.ensureBtn.hidden = NO;
        }
            break;
        case 1:
        {
            self.ensureBtn.hidden = YES;
        }
            break;
        case 2:
        {
            self.ensureBtn.hidden = NO;
            self.ensureBtn.enabled = NO;
            [self.ensureBtn setTitle:@"重新认证" forState:UIControlStateNormal];
            
        }
            break;
        case 3:
        {
            self.ensureBtn.hidden = NO;
            self.ensureBtn.enabled = NO;
            [self.ensureBtn setTitle:@"审核中" forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (IBAction)ensure:(id)sender {

    if (self.trueNameTF.text.length == 0) {
        [MBProgressHUD showError:@"请输入真实姓名"];
        return;
    }else if(![predicateModel IsChinese:self.trueNameTF.text]){
        [MBProgressHUD showError:@"真实姓名应该是汉字"];
        return;
    }
    
    if (self.IDCardNumTF.text.length == 0) {
        [MBProgressHUD showError:@"请输入身份证号"];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"type"] = @"2";
    dict[@"truename"] = self.trueNameTF.text;
    dict[@"idcard"] = self.IDCardNumTF.text;
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kUSER_INFO_SAVE_URL paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            
        }
        
        [MBProgressHUD showError:responseObject[@"message"]];
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];

    }];

}

//头像修改
- (IBAction)picModify:(id)sender {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"头像修改" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
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
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"token"] = [UserModel defaultUser].token;
        dict[@"uid"] = [UserModel defaultUser].uid;
        dict[@"type"] = @"1";
//        dict[@"pic"] = data;
        
        _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
        manager.requestSerializer.timeoutInterval = 10;
        // 加上这行代码，https ssl 验证。
        [manager setSecurityPolicy:[NetworkManager customSecurityPolicy]];
        [manager POST:[NSString stringWithFormat:@"%@%@",URL_Base,kUSER_INFO_SAVE_URL] parameters:dict  constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            //将图片以表单形式上传
            
            if (picImage) {
                
                NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
                formatter.dateFormat=@"yyyyMMddHHmmss";
                NSString *str=[formatter stringFromDate:[NSDate date]];
                NSString *fileName=[NSString stringWithFormat:@"%@.png",str];
                NSData *data = UIImagePNGRepresentation(picImage);
                [formData appendPartWithFileData:data name:@"pic" fileName:fileName mimeType:@"image/png"];
            }
            
        }progress:^(NSProgress *uploadProgress){
            
        }success:^(NSURLSessionDataTask *task, id responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            if ([dic[@"code"]integerValue] == SUCCESS_CODE) {
                
                self.picImageV.image = [UIImage imageWithData:data];
                [MBProgressHUD showError:dic[@"message"]];
                
            }else{
                
                [MBProgressHUD showError:dic[@"message"]];
            }
            
            [_loadV removeloadview];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [_loadV removeloadview];
            [MBProgressHUD showError:error.localizedDescription];
        }];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
}

//昵称修改
- (IBAction)nameModify:(id)sender {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"昵称修改" message:@"what's your name?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"请输入昵称";
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"token"] = [UserModel defaultUser].token;
        dict[@"uid"] = [UserModel defaultUser].uid;
        dict[@"type"] = @"1";
        dict[@"nickname"] = alertVC.textFields.lastObject.text;
        
        _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
        [NetworkManager requestPOSTWithURLStr:kUSER_INFO_SAVE_URL paramDic:dict finish:^(id responseObject) {
            
            [_loadV removeloadview];
            
            if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
                [MBProgressHUD showSuccess:responseObject[@"message"]];
                [self refresh];
            }
            
            [MBProgressHUD showError:responseObject[@"message"]];
            
        } enError:^(NSError *error) {
            [_loadV removeloadview];
        }];
    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:ok];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

//刷新数据
-(void)refresh {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    
    [NetworkManager requestPOSTWithURLStr:kREFRESH_URL paramDic:dict finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            
            [UserModel defaultUser].umoney = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"umoney"]];
            [UserModel defaultUser].invest_count = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"invest_count"]];
            [UserModel defaultUser].item_count = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"item_count"]];
            [UserModel defaultUser].user_server = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"user_server"]];
            [UserModel defaultUser].real_state = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"real_state"]];
            [UserModel defaultUser].nickname = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"nickname"]];
            
            [usermodelachivar achive];
            self.nickNameLabel.text = [UserModel defaultUser].nickname;
        }
        
    } enError:^(NSError *error) {

    }];
}

- (IBAction)address:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_PersonInfo_AddressChooseController *addressVC = [[GLMine_PersonInfo_AddressChooseController alloc] init];
    [self.navigationController pushViewController:addressVC animated:YES];
}


@end
