//
//  GLTalentPoolController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/11/18.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLTalentPoolController.h"
#import "GLBusiniessCell.h"
#import "GLBusinessCircle_MenuScreeningView.h"

@interface GLTalentPoolController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) GLBusinessCircle_MenuScreeningView *menuScreeningView;  //条件选择器
@property (nonatomic, assign)BOOL HideNavagation;//是否需要恢复自定义导航栏

@end

@implementation GLTalentPoolController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.menuScreeningView];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLBusiniessCell" bundle:nil] forCellReuseIdentifier:@"GLBusiniessCell"];
    self.menuScreeningView.block = ^(NSInteger itemIndex,NSInteger firstIndex,NSInteger index){
       
//        [weakSelf postRequest:YES];
    };

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLBusiniessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLBusiniessCell"];
    cell.selectionStyle = 0;
//    cell.model = self.models[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 155;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}
#pragma mark - 懒加载
-(GLBusinessCircle_MenuScreeningView*)menuScreeningView{
    
    if (!_menuScreeningView) {
        _menuScreeningView = [[GLBusinessCircle_MenuScreeningView alloc] initWithFrame:CGRectMake(0, 20,kSCREEN_WIDTH , 50) WithTitles:@[@"城市",@"行业",@"官方发布",@"筹款中"]];
        //        _menuScreeningView.isHaveSecond = YES;
        _menuScreeningView.backgroundColor = [UIColor whiteColor];
    }
    
    return _menuScreeningView;
    
}

@end
