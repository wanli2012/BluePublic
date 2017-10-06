//
//  GLMine_WalletCardChooseController.h
//  lanzhong
//
//  Created by 龚磊 on 2017/10/5.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^cardChooseBlock)(NSString *bankName,NSString *bankNum);

@interface GLMine_WalletCardChooseController : UIViewController

@property (nonatomic, copy)cardChooseBlock block;

@end
