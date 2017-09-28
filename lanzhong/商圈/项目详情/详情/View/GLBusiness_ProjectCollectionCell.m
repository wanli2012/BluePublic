//
//  GLBusiness_ProjectCollectionCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/28.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLBusiness_ProjectCollectionCell.h"

@interface GLBusiness_ProjectCollectionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@end

@implementation GLBusiness_ProjectCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.imageV.layer.cornerRadius = 5.f;
}


@end
