//
//  GLBusiness_DetailProjectCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/27.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLBusiness_DetailProjectCell.h"
#import "GLBusiness_ProjectCollectionCell.h"



@interface GLBusiness_DetailProjectCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;

@end

@implementation GLBusiness_DetailProjectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView.collectionViewLayout = layout;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"GLBusiness_ProjectCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"GLBusiness_ProjectCollectionCell"];
}

- (void)setDataSourceArr:(NSArray *)dataSourceArr{
    _dataSourceArr = dataSourceArr;
    
    if(self.dataSourceArr.count == 0){
        
        self.collectionViewHeight.constant = 0;
    }else if (self.dataSourceArr.count<= 3) {
        
        self.collectionViewHeight.constant = 100;
    }else if(self.dataSourceArr.count <= 6 && self.dataSourceArr.count > 3){
        
        self.collectionViewHeight.constant = 200;
    }else if(self.dataSourceArr.count <= 9 && self.dataSourceArr.count > 6){
        self.collectionViewHeight.constant = 300;
    }

    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   
    return self.dataSourceArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GLBusiness_ProjectCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GLBusiness_ProjectCollectionCell" forIndexPath:indexPath];
    
    NSString *imageStr = [NSString stringWithFormat:@"%@?imageView2/1/w/200/h/200",self.dataSourceArr[indexPath.row]];
    
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((kSCREEN_WIDTH - 10)/3, 100);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(clickToCheckBigImage:)]) {
        [self.delegate clickToCheckBigImage:indexPath.row];
    }
}

@end
