//
//  GLBusinessCircle_MenuScreeningView.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/9.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLBusinessCircle_MenuScreeningView.h"
#import "DropMenuView.h"

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height


@interface GLBusinessCircle_MenuScreeningView ()<DropMenuViewDelegate>

@property (nonatomic, strong) UIButton *oneLinkageButton;
@property (nonatomic, strong) UIButton *twoLinkageButton;
@property (nonatomic, strong) UIButton *threeLinkageButton;
@property (nonatomic, strong) UIButton *fourLinkageButton;

@property (nonatomic, strong) DropMenuView *oneLinkageDropMenu;
@property (nonatomic, strong) DropMenuView *twoLinkageDropMenu;
@property (nonatomic, strong) DropMenuView *threeLinkageDropMenu;
@property (nonatomic, strong) DropMenuView *fourLinkageDropMenu;

@end

@implementation GLBusinessCircle_MenuScreeningView

- (instancetype)initWithFrame:(CGRect)frame WithTitles:(NSArray *)titles
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titles = titles;
        
        self.oneLinkageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.oneLinkageButton.frame = CGRectMake(0, 0, kWidth/self.titles.count, 50);
        [self setUpButton:self.oneLinkageButton withText:titles[0]];
        
        self.oneLinkageDropMenu = [[DropMenuView alloc] init];
        self.oneLinkageDropMenu.arrowView = self.oneLinkageButton.imageView;
        self.oneLinkageDropMenu.delegate = self;
        
        self.twoLinkageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.twoLinkageButton.frame = CGRectMake(kWidth/self.titles.count, 0, kWidth/self.titles.count, 50);
        [self setUpButton:self.twoLinkageButton withText:titles[1]];
        
        self.twoLinkageDropMenu = [[DropMenuView alloc] init];
        self.twoLinkageDropMenu.arrowView = self.twoLinkageButton.imageView;
        self.twoLinkageDropMenu.delegate = self;
        
        self.threeLinkageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.threeLinkageButton.frame = CGRectMake(2 * kWidth/self.titles.count, 0,  kWidth/self.titles.count, 50);
        [self setUpButton:self.threeLinkageButton withText:titles[2]];
        
        self.threeLinkageDropMenu = [[DropMenuView alloc] init];
        self.threeLinkageDropMenu.arrowView = self.threeLinkageButton.imageView;
        self.threeLinkageDropMenu.delegate = self;
        
        self.fourLinkageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.fourLinkageButton.frame = CGRectMake(3 * kWidth/self.titles.count, 0,  kWidth/self.titles.count, 50);
        [self setUpButton:self.fourLinkageButton withText:titles[3]];
        
        self.fourLinkageDropMenu = [[DropMenuView alloc] init];
        self.fourLinkageDropMenu.arrowView = self.fourLinkageButton.imageView;
        self.fourLinkageDropMenu.delegate = self;
        
        /** 最下面横线 */
        UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 0.6, kWidth, 0.6)];
        horizontalLine.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.000];
        [self addSubview:horizontalLine];
        
    }
    return self;
}

#pragma mark - 按钮点击推出菜单 (并且其他的菜单收起)
-(void)clickButton:(UIButton *)button{
    
    if (button == self.oneLinkageButton) {
        
        [self.twoLinkageDropMenu dismiss];
        [self.threeLinkageDropMenu dismiss];
        [self.fourLinkageDropMenu dismiss];
        
        [self.oneLinkageDropMenu creatDropView:self withShowTableNum:2 withData:self.dataArr1];

        
    }else if (button == self.twoLinkageButton){
        
        [self.oneLinkageDropMenu dismiss];
        [self.threeLinkageDropMenu dismiss];
        [self.fourLinkageDropMenu dismiss];
        
        [self.twoLinkageDropMenu creatDropView:self withShowTableNum:1 withData:self.dataArr2];
        
    }else if (button == self.threeLinkageButton){
        
        [self.oneLinkageDropMenu dismiss];
        [self.twoLinkageDropMenu dismiss];
        [self.fourLinkageDropMenu dismiss];
        
        [self.threeLinkageDropMenu creatDropView:self withShowTableNum:1 withData:self.dataArr3];
    }else if (button == self.fourLinkageButton){
        
        [self.oneLinkageDropMenu dismiss];
        [self.twoLinkageDropMenu dismiss];
        [self.threeLinkageDropMenu dismiss];
        
        [self.fourLinkageDropMenu creatDropView:self withShowTableNum:1 withData:self.dataArr4];
    }
}

#pragma mark - 筛选菜单消失
-(void)menuScreeningViewDismiss{
    
    [self.oneLinkageDropMenu dismiss];
    [self.twoLinkageDropMenu dismiss];
    [self.threeLinkageDropMenu dismiss];
    [self.fourLinkageDropMenu dismiss];
}

#pragma mark - 协议实现
-(void)dropMenuView:(DropMenuView *)view didSelectName:(NSString *)str firstSelectIndex:(NSInteger)firstSelectIndex selectIndex:(NSInteger)selectIndex{
    
    if (view == self.oneLinkageDropMenu) {

        [self.oneLinkageButton setTitle:str forState:UIControlStateNormal];
        [self buttonEdgeInsets:self.oneLinkageButton];
        self.block(0,firstSelectIndex,selectIndex);
        
    }else if (view == self.twoLinkageDropMenu){
        
        [self.twoLinkageButton setTitle:str forState:UIControlStateNormal];
        
        [self buttonEdgeInsets:self.twoLinkageButton];
        self.block(1,firstSelectIndex,selectIndex);
    }else if (view == self.threeLinkageDropMenu){
        
        [self.threeLinkageButton setTitle:str forState:UIControlStateNormal];

        [self buttonEdgeInsets:self.threeLinkageButton];
        self.block(2,firstSelectIndex,selectIndex);
    }else if (view == self.fourLinkageDropMenu){
        
        [self.fourLinkageButton setTitle:str forState:UIControlStateNormal];
        
        [self buttonEdgeInsets:self.fourLinkageButton];
        self.block(3,firstSelectIndex,selectIndex);
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


@end
