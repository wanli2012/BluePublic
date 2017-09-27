//
//  GLBusiness_DetailController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/27.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLBusiness_DetailController.h"
#import "GLBusiness_DetailCommentCell.h"

@interface GLBusiness_DetailController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;//项目图
@property (weak, nonatomic) IBOutlet UIButton *supportBtn;
@property (weak, nonatomic) IBOutlet UIView *progressSignView;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIView *middleViewLayerView;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV2;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV3;

@end

@implementation GLBusiness_DetailController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUI];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLBusiness_DetailCommentCell" bundle:nil] forCellReuseIdentifier:@"GLBusiness_DetailCommentCell"];
    
}

- (void)setUI{
    
    self.view.backgroundColor = [UIColor brownColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.title = @"项目详情";
    self.imageV.layer.cornerRadius = self.imageV.height/2;
    self.supportBtn.layer.cornerRadius = 5.f;
    
    self.headerView.height = 295;
    self.progressSignView.layer.cornerRadius = self.progressSignView.height/2;
    self.progressSignView.layer.borderColor = YYSRGBColor(0, 125, 254, 1).CGColor;
    self.progressSignView.layer.borderWidth = 0.5f;
    
    self.middleView.layer.cornerRadius = 5.f;
    
    self.middleViewLayerView.layer.cornerRadius = 5.f;
    self.middleViewLayerView.layer.shadowOpacity = 0.1f;
    self.middleViewLayerView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.middleViewLayerView.layer.shadowRadius = 2.f;
    
    self.iconImageV.layer.cornerRadius = self.iconImageV.height/2;
    self.iconImageV2.layer.cornerRadius = self.iconImageV2.height/2;
    self.iconImageV3.layer.cornerRadius = self.iconImageV3.height/2;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

//爱心贡献榜
- (IBAction)contributionList:(id)sender {
    NSLog(@"爱心贡献榜");
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLBusiness_DetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLBusiness_DetailCommentCell"];
    cell.selectionStyle = 0;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 44;
    
    return tableView.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    self.hidesBottomBarWhenPushed = YES;
//    GLBusiness_DetailController *detailVC = [[GLBusiness_DetailController alloc] init];
//    [self.navigationController pushViewController:detailVC animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
    
}


@end
