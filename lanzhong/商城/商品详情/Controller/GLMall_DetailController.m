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

@interface GLMall_DetailController ()<UITableViewDelegate,UITableViewDataSource,GLMall_DetailSpecCellDelegate,GLMall_DetailAddressCellDelegate,GLMall_DetailSelecteCellDelegate,UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;//透视图
@property (weak, nonatomic) IBOutlet UIView *navView;//导航栏View

@property (nonatomic, strong)GLMall_DetailFooterView *footerView;//footer
@property (nonatomic, strong)NSMutableArray *dataSource;//数据源

@end

@implementation GLMall_DetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMall_DetailSpecCell" bundle:nil] forCellReuseIdentifier:@"GLMall_DetailSpecCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMall_DetailAddressCell" bundle:nil] forCellReuseIdentifier:@"GLMall_DetailAddressCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMall_DetailSelecteCell" bundle:nil] forCellReuseIdentifier:@"GLMall_DetailSelecteCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMall_DetailCommentCell" bundle:nil] forCellReuseIdentifier:@"GLMall_DetailCommentCell"];
    
    self.footerView.webView.delegate = self;
    self.tableView.tableFooterView = self.footerView;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
}

- (IBAction)pop:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    CGFloat webViewHeight=[webView.scrollView contentSize].height;
    CGRect newFrame = webView.frame;
    newFrame.size.height = webViewHeight;
    
    self.footerView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, newFrame.size.height + 10);
}

#pragma mark - GLMall_DetailSpecCellDelegate
- (void)changeNum:(BOOL)isAdd{
    
    if (isAdd) {
        NSLog(@"加法");
    }else{
        NSLog(@"减法");
    }
}

#pragma mark - GLMall_DetailAddressCellDelegate
- (void)addressChoose{
    
    NSLog(@"地址选择");
    
}

#pragma mark - GLMall_DetailSelecteCellDelegate

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

@end
