//
//  GLMine_CV_ElegantShowController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/11/21.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_CV_ElegantShowController.h"
#import "HXPhotoViewController.h"
#import "HXPhotoView.h"

static const CGFloat kPhotoViewMargin = 12.0;

@interface GLMine_CV_ElegantShowController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,HXPhotoViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UIImageView *imageV2;
@property (weak, nonatomic) IBOutlet UIImageView *imageV3;

@property (nonatomic, strong)LoadWaitView *loadV;
@property (nonatomic, assign)NSInteger picIndex;

@property (nonatomic, strong)NSMutableArray *imageArr;
@property (strong, nonatomic) HXPhotoManager *manager;
@property (strong, nonatomic) HXPhotoView *photoView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeight;

@end

@implementation GLMine_CV_ElegantShowController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"风采展示";
    self.ensureBtn.layer.cornerRadius = 5.f;

    if (self.images.count != 0) {
        
        self.manager.networkPhotoUrls = [NSMutableArray arrayWithArray:self.images];
        self.manager.photoMaxNum = 3 - self.images.count;
    }
    self.photoView.manager = self.manager;
    [self.scrollView addSubview:self.photoView];
    
    self.scrollViewHeight.constant = (kSCREEN_WIDTH - 12)/3;

}

- (IBAction)ensure:(id)sender {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    
    for (int i = 0;  i < self.images.count; i ++) {
        NSString *name = [NSString stringWithFormat:@"head_pic_url[%zd]",i];
        dict[name] = self.images[i];
    }
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    manager.requestSerializer.timeoutInterval = 10;
    // 加上这行代码，https ssl 验证。
    [manager setSecurityPolicy:[NetworkManager customSecurityPolicy]];
    [manager POST:[NSString stringWithFormat:@"%@%@",URL_Base,kCV_DES_SHOW_URL] parameters:dict  constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //将图片以表单形式上传
        for (int i = 0 ; i < self.imageArr.count ; i ++) {
            
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            formatter.dateFormat=@"yyyyMMddHHmmss";
            NSString *str=[formatter stringFromDate:[NSDate date]];
            NSString *fileName=[NSString stringWithFormat:@"%@.png",str];
            NSData *data;
            if (UIImagePNGRepresentation(self.imageArr[i]) == nil) {
                
                data = UIImageJPEGRepresentation(self.imageArr[i], 0.2);
            }else {
                data = UIImageJPEGRepresentation(self.imageArr[i], 0.2);
            }
            
            NSString *name = [NSString stringWithFormat:@"show_pic[%zd]",i];
            [formData appendPartWithFileData:data name:name fileName:fileName mimeType:@"image/png"];
        }
     
    }progress:^(NSProgress *uploadProgress){
        
    }success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if ([dic[@"code"]integerValue] == SUCCESS_CODE) {

            [SVProgressHUD showSuccessWithStatus:dic[@"message"]];
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GLMine_CV_BaseInfoNotification" object:nil];
            
        }else{
            [SVProgressHUD showErrorWithStatus:dic[@"message"]];
        }
        
        [_loadV removeloadview];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [_loadV removeloadview];
        
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (IBAction)picChoose:(UITapGestureRecognizer *)sender {
    
}

#pragma mark - 照片选择器 代理
- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {
    
    [self.imageArr removeAllObjects];
    for (HXPhotoModel *photo in photos) {
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        
        __weak typeof(self) weakself = self;
        [[PHImageManager defaultManager] requestImageForAsset:photo.asset targetSize:[UIScreen mainScreen].bounds.size contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage *result, NSDictionary *info) {
            //设置图片
            if (photo.networkPhotoUrl.length == 0) {
                
                [weakself.imageArr insertObject:result atIndex:0];
            }
        }];
    }
}

- (void)photoView:(HXPhotoView *)photoView deleteNetworkPhoto:(NSString *)networkPhotoUrl {

    BOOL isDel = NO;
    for (NSString *url in self.images) {
        if ([url isEqualToString:networkPhotoUrl]) {

            isDel = YES;
        }
    }
    
    if(isDel){
        [self.images removeObject:networkPhotoUrl];
    }
}

/**  网络图片全部下载完成时调用  */
- (void)photoViewAllNetworkingPhotoDownloadComplete:(HXPhotoView *)photoView{
   
}

- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(frame) + kPhotoViewMargin);
}

#pragma mark - 懒加载
- (NSMutableArray *)imageArr{
    if (!_imageArr) {
        _imageArr = [NSMutableArray arrayWithObjects:@"addphotograph", nil];
    }
    return _imageArr;
}

- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
        _manager.openCamera = YES;
        _manager.cacheAlbum = YES;
        _manager.lookLivePhoto = YES;
        _manager.open3DTouchPreview = YES;
        _manager.cameraType = HXPhotoManagerCameraTypeSystem;
        _manager.photoMaxNum = 3;
        _manager.videoMaxNum = 3;
        _manager.maxNum = 18;
        _manager.saveSystemAblum = NO;
        
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

- (NSMutableArray *)images{
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}

@end
