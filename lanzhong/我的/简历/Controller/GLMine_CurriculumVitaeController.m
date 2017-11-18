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
#import "GLMine_CV_EducationCell.h"//教育经历cell

@interface GLMine_CurriculumVitaeController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)NSArray *titleArr;
@property (nonatomic, assign)NSInteger seletecSection;//点中编辑是哪个组

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (weak, nonatomic) IBOutlet UIView *headerView;//头视图
@property (weak, nonatomic) IBOutlet UIImageView *picImageV;//头像
@property (weak, nonatomic) IBOutlet UIImageView *bgImageV;//背景图片

@end

@implementation GLMine_CurriculumVitaeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的简历";
    
    self.picImageV.layer.cornerRadius = self.picImageV.height/2;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_CV_BaseCell" bundle:nil] forCellReuseIdentifier:@"GLMine_CV_BaseCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_CV_EducationCell" bundle:nil] forCellReuseIdentifier:@"GLMine_CV_EducationCell"];
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
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    switch (indexPath.section) {
        case 0:
        {
            GLMine_CV_BaseCell *c = [tableView dequeueReusableCellWithIdentifier:@"GLMine_CV_BaseCell"];
            cell = c;
        }
            break;
        case 1:
        {
            
            GLMine_CV_BaseCell *c = [tableView dequeueReusableCellWithIdentifier:@"GLMine_CV_BaseCell"];
            cell = c;
        }
            break;
        case 2:
        {
            
            GLMine_CV_BaseCell *c = [tableView dequeueReusableCellWithIdentifier:@"GLMine_CV_BaseCell"];
           cell = c;
        }
            break;
            
        default:
        {
            GLMine_CV_BaseCell *c = [tableView dequeueReusableCellWithIdentifier:@"GLMine_CV_BaseCell"];
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
            return 360;
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
    
    [headerView.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    
    headerView.block = ^(NSInteger index){
        NSLog(@"%zd",section);
    };
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

#pragma mark - 懒加载
- (NSArray *)titleArr{
    if (!_titleArr) {
        _titleArr = @[@"基本信息", @"工作经历",@"教育经历",@"技能",@"自我风采",@"期望工作"];
    }
    return _titleArr;
}

@end
