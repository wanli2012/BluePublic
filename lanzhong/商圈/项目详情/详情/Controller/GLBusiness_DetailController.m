//
//  GLBusiness_DetailController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/27.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLBusiness_DetailController.h"
#import "GLBusiness_DetailCommentCell.h"
#import "GLBusiness_DetailProjectCell.h"
//#import "GLBusiness_trendCell.h"
#import "GLBusiness_ChooseCell.h"//资金动向和官方认证
#import "GLBusiness_CertificationController.h"//官方认证
#import "GLBusiness_LoveListController.h"
#import "GLBusiness_FundTrendController.h"//资金动向
#import "GLBusiness_DetailModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface GLBusiness_DetailController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,GLBusiness_ChooseCellDelegate>
{
    CGRect _rect;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;//项目图
@property (weak, nonatomic) IBOutlet UILabel *personNameLabel;//发起人名
@property (weak, nonatomic) IBOutlet UILabel *targetMoneyLabel;//目标金额
@property (weak, nonatomic) IBOutlet UILabel *raisedLabel;//已筹金额
@property (weak, nonatomic) IBOutlet UIView *bgProgressView;//进度条背景
@property (weak, nonatomic) IBOutlet UIView *progressView;//进度条
@property (weak, nonatomic) IBOutlet UIView *progressSignView;//百分比 球
@property (weak, nonatomic) IBOutlet UILabel *listNumLabel;//榜单人数


@property (weak, nonatomic) IBOutlet UIButton *supportBtn;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIView *middleViewLayerView;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV2;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV3;


@property (nonatomic, strong)GLBusiness_DetailModel *model;
@property (nonatomic, strong)LoadWaitView *loadV;

@end

@implementation GLBusiness_DetailController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUI];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLBusiness_DetailCommentCell" bundle:nil] forCellReuseIdentifier:@"GLBusiness_DetailCommentCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLBusiness_DetailProjectCell" bundle:nil] forCellReuseIdentifier:@"GLBusiness_DetailProjectCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLBusiness_ChooseCell" bundle:nil] forCellReuseIdentifier:@"GLBusiness_ChooseCell"];
    
    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf postRequest:YES];

    }];

    // 设置文字
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔..." forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_header = header;
    
    [self postRequest:YES];
    
}

- (void)postRequest:(BOOL)isRefresh{

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    self.item_id = @"36";
    
    dic[@"item_id"] = self.item_id;
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kCIRCLE_DETAIL_URL paramDic:dic finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self endRefresh];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            if([responseObject[@"data"] count] != 0){
        
                self.model = [GLBusiness_DetailModel mj_objectWithKeyValues:responseObject[@"data"]];
                [self headerViewFuzhi];
                
            }
            
        }else{
            
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
        [self.tableView reloadData];
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self endRefresh];
        [self.tableView reloadData];
    }];
}

//为头视图赋值
- (void)headerViewFuzhi {
    
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:self.model.user_info_pic] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    self.personNameLabel.text = self.model.linkman;
    self.targetMoneyLabel.text = [NSString stringWithFormat:@"%@元",self.model.admin_money];
    self.raisedLabel.text = [NSString stringWithFormat:@"%@元",self.model.draw_money];
    self.listNumLabel.text = [NSString stringWithFormat:@"榜单:%@人",self.model.invest_count];
    if (self.model.sev_photo.count == 3) {
        [self.iconImageV3 sd_setImageWithURL:[NSURL URLWithString:self.model.invest_10[0].must_user_pic] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
        [self.iconImageV2 sd_setImageWithURL:[NSURL URLWithString:self.model.invest_10[1].must_user_pic] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
        [self.iconImageV sd_setImageWithURL:[NSURL URLWithString:self.model.invest_10[2].must_user_pic] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    }
}

- (void)endRefresh {
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
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
    
    self.hidesBottomBarWhenPushed = YES;
    GLBusiness_LoveListController *lovelistVC = [[GLBusiness_LoveListController alloc] init];
    [self.navigationController pushViewController:lovelistVC animated:YES];
    
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    CGFloat webViewHeight=[webView.scrollView contentSize].height;
    CGRect newFrame = webView.frame;
    newFrame.size.height = webViewHeight;
    
    _rect = CGRectMake(0, 0, kSCREEN_WIDTH, newFrame.size.height + 10);
    
    NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:1 inSection:0]; //刷新第0段第2行
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA,nil] withRowAnimation:UITableViewRowAnimationNone];
    
}

#pragma mark - GLBusiness_ChooseCellDelegate
- (void)didSeletedIndex:(NSInteger)index{
    
    self.hidesBottomBarWhenPushed = YES;
    
    switch (index) {
        case 0:
        {

            GLBusiness_CertificationController *cerVC = [[GLBusiness_CertificationController alloc] init];
            [self.navigationController pushViewController:cerVC animated:YES];
            
        }
            break;
        case 1:
        {
            NSLog(@"资金动向");
            GLBusiness_FundTrendController *fundVC = [[GLBusiness_FundTrendController alloc] init];
            [self.navigationController pushViewController:fundVC animated:YES];
        }
            break;
        case 2:
        {
            NSLog(@"全部评论");
//            GLBusiness_FundTrendController *fundVC = [[GLBusiness_FundTrendController alloc] init];
//            [self.navigationController pushViewController:fundVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
            return 2;
        }
            break;
        case 1:
        {
            return self.model.invest_list.count;
        }
            break;
            
        default:
            break;
    }
    return 6;
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if (section == 1) {
//        
//        UIView *sectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 40)];
//        sectionHeader.backgroundColor = [UIColor whiteColor];
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, 40)];
//        label.text = @"评论";
//        label.textColor = [UIColor darkTextColor];
//        label.font = [UIFont systemFontOfSize:14];
//        [sectionHeader addSubview:label];
//        
//        return sectionHeader;
//    }else{
//        
//        return nil;
//    }
//    
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section == 1) {
//        return 40;
//    }
//    return 0;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                GLBusiness_DetailProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLBusiness_DetailProjectCell"];
                cell.selectionStyle = 0;
                
//                cell.detailStr = self.model.details;
                cell.dataSourceArr = self.model.sev_photo;
                cell.detailLabel.text = self.model.info;
                return cell;
                
            }else if(indexPath.row == 1){
                
                GLBusiness_ChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLBusiness_ChooseCell"];
                cell.selectionStyle = 0;
//                cell.webView.delegate = self;
                cell.delegate = self;
                
                return cell;
            }

        }
            break;
        default:
        {
            GLBusiness_DetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLBusiness_DetailCommentCell"];
            cell.selectionStyle = 0;
            
            
            cell.model = self.model.invest_list[indexPath.row];
            
            return cell;

        }
            break;
    }

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        if(indexPath.row == 1){
         
            return 180;
        }
    }
    
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
