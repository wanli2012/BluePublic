//
//  GLMine_CV_Header.h
//  lanzhong
//
//  Created by 龚磊 on 2017/11/18.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class GLMine_CV_Header;

typedef void(^retrunshowsection)(NSInteger index);

@interface GLMine_CV_Header : UITableViewHeaderFooterView

@property(copy,nonatomic)retrunshowsection block;

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, strong)UILabel *titleLabel;

@property (nonatomic, strong)UIButton *editBtn;

@end
