//
//  GLMine_MyMessage_ExchangeController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/6.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_MyMessage_ExchangeController.h"
#import "GLMine_MyMessageCell.h"

@interface GLMine_MyMessage_ExchangeController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GLMine_MyMessage_ExchangeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_MyMessageCell" bundle:nil] forCellReuseIdentifier:@"GLMine_MyMessageCell"];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMine_MyMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_MyMessageCell"];
    cell.checkOutView.hidden = YES;
    cell.selectionStyle = 0;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 44;
    
    return tableView.rowHeight;
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
//}
@end
