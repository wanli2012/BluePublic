//
//  GLMine_PersonInfo_AddressCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_PersonInfo_AddressCell.h"

@interface GLMine_PersonInfo_AddressCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@end

@implementation GLMine_PersonInfo_AddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (IBAction)edit:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(editAddress:)]) {
        [self.delegate editAddress:self.index];
    }
}

- (void)setModel:(GLMine_AddressModel *)model{
    _model = model;
    self.nameLabel.text = model.collect_name;
    self.phoneLabel.text = model.phone;
    self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",model.province_name,model.city_name,model.area_name,model.address];
    
    if ([model.is_default integerValue] == 0) {
        
        self.imageV.image = [UIImage imageNamed:@"address_nochoice"];
    }else{
        self.imageV.image = [UIImage imageNamed:@"address_choice"];
    }
    
}

@end
