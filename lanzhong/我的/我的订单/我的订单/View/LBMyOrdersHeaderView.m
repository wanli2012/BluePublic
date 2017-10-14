//
//  LBMyOrdersHeaderView.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/27.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMyOrdersHeaderView.h"
#import <Masonry/Masonry.h>
#import "formattime.h"

@implementation LBMyOrdersHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self initerface];
    }
    return self;
}

-(void)initerface{
    
    UITapGestureRecognizer *tapgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgestureSection)];
    [self addGestureRecognizer:tapgesture];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.orderCode];
    [self addSubview:self.orderTime];
    [self addSubview:self.lineview];
    [self addSubview:self.totalPriceLabel];
    [self addSubview:self.statusLabel];
    [self addSubview:self.payBt];
    [self addSubview:self.cancelBt];
    [self addSubview:self.DeleteBt];
    
    [self.orderCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-10);
        make.leading.equalTo(self).offset(10);
        make.top.equalTo(self).offset(10);
        make.height.equalTo(@20);
    }];
    
    [self.orderTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-10);
        make.leading.equalTo(self).offset(10);
        make.top.equalTo(self.orderCode.mas_bottom).offset(5);
        make.height.equalTo(@20);
    }];
    [self.lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-10);
        make.leading.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-1);
        make.height.equalTo(@1);
    }];
    
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-10);
        //make.leading.equalTo(self).offset(10);
        make.top.equalTo(self.orderTime.mas_bottom).offset(5);
        make.height.equalTo(@25);
        make.width.equalTo(@80);
    }];
    
    [self.payBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-10);
        //make.leading.equalTo(self).offset(10);
        make.top.equalTo(self.orderTime.mas_bottom).offset(5);
        make.height.equalTo(@25);
        make.width.equalTo(@80);
    }];
    
    [self.totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.payBt.mas_leading).offset(-10);
        //make.leading.equalTo(self).offset(10);
        make.top.equalTo(self.orderTime.mas_bottom).offset(5);
        make.height.equalTo(@25);
        make.width.equalTo(self).offset(-100);
    }];
    
    [self.cancelBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.payBt.mas_leading).offset(-10);
        //make.leading.equalTo(self).offset(10);
        make.top.equalTo(self.orderTime.mas_bottom).offset(5);
        make.height.equalTo(@25);
        make.width.equalTo(@80);
    }];
    
    [self.DeleteBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-10);
        //make.leading.equalTo(self).offset(10);
        make.top.equalTo(self).offset(10);
        make.height.equalTo(@25);
        make.width.equalTo(@80);
    }];
    
    
}

-(void)setSectionModel:(LBMyOrdersModel *)sectionModel{

    if (_sectionModel != sectionModel) {
        _sectionModel = sectionModel;
    }
    
    self.orderCode.text = [NSString stringWithFormat:@"订单号:%@" , _sectionModel.order_num];
     self.orderTime.text = [NSString stringWithFormat:@"下单时间:%@" ,[formattime formateTimeOfDate3:_sectionModel.addtime]];
    
//    if ([_sectionModel.order_type integerValue] == 1) {
//        self.orderStaues.text = @"订单类型:消费订单";
//    }else if ([_sectionModel.order_type integerValue] == 2){
//        self.orderStaues.text = @"订单类型:米券订单";
//    
//    }else if ([_sectionModel.order_type integerValue] == 3){
//        self.orderStaues.text = @"订单类型:面对面订单";
//    }
    
}

-(void)tapgestureSection{
    self.sectionModel.isExpanded = !self.sectionModel.isExpanded;
    if (self.expandCallback) {
        self.expandCallback(self.sectionModel.isExpanded);
    }
}
//支付
-(void)CollectinGoodsBtbttonOne{

    if (self.returnPayBt) {
        self.returnPayBt(self.section);
    }


}
//取消订单
- (void)cancelOrder {
    if (self.returnCancelBt) {
        self.returnCancelBt(self.section);
    }
}
//删除
-(void)delegeteEvent{

    if (self.returnDeleteBt) {
        self.returnDeleteBt(self.section);
    }
}

-(UILabel*)orderCode{
    
    if (!_orderCode) {
        _orderCode=[[UILabel alloc]init];
        _orderCode.backgroundColor=[UIColor clearColor];
        _orderCode.textColor=[UIColor blackColor];
        _orderCode.font=[UIFont systemFontOfSize:13];
        _orderCode.text = @"订单号:";
    }
    
    return _orderCode;
    
}
-(UILabel*)orderTime{
    
    if (!_orderTime) {
        _orderTime=[[UILabel alloc]init];
        _orderTime.backgroundColor=[UIColor clearColor];
        _orderTime.textColor=[UIColor blackColor];
        _orderTime.font=[UIFont systemFontOfSize:13];
        _orderTime.text = @"订单时间:";
        
    }
    
    return _orderTime;
    
}
-(UIView*)lineview{
    
    if (!_lineview) {
        
        _lineview=[[UIView alloc]init];
        _lineview.backgroundColor=[UIColor groupTableViewBackgroundColor];
        
    }
    
    return _lineview;
}
-(UILabel*)totalPriceLabel{
    
    if (!_totalPriceLabel) {
        _totalPriceLabel=[[UILabel alloc]init];
        _totalPriceLabel.backgroundColor=[UIColor clearColor];
        _totalPriceLabel.textColor=[UIColor blackColor];
        _totalPriceLabel.font=[UIFont systemFontOfSize:13];
        _totalPriceLabel.text = @"需付款";
        _totalPriceLabel.hidden = YES;
        
    }
    
    return _totalPriceLabel;
    
}
-(UILabel*)statusLabel{
    
    if (!_statusLabel) {
        _statusLabel=[[UILabel alloc]init];
        _statusLabel.backgroundColor=[UIColor clearColor];
        _statusLabel.textColor=[UIColor lightGrayColor];
        _statusLabel.font=[UIFont systemFontOfSize:13];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.text = @"";
        _statusLabel.hidden = YES;
        _statusLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _statusLabel.layer.borderWidth = 0.5f;
    }
    
    return _statusLabel;
    
}

-(UIButton*)payBt{//右边
    
    if (!_payBt) {
        _payBt=[[UIButton alloc]init];
        _payBt.backgroundColor = YYSRGBColor(1, 121, 244, 1);
        [_payBt setTitle:@"" forState:UIControlStateNormal];
        _payBt.titleLabel.font=[UIFont systemFontOfSize:13];
        [_payBt addTarget:self action:@selector(CollectinGoodsBtbttonOne) forControlEvents:UIControlEventTouchUpInside];
        [_payBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _payBt.layer.cornerRadius = 3.f;
        _payBt.clipsToBounds =YES;
        _payBt.hidden = YES;
    }
    
    return _payBt;
}

-(UIButton*)cancelBt{//左边
    
    if (!_cancelBt) {
        _cancelBt=[[UIButton alloc]init];
        _cancelBt.backgroundColor = [UIColor whiteColor];
        [_cancelBt setTitle:@"" forState:UIControlStateNormal];
        _cancelBt.titleLabel.font=[UIFont systemFontOfSize:13];
        [_cancelBt addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBt setTitleColor:YYSRGBColor(1, 121, 244, 1) forState:UIControlStateNormal];
        
        _cancelBt.layer.borderWidth = 0.5f;
        _cancelBt.layer.borderColor = YYSRGBColor(1, 121, 244, 1).CGColor;
        _cancelBt.layer.cornerRadius = 3.f;
        _cancelBt.clipsToBounds =YES;
        _cancelBt.hidden = YES;
        
    }
    return _cancelBt;
}

-(UIButton*)DeleteBt{
    
    if (!_DeleteBt) {
        _DeleteBt=[[UIButton alloc]init];
        [_DeleteBt addTarget:self action:@selector(delegeteEvent) forControlEvents:UIControlEventTouchUpInside];
        _DeleteBt.backgroundColor = [UIColor whiteColor];
        [_DeleteBt setTitle:@"" forState:UIControlStateNormal];
        _DeleteBt.titleLabel.font=[UIFont systemFontOfSize:13];
        [_DeleteBt addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
        [_DeleteBt setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        _DeleteBt.clipsToBounds =YES;
        _DeleteBt.hidden = YES;
    }
    
    return _DeleteBt;
    
}
@end
