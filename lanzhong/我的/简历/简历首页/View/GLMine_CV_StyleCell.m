//
//  GLMine_CV_StyleCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/11/20.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_CV_StyleCell.h"
#import "GLMine_CV_StyleCollectionCell.h"

@interface GLMine_CV_StyleCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation GLMine_CV_StyleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.collectionView registerNib:[UINib nibWithNibName:@"GLMine_CV_StyleCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"GLMine_CV_StyleCollectionCell"];
}
- (void)setImages:(NSArray *)images{
    _images = images;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMine_CV_StyleCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GLMine_CV_StyleCollectionCell" forIndexPath:indexPath];
    
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:self.images[indexPath.row]] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    
    return cell;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 15, 5, 15);
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kSCREEN_WIDTH - 41)/3, 150);
}

//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(toSeeBigPic:)]) {
        [self.delegate toSeeBigPic:indexPath.row];
    }
}

@end
