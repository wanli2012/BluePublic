//
//  GLMall_DetailController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/26.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMall_DetailController.h"
//#import "GLMall_DetailSpecCell.h"
//#import "GLMall_DetailAddressCell.h"
#import "GLMall_DetailSelecteCell.h"
#import "GLMall_DetailCommentCell.h"
#import "GLMall_DetailFooterView.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "GLShoppingCartController.h"
#import "GLMall_DetailModel.h"
#import "GLMall_DetailWebCell.h"

#import "MHActionSheet.h"
#import "GLConfirmOrderController.h"

#define headerImageHeight 64
@interface GLMall_DetailController ()<UITableViewDelegate,UITableViewDataSource,GLMall_DetailSelecteCellDelegate,UIWebViewDelegate,SDCycleScrollViewDelegate>

{
    BOOL _isDetail;//是否是商品详情
    CGFloat _detailHeight;//商品详情高度
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;//透视图
@property (weak, nonatomic) IBOutlet UIView *navView;//导航栏View

@property (nonatomic, strong)GLMall_DetailFooterView *footerView;//footer
@property (nonatomic, strong)NSMutableArray *dataSource;//数据源

@property (nonatomic, strong)SDCycleScrollView *cycleScrollView;

@property (nonatomic, assign)BOOL  HideNavagation;//是否需要恢复自定义导航栏
@property(assign , nonatomic)CGPoint offset;//记录偏移
@property (weak, nonatomic) IBOutlet UILabel *navTitleLabel;//自定义导航栏title

@property (weak, nonatomic) IBOutlet UIButton *buyNowBtn;//立即购买Btn
@property (weak, nonatomic) IBOutlet UIButton *addCartBtn;//加入购物车
@property (weak, nonatomic) IBOutlet UIButton *cartBtn;//去购物车

@property (nonatomic, strong)NSMutableArray *commentModels;
@property (nonatomic, strong)LoadWaitView *loadV;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)GLMall_DetailModel *model;
@property (nonatomic, strong)NSDictionary *goods_infoDic;

@property (nonatomic, copy)NSString *spec_id;//规格id
@property (nonatomic, assign)NSInteger sum;//购买数量

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;//价格label
@property (weak, nonatomic) IBOutlet UILabel *saleNumLabel;//销量
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;//描述
@property (weak, nonatomic) IBOutlet UILabel *specLabel;//规格
@property (weak, nonatomic) IBOutlet UITextField *countTF;//购买数量
@property (weak, nonatomic) IBOutlet UIButton *reduceBtn;//购买数量 减
@property (weak, nonatomic) IBOutlet UIButton *addBtn;//购买数量 加

@end

@implementation GLMall_DetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.buyNowBtn.layer.cornerRadius = 5.f;
    self.buyNowBtn.layer.borderColor = YYSRGBColor(24, 97, 228, 1).CGColor;
    self.buyNowBtn.layer.borderWidth = 1.f;
    
    self.addCartBtn.layer.cornerRadius = 5.f;
    self.addCartBtn.layer.borderColor = YYSRGBColor(255, 133, 52, 1).CGColor;
    self.addCartBtn.layer.borderWidth = 1.f;
    
    
//    [self.tableView registerNib:[UINib nibWithNibName:@"GLMall_DetailSpecCell" bundle:nil] forCellReuseIdentifier:@"GLMall_DetailSpecCell"];
//    [self.tableView registerNib:[UINib nibWithNibName:@"GLMall_DetailAddressCell" bundle:nil] forCellReuseIdentifier:@"GLMall_DetailAddressCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMall_DetailSelecteCell" bundle:nil] forCellReuseIdentifier:@"GLMall_DetailSelecteCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMall_DetailCommentCell" bundle:nil] forCellReuseIdentifier:@"GLMall_DetailCommentCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMall_DetailWebCell" bundle:nil] forCellReuseIdentifier:@"GLMall_DetailWebCell"];
    
    self.footerView.webView.delegate = self;
    
    [self.headerView addSubview:self.cycleScrollView];

    [self selectedFunc:NO];
    
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
//    [self.tableView.mj_header beginRefreshing];
    
    _isDetail = NO;
    self.sum = 1;
    
}

- (void)postRequest:(BOOL)isRefresh{
    
    if (isRefresh) {
        self.page = 1;
        [self.commentModels removeAllObjects];
    }else{
        self.page ++ ;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    self.goods_id = @"8";
    
    dic[@"goods_id"] = self.goods_id;
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kGOODS_DETAIL_URL paramDic:dic finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self endRefresh];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            if([responseObject[@"data"] count] != 0){
                
                self.model = [GLMall_DetailModel mj_objectWithKeyValues:responseObject[@"data"]];

                self.model.goods_details = @"http://www.jianshu.com/p/69d338f8b67d";
                self.goods_infoDic = responseObject[@"data"][@"goods_data"];
                
                self.cycleScrollView.imageURLStringsGroup = self.model.goods_data.must_thumb_url;
                [self setHeaderValue];//为头视图赋值
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

- (void)endRefresh {
    
    [self.tableView.mj_header endRefreshing];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

//头视图赋值
- (void)setHeaderValue{
    
    self.priceLabel.text = [NSString stringWithFormat:@"%@",self.goods_infoDic[@"goods_discount"]];
    self.saleNumLabel.text = [NSString stringWithFormat:@"总销量:%@件",self.goods_infoDic[@"salenum"]];
    self.infoLabel.text = [NSString stringWithFormat:@"%@",self.goods_infoDic[@"goods_info"]];
    
}

- (IBAction)numChange:(UIButton *)sender {
    
    if(sender == self.addBtn){
        self.sum += 1;
    }else{
        
        if (self.sum == 1) {
            self.sum = 1;
        }else{
            
            self.sum -= 1;
        }
    }
    
    self.countTF.text = [NSString stringWithFormat:@"%zd",self.sum];
}

#pragma mark - 立即购买  加入购物车
//立即购买
- (IBAction)buyNow:(id)sender {
    NSLog(@"立即购买");
    self.hidesBottomBarWhenPushed = YES;
   
    if ([UserModel defaultUser].loginstatus == NO) {
        [MBProgressHUD showError:@"请先登录"];
        return;
    }
    
//    if ([UserModel defaultUser].isSetTwoPwd == 0) {
//        [MBProgressHUD showError:@"请先在设置中设置支付密码"];
//        return;
//    }

    if (self.spec_id.length <= 0) {
        [MBProgressHUD showError:@"还未选择规格"];
        return;
    }
    GLConfirmOrderController *vc=[[GLConfirmOrderController alloc]init];
    vc.goods_id = self.goods_id;
    vc.goods_count = self.countTF.text;
    vc.orderType = 2; //订单类型
    vc.goods_spec = self.spec_id;
    [self.navigationController pushViewController:vc animated:YES];
    
}
//添加到购物车
- (IBAction)addToCart:(id)sender {
    
    if (self.spec_id.length == 0) {
        [MBProgressHUD showError:@"请选择规格"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    self.goods_id = @"8";
    
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"goods_id"] = self.goods_id;
    dic[@"num"] = @(self.sum);
    dic[@"spec_id"] = self.spec_id;
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kADD_TOCART_URL paramDic:dic finish:^(id responseObject) {
        
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
             [MBProgressHUD showError:responseObject[@"message"]];
        }else{
            
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        
    }];

    
}
//去购物车
- (IBAction)toCart:(id)sender {
    NSLog(@"跳转到购物车");
    self.hidesBottomBarWhenPushed = YES;
    GLShoppingCartController *cartVC = [[GLShoppingCartController alloc] init];
    [self.navigationController pushViewController:cartVC animated:YES];
    
}

- (IBAction)pop:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y <= 0) {
        
        self.navView.backgroundColor = YYSRGBColor(255, 255, 255,0);
        
        self.navTitleLabel.textColor = YYSRGBColor(85, 85, 85, 0);
    }else{
        self.navView.backgroundColor = YYSRGBColor(255, 255, 255,ABS(scrollView.contentOffset.y)/headerImageHeight);
        self.navTitleLabel.textColor = YYSRGBColor(85, 85, 85, ABS(scrollView.contentOffset.y)/headerImageHeight);
    }
}

//#pragma mark - GLMall_DetailSpecCellDelegate 规格 数量
//- (void)changeNum:(BOOL)isAdd{
//    
//    if (isAdd) {
//        NSLog(@"加法");
//    }else{
//        NSLog(@"减法");
//    }
//}

- (IBAction)chooseSpec:(id)sender {
  
    NSMutableArray *specTitles = [NSMutableArray array];
    
    for (GLDetail_spec *spec in self.model.spec) {
        [specTitles addObject:spec.title];
    }
    MHActionSheet *actionSheet = [[MHActionSheet alloc] initSheetWithTitle:@"规格选择" style:MHSheetStyleDefault itemTitles:specTitles];
    __weak typeof(self) weakSelf = self;
    [actionSheet didFinishSelectIndex:^(NSInteger index, NSString *title) {
//        NSString *text = [NSString stringWithFormat:@"第%ld行,%@",index, title];
        weakSelf.specLabel.text = title;
        
        weakSelf.priceLabel.text = [NSString stringWithFormat:@"¥ %@",self.model.spec[index].marketprice];
        weakSelf.spec_id = self.model.spec[index].id;

    }];

}


#pragma mark - GLMall_DetailSelecteCellDelegate 商品详情 评价

- (void)selectedFunc:(BOOL)isDetail{
    
    [self.dataSource removeAllObjects];
    
    if (isDetail) {
        
        NSLog(@"商品详情");
        _isDetail = YES;


    }else{
        
        NSLog(@"用户评论");

        _isDetail = NO;
    }
 
    NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:1];
    
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 1;
    }else{
         if (_isDetail) {
             
             return 1;
         }else{
             
             return self.model.comment_data.count;
         }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        switch (indexPath.row) {
                
            case 0:
            {
                GLMall_DetailSelecteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMall_DetailSelecteCell"];
                cell.selectionStyle = 0;
                cell.delegate = self;
                return cell;
                
            }
                break;
                
            default:
            {
                GLMall_DetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMall_DetailCommentCell"];
                cell.selectionStyle = 0;
                return cell;
                
            }
                break;
        }
        
    }else{
        
        if (_isDetail) {
            
            GLMall_DetailWebCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMall_DetailWebCell"];
            cell.selectionStyle = 0;

            cell.url = self.model.goods_details;
            
            return cell;
            
        }else{
            
            GLMall_DetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMall_DetailCommentCell"];
            cell.selectionStyle = 0;
            
            
            cell.model = self.model.comment_data[indexPath.row];
            
            return cell;
        }

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        
        switch (indexPath.row) {

            case 0:
            {
                return 50;
            }
                break;
            default:
            {
                tableView.rowHeight = UITableViewAutomaticDimension;
                tableView.estimatedRowHeight = 44;
                return tableView.rowHeight;
            }
                break;
        }
        
    }else{
        
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 44;
        return tableView.rowHeight;
    }
}


#pragma mark - SDCycleScrollViewDelegate 点击看大图
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    self.HideNavagation = YES;
    
//    JZAlbumViewController *jzAlbumVC = [[JZAlbumViewController alloc]init];
//    jzAlbumVC.currentIndex =index;//这个参数表示当前图片的index，默认是0
//    jzAlbumVC.imgArr = [self.cycleScrollView.imageURLStringsGroup copy];//图片数组，可以是url，也可以是UIImage
//    [self presentViewController:jzAlbumVC animated:NO completion:nil];
    
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
}
#pragma mark - 懒加载

- (GLMall_DetailFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[GLMall_DetailFooterView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 300)];
        
    }
    
    return _footerView;
}
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        for (int i = 0; i < 8; i ++) {
            [_dataSource addObject:@(i)];
        }
    }
    return _dataSource;
}
- (SDCycleScrollView *)cycleScrollView{
    
    if (!_cycleScrollView) {

        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 170)
                                                              delegate:self
                                                      placeholderImage:[UIImage imageNamed:LUNBO_PlaceHolder]];
        
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.clipsToBounds = YES;
        _cycleScrollView.autoScrollTimeInterval = 2;// 自动滚动时间间隔
        _cycleScrollView.placeholderImageContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;// 翻页 右下角
        _cycleScrollView.titleLabelBackgroundColor = [UIColor redColor];// 图片对应的标题的 背景色。（因为没有设标题）
        _cycleScrollView.placeholderImage = [UIImage imageNamed:LUNBO_PlaceHolder];
        _cycleScrollView.pageControlDotSize = CGSizeMake(10, 10);
        
        _cycleScrollView.localizationImageNamesGroup = @[@"timg",@"timg",@"timg",@"timg"];
    }
    return _cycleScrollView;
}

- (NSMutableArray *)commentModels{
    if (!_commentModels) {
        _commentModels = [NSMutableArray array];
    }
    return _commentModels;
}

@end
