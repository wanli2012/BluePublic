//
//  GLMine_ShareRecordController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/18.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_ShareRecordController.h"
#import "GLMine_ShareRecordCell.h"

@interface GLMine_ShareRecordController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GLMine_ShareRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"分享记录";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_ShareRecordCell" bundle:nil] forCellReuseIdentifier:@"GLMine_ShareRecordCell"];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMine_ShareRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_ShareRecordCell"];
    cell.selectionStyle = 0;
//    cell.model = self.model.groom_item[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    self.hidesBottomBarWhenPushed = YES;
//    
//    if (indexPath.row == 0) {
//        
//        GLPay_ChooseController *payVC = [[GLPay_ChooseController alloc] init];
//        [self.navigationController pushViewController:payVC animated:YES];
//        
//    }else if(indexPath.row == 1){
//        
//    }else{
//        
//    }
    
    
//    self.hidesBottomBarWhenPushed = NO;
    
}

@end
