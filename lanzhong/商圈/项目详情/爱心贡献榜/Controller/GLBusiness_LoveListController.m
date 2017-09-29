//
//  GLBusiness_LoveListController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/28.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLBusiness_LoveListController.h"
#import "GLBusiness_LoveListCell.h"

@interface GLBusiness_LoveListController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *contentViewLayerView;

@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirdBtn;

@property (weak, nonatomic) IBOutlet UILabel *firstMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdMoneyLabel;

@end

@implementation GLBusiness_LoveListController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"爱心排行行";
    
    self.contentView.layer.cornerRadius = 5.f;
    self.contentViewLayerView.layer.cornerRadius = 5.f;
    self.contentViewLayerView.layer.shadowOpacity = 0.1f;
    self.contentViewLayerView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.contentViewLayerView.layer.shadowRadius = 2.f;
    
    self.firstBtn.layer.cornerRadius = self.firstBtn.height / 2;
    self.secondBtn.layer.cornerRadius = self.secondBtn.height / 2;
    self.thirdBtn.layer.cornerRadius = self.thirdBtn.height / 2;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLBusiness_LoveListCell" bundle:nil] forCellReuseIdentifier:@"GLBusiness_LoveListCell"];
    
    NSString *str = [NSString stringWithFormat:@"%@",@"800"];
    
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@元",str]];
    
    [hintString addAttribute:NSForegroundColorAttributeName value:MAIN_COLOR range:NSMakeRange(0,str.length)];
       
    self.firstMoneyLabel.attributedText = hintString;
    self.secondMoneyLabel.attributedText = hintString;
    self.thirdMoneyLabel.attributedText = hintString;
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLBusiness_LoveListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLBusiness_LoveListCell"];
    cell.selectionStyle = 0;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


@end
