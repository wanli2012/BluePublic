//
//  GLMineController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/25.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMineController.h"
#import "GLMineCell.h"

@interface GLMineController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;//透视图
@property (weak, nonatomic) IBOutlet UIView *bgView;//topView
@property (weak, nonatomic) IBOutlet UIImageView *bgimageV;//背景图
@property (weak, nonatomic) IBOutlet UIImageView *imageV;//头像
@property (weak, nonatomic) IBOutlet UIView *middleView;//中间6个label的背景View

@property (nonatomic, strong)UIVisualEffectView *visualEffectView;

@property (nonatomic, strong)NSMutableArray *dataSource;

@end

#define kHEIGHT 150

@implementation GLMineController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMineCell" bundle:nil] forCellReuseIdentifier:@"GLMineCell"];
    
}
- (void)setUI
{
    self.view.backgroundColor = [UIColor blueColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.imageV.layer.cornerRadius = self.imageV.height/2;
    
    //实现模糊效果
    UIBlurEffect *blurEffrct = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    //毛玻璃视图
    self.visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffrct];
    
    self.visualEffectView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, self.bgimageV.height);
    
    self.visualEffectView.alpha = 0.8;
    
    [self.bgimageV addSubview:self.visualEffectView];
    
    self.middleView.layer.cornerRadius = 5.f;

}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark - UIScrollViewDelegate 下拉放大图片
//scrollView的方法视图滑动时 实时调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat width = self.view.frame.size.width;
    // 图片宽度
    CGFloat yOffset = scrollView.contentOffset.y;
    // 偏移的y值
    
    if(yOffset < 0){
        
        CGFloat totalOffset = kHEIGHT + ABS(yOffset);
        CGFloat f = totalOffset / kHEIGHT;
        //拉伸后的图片的frame应该是同比例缩放。
        self.bgimageV.frame =  CGRectMake(- (width *f-width) / 2, yOffset, width * f, totalOffset);
        self.visualEffectView.frame = CGRectMake(0, 0, width * f, totalOffset);
        
    }
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dataSource[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLMineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMineCell"];
    cell.selectionStyle = 0;
    
    NSArray *arr = self.dataSource[indexPath.section];
    cell.titleLabel.text = arr[indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    NSLog(@"%@",self.dataSource[indexPath.section][indexPath.row]);
                }
                    break;
                case 1:
                {
                     NSLog(@"%@",self.dataSource[indexPath.section][indexPath.row]);
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                     NSLog(@"%@",self.dataSource[indexPath.section][indexPath.row]);
                }
                    break;
                case 1:
                {
                     NSLog(@"%@",self.dataSource[indexPath.section][indexPath.row]);
                }
                    break;
                case 2:
                {
                    NSLog(@"%@",self.dataSource[indexPath.section][indexPath.row]);
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                {
                     NSLog(@"%@",self.dataSource[indexPath.section][indexPath.row]);
                }
                    break;
                case 1:
                {
                     NSLog(@"%@",self.dataSource[indexPath.section][indexPath.row]);
                }
                    break;
                case 2:
                {
                    NSLog(@"%@",self.dataSource[indexPath.section][indexPath.row]);
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 5)];
    header.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 3;
}


#pragma mark - 懒加载
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        
        NSArray *arr = @[@"我的项目",@"项目发布"];
        NSArray *arr2 = @[@"分享权益",@"购物车",@"钱包"];
        NSArray *arr3 = @[@"收藏",@"我的消息",@"设置"];
        
        [_dataSource addObject:arr];
        [_dataSource addObject:arr2];
        [_dataSource addObject:arr3];
        
    }
    return _dataSource;
}

@end
