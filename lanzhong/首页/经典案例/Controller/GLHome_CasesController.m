//
//  GLHome_CasesController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/30.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLHome_CasesController.h"
#import "GLHomeCell.h"

@interface GLHome_CasesController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GLHome_CasesController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"经典案例";
    [self.tableView registerNib:[UINib nibWithNibName:@"GLHomeCell" bundle:nil] forCellReuseIdentifier:@"GLHomeCell"];
    
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
    
    GLHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLHomeCell"];
    cell.selectionStyle = 0;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
}

@end
