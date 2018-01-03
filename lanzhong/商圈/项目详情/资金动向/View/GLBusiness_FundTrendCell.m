//
//  GLBusiness_FundTrendCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/30.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLBusiness_FundTrendCell.h"


@interface GLBusiness_FundTrendCell ()

@property (weak, nonatomic) IBOutlet UIImageView *ballImageV;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation GLBusiness_FundTrendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.ballImageV.layer.cornerRadius = self.ballImageV.height/2;
    self.ballImageV.layer.borderColor = [UIColor blueColor].CGColor;
    self.ballImageV.layer.borderWidth = 1.f;
    
    // 画虚线
    self.topImageV.image = [self drawVerticalLineByImageView:self.topImageV];
    self.middleImageV.image = [self drawLineByImageView:self.middleImageV];
    self.bottomImageV.image = [self drawVerticalLineByImageView:self.bottomImageV];

}
- (void)setModel:(GLBusiness_FundTrendModel *)model{
    _model = model;
    
    self.dateLabel.text = [NSString stringWithFormat:@"%@ -- %@",[formattime formateTimeOfDate4:model.starttime],[formattime formateTimeOfDate4:model.endtime]];
    self.contentLabel.text = model.content;
}

- (void)setLogisticsmodel:(GLMall_list *)logisticsmodel{
    _logisticsmodel = logisticsmodel;
    
    self.dateLabel.text = logisticsmodel.time;
    self.contentLabel.text = logisticsmodel.status;
}

// 返回虚线image的方法
- (UIImage *)drawLineByImageView:(UIImageView *)imageView{
    UIGraphicsBeginImageContext(imageView.frame.size); //开始画线 划线的frame
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    //设置线条终点形状
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    // 5是每个虚线的长度 1是高度
    CGFloat lengths[] = {5,1};
    CGContextRef line = UIGraphicsGetCurrentContext();
    // 设置颜色
    CGContextSetStrokeColorWithColor(line, [UIColor colorWithWhite:0.408 alpha:1.000].CGColor);
    CGContextSetLineDash(line, 2, lengths,2); //画虚线
    CGContextMoveToPoint(line, 2.0, 2.0); //开始画线
    CGContextAddLineToPoint(line, kSCREEN_WIDTH - 10, 2.0);
    
    CGContextStrokePath(line);
    // UIGraphicsGetImageFromCurrentImageContext()返回的就是image
    return UIGraphicsGetImageFromCurrentImageContext();
}
// 返回虚线image的方法
- (UIImage *)drawVerticalLineByImageView:(UIImageView *)imageView{

    UIGraphicsBeginImageContext(imageView.frame.size); //开始画线 划线的frame
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    //设置线条终点形状
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    // 5是每个虚线的长度 1是高度
    CGFloat lengths[] = {5,1};
    CGContextRef line = UIGraphicsGetCurrentContext();
    // 设置颜色
    CGContextSetStrokeColorWithColor(line, [UIColor colorWithWhite:0.408 alpha:1.000].CGColor);
    CGContextSetLineDash(line, 0, lengths, 2); //画虚线
    CGContextMoveToPoint(line, 2, 0); //开始画线
    CGContextAddLineToPoint(line, 2, imageView.frame.size.height);
    
    CGContextStrokePath(line);
    // UIGraphicsGetImageFromCurrentImageContext()返回的就是image
    return UIGraphicsGetImageFromCurrentImageContext();
}

@end
