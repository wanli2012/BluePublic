//
//  GLMine_WalletCardChooseController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/5.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_WalletCardChooseController.h"
#import "GLMine_WalletCardChooseCell.h"

@interface GLMine_WalletCardChooseController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GLMine_WalletCardChooseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_WalletCardChooseCell" bundle:nil] forCellReuseIdentifier:@"GLMine_WalletCardChooseCell"];
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMine_WalletCardChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_WalletCardChooseCell"];
    cell.selectionStyle = 0;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

@end
