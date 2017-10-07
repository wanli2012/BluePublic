//
//  GLMine_PersonInfo_AddressChooseController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_PersonInfo_AddressChooseController.h"
#import "GLMine_PersonInfo_AddressCell.h"
#import "GLMine_AddressAddController.h"//新增收货地址

@interface GLMine_PersonInfo_AddressChooseController ()<GLMine_PersonInfo_AddressCellDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GLMine_PersonInfo_AddressChooseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"收货地址";
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_PersonInfo_AddressCell" bundle:nil] forCellReuseIdentifier:@"GLMine_PersonInfo_AddressCell"];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}
//添加收货地址
- (IBAction)addAD:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_AddressAddController *addressVC = [[GLMine_AddressAddController alloc] init];
    [self.navigationController pushViewController:addressVC animated:YES];
    
}

#pragma mark - GLMine_PersonInfo_AddressCellDelegate

- (void)editAddress:(NSInteger)index{
    
    NSLog(@"编辑%zd",index);
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMine_PersonInfo_AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_PersonInfo_AddressCell"];
    
    cell.index = indexPath.row;
    
    cell.delegate = self;
    
    cell.selectionStyle = 0;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 44;
    
    return tableView.rowHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"选中一个地址");
    
}

@end
