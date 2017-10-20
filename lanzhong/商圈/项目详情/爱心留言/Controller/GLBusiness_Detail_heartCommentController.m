//
//  GLBusiness_Detail_heartCommentController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/12.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLBusiness_Detail_heartCommentController.h"
#import "GLBusiness_DetailCommentCell.h"
#import "GLBusiness_DetailModel.h"
#import "IQKeyboardManager.h"

@interface GLBusiness_Detail_heartCommentController ()<UITableViewDelegate,UITableViewDataSource,GLBusiness_DetailCommentCellDelegate,UITextViewDelegate>
{
    NSInteger _currentIndex;//当前正在回复的是那一条
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *models;
@property (nonatomic, strong)LoadWaitView *loadV;
@property (nonatomic, assign)NSInteger page;

@property (nonatomic, copy)NSString *replyName;

@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,strong)UIView *inputBackgroundView;
@property(nonatomic,strong)UIView *toolView;
@property(nonatomic,assign)CGFloat keyboardHeight;
@property (nonatomic, strong)UIButton *sendBtn;

@property (nonatomic, strong)UIView *maskView;

@end

@implementation GLBusiness_Detail_heartCommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"更多评论";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLBusiness_DetailCommentCell" bundle:nil] forCellReuseIdentifier:@"GLBusiness_DetailCommentCell"];
    
    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf postRequest:YES];
    }];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf postRequest:NO];
    }];
    
    // 设置文字
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔..." forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_header = header;
    self.tableView.mj_footer = footer;
    self.page = 1;
    [self postRequest:YES];

    //键盘的frame即将发生变化时立刻发出该通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)postRequest:(BOOL)isRefresh{
    
    if (isRefresh) {
        self.page = 1;
        [self.models removeAllObjects];
    }else{
        self.page ++ ;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"item_id"] = self.item_id;
    dic[@"page"] = @(self.page);
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kCIRCLE_MORECOMMENT_URL paramDic:dic finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self endRefresh];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            if([responseObject[@"data"] count] != 0){
                
                for (NSDictionary *dic in responseObject[@"data"][@"invest_list"]) {
                    GLBusiness_CommentModel * model = [GLBusiness_CommentModel mj_objectWithKeyValues:dic];
                    model.linkman = responseObject[@"data"][@"linkman"];
                    [self.models addObject:model];
                }
            }
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        [self.tableView reloadData];
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self endRefresh];
        [self.tableView reloadData];
    }];
}

- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)sendReply{
    
    GLBusiness_CommentModel *model = self.models[_currentIndex];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"item_id"] = self.item_id;
    dic[@"comment_id"] = model.id;
    dic[@"reply"] = self.textView.text;
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kANSWER_COMMENT_URL paramDic:dic finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self endRefresh];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            [self dismiss];
            [self postRequest:YES];
        }
        [MBProgressHUD showError:responseObject[@"message"]];
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self endRefresh];
    }];

}

- (void)dismiss{
    [UIView animateWithDuration:0.3 animations:^{
        
        [self.textView resignFirstResponder];
    }completion:^(BOOL finished) {
        
        [self.maskView removeFromSuperview];
        [self.inputBackgroundView removeFromSuperview];

    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}
-(void)buttonAction{
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

#pragma mark - 键盘高度处理
-(void)keyboardChanged:(NSNotification *)notification{
    
    CGRect frame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    
    CGRect currentFrame = self.inputBackgroundView.frame;
    
    [UIView animateWithDuration:0.25 animations:^{
        //输入框最终的位置
        CGRect resultFrame;
        
        if (frame.origin.y==kSCREEN_HEIGHT) {
            resultFrame = CGRectMake(currentFrame.origin.x, kSCREEN_HEIGHT-currentFrame.size.height, currentFrame.size.width, currentFrame.size.height);
            self.keyboardHeight=0;
        }else{
            resultFrame = CGRectMake(currentFrame.origin.x,kSCREEN_HEIGHT-currentFrame.size.height-frame.size.height , currentFrame.size.width, currentFrame.size.height);
            self.keyboardHeight=frame.size.height;
        }
        
        self.inputBackgroundView.frame=resultFrame;
    }];
}

-(void)textViewDidChange:(UITextView *)textView{
    
    NSString *str=textView.text;
    
    CGSize maxSize=CGSizeMake(textView.bounds.size.width, MAXFLOAT);
    //NSStringDrawingUsesLineFragmentOrigin:用于多行绘制，因为默认是单行绘制，如果不指定，那么绘制出来的高度就是0，也就是啥都不显示出来。
    
    //NSStringDrawingUsesFontLeading:计算行高时使用自体的间距，也就是行高=行距+字体高度
    
    //NSStringDrawingUsesDeviceMetrics:计算布局时使用图元字形（而不是印刷字体）
    
    //NSStringDrawingTruncatesLastVisibleLine:设置的string的bounds放不下文本的话，就会截断，然后在最后一个可见行后面加上省略号。如果NSStringDrawingUsesLineFragmentOrigin不设置的话，只设置这一个选项是会被忽略的。因为如果不设置NSStringDrawingUsesLineFragmentOrigin，默认是单行显示的。
    //(注意：我在弹出框的内容string中设置了这个字串，但是最后显示出来的时候并没有打省略号…,这是因为在当前方法boundingRectWithSize..中设置这个option并不会起作用的，因为当前方法只是测量string的大小，并不是绘制string，在drawWithRect:(CGRect)rect options:(NSStringDrawingOptions)options attributes:...这个方法中设置这个option就会起作用)
    
    
    //测量string的大小
    CGRect frame=[str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:textView.font} context:nil];
    //设置self.textView的高度，默认是30
    CGFloat tarHeight=30;
    //如果文本框内容的高度+10大于30也就是初始的self.textview的高度的话，设置tarheight的大小为文本的内容+10，其中10是文本框和背景view的上下间距；
    if (frame.size.height+10>30) {
        tarHeight=frame.size.height+10;
    }
    //如果self.textView的高度大于200时，设置为200，即最高位200
    if (tarHeight>200) {
        tarHeight=200;
    }
    
    CGFloat width = kSCREEN_WIDTH;
    //设置输入框背景的frame
    self.inputBackgroundView.frame=CGRectMake(0, (kSCREEN_HEIGHT-self.keyboardHeight)-(tarHeight+10), width, tarHeight+10);
    //设置输入框的frame
    self.textView.frame=CGRectMake(15,(self.inputBackgroundView.bounds.size.height-tarHeight)/2 , width-30 - 60, tarHeight);
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{

    self.textView.textColor = [UIColor darkGrayColor];
    self.textView.text = @"";
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{

    if([[textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]==0) {

        self.textView.textColor = [UIColor darkGrayColor];

    }
    
    return YES;
}

#pragma mark - GLBusiness_DetailCommentCellDelegate

- (void)reply:(NSInteger)index{
    
    _currentIndex = index;
    //414
    CGFloat width = kSCREEN_WIDTH;
    //736
    CGFloat height = kSCREEN_HEIGHT - 40;
    
    self.inputBackgroundView.frame=CGRectMake(0, height, width, 40);
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:self.maskView];
    [window addSubview:self.inputBackgroundView];
    
    self.textView.frame = CGRectMake(15, 5, width - 90, 30);
    self.sendBtn.frame = CGRectMake(width - 75 , 5, 75, 30);
    [self.inputBackgroundView addSubview:self.textView];
    [self.inputBackgroundView addSubview:self.sendBtn];
    
    self.textView.inputAccessoryView = self.toolView;
    [self.textView becomeFirstResponder];
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLBusiness_CommentModel *model = self.models[indexPath.row];
    model.signIndex = self.signIndex;
    
    GLBusiness_DetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLBusiness_DetailCommentCell"];
    cell.model = self.models[indexPath.row];
    cell.selectionStyle = 0;
    cell.delegate = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    GLBusiness_CommentModel *model = self.models[indexPath.row];
    
    return model.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.signIndex == 1) {
        
    }
}

#pragma mark - 懒加载

- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}

- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_maskView addGestureRecognizer:tap];
        _maskView.backgroundColor = YYSRGBColor(0, 0, 0, 0.3);
    }
    return _maskView;
}

-(UIView *)inputBackgroundView{
    
    if (_inputBackgroundView == nil) {
        _inputBackgroundView = [UIView new];
        _inputBackgroundView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    }
    return _inputBackgroundView;
}

-(UITextView *)textView{
    
    if (_textView == nil) {
        _textView=[[UITextView alloc]init];
        _textView.font=[UIFont systemFontOfSize:15];
        _textView.layer.cornerRadius=5;
        _textView.layer.masksToBounds=YES;
        _textView.layer.borderWidth=1;
        _textView.layer.borderColor=[UIColor lightGrayColor].CGColor;
        _textView.delegate = self;
    }
    return _textView;
}

-(UIView *)toolView{
    
    if (_toolView==nil) {
        _toolView=[UIView new];
        _toolView.backgroundColor=[UIColor colorWithRed:210/255.0 green:213/255.0 blue:219/255.0 alpha:1];
        _toolView.frame=CGRectMake(0, 0, kSCREEN_WIDTH, 40);
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"收起键盘" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont systemFontOfSize:13];

        button.layer.cornerRadius = 5.f;
        button.clipsToBounds = YES;
        [button setBackgroundColor:MAIN_COLOR];
        [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        button.frame=CGRectMake(kSCREEN_WIDTH-60-15, (40-30)/2.0, 60, 30);
        [_toolView addSubview:button];
        
        UIView *topLineView=[UIView new];
        topLineView.backgroundColor=[UIColor grayColor];
        topLineView.frame=CGRectMake(0, 0, kSCREEN_WIDTH, 1);
        [_toolView addSubview:topLineView];
    }
    return _toolView;
}

- (UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [[UIButton alloc] init];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        [_sendBtn addTarget:self action:@selector(sendReply) forControlEvents:UIControlEventTouchUpInside];
        [_sendBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_sendBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        
    }
    return _sendBtn;
}


@end
