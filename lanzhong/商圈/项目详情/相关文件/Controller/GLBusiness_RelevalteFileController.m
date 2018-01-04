//
//  GLBusiness_RelevalteFileController.m
//  lanzhong
//
//  Created by 龚磊 on 2018/1/4.
//  Copyright © 2018年 三君科技有限公司. All rights reserved.
//

#import "GLBusiness_RelevalteFileController.h"
#import "GLBusiness_RelevateFileCell.h"

@interface GLBusiness_RelevalteFileController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy)NSArray *titleArr;

@end

@implementation GLBusiness_RelevalteFileController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"相关文件";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.titleArr = @[@"承诺书",@"项目资金使用计划书",@"项目回馈计划"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLBusiness_RelevateFileCell" bundle:nil] forCellReuseIdentifier:@"GLBusiness_RelevateFileCell"];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLBusiness_RelevateFileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLBusiness_RelevateFileCell"];

    cell.nameLabel.text = self.titleArr[indexPath.row];
    
    cell.selectionStyle = 0;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%@",self.titleArr[indexPath.row]);
    
}

@end
