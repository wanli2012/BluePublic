//
//  GLShoppingCartController.m
//  PublicSharing
//
//  Created by 龚磊 on 2017/3/23.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLShoppingCartController.h"
#import "GLShoppingCell.h"
#import "UIButton+SetEdgeInsets.h"
#import "LBSetFillet.h"

@interface GLShoppingCartController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *clearingBtn;

@property (nonatomic, assign)BOOL isSelectedRightBtn;

@property (nonatomic, strong)NSMutableArray *selectArr;

@property (nonatomic, strong)UIButton *rightBtn;

//@property (nonatomic, assign)CGFloat totalPrice;

@property (nonatomic, assign)NSInteger totalNum;

@property (nonatomic, strong)NSMutableArray *models;
@property (weak, nonatomic) IBOutlet UILabel *navaTitle;
@property (weak, nonatomic) IBOutlet UIButton *seleteAllBtn;

@end

static NSString *ID = @"GLShoppingCell";
@implementation GLShoppingCartController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"GLShoppingCell" bundle:nil] forCellReuseIdentifier:ID];

     [self.clearingBtn addTarget:self action:@selector(clearingMore:) forControlEvents:UIControlEventTouchUpInside];

    self.totalPriceLabel.text = [NSString stringWithFormat:@"合计:¥ 0"];
   
    [self postRequest];
    
}

- (void)postRequest {
    
}

//去结算
- (void)clearingMore:(UIButton *)sender{

    NSMutableArray *tempArr = [NSMutableArray array];
    NSMutableArray *tempArr2 = [NSMutableArray array];
    NSMutableArray *tempArr3 = [NSMutableArray array];
    NSMutableArray *tempArr4 = [NSMutableArray array];
    
    for (int i = 0; i < self.models.count; i ++) {
        GLShoppingCartModel *model = self.models[i];
        if (model.isSelect) {
            
            [tempArr addObject:model.goods_id];
            [tempArr2 addObject:model.num];
            [tempArr3 addObject:model.cart_id];
            [tempArr4 addObject:model.spec_id];
            
        }
    }
    
    if (tempArr.count == 0) {
       // [MBProgressHUD showError:@"还未选择商品"];
        return;
    }
    
    

}

//全选
- (IBAction)selectAll:(UIButton*)sender {
    
    if(self.models.count == 0){
        //[MBProgressHUD showError:@"暂无可选商品"];
        return;
    }
    sender.selected = !sender.selected;
    float  num = 0;
    [self.selectArr removeAllObjects];
    
    if (sender.selected) {
        for (int i = 0; i < self.models.count; i++) {
            GLShoppingCartModel *model = self.models[i];
            model.isSelect = YES;
            num = num + [model.goods_price floatValue] * [model.num floatValue];

        }
    }else{
        [self.selectArr removeAllObjects];
        
        if (self.models.count == 0) {
            
            return;
        }
        for (int i = 0; i < self.models.count; i++) {
            GLShoppingCartModel *model = self.models[i];
            model.isSelect = NO;
        }
    }
    
    self.totalPriceLabel.text = [NSString stringWithFormat:@"总计:¥ %.2f",num];
    
    [self.tableView reloadData];

    
}

//选中,取消选中
- (void)changeStatus:(NSInteger)index {
    
     [self.selectArr removeAllObjects];
    
    BOOL  b = NO;
    float  num = 0;
    
    for (int i = 0; i < self.models.count; i++) {
        GLShoppingCartModel *model = self.models[i];
        
        if (model.isSelect == NO) {
            b = YES;
            
        }else{
            num = num + [model.goods_price floatValue] * [model.num floatValue];
//            [self.selectArr addObject:model];
        }
    }
    
    if (b == YES) {
        
        self.seleteAllBtn.selected = NO;
        
    }else{
        
        self.seleteAllBtn.selected = YES;
    }
    self.totalPriceLabel.text = [NSString stringWithFormat:@"总计:¥ %.2f",num];
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:index inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
    
}

- (void)updateTitleNum {
    
    if (self.isMainVC == NO) {
        self.navaTitle.text = [NSString stringWithFormat:@"购物车"];
    }else{
        self.navigationItem.title = [NSString stringWithFormat:@"购物车"];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    [self updateTitleNum];
    
}

#pragma  UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.models.count == 0 ? 0:self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GLShoppingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.index = indexPath.row;
   

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    GLShoppingCartModel *model = self.models[indexPath.row];
//    model.isSelect = !model.isSelect;
//    [self changeStatus:indexPath.row];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return   UITableViewCellEditingStyleDelete;
}

//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableView setEditing:NO animated:YES];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"你确定删除该商品？" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertController removeFromParentViewController];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

            GLShoppingCartModel *model = self.models[indexPath.row];
            
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.clearingBtn.layer.borderWidth = 1.0;
    self.clearingBtn.layer.borderColor = YYSRGBColor(0, 92, 254, 1).CGColor;
    self.clearingBtn.layer.cornerRadius = 4;
    self.clearingBtn.clipsToBounds = YES;
    
    
}

- (NSMutableArray *)selectArr {
    if (_selectArr == nil) {
        _selectArr = [NSMutableArray array];
    }
    return _selectArr;
}

- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}

@end
