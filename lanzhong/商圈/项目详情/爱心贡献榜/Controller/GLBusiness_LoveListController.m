//
//  GLBusiness_LoveListController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/28.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLBusiness_LoveListController.h"
#import "GLBusiness_LoveListCell.h"
#import <SDWebImage/UIButton+WebCache.h>

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

@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdNameLabel;

@property (nonatomic, strong)NodataView *nodataV;

@end

@implementation GLBusiness_LoveListController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"爱心排行行";
    [self.tableView registerNib:[UINib nibWithNibName:@"GLBusiness_LoveListCell" bundle:nil] forCellReuseIdentifier:@"GLBusiness_LoveListCell"];
    [self.tableView addSubview:self.nodataV];
    self.nodataV.hidden = YES;
    
    [self setUI];
    
}
- (void)setUI{
    
    self.contentView.layer.cornerRadius = 5.f;
    self.contentViewLayerView.layer.cornerRadius = 5.f;
    self.contentViewLayerView.layer.shadowOpacity = 0.1f;
    self.contentViewLayerView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.contentViewLayerView.layer.shadowRadius = 2.f;
    
    self.firstBtn.layer.cornerRadius = self.firstBtn.height / 2;
    self.secondBtn.layer.cornerRadius = self.secondBtn.height / 2;
    self.thirdBtn.layer.cornerRadius = self.thirdBtn.height / 2;
    
    if (self.dataSourceArr.count > 1) {
        
        GLBusiness_HeartModel *model = self.dataSourceArr[0];
        
        self.firstNameLabel.text = model.uname;
        self.firstMoneyLabel.attributedText = [self attributedTextWithString:model.money];
        [self.firstBtn sd_setImageWithURL:[NSURL URLWithString:model.must_user_pic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    
        if (self.dataSourceArr.count >= 2) {
            
            GLBusiness_HeartModel *model1 = self.dataSourceArr[1];
            
            self.secondNameLabel.text = model1.uname;
            self.secondMoneyLabel.attributedText = [self attributedTextWithString:model1.money];
            [self.secondBtn sd_setImageWithURL:[NSURL URLWithString:model1.must_user_pic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
            
            if (self.dataSourceArr.count >= 3) {
                
                GLBusiness_HeartModel *model2 = self.dataSourceArr[2];
                
                self.thirdNameLabel.text = model2.uname;
                self.thirdMoneyLabel.attributedText = [self attributedTextWithString:model2.money];
                [self.thirdBtn sd_setImageWithURL:[NSURL URLWithString:model2.must_user_pic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
            }
        }
    }
}

- (NSMutableAttributedString *)attributedTextWithString:(NSString *)string{
    NSString *str = [NSString stringWithFormat:@"%@",string];
    
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@元",str]];
    
    [hintString addAttribute:NSForegroundColorAttributeName value:YYSRGBColor(255, 105, 0, 1) range:NSMakeRange(0,str.length)];
    return hintString;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.dataSourceArr.count == 0) {
        self.nodataV.hidden = NO;
    }else{
        self.nodataV.hidden = YES;
    }
    
    if (self.dataSourceArr.count <= 3) {
        return 0;
    }else{
        return self.dataSourceArr.count - 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLBusiness_LoveListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLBusiness_LoveListCell"];
    cell.selectionStyle = 0;
    cell.index = indexPath.row;
    cell.model = self.dataSourceArr[indexPath.row + 3];
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NodataView *)nodataV{
    if (!_nodataV) {
        _nodataV = [[NSBundle mainBundle] loadNibNamed:@"NodataView" owner:nil options:nil].lastObject;
        _nodataV.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64);
        
    }
    return _nodataV;
}
@end
