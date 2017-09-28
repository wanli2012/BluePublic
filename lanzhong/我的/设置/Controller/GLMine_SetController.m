//
//  GLMine_SetController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/28.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_SetController.h"
#import "GLMineCell.h"

@interface GLMine_SetController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UIButton *exitBtn;

@end

@implementation GLMine_SetController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"设置";
    self.exitBtn.layer.borderColor = YYSRGBColor(0, 125, 254, 1).CGColor;
    self.exitBtn.layer.borderWidth = 1.f;
    self.exitBtn.layer.cornerRadius = 5.f;
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMineCell" bundle:nil] forCellReuseIdentifier:@"GLMineCell"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    
}
- (IBAction)quit:(id)sender {
    NSLog(@"退出登录");
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
    
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                cell.status = 2;
            }else if(indexPath.row == 1){
                cell.status = 0;
                cell.valueLabel.text = @"200M";
            }else if(indexPath.row == 2){
                cell.status = 2;
            }
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                cell.status = 1;
                cell.valueLabel.text = @"0282397656";
            }else if(indexPath.row == 1){
                cell.status = 2;
            }else if(indexPath.row == 2){
                cell.status = 1;
                cell.valueLabel.text = @"V1.02";
            }
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    NSLog(@"密码修改");
                }
                    break;
                case 1:
                {
                    NSLog(@"清理内存");
                }
                    break;
                case 2:
                {
                    NSLog(@"关于公司");
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
                    NSLog(@"联系客服");
                }
                    break;
                case 1:
                {
                    NSLog(@"帮助中心");
                }
                    break;
                case 2:
                {
                    NSLog(@"版本更新");
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
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 5)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
#pragma mark - 懒加载
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        
        NSArray *arr = @[@"密码修改",@"内存清理",@"关于公司"];
        NSArray *arr2 = @[@"联系客服",@"帮助中心",@"版本更新"];
//        NSArray *arr3 = @[@"版本更新"];
        
        [_dataSource addObject:arr];
        [_dataSource addObject:arr2];
//        [_dataSource addObject:arr3];
        
    }
    return _dataSource;
}
@end
