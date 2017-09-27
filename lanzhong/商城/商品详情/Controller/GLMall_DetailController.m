//
//  GLMall_DetailController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/26.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMall_DetailController.h"
#import "GLMall_DetailSpecCell.h"
#import "GLMall_DetailAddressCell.h"
#import "GLMall_DetailSelecteCell.h"
#import "GLMall_DetailCommentCell.h"
#import "GLMall_DetailFooterView.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "GLShoppingCartController.h"


#define headerImageHeight 64
@interface GLMall_DetailController ()<UITableViewDelegate,UITableViewDataSource,GLMall_DetailSpecCellDelegate,GLMall_DetailAddressCellDelegate,GLMall_DetailSelecteCellDelegate,UIWebViewDelegate,SDCycleScrollViewDelegate>


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
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMall_DetailSpecCell" bundle:nil] forCellReuseIdentifier:@"GLMall_DetailSpecCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMall_DetailAddressCell" bundle:nil] forCellReuseIdentifier:@"GLMall_DetailAddressCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMall_DetailSelecteCell" bundle:nil] forCellReuseIdentifier:@"GLMall_DetailSelecteCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMall_DetailCommentCell" bundle:nil] forCellReuseIdentifier:@"GLMall_DetailCommentCell"];
    
    self.footerView.webView.delegate = self;
    
    [self.headerView addSubview:self.cycleScrollView];
    self.tableView.tableFooterView = self.footerView;
    [self selectedFunc:YES];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
}

//立即购买
- (IBAction)buyNow:(id)sender {
    NSLog(@"立即购买");
}
//添加到购物车
- (IBAction)addToCart:(id)sender {
    NSLog(@"加入购物车");
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

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //http://news.163.com/17/0921/09/CURK48U10001875N.html
    
    CGFloat webViewHeight = [webView.scrollView contentSize].height;
    CGRect newFrame = webView.frame;
    newFrame.size.height = webViewHeight;
    
    self.footerView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, newFrame.size.height + 10);
}

#pragma mark - GLMall_DetailSpecCellDelegate 规格 数量
- (void)changeNum:(BOOL)isAdd{
    
    if (isAdd) {
        NSLog(@"加法");
    }else{
        NSLog(@"减法");
    }
}

- (void)specChoose{
    NSLog(@"规格选择");
}

#pragma mark - GLMall_DetailAddressCellDelegate 地址选择
- (void)addressChoose{
    
    NSLog(@"地址选择");
    
}

#pragma mark - GLMall_DetailSelecteCellDelegate 商品详情 评价

- (void)selectedFunc:(BOOL)isDetail{
    
    [self.dataSource removeAllObjects];
    
    if (isDetail) {
        
        NSLog(@"商品详情");
        self.footerView.hidden = NO;
                
        for (int i = 0; i <2; i++) {
            [self.dataSource addObject:@(i)];
        }
        
        [self.tableView reloadData];
        
    }else{
        
        NSLog(@"用户评论");
        self.footerView.hidden = YES;
        
        for (int i = 0; i < 8; i++) {
            [self.dataSource addObject:@(i)];
        }

        [self.tableView reloadData];
    }
 
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
        {
            GLMall_DetailSpecCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMall_DetailSpecCell"];
            cell.selectionStyle = 0;
            cell.delegate = self;
            return cell;
            
        }
            break;

        case 1:
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
//            cell.delegate = self;
            return cell;
            
        }
            break;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
            return 175;
            break;
        case 1:
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

        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 170 *autoSizeScaleY)
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
@end
