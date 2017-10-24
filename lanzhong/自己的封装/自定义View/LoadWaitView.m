//
//  LoadWaitView.m
//  PovertyAlleviation
//
//  Created by 四川三君科技有限公司 on 2017/2/27.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LoadWaitView.h"
#import <SDWebImage/UIImage+GIF.h>

@interface LoadWaitView  ()

@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@end

@implementation LoadWaitView

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
        NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"LoadWaitView" owner:self options:nil];
        self = viewArray[0];
        self.frame = frame;
        self.backgroundColor=[UIColor clearColor];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgestrue)];
        [self addGestureRecognizer:tap];
        
        [self initinterface];
        
        self.isTap = NO;
        
        
        
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"9e32602be585527e120aa99beb0d666f" ofType:@"gif"];
//        NSData *data = [NSData dataWithContentsOfFile:path];
////        UIImage *image = [UIImage sd_animatedGIFWithData:data];
//        UIImage *image = [UIImage sd_animatedGIFWithData:data];
//        self.imageV.image = image;
        
//        // 读取gif图片数据
//        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(50,100,200,200)];
//        [self addSubview:webView];
//        
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"9e32602be585527e120aa99beb0d666f" ofType:@"gif"];
        /*
         NSData *data = [NSData dataWithContentsOfFile:path];
         使用loadData:MIMEType:textEncodingName: 则有警告
         [webView loadData:data MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
         */
//        NSURL *url = [NSURL URLWithString:path];
//        [webView loadRequest:[NSURLRequest requestWithURL:url]];

    }
    return self;

}

+(LoadWaitView*)addloadview:(CGRect)rect tagert:(id)tagert{
    
    LoadWaitView *loadview=[[LoadWaitView alloc] initWithFrame:rect];
    [tagert addSubview:loadview];
    
    return loadview;

}

-(void)removeloadview{

    [self removeFromSuperview];
    [self.loadImage stopAnimating];

}

-(void)initinterface{
 
//    self.loadImage.animationImages = self.imageArr;
//    self.loadImage.animationDuration = 1;//设置动画时间
//    self.loadImage.animationRepeatCount = 0;//设置动画次数 0 表示无限
//    
//    [self.loadImage startAnimating];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"gif03" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    UIImage *image = [UIImage sd_animatedGIFWithData:data];
    self.imageV.image = image;
    
}

-(void)tapgestrue{

    if (self.isTap == NO) {
        [self removeFromSuperview];
        [self.loadImage stopAnimating];
    }else{
        return;
    }
}

-(NSArray*)imageArr{

    if (!_imageArr) {
        _imageArr=[NSArray arrayWithObjects:[UIImage imageNamed:@"progress_1.png"],[UIImage imageNamed:@"progress_2.png"],[UIImage imageNamed:@"progress_3.png"],[UIImage imageNamed:@"progress_4.png"],[UIImage imageNamed:@"progress_5.png"],[UIImage imageNamed:@"progress_6.png"],[UIImage imageNamed:@"progress_7.png"],[UIImage imageNamed:@"progress_8.png"], nil];
        
    }
    return _imageArr;

}

@end
