//
//  GLMine_CurriculumVitaeController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/11/18.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_CurriculumVitaeController.h"

#import "GLMine_CV_Header.h"//头视图
#import "GLMine_CV_BaseCell.h"//基础信心cell
#import "GLMine_CV_WorkCell.h"//工作经历cell
#import "GLMine_CV_EducationCell.h"//教育经历cell
#import "GLMine_CV_SkillCell.h"//技能评价cell
#import "GLMine_CV_StyleCell.h"//风采展示cell
#import "GLMine_CV_ExpectedJobCell.h"//期望工作
#import "GLMine_CV_DescriptionCell.h"//自我描述

#import "GLMine_CV_BaseInfoController.h"//基本信息修改界面
#import "GLMine_CV_PlaceHolderCell.h"//占位cell
#import "GLMine_CV_LiveListController.h"//工作经历列表
#import "GLMine_CV_EducationController.h"//教育经历
#import "GLMine_CV_SkillController.h"//技能评价
#import "GLMine_CV_ExpectedWorkController.h"//期望工作
#import "GLMine_CV_ElegantShowController.h"//风采展示
#import "GLMine_CV_SelfDescriptionController.h"//自我描述
#import "GLMine_CV_PreviewController.h"//预览

@interface GLMine_CurriculumVitaeController ()<UITableViewDelegate,UITableViewDataSource,GLMine_CV_PlaceHolderCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong)NSArray *titleArr;
@property (nonatomic, assign)NSInteger seletecSection;//点中编辑是哪个组

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *headerView;//头视图
@property (weak, nonatomic) IBOutlet UIImageView *picImageV;//头像
@property (weak, nonatomic) IBOutlet UIImageView *bgImageV;//背景图片
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *editImageV;

@property (nonatomic, strong)LoadWaitView *loadV;
@property (nonatomic, strong)GLMine_CV_DetailModel *model;
@property (weak, nonatomic) IBOutlet UISwitch *showSwitch;

@end

@implementation GLMine_CurriculumVitaeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的简历";
    
    self.picImageV.layer.cornerRadius = self.picImageV.height/2;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_CV_BaseCell" bundle:nil] forCellReuseIdentifier:@"GLMine_CV_BaseCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_CV_WorkCell" bundle:nil] forCellReuseIdentifier:@"GLMine_CV_WorkCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_CV_EducationCell" bundle:nil] forCellReuseIdentifier:@"GLMine_CV_EducationCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_CV_SkillCell" bundle:nil] forCellReuseIdentifier:@"GLMine_CV_SkillCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_CV_StyleCell" bundle:nil] forCellReuseIdentifier:@"GLMine_CV_StyleCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_CV_ExpectedJobCell" bundle:nil] forCellReuseIdentifier:@"GLMine_CV_ExpectedJobCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_CV_DescriptionCell" bundle:nil] forCellReuseIdentifier:@"GLMine_CV_DescriptionCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_CV_PlaceHolderCell" bundle:nil] forCellReuseIdentifier:@"GLMine_CV_PlaceHolderCell"];
    
    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf postRequest];
        
    }];
    
    // 设置文字
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔..." forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_header = header;
    
    [self postRequest];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"GLMine_CV_BaseInfoNotification" object:nil];

    [self setNav];
}

#pragma mark - 设置导航栏右键
- (void)setNav{
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//右对齐
    // 让返回按钮内容继续向左边偏移10
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -17);
    
    [button setTitle:@"预览" forState:UIControlStateNormal];
    [button setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    
    button.backgroundColor=[UIColor clearColor];
    [button addTarget:self action:@selector(preview) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}
- (void)refresh{
    self.tableView.contentOffset = CGPointMake(0, 0);
    [self postRequest];
}

#pragma mark - 预览
- (void)preview {
    self.hidesBottomBarWhenPushed = YES;
    GLMine_CV_PreviewController *previewVC = [[GLMine_CV_PreviewController alloc] init];
    [self.navigationController pushViewController:previewVC animated:YES];
}
#pragma mark - 请求数据
- (void)postRequest{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"uid"] = [UserModel defaultUser].uid;
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kCV_DETAIL_URL paramDic:dic finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self endRefresh];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            if([responseObject[@"data"] count] != 0){
                self.model = nil;
                self.model = [GLMine_CV_DetailModel mj_objectWithKeyValues:responseObject[@"data"]];

                [self.picImageV sd_setImageWithURL:[NSURL URLWithString:self.model.basic.head_pic] placeholderImage:[UIImage imageNamed:@"touxiang2"]];
                
                if ([self.model.basic.is_open integerValue] == 1) {
                    [self.showSwitch setOn:YES];
                }else{
                    [self.showSwitch setOn:NO];
                }
            }
        }else{

//            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
        [self.tableView reloadData];
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self endRefresh];
        [self.tableView reloadData];
    }];
}
- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - 修改头像
- (IBAction)modifyPic:(id)sender {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"头像修改" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *picture = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        //    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        // 设置选择后的图片可以被编辑
        
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
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
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
        
        _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
        manager.requestSerializer.timeoutInterval = 10;
        // 加上这行代码，https ssl 验证。
        [manager setSecurityPolicy:[NetworkManager customSecurityPolicy]];
        [manager POST:[NSString stringWithFormat:@"%@%@",URL_Base,kCV_MODIFY_PIC_URL] parameters:dict  constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            //将图片以表单形式上传
            
            if (picImage) {
                
                NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
                formatter.dateFormat=@"yyyyMMddHHmmss";
                NSString *str=[formatter stringFromDate:[NSDate date]];
                NSString *fileName=[NSString stringWithFormat:@"%@.png",str];
                NSData *data = UIImagePNGRepresentation(picImage);
                [formData appendPartWithFileData:data name:@"head_pic" fileName:fileName mimeType:@"image/png"];
            }
            
        }progress:^(NSProgress *uploadProgress){
            
        }success:^(NSURLSessionDataTask *task, id responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            if ([dic[@"code"]integerValue] == SUCCESS_CODE) {
                
                self.picImageV.image = [UIImage imageWithData:data];
                
                [SVProgressHUD showSuccessWithStatus:dic[@"message"]];
                
            }else{
                [SVProgressHUD showErrorWithStatus:dic[@"message"]];
            }
            
            [_loadV removeloadview];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [_loadV removeloadview];
            
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)judgeSwithIsOn{
    if ([self.model.basic.is_open integerValue] == 1) {
        [self.showSwitch setOn:YES];
    }else if([self.model.basic.is_open integerValue] == 2){
        [self.showSwitch setOn:NO];
    }
}

#pragma mark - 设置时候展示简历
- (IBAction)isShowCV:(UISwitch *)sender {
    if (self.model.basic.name.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请先完善基本信息"];
        [self judgeSwithIsOn];
        return;
    }
    if (self.model.basic.head_pic.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请先上传头像"];
        [self judgeSwithIsOn];
        return;
    }
    if (self.model.want.want_duty.length == 0 || self.model.want.want_wages.length == 0 || self.model.want.want_province_name.length == 0 || self.model.want.want_city_name.length == 0) {
        [self judgeSwithIsOn];
        return;
    }
    
    NSString *is_open;
    if (sender.isOn) {//开启状态 1是 2否
        is_open = @"1";
    }else{
        is_open = @"2";
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"is_open"] = is_open;
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kCV_SHOW_CV_URL paramDic:dic finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self endRefresh];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            [SVProgressHUD showSuccessWithStatus:responseObject[@"message"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GLMine_CVNotification" object:nil];
        }else{
           [self judgeSwithIsOn];
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
        [self.tableView reloadData];
        
    } enError:^(NSError *error) {
        [self.tableView reloadData];
    }];
}

#pragma mark - GLMine_CV_PlaceHolderDelegate
//从添加模块进入编辑界面
- (void)edit:(NSInteger)index{
    
    self.hidesBottomBarWhenPushed = YES;
    switch (index) {
        case 0:
        {
            GLMine_CV_BaseInfoController *baseVC = [[GLMine_CV_BaseInfoController alloc] init];
            baseVC.basicModel = self.model.basic;
            [self.navigationController pushViewController:baseVC animated:YES];
        }
            break;
        case 1://工作经历
        {
            GLMine_CV_LiveListController *liveListVC = [[GLMine_CV_LiveListController alloc] init];
            [self.navigationController pushViewController:liveListVC animated:YES];
        }
            break;
        case 2://教育经历
        {
            GLMine_CV_EducationController *educationVC = [[GLMine_CV_EducationController alloc] init];
            educationVC.model = self.model.teach;
            [self.navigationController pushViewController:educationVC animated:YES];
            
        }
            break;
        case 3://技能评价
        {
            GLMine_CV_SkillController *skillVC = [[GLMine_CV_SkillController alloc] init];
            [self.navigationController pushViewController:skillVC animated:YES];
        }
            break;
        case 4://期望工作
        {
            GLMine_CV_ExpectedWorkController *workVC = [[GLMine_CV_ExpectedWorkController alloc] init];
            workVC.model = self.model.want;
            [self.navigationController pushViewController:workVC animated:YES];
        }
            break;
        case 5://自我风采
        {
            GLMine_CV_ElegantShowController *showVC = [[GLMine_CV_ElegantShowController alloc] init];
//            showVC.images = [NSMutableArray arrayWithArray:self.model.basic.show_photo];
            [showVC.images removeAllObjects];
            [showVC.images addObjectsFromArray:self.model.basic.show_photo];
            [self.navigationController pushViewController:showVC animated:YES];
        }
            break;
        case 6://自我描述
        {
            GLMine_CV_SelfDescriptionController *desVC = [[GLMine_CV_SelfDescriptionController alloc] init];
            desVC.i_info = self.model.basic.i_info;
            [self.navigationController pushViewController:desVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 取消header的跟随效果
- (void)scrollViewDidScroll:(UIScrollView*)scrollView {
    
    CGFloat sectionHeaderHeight = 50;
    
    if(scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        
        scrollView.contentInset=UIEdgeInsetsMake(-scrollView.contentOffset.y,0,0,0);
        
    }else if(scrollView.contentOffset.y>=sectionHeaderHeight) {
        
        scrollView.contentInset=UIEdgeInsetsMake(-sectionHeaderHeight,0,0,0);
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.titleArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 1 && self.model.live.count > 0) {
        return self.model.live.count;
    }else if(section == 3 && self.model.skill.count > 0){
        return self.model.skill.count;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell;
    switch (indexPath.section) {
        case 0://基本信息
        {
            GLMine_CV_BaseCell *baseCell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_CV_BaseCell"];
            baseCell.model = self.model.basic;
            cell = baseCell;
        }
            break;
        case 1://工作经历
        {
            if (self.model.live.count == 0) {
                GLMine_CV_PlaceHolderCell *placeHolderCell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_CV_PlaceHolderCell"];
                placeHolderCell.delegate = self;
                placeHolderCell.index = indexPath.section;
                placeHolderCell.titleLabel.text = @"添加工作经历";
                placeHolderCell.selectionStyle = 0;
                return placeHolderCell;
            }
            
            GLMine_CV_WorkCell *c = [tableView dequeueReusableCellWithIdentifier:@"GLMine_CV_WorkCell"];
            c.model = self.model.live[indexPath.row];
            cell = c;
        }
            break;
        case 2://教育经历
        {
            if(self.model.teach.education_leave.length == 0 && self.model.teach.leave_time.length == 0 && self.model.teach.major.length == 0 && self.model.teach.school.length == 0){
                GLMine_CV_PlaceHolderCell *placeHolderCell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_CV_PlaceHolderCell"];
                placeHolderCell.delegate = self;
                placeHolderCell.index = indexPath.section;
                placeHolderCell.titleLabel.text = @"添加教育经历";
                placeHolderCell.selectionStyle = 0;
                return placeHolderCell;
            }
            GLMine_CV_EducationCell *c = [tableView dequeueReusableCellWithIdentifier:@"GLMine_CV_EducationCell"];
            c.model = self.model.teach;
           cell = c;
        }
            break;
        case 3://技能评价
        {
            if(self.model.skill.count == 0){
                GLMine_CV_PlaceHolderCell *placeHolderCell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_CV_PlaceHolderCell"];
                placeHolderCell.delegate = self;
                placeHolderCell.index = indexPath.section;
                placeHolderCell.titleLabel.text = @"添加技能评价";
                placeHolderCell.selectionStyle = 0;
                return placeHolderCell;
            }
            GLMine_CV_SkillCell *c = [tableView dequeueReusableCellWithIdentifier:@"GLMine_CV_SkillCell"];
            c.model = self.model.skill[indexPath.row];
            cell = c;
        }
            break;
        case 4://期望工作
        {
            if (self.model.want.want_city_name.length == 0 && self.model.want.want_duty.length == 0) {
                GLMine_CV_PlaceHolderCell *placeHolderCell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_CV_PlaceHolderCell"];
                placeHolderCell.delegate = self;
                placeHolderCell.index = indexPath.section;
                placeHolderCell.titleLabel.text = @"添加期望工作";
                placeHolderCell.selectionStyle = 0;
                return placeHolderCell;
            }
            GLMine_CV_ExpectedJobCell *c = [tableView dequeueReusableCellWithIdentifier:@"GLMine_CV_ExpectedJobCell"];
            c.model = self.model.want;
            cell = c;
        }
            break;
        case 5://自我风采
        {
            if (self.model.basic.show_photo.count == 0) {
                GLMine_CV_PlaceHolderCell *placeHolderCell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_CV_PlaceHolderCell"];
                placeHolderCell.delegate = self;
                placeHolderCell.index = indexPath.section;
                placeHolderCell.titleLabel.text = @"添加自我风采";
                placeHolderCell.selectionStyle = 0;
                return placeHolderCell;
            }
            GLMine_CV_StyleCell *c = [tableView dequeueReusableCellWithIdentifier:@"GLMine_CV_StyleCell"];
            c.images = self.model.basic.show_photo;
            cell = c;
        }
            break;
        case 6://自我描述
        {
            if (self.model.basic.i_info.length == 0) {
                GLMine_CV_PlaceHolderCell *placeHolderCell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_CV_PlaceHolderCell"];
                placeHolderCell.delegate = self;
                placeHolderCell.index = indexPath.section;
                placeHolderCell.titleLabel.text = @"添加自我描述";
                placeHolderCell.selectionStyle = 0;
                return placeHolderCell;
            }
            GLMine_CV_DescriptionCell *c = [tableView dequeueReusableCellWithIdentifier:@"GLMine_CV_DescriptionCell"];
            c.titleLabel.text = self.model.basic.i_info;
            cell = c;
        }
            break;
        default:
        {
            GLMine_CV_DescriptionCell *c = [tableView dequeueReusableCellWithIdentifier:@"GLMine_CV_DescriptionCell"];
            cell = c;
        }
            break;
    }
    cell.selectionStyle = 0;
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            return 370;
        }
            break;
        case 1:
        {
            if (self.model.live.count == 0) {
                return 100;
            }
            self.tableView.rowHeight = UITableViewAutomaticDimension;
            self.tableView.estimatedRowHeight = 44;
            
            return self.tableView.rowHeight;
        }
            break;
        case 2:
        {
            if(self.model.teach.education_leave.length == 0 && self.model.teach.leave_time.length == 0 && self.model.teach.major.length == 0 && self.model.teach.school.length == 0){
                return 100;
            }
            return 65;
        }
            break;
        case 3:
        {
            if(self.model.skill.count == 0){
                return 100;
            }

            return 40;
        }
            break;
        case 4:
        {
            if (self.model.want.want_city_name.length == 0 && self.model.want.want_duty.length == 0) {
                return 100;
            }
            return 62;
        }
            break;
        case 5:
        {
            if (self.model.basic.show_photo.count == 0) {
                return 100;
            }
            return 95;
        }
            break;
        case 6:
        {
            if (self.model.basic.i_info.length == 0) {
                return 100;
            }
            self.tableView.rowHeight = UITableViewAutomaticDimension;
            self.tableView.estimatedRowHeight = 44;
            
            return self.tableView.rowHeight;
        }
            break;
        default:
            break;
    }
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    static NSString *viewIdentfier = @"GLMine_CV_Header";
    
    GLMine_CV_Header *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewIdentfier];
    
    if(!headerView){
        
        headerView = [[GLMine_CV_Header alloc] initWithReuseIdentifier:viewIdentfier];
    }
    
    headerView.titleLabel.text = self.titleArr[section];
    headerView.index = section;
    [headerView.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    
    if ((self.model.live.count == 0 && section == 1) ||
        (self.model.teach.major.length == 0 && section == 2) ||
        (self.model.skill.count == 0 && section == 3) ||
        (self.model.want.want_duty.length == 0 && section == 4)||
        (self.model.basic.show_photo.count == 0 && section == 5)||
        (self.model.basic.i_info.length == 0 && section == 6)) {
        headerView.editBtn.hidden = YES;
    }else{
        headerView.editBtn.hidden = NO;
    }
    
    if (section == 0 || section == 4){
        headerView.mustLabel.hidden = NO;
    }else{
        headerView.mustLabel.hidden = YES;
    }
    
    __weak typeof(self)weakSelf = self;
    headerView.block = ^(NSInteger index){
        [weakSelf edit:index];
    };
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}

#pragma mark - 懒加载
- (NSArray *)titleArr{
    if (!_titleArr) {
        _titleArr = @[@"基本信息", @"工作经历",@"教育经历",@"技能评价",@"期望工作",@"风采展示",@"自我描述"];
    }
    return _titleArr;
}

@end
