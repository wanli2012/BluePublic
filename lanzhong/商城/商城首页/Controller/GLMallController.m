//
//  GLMallController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/25.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMallController.h"
#import "GLClassifyCell.h"
#import "GLMall_DetailController.h"
#import "LBSetFillet.h"
#import "MenuScreeningView.h"
#import "GLShoppingCartController.h"

#define sizeScaleimageH  (285.0/349.0)
@interface GLMallController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectioview;
@property (nonatomic, strong) MenuScreeningView *menuScreeningView;  //条件选择器

@end

static NSString *ID = @"GLClassifyCell";

@implementation GLMallController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor whiteColor];
    
    [self initializationCollection];//初始化
    [self.collectioview registerNib:[UINib nibWithNibName:ID bundle:nil] forCellWithReuseIdentifier:ID];
    
    [self.view addSubview:self.menuScreeningView];
    
}

#pragma UICollectionDelegate UICollectionDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 10;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GLClassifyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.layer.mask = [LBSetFillet setFilletRoundedRect:cell.bounds cornerRadii:CGSizeMake(4, 4)];
    
    return cell;
}
//设置圆角
-(void)setFillet{

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0 ) {
        self.hidesBottomBarWhenPushed = YES;
        GLShoppingCartController *vc =[[GLShoppingCartController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        return;
    }
    self.hidesBottomBarWhenPushed = YES;
    GLMall_DetailController *vc =[[GLMall_DetailController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}



-(void)initializationCollection{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((kSCREEN_WIDTH - 30) /2 - 0.5,((kSCREEN_WIDTH - 30) /2 - 0.5) * sizeScaleimageH + 65);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.collectioview.collectionViewLayout = layout;

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(MenuScreeningView*)menuScreeningView{

    if (!_menuScreeningView) {
        _menuScreeningView = [[MenuScreeningView alloc] initWithFrame:CGRectMake(0, 20,kSCREEN_WIDTH , 50)];
         _menuScreeningView.backgroundColor = [UIColor whiteColor];
    }
    
    return _menuScreeningView;

}

@end
