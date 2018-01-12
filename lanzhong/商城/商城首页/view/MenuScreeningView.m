//
//  MenuScreeningView.m
//  LinkageMenu
//
//  Created by mango on 2017/3/4.
//  Copyright © 2017年 mango. All rights reserved.
//

#import "MenuScreeningView.h"
#import "DropMenuView.h"

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

@interface MenuScreeningView ()<DropMenuViewDelegate>

@property (nonatomic, strong)NSMutableArray *linkBtnArr;
@property (nonatomic, strong)NSMutableArray *dropMenuArr;

@end

@implementation MenuScreeningView

- (instancetype)initWithFrame:(CGRect)frame WithTitles:(NSArray *)titles
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titles = titles;

        for (int i = 0 ; i < titles.count; i ++) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i * kWidth/titles.count, 0,  kWidth/titles.count, 50);
            [self setUpButton:btn withText:titles[i]];
            
            DropMenuView *menuV = [[DropMenuView alloc] init];
            menuV.arrowView = btn.imageView;
            menuV.delegate = self;
            
            [self.linkBtnArr addObject:btn];
            [self.dropMenuArr addObject:menuV];
        }
        
        /** 最下面横线 */
        UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 0.6, kWidth, 0.6)];
        horizontalLine.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.000];
        [self addSubview:horizontalLine];
        
    }
    return self;
}

#pragma mark - 按钮点击推出菜单 (并且其他的菜单收起)
-(void)clickButton:(UIButton *)button{
    
    NSInteger index = -1;

    for (int i = 0 ; i < self.linkBtnArr.count; i ++) {
        if (button == self.linkBtnArr[i]) {
            index = i;
            
        }
    }
    
    for (int i = 0 ; i < self.dropMenuArr.count ; i++ ) {
        DropMenuView *menuV = self.dropMenuArr[i];
        
        if (i != index) {
            [menuV dismiss];
        }else {
            [menuV creatDropView:self withShowTableNum:1 withData:self.dataArr[i]];
        }
        
    }

}

#pragma mark - 筛选菜单消失
-(void)menuScreeningViewDismiss{

    for (DropMenuView *menuV in self.dropMenuArr) {
        [menuV dismiss];
    }
}

#pragma mark - 协议实现
- (void)dropMenuView:(DropMenuView *)view didSelectName:(NSString *)str firstSelectIndex:(NSInteger)firstSelectIndex selectIndex:(NSInteger)selectIndex{

    NSInteger index = -1;
    
    for (int i = 0 ; i < self.dropMenuArr.count; i ++) {
        if (view == self.dropMenuArr[i]) {
            index = i;
            self.block(i,firstSelectIndex,selectIndex);
        }
    }

}

#pragma mark - 设置Button
-(void)setUpButton:(UIButton *)button withText:(NSString *)str{
    
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [button setTitle:str forState:UIControlStateNormal];
    button.titleLabel.font =  [UIFont systemFontOfSize:11];
    button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [button setTitleColor:[UIColor colorWithWhite:0.3 alpha:1.000] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"downarr"] forState:UIControlStateNormal];
    
    [self buttonEdgeInsets:button];
    
    UIView *verticalLine = [[UIView alloc]init];
    verticalLine.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [button addSubview:verticalLine];
    verticalLine.frame = CGRectMake(button.frame.size.width - 0.5, 10, 0.5, 30);
}

-(void)buttonEdgeInsets:(UIButton *)button{
    
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -button.imageView.bounds.size.width + 2, 0, button.imageView.bounds.size.width + 10)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, button.titleLabel.bounds.size.width + 10, 0, -button.titleLabel.bounds.size.width + 2)];
    
}

#pragma mark - 懒加载
- (NSMutableArray *)linkBtnArr{
    if (!_linkBtnArr) {
        _linkBtnArr = [NSMutableArray array];
    }
    return _linkBtnArr;
}

- (NSMutableArray *)dropMenuArr{
    if (!_dropMenuArr) {
        _dropMenuArr = [NSMutableArray array];
    }
    return _dropMenuArr;
}

@end
