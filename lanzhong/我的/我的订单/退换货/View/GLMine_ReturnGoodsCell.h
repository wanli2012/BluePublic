//
//  GLMine_ReturnGoodsCell.h
//  lanzhong
//
//  Created by 龚磊 on 2017/10/24.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLMine_ReturnGoodsModel.h"

@protocol GLMine_ReturnGoodsCellDelegate <NSObject>

- (void)returnGoods:(NSInteger)index;

@end

@interface GLMine_ReturnGoodsCell : UITableViewCell

@property (nonatomic, strong)GLMine_ReturnGoodsModel *model;

@property (weak, nonatomic) IBOutlet UIButton *applyReturnBtn;

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, weak)id <GLMine_ReturnGoodsCellDelegate>delegate;

@end
