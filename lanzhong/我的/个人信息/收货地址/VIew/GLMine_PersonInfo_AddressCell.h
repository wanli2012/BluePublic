//
//  GLMine_PersonInfo_AddressCell.h
//  lanzhong
//
//  Created by 龚磊 on 2017/10/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GLMine_PersonInfo_AddressCellDelegate <NSObject>

//- (void)addressChoose:(NSInteger)index;
- (void)editAddress:(NSInteger)index;

@end

@interface GLMine_PersonInfo_AddressCell : UITableViewCell

@property (nonatomic, weak)id <GLMine_PersonInfo_AddressCellDelegate> delegate;

@property (nonatomic, assign)NSInteger index;

@end
