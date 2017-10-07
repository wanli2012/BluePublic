//
//  GLMall_LogisticsController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMall_LogisticsController.h"
#import "GLBusiness_FundTrendCell.h"

@interface GLMall_LogisticsController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GLMall_LogisticsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"物流跟踪";
    [self.tableView registerNib:[UINib nibWithNibName:@"GLBusiness_FundTrendCell" bundle:nil] forCellReuseIdentifier:@"GLBusiness_FundTrendCell"];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLBusiness_FundTrendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLBusiness_FundTrendCell"];
    
    if (indexPath.row == 0) {
        
        cell.topImageV.hidden = YES;
        cell.bottomImageV.hidden = NO;
        
    }else if(indexPath.row == 2){
        
        cell.topImageV.hidden = NO;
        cell.bottomImageV.hidden = YES;
    }else{
        cell.topImageV.hidden = NO;
        cell.bottomImageV.hidden = NO;
    }
    
    cell.selectionStyle = 0;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 33;
    return tableView.rowHeight;
}
@end
