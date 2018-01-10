//
//  GLMine_NotSaleController.m
//  lanzhong
//
//  Created by 龚磊 on 2018/1/10.
//  Copyright © 2018年 三君科技有限公司. All rights reserved.
//

#import "GLMine_NotSaleController.h"
#import "GLMine_NotSaleCell.h"
#import "GLMine_NotSaleModel.h"

@interface GLMine_NotSaleController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *models;
@property (nonatomic, strong)LoadWaitView *loadV;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)NodataView *nodataV;

@end

@implementation GLMine_NotSaleController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_NotSaleCell" bundle:nil] forCellReuseIdentifier:@"GLMine_NotSaleCell"];
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLMine_NotSaleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_NotSaleCell"];
    
    cell.selectionStyle = 0;
    cell.model = self.models[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 115;
}

#pragma mark - 懒加载
- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
        
        for (int i = 0; i < 9; i ++ ) {
            GLMine_NotSaleModel *model = [[GLMine_NotSaleModel alloc] init];
            model.picName = [NSString stringWithFormat:@"dd%zd",i];
            model.projectName = [NSString stringWithFormat:@"项目名称%zd",i];
            model.detail = [NSString stringWithFormat:@"项目详情,前景非常好哦%zd",i];
            model.raise = [NSString stringWithFormat:@"12%zd万",i];
            model.insure = [NSString stringWithFormat:@"%zd",i % 2];
            model.date = [NSString stringWithFormat:@"2017-09-0%zd",i];
            model.cost = [NSString stringWithFormat:@"12%zd万",i];
            model.partners = [NSString stringWithFormat:@"1%zd万人",i];
            model.status = [NSString stringWithFormat:@"%zd",i];
            [_models addObject:model];
        }
    }
    
    return _models;
}

- (NodataView *)nodataV{
    if (!_nodataV) {
        _nodataV = [[NSBundle mainBundle] loadNibNamed:@"NodataView" owner:nil options:nil].lastObject;
        _nodataV.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64 - 40 - 10);
        
    }
    return _nodataV;
}

@end
