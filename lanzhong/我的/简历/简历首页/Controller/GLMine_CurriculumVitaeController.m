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
//#import "GLMine_CV_DetailModel.h"
#import "GLMine_CV_LiveListController.h"//工作经历列表

@interface GLMine_CurriculumVitaeController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)NSArray *titleArr;
@property (nonatomic, assign)NSInteger seletecSection;//点中编辑是哪个组

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *headerView;//头视图
@property (weak, nonatomic) IBOutlet UIImageView *picImageV;//头像
@property (weak, nonatomic) IBOutlet UIImageView *bgImageV;//背景图片

@property (nonatomic, strong)LoadWaitView *loadV;
@property (nonatomic, strong)GLMine_CV_DetailModel *model;

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
    
}

- (void)refresh{
    
    [self postRequest];
}

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
                
                self.model = [GLMine_CV_DetailModel mj_objectWithKeyValues:responseObject[@"data"]];
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
    
    if (section == 1) {
        return self.model.live.count;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell;
    switch (indexPath.section) {
        case 0:
        {
            GLMine_CV_BaseCell *baseCell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_CV_BaseCell"];
            baseCell.model = self.model.basic;
            cell = baseCell;
        }
            break;
        case 1:
        {
            if (self.model.live.count == 0) {
                GLMine_CV_PlaceHolderCell *placeHolderCell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_CV_PlaceHolderCell"];
                return placeHolderCell;
            }
            
            GLMine_CV_WorkCell *c = [tableView dequeueReusableCellWithIdentifier:@"GLMine_CV_WorkCell"];
            c.model = self.model.live[indexPath.row];
            cell = c;
        }
            break;
        case 2:
        {
            if(self.model.teach.education_leave.length == 0 && self.model.teach.leave_time.length == 0 && self.model.teach.major.length == 0 && self.model.teach.school.length == 0){
                GLMine_CV_PlaceHolderCell *placeHolderCell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_CV_PlaceHolderCell"];
                return placeHolderCell;

            }
            GLMine_CV_EducationCell *c = [tableView dequeueReusableCellWithIdentifier:@"GLMine_CV_EducationCell"];
           cell = c;
        }
            break;
        case 3:
        {
            if(self.model.skill.count == 0){
                GLMine_CV_PlaceHolderCell *placeHolderCell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_CV_PlaceHolderCell"];
                return placeHolderCell;

            }
            GLMine_CV_SkillCell *c = [tableView dequeueReusableCellWithIdentifier:@"GLMine_CV_SkillCell"];
            cell = c;
        }
            break;
        case 4:
        {
            if (self.model.basic.show_photo.count) {
                GLMine_CV_PlaceHolderCell *placeHolderCell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_CV_PlaceHolderCell"];
                return placeHolderCell;
            }
            GLMine_CV_StyleCell *c = [tableView dequeueReusableCellWithIdentifier:@"GLMine_CV_StyleCell"];
            cell = c;
        }
            break;
        case 5:
        {
            if (self.model.want.want_city_name.length == 0 && self.model.want.want_duty.length == 0) {
                GLMine_CV_PlaceHolderCell *placeHolderCell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_CV_PlaceHolderCell"];
                return placeHolderCell;
            }
            GLMine_CV_ExpectedJobCell *c = [tableView dequeueReusableCellWithIdentifier:@"GLMine_CV_ExpectedJobCell"];
            cell = c;
        }
            break;
        case 6:
        {
            if (self.model.basic.i_info.length == 0) {
                GLMine_CV_PlaceHolderCell *placeHolderCell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_CV_PlaceHolderCell"];
                return placeHolderCell;
            }
            GLMine_CV_DescriptionCell *c = [tableView dequeueReusableCellWithIdentifier:@"GLMine_CV_DescriptionCell"];
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
            return 315;
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
            if (self.model.basic.show_photo.count) {
                return 100;
            }
            return 95;
        }
            break;
        case 5:
        {
            if (self.model.want.want_city_name.length == 0 && self.model.want.want_duty.length == 0) {
                return 100;
            }
            return 62;
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
    
    __weak typeof(self)weakSelf = self;
    headerView.block = ^(NSInteger index){
        weakSelf.hidesBottomBarWhenPushed = YES;
        switch (index) {
            case 0:
            {
                
                GLMine_CV_BaseInfoController *baseVC = [[GLMine_CV_BaseInfoController alloc] init];
                baseVC.basicModel = weakSelf.model.basic;
                [weakSelf.navigationController pushViewController:baseVC animated:YES];
            }
                break;
            case 1:
            {
                
                GLMine_CV_LiveListController *liveListVC = [[GLMine_CV_LiveListController alloc] init];
                liveListVC.models = weakSelf.model.live;
                [weakSelf.navigationController pushViewController:liveListVC animated:YES];
            }
                break;
                
            default:
                break;
        }
        
    };
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}

#pragma mark - 懒加载
- (NSArray *)titleArr{
    if (!_titleArr) {
        _titleArr = @[@"基本信息", @"工作经历",@"教育经历",@"技能评价",@"自我风采",@"期望工作",@"自我描述"];
    }
    return _titleArr;
}

@end
