//
//  GLMine_SetController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/28.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_SetController.h"
#import "GLMineCell.h"
#import "GLMine_Set_modifyPwdController.h"//修改密码
#import "MinePhoneAlertView.h"
#import "GLBusiness_CertificationController.h"//web页面VC

@interface GLMine_SetController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UIButton *exitBtn;

@property (nonatomic, copy)NSString *memory;//内存
@property(nonatomic ,strong)MinePhoneAlertView  *phoneView;
@property(nonatomic ,strong)NSString  *phonestr;//服务热线

@property (weak, nonatomic) IBOutlet UILabel *copyrightLabel;
@property (strong, nonatomic)  NSString *app_Version;//当前版本号

@end

@implementation GLMine_SetController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"设置";
    self.exitBtn.layer.borderColor = YYSRGBColor(0, 125, 254, 1).CGColor;
    self.exitBtn.layer.borderWidth = 1.f;
    self.exitBtn.layer.cornerRadius = 5.f;

    self.memory = [NSString stringWithFormat:@"%.2fM", [self filePath]];
    self.phonestr = [UserModel defaultUser].user_server;
    
    self.copyrightLabel.text = @"copyright@2017-2018\n贵州蓝众投资管理有限公司";
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    // app版本
    _app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMineCell" bundle:nil] forCellReuseIdentifier:@"GLMineCell"];
    
//    [self Postpath:GET_VERSION];/检查是否有更新版本
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    
}
#pragma mark - 退出登录
- (IBAction)quit:(id)sender {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"你确定要退出吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [UserModel defaultUser].loginstatus = NO;
        [UserModel defaultUser].user_pic = @"";
        [UserModel defaultUser].token = @"";
        [UserModel defaultUser].uid = @"";

        [usermodelachivar achive];
        
        CATransition *animation = [CATransition animation];
        animation.duration = 0.3;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = @"suckEffect";
        [self.view.window.layer addAnimation:animation forKey:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"exitLogin" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:ok];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dataSource[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLMineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMineCell"];
    cell.selectionStyle = 0;
    
    NSArray *arr = self.dataSource[indexPath.section];
    cell.titleLabel.text = arr[indexPath.row];
    cell.imageViewWidth.constant = 0;
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                cell.status = 2;
            }else if(indexPath.row == 1){
                cell.status = 0;
                cell.valueLabel.text = self.memory;
            }else if(indexPath.row == 2){
                cell.status = 2;
            }
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                cell.status = 1;
                cell.valueLabel.text = self.phonestr;
            }else if(indexPath.row == 1){
                cell.status = 2;
            }else if(indexPath.row == 2){
                cell.status = 1;
                cell.valueLabel.text = [NSString stringWithFormat:@"V%@",self.app_Version];
            }
        }
            break;
        default:
            break;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed = YES;
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    GLMine_Set_modifyPwdController *modifyVC = [[GLMine_Set_modifyPwdController alloc] init];
                    [self.navigationController pushViewController:modifyVC animated:YES];
                
                }

                    break;
                case 1:
                {

                    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您确定要删除缓存吗?" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    
                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                       [self clearFile];//清楚缓存
                        
                    }];
                    
                    [alertVC addAction:cancel];
                    [alertVC addAction:ok];
                    
                    [self presentViewController:alertVC animated:YES completion:nil];

                }
                    break;
                case 2:
                {
                    self.hidesBottomBarWhenPushed = YES;
                    GLBusiness_CertificationController *aboutVC = [[GLBusiness_CertificationController alloc] init];
                    aboutVC.url = About_URL;
                    aboutVC.navTitle = @"关于";
                    [self.navigationController pushViewController:aboutVC animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    
                    self.phoneView.transform=CGAffineTransformMakeScale(0, 0);
                    
                    NSString *str=[NSString stringWithFormat:@"是否拨打电话? %@",self.phonestr];
                    NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc]initWithString:str];
                    NSRange rangel = [[textColor string] rangeOfString:self.phonestr];
                    [textColor addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:76/255.0 green:140/255.0 blue:247/255.0 alpha:1] range:rangel];
                    [_phoneView.titleLb setAttributedText:textColor];
                    
                    [[UIApplication sharedApplication].keyWindow addSubview:self.phoneView];
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        _phoneView.transform=CGAffineTransformIdentity;
                        
                    } completion:^(BOOL finished) {
                        
                    }];

                }
                    break;
                case 1:
                {
                    
                    self.hidesBottomBarWhenPushed = YES;
                    GLBusiness_CertificationController *aboutVC = [[GLBusiness_CertificationController alloc] init];
                    aboutVC.url = Help_Center_URL;
                    aboutVC.navTitle = @"帮助中心";
                    [self.navigationController pushViewController:aboutVC animated:YES];

                }
                    break;
                case 2:
                {
//                    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"更新" message:@"" preferredStyle:UIAlertControllerStyleAlert];
//                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                    }];
//                    
//                    [alertVC addAction:cancel];
//                    [alertVC addAction:ok];
//                    
//                    [self presentViewController:alertVC animated:YES completion:nil];
                    
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}

-(void)Postpath:(NSString *)path
{
    
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    
    NSOperationQueue *queue = [NSOperationQueue new];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response,NSData *data,NSError *error){
        NSMutableDictionary *receiveStatusDic=[[NSMutableDictionary alloc]init];
        if (data) {
            
            NSDictionary *receiveDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if ([[receiveDic valueForKey:@"resultCount"] intValue] > 0) {
                
                [receiveStatusDic setValue:@"1" forKey:@"status"];
                [receiveStatusDic setValue:[[[receiveDic valueForKey:@"results"] objectAtIndex:0] valueForKey:@"version"]   forKey:@"version"];
            }else{
                
                [receiveStatusDic setValue:@"-1" forKey:@"status"];
            }
        }else{
            [receiveStatusDic setValue:@"-1" forKey:@"status"];
        }
        
        [self performSelectorOnMainThread:@selector(receiveData:) withObject:receiveStatusDic waitUntilDone:NO];
    }];
}

-(void)receiveData:(id)sender
{
    NSString  *Newversion = [NSString stringWithFormat:@"%@",sender[@"version"]];
    
    if (![_app_Version isEqualToString:Newversion]) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"更新提示"
                                                            message:@"发现新版本,是否更新 ?"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"立即更新", nil];
        
        [alertView show];
    }
    
}
#pragma mark ----- uialertviewdelegete
//下载
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:DOWNLOAD_URL]];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 5)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

//*********************清理缓存********************//
//显示缓存大小
-( float )filePath
{
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    
    return [self folderSizeAtPath :cachPath];
}
//单个文件的大小

- ( long long ) fileSizeAtPath:( NSString *) filePath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if ([manager fileExistsAtPath :filePath]){
        
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize ];
    }
    return 0 ;
}
//返回多少 M
- ( float ) folderSizeAtPath:( NSString *) folderPath{
    NSFileManager * manager = [ NSFileManager defaultManager ];
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
    }
    return folderSize/( 1024.0 * 1024.0 );
}
// 清理缓存
- (void)clearFile
{
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    NSArray * files = [[ NSFileManager defaultManager ] subpathsAtPath :cachPath];
    //NSLog ( @"cachpath = %@" , cachPath);
    for ( NSString * p in files) {
        NSError * error = nil ;
        NSString * path = [cachPath stringByAppendingPathComponent :p];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        }
    }
    
    [self performSelectorOnMainThread:@selector(clearCachSuccess) withObject:nil waitUntilDone:YES];
}

-(void)clearCachSuccess{
    
    self.memory = [NSString stringWithFormat:@"%.2fM", [self filePath]];
    
    [self.tableView reloadData];
    
//    self.momeryLb.text = [NSString stringWithFormat:@"%.2fM",self.folderSize];
    
}

#pragma mark - 懒加载
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        
        NSArray *arr = @[@"密码修改",@"内存清理",@"关于公司"];
        NSArray *arr2 = @[@"联系客服",@"帮助中心",@"版本更新"];
    
        [_dataSource addObject:arr];
        [_dataSource addObject:arr2];

        
    }
    return _dataSource;
}

-(MinePhoneAlertView *)phoneView{
    
    if (!_phoneView) {
        _phoneView=[[NSBundle mainBundle]loadNibNamed:@"MinePhoneAlertView" owner:nil options:nil].firstObject;
        _phoneView.frame=CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        _phoneView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        [_phoneView.cancelBt addTarget:self action:@selector(cancelbutton) forControlEvents:UIControlEventTouchUpInside];
        [_phoneView.sureBt addTarget:self action:@selector(surebuttonE) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _phoneView;
}

-(void)cancelbutton{
    [UIView animateWithDuration:0.3 animations:^{
        _phoneView.transform=CGAffineTransformMakeScale(0.000001, 0.000001);
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            [_phoneView removeFromSuperview];
        }
    }];
    
}

-(void)surebuttonE{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.phonestr]]]; //拨号

}

@end
