//
//  LBMyOrderListTableViewCell.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBMyOrdersModel.h"
//#import "LBMyorderRebateModel.h"

@protocol LBMyOrderListTableViewCellDelegete <NSObject>

-(void)clickTapgesture;
- (void)applyForReturn:(NSInteger)index section:(NSInteger)section;

@end

@interface LBMyOrderListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imagev;

@property (weak, nonatomic) IBOutlet UILabel *namelb;
@property (weak, nonatomic) IBOutlet UILabel *specLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;
@property (assign, nonatomic)NSInteger index;
@property (nonatomic, assign)NSInteger section;
@property (strong, nonatomic)NSIndexPath *indexpath;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (assign, nonatomic)id<LBMyOrderListTableViewCellDelegete> delegete;
@property (strong, nonatomic)LBMyOrdersListModel *myorderlistModel;
@property (weak, nonatomic) IBOutlet UIButton *applyReturnBtn;

@end
