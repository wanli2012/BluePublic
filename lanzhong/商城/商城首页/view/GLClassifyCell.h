//
//  GLClassifyCell.h
//  Universialshare
//
//  Created by 龚磊 on 2017/4/21.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLMallModel.h"

@interface GLClassifyCell : UICollectionViewCell

@property (nonatomic, strong)NSString *goods_typeName;
@property (nonatomic, strong)GLMallModel *model;

@end
