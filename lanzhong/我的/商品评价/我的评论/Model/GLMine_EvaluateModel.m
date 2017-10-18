//
//  GLMine_EvaluateModel.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/18.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_EvaluateModel.h"

@implementation GLMine_EvaluateModel

-(CGFloat)cellHeight{

    CGRect commentRect = [self.comment boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil];
    
    CGRect replyRect;
    if (self.reply.length != 0) {
        
        NSString *replyStr = [NSString stringWithFormat:@"商家回复:%@",self.reply];
        replyRect = [replyStr boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil];
        
        return 170 + commentRect.size.height + replyRect.size.height;
        
    }else{
        
        replyRect = CGRectZero;
        return 140 + commentRect.size.height + replyRect.size.height;
    }
    
    
}

@end
