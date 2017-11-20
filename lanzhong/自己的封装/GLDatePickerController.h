//
//  GLDatePickerController.h
//  lanzhong
//
//  Created by 龚磊 on 2017/11/20.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLDatePickerController : UIViewController

@property (nonatomic , copy)void(^returnreslut)(NSString *dateStr);

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;

@property (nonatomic, copy)NSArray *dataArr;

@end
