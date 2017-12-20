//
//  GLMall_DetailController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/26.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMall_DetailController.h"
#import "GLMall_DetailSelecteCell.h"
#import "GLMall_DetailCommentCell.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "GLShoppingCartController.h"
#import "GLMall_DetailModel.h"
#import "GLMall_DetailWebCell.h"

#import "MHActionSheet.h"
#import "GLConfirmOrderController.h"
#import "GLMall_MoreCommentController.h"//更多评论
#import "JZAlbumViewController.h"
#import "BaseNavigationViewController.h"
#import "GLLoginController.h"

#define headerImageHeight 64

#define HEADER_VIEW_HEIGHT      170.0f      // 顶部商品图片高度
#define END_DRAG_SHOW_HEIGHT    80.0f       // 结束拖拽最大值时的显示
#define BOTTOM_VIEW_HEIGHT      50.0f       // 底部视图高度（加入购物车＼立即购买）


@interface GLMall_DetailController ()<UITableViewDelegate,UITableViewDataSource,GLMall_DetailSelecteCellDelegate,UIWebViewDelegate,SDCycleScrollViewDelegate>

{
    BOOL _isDetail;//是否是商品详情
    CGFloat _detailHeight;//商品详情高度
    
    // 图文详情开关，
    BOOL isShowDetail;
    
    CGFloat minY;
    CGFloat maxY;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;//头视图
@property (weak, nonatomic) IBOutlet UIView *navView;//导航栏View

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
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;//价格label
@property (weak, nonatomic) IBOutlet UILabel *saleNumLabel;//销量
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;//描述
@property (weak, nonatomic) IBOutlet UILabel *specLabel;//规格
@property (weak, nonatomic) IBOutlet UITextField *countTF;//购买数量
@property (weak, nonatomic) IBOutlet UIButton *reduceBtn;//购买数量 减
@property (weak, nonatomic) IBOutlet UIButton *addBtn;//购买数量 加

@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIWebView *detailWebView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *allView;


@property (strong, nonatomic) UIView *popTopView;               // 弹出顶部视图
@property (strong, nonatomic) UIView *popView;                  // 弹出底部视图
@property (strong, nonatomic) UIView *maskView;                 // 遮罩视图
@property (strong, nonatomic) UILabel *topTitleLabel;           // 顶部标题
@property (strong, nonatomic) UILabel *titleLabel;              // 规格标题

@property (strong, nonatomic) UILabel *topMsgLabel;             // 顶部提示信息
@property (strong, nonatomic) UILabel *bottomMsgLabel;          // 底部提示信息

@property (copy, nonatomic) NSString *popTitle;                 // 点击的代理

@end

@implementation GLMall_DetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"商品详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navTitleLabel.text = @"商品详情";
    
    // 加载图文详情
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",Goods_Info_URL,self.goods_id];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//    });
    
    [self.detailWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    self.detailWebView.scrollView.delegate = self;
    
    _bottomMsgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -END_DRAG_SHOW_HEIGHT, kSCREEN_WIDTH, END_DRAG_SHOW_HEIGHT)];
    _bottomMsgLabel.font = [UIFont systemFontOfSize:13.0f];
    _bottomMsgLabel.textAlignment = NSTextAlignmentCenter;
    _bottomMsgLabel.text = @"下拉返回商品详情";
    [self.detailWebView.scrollView addSubview:_bottomMsgLabel];

    
    self.buyNowBtn.layer.cornerRadius = 5.f;
    self.buyNowBtn.layer.borderColor = YYSRGBColor(24, 97, 228, 1).CGColor;
    self.buyNowBtn.layer.borderWidth = 1.f;
    
    self.addCartBtn.layer.cornerRadius = 5.f;
    self.addCartBtn.layer.borderColor = YYSRGBColor(255, 133, 52, 1).CGColor;
    self.addCartBtn.layer.borderWidth = 1.f;
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMall_DetailSelecteCell" bundle:nil] forCellReuseIdentifier:@"GLMall_DetailSelecteCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMall_DetailCommentCell" bundle:nil] forCellReuseIdentifier:@"GLMall_DetailCommentCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMall_DetailWebCell" bundle:nil] forCellReuseIdentifier:@"GLMall_DetailWebCell"];
    
    
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
    
    dic[@"goods_id"] = self.goods_id;
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kGOODS_DETAIL_URL paramDic:dic finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self endRefresh];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            if([responseObject[@"data"] count] != 0){
                
                self.model = [GLMall_DetailModel mj_objectWithKeyValues:responseObject[@"data"]];

                self.model.goods_details = [NSString stringWithFormat:@"%@%@",Goods_Info_URL,self.goods_id];
                self.goods_infoDic = responseObject[@"data"][@"goods_data"];
                
                NSMutableArray *arrM = [NSMutableArray array];
                for (NSString * s in self.goods_infoDic[@"must_thumb_url"]) {
                    NSString *str = [NSString stringWithFormat:@"%@?imageView2/1/w/414/h/200",s];
                    [arrM addObject:str];
                }                
                self.cycleScrollView.imageURLStringsGroup = arrM;
                [self setHeaderValue];//为头视图赋值
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
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}

#pragma mark - 重写返回键
- (IBAction)pop:(id)sender {
    
    if (isShowDetail) {
        [UIView animateWithDuration:0.4 animations:^{
            self.allView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            isShowDetail = NO;
        }];
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 头视图赋值
- (void)setHeaderValue{
    
    self.priceLabel.text = [NSString stringWithFormat:@"%@",self.goods_infoDic[@"goods_discount"]];
    self.saleNumLabel.text = [NSString stringWithFormat:@"总销量:%@件",self.goods_infoDic[@"salenum"]];
    self.goodsNameLabel.text = [NSString stringWithFormat:@"%@",self.goods_infoDic[@"goods_name"]];
    self.infoLabel.text = [NSString stringWithFormat:@"%@",self.goods_infoDic[@"goods_info"]];
    
    CGRect rect = [self.goods_infoDic[@"goods_info"] boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil];
    CGRect nameRect = [self.goods_infoDic[@"goods_name"] boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil];
    
    self.headerView.height = 402 + rect.size.height + nameRect.size.height;
    
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
    
    self.hidesBottomBarWhenPushed = YES;
   
    if ([UserModel defaultUser].loginstatus == NO) {

        [SVProgressHUD showErrorWithStatus:@"请先登录"];
        return;
    }
    
    if (self.spec_id.length <= 0) {

        [SVProgressHUD showErrorWithStatus:@"还未选择规格"];
        return;
    }
    GLConfirmOrderController *vc=[[GLConfirmOrderController alloc]init];
    vc.goods_id = self.goods_id;
    vc.goods_count = self.countTF.text;
    vc.orderType = 1; //订单类型 1:商品详情页购买 2:购物车购买
    vc.goods_spec = self.spec_id;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 添加到购物车
- (IBAction)addToCart:(id)sender {
    
    if ([UserModel defaultUser].loginstatus == NO) {
        [SVProgressHUD showErrorWithStatus:@"请先登录"];
        return;
    }
    
    if (self.spec_id.length == 0) {

        [SVProgressHUD showErrorWithStatus:@"请选择规格"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"goods_id"] = self.goods_id;
    dic[@"num"] = @(self.sum);
    dic[@"spec_id"] = self.spec_id;
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kADD_TOCART_URL paramDic:dic finish:^(id responseObject) {
        
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            [SVProgressHUD showSuccessWithStatus:responseObject[@"message"]];
            
        }else if([responseObject[@"code"] integerValue] == OVERDUE_CODE){
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            
            [UserModel defaultUser].loginstatus = NO;
            [usermodelachivar achive];
            
            GLLoginController *loginVC = [[GLLoginController alloc] init];

            BaseNavigationViewController *nav = [[BaseNavigationViewController alloc]initWithRootViewController:loginVC];
            nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:nav animated:YES completion:nil];
            
        }else{
        
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        
    }];
    
}


#pragma mark - 去购物车
- (IBAction)toCart:(id)sender {
    
    if ([UserModel defaultUser].loginstatus == NO) {

        [SVProgressHUD showErrorWithStatus:@"请先登录"];
        return;
    }
    
    self.hidesBottomBarWhenPushed = YES;
    GLShoppingCartController *cartVC = [[GLShoppingCartController alloc] init];
    [self.navigationController pushViewController:cartVC animated:YES];
    
}

#pragma mark -查看更多评论
- (void)moreComment {
    
    if (self.model.comment_data.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"没有更多评论了"];
        return;
    }
    
    self.hidesBottomBarWhenPushed = YES;
    GLMall_MoreCommentController *moreVC = [[GLMall_MoreCommentController alloc] init];
    moreVC.goods_id = self.goods_id;
    [self.navigationController pushViewController:moreVC animated:YES];
    
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    if (scrollView == self.tableView) {
        // 重新赋值，就不会有淘宝用力拖拽时的回弹
        self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, 0);
        if (self.tableView.contentOffset.y >= 0 &&  self.tableView.contentOffset.y <= HEADER_VIEW_HEIGHT) {
            self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, -offset / 2.0f);
        }
    } else {
        // WebView中的ScrollView
        if (offset <= -END_DRAG_SHOW_HEIGHT) {
            _bottomMsgLabel.text = @"释放返回商品详情";
        } else {
            _bottomMsgLabel.text = @"下拉返回商品详情";
        }
    }
}

/**
 *  每次拖拽都会回调
 *  @param decelerate YES时，为滑动减速动画，NO时，没有滑动减速动画
 */
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate) {
        CGFloat offset = scrollView.contentOffset.y;
        if (scrollView == self.tableView) {
            if (offset < 0) {
                minY = MIN(minY, offset);
            } else {
                maxY = MAX(maxY, offset);
            }
        } else {
            minY = MIN(minY, offset);
        }
        
        // 滚到图文详情
        if (self.tableView.contentSize.height < self.view.height - 114) {
            if (maxY >= self.view.height - 114 - kSCREEN_HEIGHT + END_DRAG_SHOW_HEIGHT + BOTTOM_VIEW_HEIGHT) {
                isShowDetail = NO;
                [UIView animateWithDuration:0.4 animations:^{
                    self.allView.transform = CGAffineTransformTranslate(self.allView.transform, 0, - (kSCREEN_HEIGHT - BOTTOM_VIEW_HEIGHT));
                } completion:^(BOOL finished) {
                    maxY = 0.0f;
                    isShowDetail = YES;
                }];
            }

        }else{
            if (maxY >= self.tableView.contentSize.height - kSCREEN_HEIGHT + END_DRAG_SHOW_HEIGHT + BOTTOM_VIEW_HEIGHT) {
                isShowDetail = NO;
                [UIView animateWithDuration:0.4 animations:^{
                    self.allView.transform = CGAffineTransformTranslate(self.allView.transform, 0, - (kSCREEN_HEIGHT - BOTTOM_VIEW_HEIGHT));
                } completion:^(BOOL finished) {
                    maxY = 0.0f;
                    isShowDetail = YES;
                }];
            }
        }
        
        // 滚到商品详情
        if (minY <= -END_DRAG_SHOW_HEIGHT && isShowDetail) {
            [UIView animateWithDuration:0.4 animations:^{
                self.allView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                minY = 0.0f;
                isShowDetail = NO;
                _bottomMsgLabel.text = @"下拉返回商品详情";
            }];
        }
    }
}

/**
 *  带有滑动减速动画效果时，才会调用
 */
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

}


- (IBAction)chooseSpec:(id)sender {
  
    NSMutableArray *specTitles = [NSMutableArray array];
    
    for (GLDetail_spec *spec in self.model.spec) {
        [specTitles addObject:spec.title];
    }
    MHActionSheet *actionSheet = [[MHActionSheet alloc] initSheetWithTitle:@"规格选择" style:MHSheetStyleDefault itemTitles:specTitles];
    __weak typeof(self) weakSelf = self;
    [actionSheet didFinishSelectIndex:^(NSInteger index, NSString *title) {
        weakSelf.specLabel.text = title;
        
        weakSelf.priceLabel.text = [NSString stringWithFormat:@"¥ %@",self.model.spec[index].marketprice];
        weakSelf.spec_id = self.model.spec[index].id;

    }];

}


#pragma mark - GLMall_DetailSelecteCellDelegate 商品详情 评价

- (void)selectedFunc:(BOOL)isDetail{
    
    [self.dataSource removeAllObjects];
    if (isDetail) {
        _isDetail = YES;
    }else{
        _isDetail = NO;
    }
 
    NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:1];
    
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.model.comment_data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMall_DetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMall_DetailCommentCell"];
    cell.selectionStyle = 0;
    
    cell.model = self.model.comment_data[indexPath.row];
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLDetail_comment_data * model = self.model.comment_data[indexPath.row];
    return model.cellHeight;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 44)];
    headerV.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 44)];
    label.text = @"用户评论";
    label.textColor = MAIN_COLOR;
    label.font = [UIFont systemFontOfSize:15];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH - 25, 15, 10, 15)];
    imageV.image = [UIImage imageNamed:@"return2"];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44 - 1, kSCREEN_WIDTH, 1)];
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreComment)];
    [headerV addGestureRecognizer:tap];
    
    [headerV addSubview:label];
    [headerV addSubview:imageV];
    [headerV addSubview:lineView];
    
    return headerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 44;
}

#pragma mark - SDCycleScrollViewDelegate 点击看大图
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    self.HideNavagation = YES;
    JZAlbumViewController *jzAlbumVC = [[JZAlbumViewController alloc]init];
    jzAlbumVC.currentIndex = index;//这个参数表示当前图片的index，默认是0
    
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSString * s in self.goods_infoDic[@"must_thumb_url"]) {
//        NSString *str = [NSString stringWithFormat:@"%@?imageView2/1/w/414/h/200",s];
        [arrM addObject:s];
    }
    jzAlbumVC.imgArr = arrM;//图片数组，可以是url，也可以是UIImage
    [self presentViewController:jzAlbumVC animated:NO completion:nil];
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
}
#pragma mark - 懒加载
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
        
        _cycleScrollView.localizationImageNamesGroup = @[LUNBO_PlaceHolder,LUNBO_PlaceHolder,LUNBO_PlaceHolder,LUNBO_PlaceHolder];
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
