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


@end
