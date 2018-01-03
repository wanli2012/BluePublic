//
//  GLMine_CV_PreviewController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/11/22.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_CV_PreviewController.h"
#import "JZAlbumViewController.h"

#import "GLMine_CV_Header.h"//头视图
#import "GLMine_CV_BaseCell.h"//基础信心cell
#import "GLMine_CV_WorkCell.h"//工作经历cell
#import "GLMine_CV_EducationCell.h"//教育经历cell
#import "GLMine_CV_SkillCell.h"//技能评价cell
#import "GLMine_CV_StyleCell.h"//风采展示cell
#import "GLMine_CV_ExpectedJobCell.h"//期望工作
#import "GLMine_CV_DescriptionCell.h"//自我描述

#import "GLMine_CV_BaseInfoController.h"//基本信息修改界面

#import "GLMine_CV_LiveListController.h"//工作经历列表
#import "GLMine_CV_EducationController.h"//教育经历
#import "GLMine_CV_SkillController.h"//技能评价
#import "GLMine_CV_ExpectedWorkController.h"//期望工作
#import "GLMine_CV_ElegantShowController.h"//风采展示
#import "GLMine_CV_SelfDescriptionController.h"//自我描述

@interface GLMine_CV_PreviewController ()<UITableViewDelegate,UITableViewDataSource,GLMine_CV_StyleCellDelegate,GLMine_CV_BaseCellDelegate>

@property (nonatomic, strong)NSMutableArray *titleArr;
@property (nonatomic, assign)NSInteger seletecSection;//点中编辑是哪个组

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *headerView;//头视图
@property (weak, nonatomic) IBOutlet UIImageView *picImageV;//头像
@property (weak, nonatomic) IBOutlet UIImageView *bgImageV;//背景图片
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *editImageV;

@property (nonatomic, strong)LoadWaitView *loadV;
@property (nonatomic, strong)GLMine_CV_DetailModel *model;

@property (nonatomic, assign)BOOL  HideNavagation;//是否需要恢复自定义导航栏

@end

@implementation GLMine_CV_PreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"简历预览";
    
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
}

- (void)refresh{
    self.tableView.contentOffset = CGPointMake(0, 0);
    [self postRequest];
}

#pragma mark - 预览
- (void)preview {
    
}
#pragma mark - 请求数据
- (void)postRequest{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"resume_id"] = self.resume_id;
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kCV_DETAIL_URL paramDic:dic finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self endRefresh];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            if([responseObject[@"data"] count] != 0){
                
                self.model = [GLMine_CV_DetailModel mj_objectWithKeyValues:responseObject[@"data"]];
                [self.picImageV sd_setImageWithURL:[NSURL URLWithString:self.model.basic.head_pic] placeholderImage:[UIImage imageNamed:@"touxiang2"]];
                [self.titleArr removeAllObjects];
                [self.titleArr addObjectsFromArray:@[@"基本信息",@"工作经历",@"教育经历",@"技能评价",@"期望工作",@"风采展示",@"自我描述"]];
            }
        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
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
#pragma mark - 查看头像大图
- (IBAction)checkBigPic:(id)sender {
    self.HideNavagation = YES;
    JZAlbumViewController *jzAlbumVC = [[JZAlbumViewController alloc]init];
    jzAlbumVC.currentIndex = 0;//这个参数表示当前图片的index，默认是0

    NSString *str = self.model.basic.head_pic;
    jzAlbumVC.imgArr = [NSMutableArray arrayWithObject:str];//图片数组，可以是url，也可以是UIImage
    [self presentViewController:jzAlbumVC animated:NO completion:nil];
    
}
#pragma mark - 打电话
- (void)callThePerson:(NSString *)phoneNum{

    NSString *tel = [NSString stringWithFormat:@"tel://%@",phoneNum];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];

}

#pragma mark - 查看大图
- (void)toSeeBigPic:(NSInteger)index{
    self.HideNavagation = YES;
    JZAlbumViewController *jzAlbumVC = [[JZAlbumViewController alloc]init];
    jzAlbumVC.currentIndex = index;//这个参数表示当前图片的index，默认是0
    
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSString * s in self.model.basic.show_photo) {
        [arrM addObject:s];
    }
    jzAlbumVC.imgArr = arrM;//图片数组，可以是url，也可以是UIImage
    [self presentViewController:jzAlbumVC animated:NO completion:nil];
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

    switch (section) {
        case 1:
        {
            return self.model.live.count;
        }
            break;
        case 2:
        {
            if(self.model.teach.school.length == 0){
                return 0;
            }else{
                return 1;
            }
        }
            break;
        case 3:
        {
            return self.model.skill.count;
        }
            break;
        case 4:
        {
            if (self.model.want.want_duty.length == 0) {
                return 0;
            }else{
                return 1;
            }
        }
            break;
        case 5:
        {
            if (self.model.basic.show_photo.count == 0) {
                return 0;
            }else{
                return 1;
            }
        }
            break;
        case 6:
        {
            if (self.model.basic.i_info.length == 0) {
                return 0;
            }else{
                return 1;
            }
        }
            break;
            
        default:
        {
            return 1;
        }
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    switch (indexPath.section) {
        case 0://基本信息
        {
            GLMine_CV_BaseCell *baseCell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_CV_BaseCell"];
            baseCell.model = self.model.basic;
            baseCell.delegate = self;
            baseCell.callBtn.hidden = NO;
            cell = baseCell;
            
        }
            break;
        case 1://工作经历
        {
            GLMine_CV_WorkCell *c = [tableView dequeueReusableCellWithIdentifier:@"GLMine_CV_WorkCell"];
            if (self.model.live.count > 0) {
                
                c.model = self.model.live[indexPath.row];
            }
            cell = c;
        }
            break;
        case 2://教育经历
        {
            GLMine_CV_EducationCell *c = [tableView dequeueReusableCellWithIdentifier:@"GLMine_CV_EducationCell"];
            c.model = self.model.teach;
            cell = c;
        }
            break;
        case 3://技能评价
        {
            GLMine_CV_SkillCell *c = [tableView dequeueReusableCellWithIdentifier:@"GLMine_CV_SkillCell"];

            if (self.model.skill.count > 0) {
                
                c.model = self.model.skill[indexPath.row];
            }
            cell = c;
        }
            break;
        case 4://期望工作
        {
            GLMine_CV_ExpectedJobCell *c = [tableView dequeueReusableCellWithIdentifier:@"GLMine_CV_ExpectedJobCell"];
            c.model = self.model.want;
            cell = c;
        }
            break;
        case 5://自我风采
        {
            GLMine_CV_StyleCell *c = [tableView dequeueReusableCellWithIdentifier:@"GLMine_CV_StyleCell"];
            c.images = self.model.basic.show_photo;
            c.delegate = self;
            cell = c;
        }
            break;
        case 6://自我描述
        {
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
                return 0;
            }
            self.tableView.rowHeight = UITableViewAutomaticDimension;
            self.tableView.estimatedRowHeight = 44;
            
            return self.tableView.rowHeight;
        }
            break;
        case 2:
        {
            if(self.model.teach.education_leave.length == 0 && self.model.teach.leave_time.length == 0 && self.model.teach.major.length == 0 && self.model.teach.school.length == 0){
                return 0;
            }
            return 65;
        }
            break;
        case 3:
        {
            if(self.model.skill.count == 0){
                return 0;
            }
            return 40;
        }
            break;
        case 4:
        {
            if (self.model.want.want_city_name.length == 0 && self.model.want.want_duty.length == 0) {
                return 0;
            }
            return 62;
        }
            break;
        case 5:
        {
            if (self.model.basic.show_photo.count == 0) {
                return 0;
            }
            return 95;
        }
            break;
        case 6:
        {
            if (self.model.basic.i_info.length == 0) {
                return 0;
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
    if (self.model.live.count == 0 && section == 1) {
        UIView *view = [[UIView alloc]init];
        return view;
    }else if(self.model.teach.school.length == 0  && section == 2){
        UIView *view = [[UIView alloc]init];
        return view;
    }else if(self.model.skill.count == 0  && section == 3){
        UIView *view = [[UIView alloc]init];
        return view;
    }else if(self.model.want.want_duty.length == 0 && section == 4){
        UIView *view = [[UIView alloc]init];
        return view;
    }else if(self.model.basic.show_photo.count == 0 && section == 5){
        UIView *view = [[UIView alloc]init];
        return view;
    }else if(self.model.basic.i_info.length == 0 && section == 6){
        UIView *view = [[UIView alloc]init];
        return view;
    }

    static NSString *viewIdentfier = @"GLMine_CV_Header";
    
    GLMine_CV_Header *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewIdentfier];
    
    if(!headerView){
        
        headerView = [[GLMine_CV_Header alloc] initWithReuseIdentifier:viewIdentfier];
    }
    
    headerView.titleLabel.text = self.titleArr[section];
    headerView.index = section;

    headerView.editBtn.hidden = YES;
  
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (self.model.live.count == 0 && section == 1) {
        return 0;
    }else if(self.model.teach.school.length == 0  && section == 2){
        return 0;
    }else if(self.model.skill.count == 0  && section == 3){
        return 0;
    }else if(self.model.want.want_duty.length == 0 && section == 4){
        return 0;
    }else if(self.model.basic.show_photo.count == 0 && section == 5){
        return 0;
    }else if(self.model.basic.i_info.length == 0 && section == 6){
        return 0;
    }
    return 45;
}

#pragma mark - 懒加载
- (NSMutableArray *)titleArr{
    if (!_titleArr) {
        _titleArr = [NSMutableArray arrayWithArray:@[@"基本信息",@"工作经历",@"教育经历",@"技能评价",@"期望工作",@"风采展示",@"自我描述"]];
    }
    return _titleArr;
}

@end
