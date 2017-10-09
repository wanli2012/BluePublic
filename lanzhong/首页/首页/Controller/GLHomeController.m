//
//  GLHomeController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/25.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLHomeController.h"
#import "GLHomeCell.h"

#import "GLPay_ChooseController.h"//支付选择
#import "GLHome_CasesController.h"//经典案例
#import "GLHomeModel.h"//首页模型

@interface GLHomeController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *noticeView;
@property (weak, nonatomic) IBOutlet UIView *noticeLayerView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIView *middleViewLayerView;

//切换要用到的控件
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UILabel *label6;

@property (nonatomic, strong)GLHomeModel *model;
@property (nonatomic, strong)LoadWaitView *loadV;

@end

@implementation GLHomeController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setUI];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLHomeCell" bundle:nil] forCellReuseIdentifier:@"GLHomeCell"];
    
    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf postRequest];
        
    }];
    // 设置文字
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔..." forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_header = header;
    
    [self postRequest];//请求数据
    
}
- (void)setUI{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.headerView.height = 260;
    
    self.segment.selectedSegmentIndex = 0;
    
    self.noticeView.layer.cornerRadius = 5.f;
    self.noticeLayerView.layer.cornerRadius = 5.f;
    
    self.noticeLayerView.layer.shadowOpacity = 0.1f;
    self.noticeLayerView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.noticeLayerView.layer.shadowRadius = 1.f;
    
    self.middleView.layer.cornerRadius = 5.f;
    self.middleViewLayerView.layer.cornerRadius = 5.f;
    self.middleViewLayerView.layer.shadowOpacity = 0.1f;
    self.middleViewLayerView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.middleViewLayerView.layer.shadowRadius = 1.f;
}

- (void)postRequest{
    
    self.model = nil;
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kHOME_URL paramDic:@{} finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self endRefresh];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
  
            self.model = [GLHomeModel mj_objectWithKeyValues:responseObject[@"data"]];
            
            self.noticeLabel.text = self.model.new_notice.title;
            
            [self switchSelected:nil];
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
    
    self.navigationController.navigationBar.hidden = YES;
}

- (IBAction)more:(id)sender {

    self.hidesBottomBarWhenPushed = YES;
    GLHome_CasesController *caseVC = [[GLHome_CasesController alloc] init];
    [self.navigationController pushViewController:caseVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}

- (IBAction)notice:(id)sender {
    
    NSLog(@"公告详情");
    
}

- (IBAction)switchSelected:(id)sender {
    
    UISegmentedControl* control = (UISegmentedControl*)sender;
    
    switch (control.selectedSegmentIndex) {
        case 0:
        {
            
            self.titleLabel.text = @"创客大数据";
            self.label.text = @"创客人数";
            self.label2.text = @"创客项目";
            self.label3.text = @"创客资金";
            self.label4.text = [NSString stringWithFormat:@"%@人",self.model.c_man_num];
            self.label5.text = [NSString stringWithFormat:@"%@个",self.model.c_item_num];
            self.label6.text = [NSString stringWithFormat:@"%@元",self.model.c_over_num];
            
        }
            break;
        case 1:
        {
            self.titleLabel.text = @"爱心大数据";
            self.label.text = @"爱心人数";
            self.label2.text = @"帮扶项目";
            self.label3.text = @"爱心资金";
            self.label4.text = [NSString stringWithFormat:@"%@人",self.model.ai_man_num];
            self.label5.text = [NSString stringWithFormat:@"%@个",self.model.ai_item_num ];
            self.label6.text = [NSString stringWithFormat:@"%@元",self.model.ai_over_num ];
        }
            break;
            
        default:
            
            break;
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.model.groom_item.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLHomeCell"];
    cell.selectionStyle = 0;
    cell.model = self.model.groom_item[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 180;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.hidesBottomBarWhenPushed = YES;
    
    if (indexPath.row == 0) {
        
        GLPay_ChooseController *payVC = [[GLPay_ChooseController alloc] init];
        [self.navigationController pushViewController:payVC animated:YES];
        
    }else if(indexPath.row == 1){
        
    }else{
        
    }
    
    
    self.hidesBottomBarWhenPushed = NO;
    
}
@end
